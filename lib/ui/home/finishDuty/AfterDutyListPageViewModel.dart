import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/Tasks.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/models/rest/responses/empupdate/EmpUpdateResponse.dart';
import 'package:ttd/models/rest/responses/product/Product.dart';
import 'package:ttd/models/rest/responses/product/ProductGetAll.dart';
import 'package:ttd/models/rest/responses/room/roomGetById.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/home/HomePage.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/stockitem/StockItemRequest.dart';
import '../../../models/rest/responses/duty/dutyById/DutyByIdResponse.dart';
import '../../../models/rest/responses/materialmanagement/MaterialManagement.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class AfterDutyListPageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  String? _employeeId;
  String? _departmentId;

  String? get employeeId => _employeeId;
  String? get deparmentId => _departmentId;

  Rx<DutyByIdResponse?> currentDuty = Rx<DutyByIdResponse?>(null);
  var selectedMaterial = ''.obs;
  var materials = <Product>[].obs;

  AfterDutyListPageViewModel() {
    initPage();
  }

  initPage() async {
    await controlRemember();
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_departmentId != null) {
        await fetchMaterials(_departmentId!);
      } else {
        print("Department ID alınamadı.");
      }
    } else {
      print("Employee ID alınamadı.");
    }
  }

  Future<void> fetch() async {
    await fetchEmployeeInfoAndRooms();
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId == null) {
      print("Employee ID boş.");
      return;
    }
    if (_departmentId == null) {
      print("Department ID boş.");
      return;
    }

    await getEmployeeInfo(_employeeId!);
    await fetchMaterials(_departmentId!);
  }


  Future<void> controlRemember() async {
    var rememberMe = await _ittdSettingsRepository!.getSetting("RememberMe");
    if (rememberMe != null && jsonDecode(rememberMe)) {
      var result = await _ittdSettingsRepository!.getSetting("AuthModel");
      if (result != null) {
        AuthModel authModel = AuthModel.fromJson(jsonDecode(result));
        TTDApplicationService.authModel = authModel;
        _employeeId = authModel.employeeId;
        print("Employee ID (RememberMe): $_employeeId");
      }
    } else {
      LoginModel? loginModel = TTDApplicationService.loginModel;
      if (loginModel != null) {
        _employeeId = loginModel.employeeId;
        print("Employee ID (LoginModel): $_employeeId");
      } else {
        print("LoginModel bulunamadı. Kullanıcı giriş yapmalıdır.");
      }
    }
  }
  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.getEmployeeInfo(queryParams);
      _departmentId = response.departmentId;
      print("Department ID: $_departmentId");
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }

  Future<ProductGetAll?> fetchMaterials(String departmentId) async {
    try {
      if (departmentId.isEmpty) {
        print("Department ID boş.");
        return null;
      }
      var queryParams = {'id': departmentId};
      var response = await _personnelRestService.getAllProductByDepartmentId(queryParams);
      print("API Yanıtı: ${response}");

      if (response.listOfProduct != null && response.listOfProduct!.isNotEmpty) {
        materials.value = response.listOfProduct!;
        print("Malzeme listesi başarıyla alındı: ${materials.length} ürün.");
      } else {
        print("Malzeme listesi boş.");
      }
    } catch (e, stacktrace) {
      print('Malzeme getirme hatası: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  Future<DutyByIdResponse?> getDutyById(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.getDutyById(queryParams);
      currentDuty.value = response;
      return currentDuty.value;
    } catch (e, stacktrace) {
      print('Hata: $e');
      Fluttertoast.showToast(
        msg: "Oda ID'sinden görev getirirken hata: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception("Failed to fetch duty by ID: $id");
    }
  }

  Future<roomGetById?> getRoomById(String roomId) async {
    try {
      print("Gelen Room Id: $roomId");
      var queryParams = {'id': roomId};
      var response = await _personnelRestService.getByRoomId(queryParams);

      print("API'den Gelen Oda Bilgisi: ${response}");
      return response;
    } catch (e, stacktrace) {
      print('Hata: $e');
      Fluttertoast.showToast(
        msg: "Oda ID'sinden oda bilgisi getirirken hata: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception("Failed to fetch room by ID: $roomId");
    }
  }

  Future<void> finishDuty(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.finishDuty(queryParams);
      Fluttertoast.showToast(
        msg: response != null
            ? "Görev başarıyla bitirildi."
            : "Görev bitirme başarısız.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: response != null ? Colors.green : Colors.red,
        textColor: Colors.white,
      );
      TTDNavigator().pushToMain(NavigationPage());
    } catch (e, stacktrace) {
      Fluttertoast.showToast(
        msg: "Görev bitirme hatası: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> finishDutyAndAddStockItem(BuildContext context, String dutyId, String quantity) async {
    try {
      print("Görev bitirme işlemi başlıyor...");
      DutyByIdResponse? dutyInfo = await getDutyById(dutyId);
      // Görev bilgisi null mı kontrol ediliyor
      if (dutyInfo != null) {
        print("Görev bilgisi: $dutyInfo");

        // Room ID kontrolü
        print("Room ID: ${dutyInfo.roomId}");
        roomGetById? roomInfo = await getRoomById(dutyInfo.roomId);

        // Oda bilgisi null mı kontrol ediliyor
        if (roomInfo != null) {
          print("Oda bilgisi: $roomInfo");
          List<Room> rooms = [
            Room(
                id: roomInfo.id,
                roomName: roomInfo.roomName,
                roomDescription: roomInfo.roomDescription,
                floorId: roomInfo.floorId ?? "string", // Boş değerler yerine varsayılan değer
                hallwayId: roomInfo.hallwayId ?? "string",
                blockId: roomInfo.blockId ?? "string",
                branchId: roomInfo.branchId ?? "string",
                roomNumber: roomInfo.roomNumber ?? "",
                qrCodeAdress: roomInfo.qrCodeAddress?.isNotEmpty == true ? roomInfo.qrCodeAddress : "string",
                status: roomInfo.status
            )
          ];

          // Employee ID kontrolü
          String employeeId = dutyInfo.employeeId.isNotEmpty
              ? dutyInfo.employeeId.first.id ?? "defaultEmployeeId"
              : "defaultEmployeeId";
          print("Employee ID: $employeeId");
          String formattedEntryDate = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

          // Stok talebi için hazırlık
          print("Malzeme ID: ${selectedMaterial.value}, Miktar: $quantity");
          StockItemRequest stockItemRequest = StockItemRequest(
              productId: selectedMaterial.value,
              quantity: int.parse(quantity),
              entryDate: formattedEntryDate,
              description: "string",
              roomId: rooms,
              employeeId: employeeId);

          Map<String, dynamic> requestBody = stockItemRequest.toJson();
          print("Gönderilen JSON verisi: ${jsonEncode(requestBody)}");
          var response = await _personnelRestService.addStockItem(stockItemRequest);
          print("gelen response $response");
          print("Stok item başarıyla eklendi.");
        } else {
          print("Oda bilgisi getirilemedi.");
          Fluttertoast.showToast(
            msg: "Oda bilgisi getirilemedi.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        print("Görev bilgisi bulunamadı.");
        Fluttertoast.showToast(
          msg: "Görev bilgisi bulunamadı.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Görevi tamamlama ve stok öğesi ekleme hatası: $e");
      Fluttertoast.showToast(
        msg: "Görevi tamamlama ve stok öğesi ekleme hatası: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}