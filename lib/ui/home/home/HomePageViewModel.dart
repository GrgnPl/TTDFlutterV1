import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ttd/models/rest/responses/duty/dutyByEmployeeId/DutyByEmployeeId.dart';
import 'package:ttd/models/rest/responses/hallway/Hallway.dart';
import 'package:ttd/models/rest/responses/room/RoomDutyCount.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:ttd/ui/login/emplogin/PersonelLoginPage.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/empbreak/EmpBreakRequests.dart';
import '../../../models/rest/responses/additionaltask/Task.dart';
import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDuty.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDutyListResponse.dart';
import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';
import '../../../models/rest/responses/empbreak/EmpBreakAddResponse.dart';
import '../../../models/rest/responses/notification/GetNotificationCountByEmpIdResponse.dart';
import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
import '../../../models/rest/responses/room/Room.dart';
import '../../../models/rest/responses/techninalerror/TechninalError.dart';
import '../../../models/rest/responses/techninalerror/TechninalErrorCount.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class HomePageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  RxList<DutyData?> dutyList = <DutyData>[].obs;
  RxList<TechninalError> technicalErrorList = <TechninalError>[].obs;

  var notificationCount = 0.obs;
  var roomDutyCountLoading = false.obs;
  var roomDutyCountError = false.obs;
  var roomDutyCountErrorMessage = ''.obs;
  var isLoadingRooms = false.obs;

  RxList<DutyByEmployeeId> roomList = <DutyByEmployeeId>[].obs;
  RxList<Hallway> hallwayList = <Hallway>[].obs;
  RxList<RoomDutyCount> roomDutyCountList = <RoomDutyCount>[].obs;
  RxList<TechninalErrorCount> errorCountList = <TechninalErrorCount>[].obs;

  String? _employeeId;
  String? _branchId;
  String? _departmentId;

  String? get employeeId => _employeeId;

  HomePageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();
  }
  @override
  void onInit() {
    super.onInit();
    fetchNotificationCount(_employeeId ?? "");
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
        // Burada login sayfasına yönlendirme yapılabilir.
      }
    }
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      await getRoomsByEmployeeId(_employeeId!);
      await fetchNotificationCount(_employeeId!);
      if (_branchId != null) {
        await getDutyDetailsForDateByBranchId(_branchId!);}
      if(_departmentId !=null)
        {
         await getTechnicalErrorByDeparmentId(_departmentId!);
        }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        _branchId = response.branchId;
        _departmentId = response.departmentId;

        if (_employeeId != null) {
          fetchNotificationCount(_employeeId!);
        }
      } catch (e) {
        roomDutyCountError.value = true;
        roomDutyCountErrorMessage.value = "Employee bilgisi alınamadı.";
      }
    }
  }

  Future<void> fetchNotificationCount(String employeeId) async {
    if (employeeId.isEmpty) {
      print("Error: Employee ID is null or empty");
      return;
    }
    var queryParams = {'id': employeeId};
    try {
      GetNotificationCountByEmpIdResponse response = await _personnelRestService.getNotificationCountByEmpId(queryParams);

      print('Bildirim sayısı API yanıtı: ${response.data}');

      if (response != null && response.data != null) {
        var readNotificationsCount = response.data.where((notification) => notification.status == true).length;

        notificationCount.value = readNotificationsCount;
        print("Güncellenen bildirim sayısı: $readNotificationsCount");
      } else {
        notificationCount.value = 0;
        print("Bildirimler bulunamadı veya null döndü.");
      }

      // Güncelleme sonunda update çağrılıyor
      update();
    } catch (e) {
      print("Error in fetchNotificationCount: $e");
    }
  }

  Future<void> getDutyDetailsForDateByBranchId(String branchId) async {
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService!.getDutyDetailsForDateByBranchId(queryParams);

      if (response.listOfDuty != null && response.listOfDuty!.isNotEmpty) {
        var nonNullDuties = response.listOfDuty!.where((duty) => duty != null).cast<DutyData>().toList();

        var filteredDuties = nonNullDuties.where((duty) {
          return duty.employeeId?.any((employee) => employee.id == _employeeId) ?? false;
        }).toList();

        var filteredDutiesForAppoint = nonNullDuties.where((duty) {
          return duty.employeeId != null && duty.employeeId!.isEmpty;
        }).toList();

        int appointedDuties = filteredDutiesForAppoint.where((duty) {
          return duty.task?.any((task) => task.departmentId == _departmentId) ?? false;
        }).length;

        int completedDuties = filteredDuties.where((duty) => duty.status == false).length;
        int notCompletedDuties = filteredDuties.where((duty) => duty.status == true).length;

        roomDutyCountList.value = [
          RoomDutyCount(completedCount: completedDuties, uncompletedCount: notCompletedDuties, appointedCount: appointedDuties),
        ];

        dutyList.assignAll(filteredDuties);
      } else {
        dutyList.assignAll([]);
        roomDutyCountList.value = [RoomDutyCount(completedCount: 0, uncompletedCount: 0)];
        print('Odalar listesi boş veya null');
      }
    } catch (e) {
      print('Görevler yüklenirken hata oluştu: $e');
      //roomDutyCountError.value = true;
      //roomDutyCountErrorMessage.value = "Görevler yüklenirken hata oluştu.";
      errorCountList.value = [
        TechninalErrorCount(completedCount: 0, uncompletedCount: 0)
      ];
    }
  }
  Future<void> getTechnicalErrorByDeparmentId(String departmentId) async {
    try {
      var queryParams = {'id': departmentId};
      var response = await _personnelRestService!.getTechnicalErrorByDeparmentId(queryParams);

      if (response.listOfTechnicalError != null && response.listOfTechnicalError!.isNotEmpty) {
        var filteredDuties = response.listOfTechnicalError!.where((technicalError) {
          return technicalError.departmentId == _departmentId;
        }).toList();

        // Tamamlanmayan ve tamamlanan teknik arızaları say
        int completedTechnicalDuties = filteredDuties
            .where((technicalError) => technicalError.status == true)
            .length;
        int notCompletedTechnicalDuties = filteredDuties
            .where((technicalError) => technicalError.status == false)
            .length;

        print("completedTechnicalDuties ${completedTechnicalDuties} notCompletedTechnicalDuties ${notCompletedTechnicalDuties}");
        // Görev sayısını güncelle
        errorCountList.value = [
          TechninalErrorCount(completedCount: completedTechnicalDuties, uncompletedCount: notCompletedTechnicalDuties)
        ];

        // Teknik arıza listesini güncelle
        technicalErrorList.assignAll(filteredDuties);
      } else {
        // Eğer liste boşsa
        technicalErrorList.assignAll([]);
        errorCountList.value = [TechninalErrorCount(completedCount: 0, uncompletedCount: 0)];
        print('Teknik arıza listesi boş veya null');
      }
    } catch (e) {
      print('Teknik arızalar yüklenirken hata oluştu: $e');
      //roomDutyCountError.value = true;
      //roomDutyCountErrorMessage.value = "Teknik arızalar yüklenirken hata oluştu.";
      errorCountList.value = [
        TechninalErrorCount(completedCount: 0, uncompletedCount: 0)
      ];
    }
  }

  Future<void> getRoomsByEmployeeId(String employee_id) async {
    try {
      isLoadingRooms.value = true;
      var queryParams = {'id': employee_id};


      var response = await _personnelRestService.getDutyByEmployeeId(queryParams);

      print('API Response: $response');

      if (response.listOfDutyByEmpId != null && response.listOfDutyByEmpId!.isNotEmpty) {
        roomList.assignAll(response.listOfDutyByEmpId!);
      } else {
        roomList.assignAll([]);
        print('Odalar listesi boş veya null');
      }
    } catch (e, stacktrace) {
      print('Error fetching rooms by branch ID: $e');
      print('StackTrace: $stacktrace');

      roomDutyCountError.value = true;
      roomDutyCountErrorMessage.value = "Odalar yüklenirken hata oluştu. Hata mesajı: $e";
    } finally {
      isLoadingRooms.value = false;
    }
  }

  Future<RoomDuty?> getRoomDutyWithTasks(String roomId) async {
    try {
      var queryParams = {'id': roomId};
      RoomDutyListResponse response = await _personnelRestService.getDutyFromRoomId(queryParams);
      print("Response: $response");

      if (response != null && response.listOfRoomDuty != null && response.listOfRoomDuty!.isNotEmpty) {
        // İlk RoomDuty nesnesini alıyoruz (Örneğin listede tek bir oda görevi olduğunu varsayıyoruz)
        return response.listOfRoomDuty!.first;
      } else {
        print("Oda görevi bulunamadı");
        return null;
      }
    } catch (e) {
      print('Error fetching room duty with tasks for room: $e');
      return null;
    }
  }

  Future<void> refreshRoomDutyCounts() async {
    roomDutyCountLoading.value = true;
    roomDutyCountError.value = false;

    try {
      if (_branchId != null && _employeeId != null && _departmentId != null) {
        await getDutyDetailsForDateByBranchId(_branchId!);
        await getTechnicalErrorByDeparmentId(_departmentId!);
      }
    } catch (e) {
      roomDutyCountError.value = true;
      roomDutyCountErrorMessage.value = "Veriler yüklenirken hata oluştu: $e";
    } finally {
      roomDutyCountLoading.value = false;
    }
  }


  Future<List<Tasks>> getActiveTasksForRoom(String roomId) async {
    try {
      var queryParams = {'id': roomId};
      RoomDutyListResponse response = await _personnelRestService.getDutyFromRoomId(queryParams);
      print("Response: $response");

      if (response != null && response.listOfRoomDuty != null) {
        print("Gelen Response Oda Görevi ${response.listOfRoomDuty!.length}");

        List<Tasks> activeTasks = [];

        for (var duty in response.listOfRoomDuty!) {
          if (duty.task != null && duty.task.isNotEmpty && duty.status == true) {
            for (var task in duty.task) {
              activeTasks.add(Tasks(
                taskName: task.taskName,
                taskDescription: task.taskDescription,
                status: task.status,
                departmentId: '',
              ));
            }
          }
        }

        return activeTasks;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching active tasks for room: $e');
      return [];
    }
  }

  Future<void> submitBreakRequest(BuildContext context, String breakDescription, String breakTime, String breakDate) async {
    var employeeId = TTDApplicationService.authModel?.employeeId;
    if (employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Employee ID bulunamadı")),
      );
      return;
    }

    var breakRequest = EmpBreakRequests(
      employeeId: employeeId,
      breakDescription: breakDescription,
      breakTime: int.tryParse(breakTime),
      breakDate: breakDate,
    );

    try {
      final response = await _personnelRestService.employeeBreak(breakRequest);
      if (response != null && (response.success ?? false)) {
        Navigator.of(context).pop(); // Dialog'u kapat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mola talebi başarıyla gönderildi")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mola talebi başarısız: ${response?.message ??
              'Bilinmeyen hata'}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mola talebi gönderilemedi: $error")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}