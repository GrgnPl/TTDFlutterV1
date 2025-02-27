import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/requests/lostproperty/LostPropertyRequest.dart';
import 'package:ttd/models/rest/requests/technicalerror/TechnicalErrorRequest.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechninalError.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyTakeImagePage.dart';
import 'package:ttd/ui/home/techninalerror/TechnicalDutyFinishPhotoPage.dart';
import 'package:ttd/ui/home/techninalerror/TechninalErrorTakeImagePage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/stockitem/StockItemRequest.dart';
import '../../../models/rest/responses/duty/Duty.dart';
import '../../../models/rest/responses/lostProperty/LostProperty.dart';
import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';


class TechninalErrorPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  RxList<TechninalError> technicalErrorList = <TechninalError>[].obs;
  RxList<GetAllRoomByBranchId> roomList = <GetAllRoomByBranchId>[].obs;

  String? _employeeId;
  String? _departmentId;
  String? _departmentName;
  String? _branchId;
  String? _empName;
  String? get employeeId => _employeeId;
  String? get branchId => _branchId;
  String? get empName => _empName;
  var isLoadingRooms = false.obs; // Yükleme durumu
  var isInitialized = false.obs; // initPage'in tamamlandığını takip eden yeni bir RxBool
  var technicalDutyLoading = false.obs;

  TechninalErrorPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
  }

  void initPage() async {
    await controlRemember();
    await fetchEmployeeInfoAndRooms();
  }

  Future<void> controlRemember() async {
    var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMe != null && jsonDecode(rememberMe)) {
      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      if (result != null) {
        AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
        TTDApplicationService.authModel = authModel;
        _employeeId = authModel.employeeId;
      }
    } else {
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
        await getRoomsByBranchId(_branchId!);
      }
      if(_departmentId !=null)
      {
        await getDepartmentName(_departmentId!);
        await getTechnicalErrorByDeparmentId();
      }

    }
  }


  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.getEmployeeInfo(queryParams);
      if (response.branchId != null) {
        _branchId = response.branchId;
        _empName = "${response.firstName} ${response.lastName}";
        _departmentId = response.departmentId;

        print("_deparmentID ${_departmentId}");
      } else {
        print('Branch ID boş veya geçersiz.');
      }
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }

  Future<void> getDepartmentName(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.getDepartmentNameFromID(queryParams);
      if (response.message != null) {
        _departmentName = response.departmentName;

        print("_deparmentName ${_departmentName}");
      } else {
        print('_departmentName boş');
      }
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }

  Future<void> getRoomsByBranchId(String branchId) async {
    try {
      isLoadingRooms.value = true;
      var queryParams = {'id': branchId};
      var response = await _personnelRestService.getRoomByBranchById(queryParams);
      if (response.listOfRooms != null && response.listOfRooms!.isNotEmpty) {
        roomList.assignAll(response.listOfRooms!);
      } else {
        roomList.assignAll([]);
        print('Odalar listesi boş veya null');
      }
    } catch (e) {
      print('Odalar yüklenirken hata oluştu: $e');
    } finally {
      isLoadingRooms.value = false;
    }
  }

  Future<List<TechninalError>> getTechnicalErrorByDeparmentId() async {
    if (_departmentId == null) {
      print("Department Id null, teknik hata verisi alınamaz.");
      return [];
    }
    try {
      technicalDutyLoading.value = true;
      print("gidecek departmentID ${_departmentId}");
      var queryParams = {'id': _departmentId!};
      var response = await _personnelRestService.getTechnicalErrorByDeparmentId(queryParams);
      if (response != null) {
        print("response TechnicalError ${response.listOfTechnicalError}");
        List<TechninalError> filteredList = response.listOfTechnicalError!
            .where((item) => item.employeeName == _empName && item.status == false)
            .toList();


        technicalErrorList.assignAll(filteredList);
        print("gelenFiltreliData ${filteredList}");
        return filteredList;
      } else {
        print("response ${response.listOfTechnicalError}");
        return [];
      }
    } catch (e) {
      print('Teknik Arıza Verileri Alınamadı: $e');
      return [];
    }
    finally {
      technicalDutyLoading.value = false;
    }
  }

  Future<void> startTechnicalDuty(String dutyID) async {
    TTDNavigator().pushToMain(TechninalErrorTakeImagePage(TechnicalErrorId: dutyID));
  }

  Future<void> finishTechnicalDuty(String dutyID, String desc) async {
    TTDNavigator().pushToMain(TechnicalDutyFinishPhotoPage(TechnicalErrorId: dutyID,employeeId: _employeeId!,desc: desc,));
  }

  addTechnicalError(String errortitle, String errordescription, String selectedRoom) async {
    try {

      print("employeeInfo ${employeeId}");
      TechnicalErrorRequest technicalErrorRequest = TechnicalErrorRequest(
        errorTitle: errortitle,
        errorDescription: errordescription,
        complecetedDate: "string",
        roomId: selectedRoom,
        employeeId: employeeId,
        departmentId: _departmentId,
      );
      var response = await _personnelRestService!.addTechnicalError(technicalErrorRequest);

      if (response != null && response.success == true) {
        Fluttertoast.showToast(
          msg: "Başarıyla Talep Oluşturuldu Lütfen Bekleyin.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        TTDNavigator().pushToMain(TechninalErrorTakeImagePage(TechnicalErrorId: response.data!));
        getTechnicalErrorByDeparmentId(); // Listeyi güncelle
      } else {
        Fluttertoast.showToast(
          msg: "Talep Oluşturma Sırasında Bir Hata Oluştu.Lütfen Tekrar Deneyin.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Bir Hata Oluştu.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('View Model Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}