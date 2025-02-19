import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/responses/duty/dutyByBranchId/GetAllDutyByBranchIdResponse.dart';
import 'package:ttd/ui/ViewModelBase.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/responses/duty/Duty.dart';
import '../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class DutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService;
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  String? _employeeId;
  String? _branchId;
  String? get employeeId => _employeeId;
  String? get branchId => _branchId;
  var isLoadingDutys = false.obs;
  RxList<DutyData?> dutyList = <DutyData>[].obs;

  DutyPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    initPage();

  }

  void initPage() async {
    await controlRemember();
    await fetch();  // Kullanıcı bilgilerini ve odalarını getir
  }
  Future<void> fetch() async {
    await fetchEmployeeInfoAndRooms();
  }


  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_branchId != null && _branchId!.isNotEmpty) {
        await getAllDutyByBranchID(_branchId!);
      }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService!.getEmployeeInfo(queryParams);
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
      isLoadingDutys.value = true;
      var queryParams = {'id': branchId};
      var response = await _personnelRestService!.getDutyDetailsForDateByBranchId(queryParams);

      if (response.listOfDuty != null && response.listOfDuty!.isNotEmpty) {
        // Status değeri true olanları filtreliyoruz
        var filteredDuties = response.listOfDuty!.where((duty) {
          return duty.employeeId!.any((employee) => employee.id == _employeeId);
        }).toList();

        var notcompletedDuties = filteredDuties
            .where((duty) => duty.status == true);


        if (filteredDuties.isNotEmpty) {
          dutyList.assignAll(notcompletedDuties);
        } else {
          dutyList.assignAll([]);
          print('Filtrelenen odalar listesi boş');
        }
      } else {
        dutyList.assignAll([]);
        print('Odalar listesi boş veya null');
      }
    } catch (e) {
      print('Odalar yüklenirken hata oluştu: $e');
    } finally {
      isLoadingDutys.value = false;
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

  @override
  void dispose() {
    super.dispose();
  }
}