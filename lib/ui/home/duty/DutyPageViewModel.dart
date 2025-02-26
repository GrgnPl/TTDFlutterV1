import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/responses/duty/dutyByBranchId/GetAllDutyByBranchIdResponse.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/responses/duty/Duty.dart';
import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../models/rest/responses/duty/dutyById/DutyByIdResponse.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../dutyList/BeforeDutyListPage.dart';

class DutyPageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository;

  RxList<DutyData> duties = <DutyData>[].obs;
  RxList<DutyData> filteredDuties = <DutyData>[].obs;
  var isLoading = false.obs;
  String? _employeeId;
  String? _branchId;
  String? get employeeId => _employeeId;
  String? get branchId => _branchId;

  DutyPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
    initPage();
  }

  @override
  void onInit() {
    super.onInit();
    filteredDuties.assignAll(duties);
  }

  void initPage() async {
    try {
      await controlRemember();
      await fetchDuties();
    } catch (e) {
      print('Error in initPage: $e');
    }
  }

  Future<void> controlRemember() async {
    try {
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
        }
      }
    } catch (e) {
      print('ControlRemember error: $e');
    }
  }

  Future<void> fetchDuties() async {
    if (_employeeId == null) {
      print('Employee ID null. İşlem iptal edildi.');
      return;
    }

    try {
      isLoading.value = true;
      await getEmployeeInfo(_employeeId!);
      
      if (_branchId != null) {
        var queryParams = {
          'id': _branchId,
          'empId': _employeeId,
        };
        print("gidecek Query : $queryParams");

        final response = await _personnelRestService.getDutyDetailsForDateByBranchId(queryParams);
        print("Görevler Response $response");
        
        if (response != null && response.listOfDuty != null) {
          var filteredDuties = response.listOfDuty!.where((duty) {
            return duty.employeeId!.any((employee) => employee.id == _employeeId);
          }).toList();

          print('Görev listesi uzunluğu: ${filteredDuties.length}');
          duties.clear();
          duties.assignAll(filteredDuties);
          this.filteredDuties.assignAll(duties);
        } else {
          print('API yanıtı başarısız veya data null. Response: $response');
          duties.clear();
          filteredDuties.clear();
        }
      } else {
        print('Branch ID null. İşlem iptal edildi.');
      }
    } catch (e, stackTrace) {
      print('Görevler yüklenirken hata: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Hata',
        'Görevler yüklenirken bir hata oluştu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      duties.clear();
      filteredDuties.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService.getEmployeeInfo(queryParams);
      if (response.branchId != null) {
        _branchId = response.branchId;
        print("Branch ID: $_branchId");
      } else {
        print('Branch ID boş veya geçersiz.');
      }
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }

  Future<void> getAllDutyByBranchID(String branchId) async {
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService.getDutyDetailsForDateByBranchId(queryParams);

      if (response.listOfDuty != null && response.listOfDuty!.isNotEmpty) {
        // Status değeri true olanları filtreliyoruz
        var filteredDuties = response.listOfDuty!.where((duty) {
          return duty.employeeId!.any((employee) => employee.id == _employeeId);
        }).toList();

        var notcompletedDuties = filteredDuties
            .where((duty) => duty.status == true);

        if (filteredDuties.isNotEmpty) {
          duties.assignAll(notcompletedDuties);
          print('Görevler yüklendi: ${duties.length}');
        } else {
          duties.assignAll([]);
          print('Filtrelenen odalar listesi boş');
        }
      } else {
        duties.assignAll([]);
        print('Odalar listesi boş veya null');
      }
    } catch (e) {
      print('Odalar yüklenirken hata oluştu: $e');
      duties.clear();
    }
  }

  void goToDutyDetail(String dutyId) {
    TTDNavigator().pushToMain(BeforeDutyListPage(dutyId: dutyId));
  }

  void searchDuties(String query) {
    if (query.isEmpty) {
      filteredDuties.assignAll(duties);
    } else {
      filteredDuties.assignAll(duties.where((duty) =>
          (duty.dutyTitle?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (duty.dldDescription?.toLowerCase().contains(query.toLowerCase()) ?? false)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}