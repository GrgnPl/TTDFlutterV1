import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
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
  late ITTDSettingsRepository? _ittdSettingsRepository;

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
  String? _employeeName;

  String? get employeeId => _employeeId;
  String? get employeeName => _employeeName;

  // Yükleme durumları için yeni değişkenler
  var isInitializing = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Tamamlanmayan görevler için sayaç
  var uncompletedTaskCount = 0.obs;
  var isLoadingUncompletedTasks = false.obs;

  var completedTaskCount = 0.obs;
  var tehcnicalTaskCount = 0.obs;

  var isLoading = false.obs;
  var isFirstLoad = true;

  RxList<DutyByEmployeeId> rooms = <DutyByEmployeeId>[].obs;
  RxList<DutyByEmployeeId> filteredRooms = <DutyByEmployeeId>[].obs;

  HomePageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  }

  @override
  void onInit() {
    super.onInit();
    if (isFirstLoad) {
      initPage();
      isFirstLoad = false;
    }
    filteredRooms.assignAll(rooms);
  }

  void initPage() async {
    try {
      isLoading.value = true;
      await controlRemember();
      
      if (_employeeId != null) {
        print('Employee ID: $_employeeId'); // Debug için
        await getEmployeeInfo(_employeeId!);
        
        if (_branchId != null) {
          print('Branch ID: $_branchId'); // Debug için
          await getRoomsByEmployeeId(_employeeId!);
          await getDutyDetailsForDateByBranchId(_branchId!);
        }
        
        if (_departmentId != null) {
          await getTechnicalErrorByDeparmentId(_departmentId!);
        }
        
        await fetchUncompletedTasks();
        await fetchCompletedTasks();
        await fetchNotificationCount(_employeeId!);
      } else {
        print('Employee ID null');
      }
    } catch (e) {
      print('Error in initPage: $e');
    } finally {
      isLoading.value = false;
      isFirstLoad = false;
    }
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
      else
        {
          print("departmentID boş");
        }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        var empName = response.firstName;
        var empLastname = response.lastName;
        var empNameAndLastName = "$empName $empLastname";
        _employeeName = empNameAndLastName;
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

      if (response != null && response.data != null) {
        var readNotificationsCount = response.data.where((notification) => notification.status == true).length;
        notificationCount.value = readNotificationsCount;
      } else {
        notificationCount.value = 0;
      }
      update();
    } catch (e) {
      print("Error in fetchNotificationCount: $e");
    }
  }

  Future<void> getDutyDetailsForDateByBranchId(String branchId) async {
    if (branchId.isEmpty) return;
    
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService!.getDutyDetailsForDateByBranchId(queryParams);

      if (response.listOfDuty != null) {
        var nonNullDuties = response.listOfDuty!
            .where((duty) => duty != null)
            .cast<DutyData>()
            .toList();

        var filteredDutiesForAppoint = nonNullDuties.where((duty) =>
            duty.employeeId?.isEmpty ?? true &&
            duty.task!.any((task) => task.departmentId == _departmentId) ?? false).toList();

        // Sadece atanacak görevleri hesapla
        roomDutyCountList.value = [
          RoomDutyCount(
            completedCount: 0, // Bu değer artık fetchCompletedTasks'dan gelecek
            uncompletedCount: 0, // Bu değer fetchUncompletedTasks'dan geliyor
            appointedCount: filteredDutiesForAppoint.length
          ),
        ];

        dutyList.assignAll(nonNullDuties);
      }
    } catch (e) {
      print('Error in getDutyDetailsForDateByBranchId: $e');
      throw e;
    }
  }

  Future<void> getTechnicalErrorByDeparmentId(String departmentId) async {
    try {
      var queryParams = {'id': departmentId};
      var response = await _personnelRestService!.getTechnicalErrorByDeparmentId(queryParams);
      if (response.listOfTechnicalError != null && response.listOfTechnicalError!.isNotEmpty) {

        var filteredDuties = response.listOfTechnicalError!.where((technicalError) {
          return technicalError.employeeName == _employeeName;
        }).toList();

        int notCompletedTechnicalDuties = filteredDuties
            .where((technicalError) => technicalError.status == false)
            .length;
        tehcnicalTaskCount.value = notCompletedTechnicalDuties;
        technicalErrorList.assignAll(filteredDuties);
      } else {
        // Eğer liste boşsa
        technicalErrorList.assignAll([]);
        errorCountList.value = [TechninalErrorCount(completedCount: 0, uncompletedCount: 0)];
        print('Teknik arıza listesi boş veya null');
      }
    } catch (e) {
      print('Teknik arızalar yüklenirken hata oluştu: $e');
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

      if (response.listOfDutyByEmpId != null && response.listOfDutyByEmpId!.isNotEmpty) {
        var uniqueRooms = <DutyByEmployeeId>[];
        var seenRoomIds = <String>{};
        
        for (var room in response.listOfDutyByEmpId!) {
          if (room.id != null && !seenRoomIds.contains(room.id)) {
            seenRoomIds.add(room.id!);
            uniqueRooms.add(room);
          }
        }
        roomList.assignAll(uniqueRooms);
        rooms.assignAll(uniqueRooms);
        filteredRooms.assignAll(uniqueRooms);
      } else {
        print('Oda listesi boş geldi');
        roomList.clear();
        rooms.clear();
        filteredRooms.clear();
      }
    } catch (e, stacktrace) {
      print('Error fetching rooms by employee ID: $e');
      print('StackTrace: $stacktrace');
      roomDutyCountError.value = true;
      roomDutyCountErrorMessage.value = "Odalar yüklenirken hata oluştu. Hata mesajı: $e";
    } finally {
      isLoadingRooms.value = false;
    }
  }

  Future<List<RoomDuty>> getRoomDutyWithTasks(String roomId) async {
    try {
      var queryParams = {'id': roomId};
      RoomDutyListResponse response = await _personnelRestService.getDutyFromRoomId(queryParams);

      if (response != null && response.listOfRoomDuty != null) {
        return response.listOfRoomDuty!;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching room duty with tasks for room: $e');
      return [];
    }
  }

  Future<void> refreshRoomDutyCounts() async {
    if (isInitializing.value) return; // Zaten yükleniyorsa tekrar yükleme

    roomDutyCountLoading.value = true;
    roomDutyCountError.value = false;

    try {
      if (_branchId != null && _departmentId != null) {
        await Future.wait([
          getDutyDetailsForDateByBranchId(_branchId!),
          getTechnicalErrorByDeparmentId(_departmentId!),
        ]);
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

  Future<void> fetchUncompletedTasks() async {
    if (_branchId == null || _employeeId == null) {
        print('Branch ID veya Employee ID null. İşlem iptal edildi.');
        return;
    }
    else
      {
        print("bos emp ve branch");
      }
    isLoadingUncompletedTasks.value = true;
    try {
        var queryParams = {
            'id': _branchId,
            'empId': _employeeId,
        };
        print("gidecek Query : $queryParams");

        final response = await _personnelRestService.getDutyForNowByBranchAndEmpId(queryParams);
        print(" Tamamlanmayan Gorevler Response $response");
        if (response.success == true && response.data != null) {
            print('Görev listesi uzunluğu Tamamlanmayan Görevler: ${response.data!.length}');

            uncompletedTaskCount.value = response.data!.length;
        } else {
            print('API yanıtı başarısız veya data null. Response: $response');
        }
    } catch (e, stackTrace) {
        print('Tamamlanmayan görevler yüklenirken hata: $e');
        print('Stack trace: $stackTrace');
        Get.snackbar(
            'Hata',
            'Tamamlanmayan görevler yüklenirken bir hata oluştu',
            backgroundColor: Colors.red,
            colorText: Colors.white,
        );
    } finally {
        isLoadingUncompletedTasks.value = false;
    }
  }

  Future<void> fetchCompletedTasks() async {
    if (_branchId == null || _employeeId == null) {
      print('Branch ID veya Employee ID null. İşlem iptal edildi.');
      return;
    }
    isLoadingUncompletedTasks.value = true;
    try {
      var queryParams = {
        'id': _branchId,
        'empId': _employeeId,
      };

      final response = await _personnelRestService.getDutyForNowByBranchAndEmpIdForPassive(queryParams);
      if (response.success == true && response.data != null) {
        print('Görev listesi uzunluğu Tamamlanan Görevler: ${response.data!.length}');

        completedTaskCount.value = response.data!.length;
      } else {
        print('API yanıtı başarısız veya data null. Response: $response');
      }
    } catch (e, stackTrace) {
      print('Tamamlanan görevler yüklenirken hata: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Hata',
        'Tamamlanmayan görevler yüklenirken bir hata oluştu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingUncompletedTasks.value = false;
    }
  }

  // Manuel yenileme için
  Future<void> refreshData() async {
    if (!isLoading.value) {
      await fetchEmployeeInfoAndRooms();
      await fetchCompletedTasks();
      await fetchUncompletedTasks();
    }
  }

  void showBreakRequestDialog(BuildContext context) {
    TextEditingController breakDescriptionController = TextEditingController();
    TextEditingController breakTimeController = TextEditingController();
    TextEditingController breakDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Mola Talebi Oluştur",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: breakDescriptionController,
                decoration: InputDecoration(
                  labelText: "Mola Açıklaması",
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                cursorColor: Color(0xFF172a31),
              ),
              TextField(
                controller: breakTimeController,
                decoration: InputDecoration(
                  labelText: "Süresi (dk)",
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: Color(0xFF172a31),
              ),
              TextField(
                controller: breakDateController,
                decoration: InputDecoration(
                  labelText: "Gün",
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF172a31)),
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    breakDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                  }
                },
                readOnly: true,
                cursorColor: Color(0xFF172a31),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("İptal", style: TextStyle(color: Color(0xFF172a31))),
            ),
            TextButton(
              onPressed: () {
                if (breakDescriptionController.text.isEmpty ||
                    breakTimeController.text.isEmpty ||
                    breakDateController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Tüm alanları doldurunuz",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                submitBreakRequest(
                  context,
                  breakDescriptionController.text,
                  breakTimeController.text,
                  breakDateController.text,
                );

                breakDescriptionController.clear();
                breakTimeController.clear();
                breakDateController.clear();
              },
              child: Text("Gönder", style: TextStyle(color: Color(0xFF172a31))),
            ),
          ],
        );
      },
    );
  }

  void searchRooms(String query) {
    if (query.isEmpty) {
      filteredRooms.assignAll(rooms);
    } else {
      filteredRooms.assignAll(rooms.where((room) =>
          (room.roomName?.toLowerCase().contains(query.toLowerCase()) ?? false)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}