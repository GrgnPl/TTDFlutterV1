import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/models/domain/common/AuthModel.dart';
import 'package:ttd/services/common/TTDApplicationService.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPage.dart';
import '../../data/settings/TTDSettingsRepository.dart';
import '../../utils/navigation/TTDNavigator.dart';
import '../../utils/servicelocator/TTDServiceLocator.dart';
import '../home/workinghoursystem/WorkingHourSystemPage.dart';



class LoginPageViewModel extends ViewModelBase {
  late ITTDSettingsRepository? _ittdSettingsRepository =
  TTDServiceLocator().get<ITTDSettingsRepository>();

  var isRemembered = false.obs;

  LoginPageViewModel() {
    initPage();
  }

  initPage() async {
    var rememberMeResult =
    await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMeResult != null) {
      isRemembered.value = jsonDecode(rememberMeResult);
    }

    // If "Remember Me" is enabled, check the AuthModel
    if (isRemembered.value) {
      controlRemember();
    }
  }

  gotoLogin() {
    TTDNavigator().pushToMain(PersonelLoginPage());
  }

  controlRemember() async {
    var result = await _ittdSettingsRepository!.getSetting("AuthModel");
    print("Retrieved AuthModel data: $result");

    if (result == null) {
      print("AuthModel data is null, redirecting to login page.");
      gotoLogin();
      return;
    }

    AuthModel authModel = AuthModel.fromJson(jsonDecode(result));

    if (authModel.expiration == null) {
      print("Lütfen Giriş Yapınız.");
      gotoLogin();
      return;
    }

    DateTime now = DateTime.now();
    DateTime expiration = DateTime.parse(authModel.expiration!);

    print("Current date: $now, AuthModel expiration date: $expiration");

    if (expiration.isAfter(now)) {
      print("AuthModel data is still valid, navigating to main page.");
      TTDApplicationService.authModel = AuthModel(
          employeeId: authModel.employeeId,
          token: authModel.token,
          expiration: authModel.expiration);
      var result = await _ittdSettingsRepository!.getSetting("startShiftDialogShown");
      print("resultforworkhourssystem ${result}");
      if(result != "true")
      {
        TTDNavigator().pushToMain(WorkingHourSystemPage());

      }
      else
      {
        TTDNavigator().pushToMain(NavigationPage());

      }
    } else {
      // Verinin geçerliliği dolmuş, o halde veriyi sil
      try {
        await _ittdSettingsRepository!.deleteSetting("AuthModel");
        print("Deleted expired AuthModel data.");
      } catch (e) {
        print("Failed to delete expired AuthModel data: $e");
      }

      // Kullanıcıyı giriş sayfasına yönlendir
      print("AuthModel data has expired, redirecting to login page.");
      gotoLogin();
    }
  }

  Future<void> handleLogin(
      String employeeId, String token, String expiration) async {
    // Mevcut kullanıcı bilgilerini sil
    try {
      await _ittdSettingsRepository!.deleteSetting("AuthModel");
      print("Deleted existing AuthModel data.");
    } catch (e) {
      print("Failed to delete existing AuthModel data: $e");
    }

    // Yeni kullanıcı bilgilerini kaydet
    AuthModel newAuthModel =
    AuthModel(employeeId: employeeId, token: token, expiration: expiration);

    try {
      await _ittdSettingsRepository!
          .addSetting("AuthModel", jsonEncode(newAuthModel.toJson()));
      print("Saved new AuthModel data.");
    } catch (e) {
      print("Failed to save new AuthModel data: $e");
    }

    // "Remember Me" durumunu kaydet
    if (isRemembered.value) {
      // Set expiration time for "Remember Me" to 1 hour from now
      DateTime rememberMeExpiration = DateTime.now().add(Duration(hours: 1));
      newAuthModel.expiration = rememberMeExpiration.toIso8601String();

      try {
        await _ittdSettingsRepository!
            .addSetting("AuthModel", jsonEncode(newAuthModel.toJson()));
        await _ittdSettingsRepository!
            .addSetting("RememberMe", jsonEncode(isRemembered.value));
        print(
            "Saved AuthModel data and RememberMe state with expiration time.");
      } catch (e) {
        print("Failed to save AuthModel data or RememberMe state: $e");
      }
    } else {
      try {
        await _ittdSettingsRepository!.deleteSetting("RememberMe");
        print("Deleted RememberMe state.");
      } catch (e) {
        print("Failed to delete RememberMe state: $e");
      }
    }

    // Yeni kullanıcı bilgilerini uygulama servisinde sakla
    TTDApplicationService.authModel = newAuthModel;

    // Ana sayfaya yönlendir
    TTDNavigator().pushToMain(NavigationPage());
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