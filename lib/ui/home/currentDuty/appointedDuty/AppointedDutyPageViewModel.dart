import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/ViewModelBase.dart';

import '../../../../data/settings/TTDSettingsRepository.dart';
import '../../../../models/domain/common/AuthModel.dart';
import '../../../../models/domain/common/LoginModel.dart';
import '../../../../models/rest/requests/appointedDuty/DutyAssignmentRequest.dart';
import '../../../../models/rest/responses/duty/Duty.dart';
import '../../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../../rest/emp/PersonnelRestService.dart';
import '../../../../services/common/TTDApplicationService.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';
class AppointedDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<
      ITTDPersonelRestService>();
  RxList<DutyData?> dutyList = <DutyData>[].obs;
  RxBool isLoading = true.obs;

  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator()
      .get<ITTDSettingsRepository>();
  String? _employeeId;
  String? _branchId;
  String? _roomName;
  String? _departmentId;
  RxString roomNames = ''.obs;

  String? get roomName => _roomName;
  String? get employeeId => _employeeId;

  AppointedDutyPageViewModel() {
    initPage();
  }

  void initPage() async {
    isLoading.value = true;
    await controlRemember();
    await fetchEmployeeInfoAndRooms();
    isLoading.value = false;

  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_branchId != null) {
        await getAllAppointedDuty(_branchId!);
      }
    }
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
        // Burada login sayfasına yönlendirme yapılabilir.
      }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(
            queryParams);
        _branchId = response.branchId;
        _departmentId = response.departmentId;
      } catch (e) {}
    }
  }


  Future<void> getAllAppointedDuty(String branchId) async {
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService!.getDutyDetailsForDateByBranchId(queryParams);
      print('JSON Response: ${response.listOfDuty}');

      if (response.listOfDuty != null && response.listOfDuty!.isNotEmpty) {
        // employeeId boş olan görevleri filtreleme
        var filteredDutiesForAppoint = response.listOfDuty!.where((duty) {
          return duty.employeeId != null && duty.employeeId!.isEmpty;
        }).toList();


        print("filteredDutiesForAppoint: $filteredDutiesForAppoint");

        var appointedDuties = filteredDutiesForAppoint.where((duty) {
          if (duty.task == null || duty.task!.isEmpty) return false;

          // task içindeki departmentId eşleşmesini kontrol et
          return duty.task!.any((task) => task.departmentId == _departmentId);
        }).toList();

        // Görevleri listeye ekleme
        dutyList.assignAll(appointedDuties);

        print("Appointed Duties: $appointedDuties");
      } else {
        print('Görev listesi boş.');
      }
    } catch (e) {
      print('getAllAppointedDuty Görevler yüklenirken hata oluştu: $e');
    }
  }


  Future<void> getRoomName(String roomId) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': roomId};
        var response = await _personnelRestService!.getByRoomId(queryParams);
        print('Room Name Response: ${response.roomName}');
        roomNames.value = response.roomName ?? "Bilinmeyen Oda";
      } catch (e) {
        print("Hata : ${e}");
        roomNames.value = "Hata Oluştu";
      }
    }
  }



  Future<void> addDutyAssignment(
      String selectedRoomId,
      String selectedTaskId,
      ) async {
    try {
      var response = await _personnelRestService!.getEmployeeInfo({'id': _employeeId});
      if (response == null) {
        Fluttertoast.showToast(
          msg: "Employee bilgisi bulunamadı.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
      var dutyResponse = await _personnelRestService!.getDutyDetailsForDateByBranchId({'id': _branchId});
      if (dutyResponse.listOfDuty == null || dutyResponse.listOfDuty!.isEmpty) {
        Fluttertoast.showToast(
          msg: "Görev verisi bulunamadı.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      List<DutyAssignment> duties = dutyResponse.listOfDuty!.map((duty) {
        List<TaskAssignment> tasks = duty.task!.map((task) {
          return TaskAssignment(
            taskName: task.taskName ?? '',
            taskDescription: task.taskDescription ?? '',
            departmentId: task.departmentId ?? '',
            status: task.status ?? false,
          );
        }).toList();

        return DutyAssignment(
          id: duty.id ?? '',
          roomId: duty.roomId ?? '',
          hallwayId: duty.hallwayId ?? '',
          floorId: duty.floorId ?? '',
          branchId: duty.branchId ?? '',
          blockId: duty.blockId ?? '',
          employeeId: [
            EmployeeAssignment(
              id: response.id ?? '',
              firstName: response.firstName ?? '',
              lastName: response.lastName ?? '',
              email: response.email ?? '',
              departmentId: response.departmentId ?? '',
              age: response.age ?? 0,
              phoneNumber: response.phoneNumber ?? '',
              dateOfStart: response.dateOfStart ?? '',
              dateOfFinish: response.dateOfFinish ?? '',
              title: response.title ?? '',
              status: response.status ?? false,
              branchId: response.branchId ?? '',
              bloodGroup: response.bloodGroup ?? '',
              birthDay: response.birthDay ?? '',
              educationalStatus: response.educationalStatus ?? '',
              lowerSize: response.lowerSize ?? '',
              upperSize: response.upperSize ?? '',
              shoeSize: response.shoeSize ?? 0,
              emergencyContactName: response.emergencyContactName ?? '',
              emergencyContactNumber: response.emergencyContactNumber ?? '',
              emergencyContactRelationship: response.emergencyContactRelationship ?? '',
            )
          ],
          createdUserId: duty.createdUserId ?? '',
          dutyStartDate: duty.dutyStartDate ?? '',
          dutyEndDate: duty.dutyEndDate ?? '',
          startTime: duty.startTime ?? '',
          endTime: duty.endTime ?? '',
          createdDate: duty.createdDate ?? '',
          status: duty.status ?? false,
          dutyTitle: duty.dutyTitle ?? '',
          dutyTagId: duty.dutyTagId ?? '',
          task: tasks,
          taskId: selectedTaskId,
          dldDescription: duty.dldDescription ?? "",
        );
      }).toList();

      // DutyAssignmentRequest oluştur
      DutyAssignmentRequest dutyAssignmentRequest = DutyAssignmentRequest(
        duty: duties,
        employeeId: response.id ?? '',
      );

      // API çağrısı
      var apiResponse = await _personnelRestService!.dutyAssignment(dutyAssignmentRequest);

      if (apiResponse != null) {
        Fluttertoast.showToast(
          msg: "Görev başarıyla atandı.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Görev atama başarısız. Lütfen tekrar deneyin.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Bir hata oluştu: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('addDutyAssignment Hata: $e');
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}