import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ttd/data/settings/TTDSettingsRepository.dart';
import 'package:ttd/models/domain/common/AuthModel.dart';
import 'package:ttd/models/domain/common/LoginModel.dart';
import 'package:ttd/services/common/TTDApplicationService.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/ui/home/workinghoursystem/WorkingHourSystemPage.dart';
import 'package:ttd/ui/login/resetpassword/ResetPasswordPage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import 'package:ttd/utils/servicelocator/TTDServiceLocator.dart';

import '../../../models/rest/requests/emplogin/EmpLoginRequest.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../home/components/BottomNavigation.dart';
import 'PersonelLoginPage.dart';



class PersonelLoginPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService =
  TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository =
  TTDServiceLocator().get<ITTDSettingsRepository>();

  var isRemembered = false.obs;

  PersonelLoginPageViewModel() {
    initPage();
  }

  initPage() async {
    var result = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (result != null) {
      isRemembered.value = jsonDecode(result);
    }
    controlRemember();
  }

  login(String phoneNumber, String password) async {
    try {
      var gidecekToken;
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      final fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        gidecekToken = fcmToken;
      } else {
        print("Hata: FCM Token alınamadı.");
      }

      print("Gidecek TOKEN : ${gidecekToken}");

      EmpLoginRequest empLoginRequest = EmpLoginRequest(
        phoneNumber: phoneNumber,
        password: password,
        fireBaseId: gidecekToken,
      );

      print("Giden Request $empLoginRequest");

      var response = await _personnelRestService!.employeeLogin(empLoginRequest);
      print('Ham Response detayları:');
      print('Message: ${response.message}');
      print('Success: ${response.success}');
      print('EmployeeId: ${response.employeeId}');
      print('Token: ${response.token}');
      print('Expiration: ${response.expiration}');

      if(response.success == true)
      {
        if (!isRemembered.value) {
          TTDApplicationService.loginModel = LoginModel(
            employeeId: response.employeeId,
            token: response.token,
            expiration: response.expiration,
          );
          print("LoginModel oluşturuldu: ${TTDApplicationService.loginModel}");
        }

        // Giriş bilgilerini AuthModel'e kaydet
        TTDApplicationService.authModel = AuthModel(
          employeeId: response.employeeId,
          token: response.token,
          expiration: response.expiration,
        );

        // RememberMe işaretliyse, AuthModel'i kaydet
        if (isRemembered.value) {
          var rememberMe = TTDApplicationService.authModel!.toJson();
          _ittdSettingsRepository!.addSetting("AuthModel", jsonEncode(rememberMe));
          print("AuthModel kaydedildi.");
        }

        // RememberMe durumunu kaydet
        try {
          await _ittdSettingsRepository!.addSetting("RememberMe", jsonEncode(isRemembered.value));
          print("RememberMe durumu kaydedildi.");
        } catch (e) {
          print("RememberMe durumunu kaydetme başarısız: $e");
        }

        var result = await _ittdSettingsRepository!.getSetting("startShiftDialogShown");

        if(result != "true")
        {
          TTDNavigator().pushToMain(WorkingHourSystemPage());
          await Fluttertoast.showToast(
              msg: "${response.message}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        else
        {
          Get.offAll(() => NavigationPage(initialTab: TabItem.home));
          await Fluttertoast.showToast(
              msg: "${response.message}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }
      else
      {
        print('Başarısız giriş - Message: ${response.message}');
        print('Başarısız giriş - Success: ${response.success}');
        
        await Fluttertoast.showToast(
          msg: "${response.message}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    } catch (e, stackTrace) {
      print('Login Hatası: $e');
      print('Stack Trace: $stackTrace');
      await Fluttertoast.showToast(
        msg: "Sunucu bağlantısında hata oluştu",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  controlRemember() async {
    try {
      if (!isRemembered.value) {
        print("Beni Hatırla seçilmedi, kontrol iptal edildi.");
        return;
      }

      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      print("Alınan AuthModel verisi: $result");

      if (result == null || result.isEmpty) {
        print("AuthModel verisi boş veya null.");
        await _clearAuthData();
        return;
      }

      AuthModel authModel;
      try {
        authModel = AuthModel.fromJson(jsonDecode(result));
        
        if (authModel.token == null || authModel.employeeId == null || authModel.expiration == null) {
          print("Token, EmployeeId veya Expiration eksik.");
          await _clearAuthData();
          return;
        }

        // Token süresini kontrol et
        DateTime now = DateTime.now();
        DateTime expiration = DateTime.parse(authModel.expiration!);

        if (now.isAfter(expiration)) {
          print("Token süresi dolmuş. Expiration: ${authModel.expiration}");
          await _clearAuthData();
          return;
        }

        // Token hala geçerli, AuthModel'i set et
        TTDApplicationService.authModel = authModel;
        
        // Vardiya kontrolü yap ve uygun sayfaya yönlendir
        var shiftDialogShown = await _ittdSettingsRepository!.getSetting("startShiftDialogShown");
        if(shiftDialogShown != "true") {
          TTDNavigator().pushToMain(WorkingHourSystemPage());
        } else {
          Get.offAll(() => NavigationPage(initialTab: TabItem.home));
        }

      } catch (e) {
        print("Token kontrol hatası: $e");
        await _clearAuthData();
      }
    } catch (e) {
      print("controlRemember'da hata: $e");
      await _clearAuthData();
    }
  }

  // Auth verilerini temizleyen yardımcı metod
  Future<void> _clearAuthData() async {
    await _ittdSettingsRepository!.deleteSetting("AuthModel");
    await _ittdSettingsRepository!.deleteSetting("RememberMe");
    isRemembered.value = false;
    TTDApplicationService.authModel = null;
    TTDNavigator().pushToMain(PersonelLoginPage());
  }

  void saveServerUrl(String serverUrl) async {
    try {
      await _ittdSettingsRepository!.addSetting("ServerUrl", serverUrl);
      print("Server URL başarıyla kaydedildi: $serverUrl");

      // Kaydetme işleminden sonra başarılı bir mesaj gösterme
      Fluttertoast.showToast(
        msg: "Sunucu adresi başarıyla kaydedildi.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Server URL kaydedilemedi: $e");

      // Hata mesajı gösterme
      Fluttertoast.showToast(
        msg: "Sunucu adresi kaydedilirken hata oluştu.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  Future<String?> getServerUrl() async {
    try {
      var serverUrl = await _ittdSettingsRepository!.getSetting("ServerUrl");
      print("Kaydedilen Server URL: $serverUrl");
      return serverUrl;
    } catch (e) {
      print("Server URL alınırken hata oluştu: $e");
      return null;
    }
  }

  checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    var appVersion = packageInfo.version;
    var queryParams = {'versionName': appVersion};
    var response = await _personnelRestService!.versionControl(queryParams);
    if(response.success == true)
      {
        print("checkAppVersionResponse ${response}");
        return response;
      }
    else{
      print("checkAppVersionResponse ${response}");

    }

  }

  gotoForgotPass() {
    TTDNavigator().pushToMain(ResetPasswordPage());
  }

  void setRememberMe(bool value) {
    isRemembered.value = value;
    if (value) {
      // Save RememberMe state to repository
      _ittdSettingsRepository!.addSetting("RememberMe", jsonEncode(value));
      print("RememberMe state set to true and saved.");
    } else {
      // Delete RememberMe state from repository
      _ittdSettingsRepository!.deleteSetting("RememberMe");
      print("RememberMe state set to false and deleted.");
    }
    }
}