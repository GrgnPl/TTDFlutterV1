import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ttd/models/rest/responses/hallway/Hallway.dart';
import 'package:ttd/models/rest/responses/room/RoomDutyCount.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPage.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/empbreak/EmpBreakRequests.dart';
import '../../../models/rest/responses/additionaltask/Task.dart';
import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDutyListResponse.dart';
import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';
import '../../../models/rest/responses/empbreak/EmpBreakAddResponse.dart';
import '../../../models/rest/responses/notification/GetNotificationCountByEmpIdResponse.dart';
import '../../../models/rest/responses/profil/EmployeeGetAllResponse.dart';
import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
import '../../../models/rest/responses/room/Room.dart';
import '../../../models/rest/responses/techninalerror/TechninalError.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../login/LoginPage.dart';

class WorkingHourSystemPageExitViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  var roomDutyCountErrorMessage = ''.obs;  // RxString olarak tanımlandı
  var roomDutyCountError = false.obs;  // RxBool olarak tanımlandı

  String? _employeeId;
  String? _branchId;
  Timer? _timer; // Zamanlayıcı
  EmployeeGetAllResponse? _employeeInfo;
  String? _imageUrl;


  String? get employeeId => _employeeId;

  WorkingHourSystemPageExitViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
  }
  @override
  void onInit() {
    super.onInit();
  }
  void initPage() async {
    await controlRemember();
    await fetchEmployeeInfoAndRooms();  // Kullanıcı bilgilerini ve odalarını getir
  }



  Future<void> controlRemember() async {
    var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMe != null && jsonDecode(rememberMe)) {
      // Eğer RememberMe seçilmişse AuthModel kullanılıyor
      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      if (result != null) {
        AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
        TTDApplicationService.authModel = authModel;
        _employeeId = authModel.employeeId;
      }
    } else {
      // Eğer RememberMe seçilmediyse loginModel kullanılacak
      LoginModel? loginModel = TTDApplicationService.loginModel;
      if (loginModel != null) {
        _employeeId = loginModel.employeeId;
      } else {
        print("LoginModel bulunamadı. Kullanıcı giriş yapmalıdır.");
      }
    }
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_branchId != null) {
      }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        _branchId = response.branchId;

        if (_employeeId != null) {
        }
      } catch (e) {
        roomDutyCountError.value = true;
        roomDutyCountErrorMessage.value = "Employee bilgisi alınamadı.";
      }
    }
  }


  Future<void> finishWork(String qrId) async {
    if (_personnelRestService != null) {
      try {
        if(employeeId !=null)
        {
          var queryParams = {'id': employeeId, 'qrId': qrId};
          var response = await _personnelRestService!.finishWorkingHoursSystem(queryParams);
          print('Görev başlatma yanıtı: $response');
          print("Görev oda ID'sinden başarıyla başlatıldı");
          Fluttertoast.showToast(
            msg: "Vardiya Bitirildi. Çıkış Yapılıyor...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          _ittdSettingsRepository!.addSetting("startShiftDialogShown", "false");
          await _ittdSettingsRepository!.deleteSetting("AuthModel");
          _employeeId = null;
          _employeeInfo = null;
          _imageUrl = null;
          TTDApplicationService.authModel = null;
          TTDApplicationService.loginModel = null; // loginModel null olarak ayarlandı
          TTDNavigator().pushToMain(LoginPage());
        }

        //TTDNavigator().pushToMain(DutySituationPage(dutyId: dutyID));
      } catch (e, stacktrace) {
        Fluttertoast.showToast(
          msg: "Bir Hata Oluştu.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("Oda ID'sinden görev başlatma hatası: $e");
        print("StackTrace: $stacktrace");
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }
}