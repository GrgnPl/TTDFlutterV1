import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/ViewModelBase.dart';

import '../../../../data/settings/TTDSettingsRepository.dart';
import '../../../../models/domain/common/AuthModel.dart';
import '../../../../models/domain/common/LoginModel.dart';
import '../../../../models/rest/responses/duty/Duty.dart';
import '../../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../../rest/emp/PersonnelRestService.dart';
import '../../../../services/common/TTDApplicationService.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';

class UnCompletedDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  RxList<DutyData?> dutyList = <DutyData>[].obs;

  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  String? _employeeId;
  String? _branchId;

  String? get employeeId => _employeeId;
  UnCompletedDutyPageViewModel() {
    initPage();

  }

  void initPage() async {
    await controlRemember();
    await fetchEmployeeInfoAndRooms();  // Kullanıcı bilgilerini ve odalarını getir
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_branchId != null) {
        await getAllDutyByBranchID(_branchId!);
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
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        _branchId = response.branchId;

      } catch (e) {
      }
    }
  }


  Future<void> getAllDutyByBranchID(String branchId) async {
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService!.getDutyDetailsForDateByBranchId(queryParams);

      if (response.listOfDuty != null && response.listOfDuty!.isNotEmpty) {
        var filteredDuties = response.listOfDuty!.where((duty) {
          return duty.employeeId!.any((employee) => employee.id == _employeeId) &&
              duty.status == true;
        }).toList();

        dutyList.assignAll(filteredDuties);
      } else {
        print('Görev listesi boş.');
      }
    } catch (e) {
      print('Görevler yüklenirken hata oluştu: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}