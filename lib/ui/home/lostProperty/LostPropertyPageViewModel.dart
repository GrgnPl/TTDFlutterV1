import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/requests/lostproperty/LostPropertyRequest.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/home/lostProperty/LostPropertyTakeImagePage.dart';
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


class LostPropertyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  RxList<LostProperty> lostPropertyList = <LostProperty>[].obs;
  RxList<GetAllRoomByBranchId> roomList = <GetAllRoomByBranchId>[].obs;

  String? _employeeId;
  String? _branchId;
  String? _empName;
  String? get employeeId => _employeeId;
  String? get branchId => _branchId;
  String? get empName => _empName;
  var isLoadingRooms = false.obs; // Yükleme durumu

  LostPropertyPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
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
      if (_branchId != null && _branchId!.isNotEmpty) {
        await getRoomsByBranchId(_branchId!);
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
        print("Branch ID: $_branchId");
      } else {
        print('Branch ID boş veya geçersiz.');
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

  addLostProperty(String propertyName, String propertyDesc, String selectedRoom, bool itemValuable) async {
    try {
      LostPropertyRequest lostPropertyRequest = LostPropertyRequest(
        propertyName: propertyName,
        description: propertyDesc,
        roomId: selectedRoom,
        employeeId: employeeId,
        itemDiscoveryDate: "string",
        finishDate: "string",
        itemValuable: itemValuable,
        delivered: true,
        employeeName: empName,
      );
      print('LostPropertyRequest: $lostPropertyRequest');

      var response = await _personnelRestService!.addLostProperty(lostPropertyRequest);
      print('AddLostProperty Response: $response');

      if (response != null) {
        Fluttertoast.showToast(
          msg: "Başarıyla Talep Oluşturuldu Lütfen Bekleyin.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print("gelen id ${response.data}");
        // Navigation işleminden önce propertyID'nin null olmadığını kontrol ediyoruz
        TTDNavigator().pushToMain(LostPropertyTakeImagePage(propertyID: response.data!));
        getAllLostProperty();
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

  Future<List<LostProperty>> getAllLostProperty() async {
    try {
      var response = await _personnelRestService.getAllLostProperty();
      if (response != null) {
        // delivered == true olan kayıtları filtreliyoruz.
        List<LostProperty> filteredList = response.listOfLostProperty!.where((item) => item.delivered == true).toList();
        lostPropertyList.assignAll(filteredList);
        return filteredList;
      } else {
        return [];
      }
    } catch (e) {
      print('Kayıp eşya verileri alınamadı: $e');
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}