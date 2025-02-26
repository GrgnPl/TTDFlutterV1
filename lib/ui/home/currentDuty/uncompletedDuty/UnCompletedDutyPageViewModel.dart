import 'dart:async';
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import 'package:get/get.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPage.dart';

import '../../../../data/settings/TTDSettingsRepository.dart';
import '../../../../models/domain/common/AuthModel.dart';
import '../../../../models/domain/common/LoginModel.dart';
import '../../../../models/rest/responses/duty/Duty.dart';
import '../../../../models/rest/responses/duty/dutyByBranchId/DutyData.dart';
import '../../../../models/rest/responses/duty/dutyForNow/DutyForNowResponse.dart';
import '../../../../rest/emp/PersonnelRestService.dart';
import '../../../../services/common/TTDApplicationService.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';

class UnCompletedDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  
  final uncompletedDuties = <DutyForNowData>[].obs;
  final isLoading = false.obs;

  String? _employeeId;
  String? _branchId;

  String? get employeeId => _employeeId;

  UnCompletedDutyPageViewModel() {
    initPage();
  }

  void initPage() async {
    await controlRemember();
    await fetchEmployeeInfoAndRooms();
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
      if (_branchId != null) {
        await getUncompletedDuties();
      }
    }
  }

  Future<void> getUncompletedDuties() async {
    if (_branchId == null || _employeeId == null) {
      print('Branch ID veya Employee ID null. İşlem iptal edildi.');
      return;
    }

    try {
      isLoading.value = true;
      var queryParams = {
        'id': _branchId,
        'empId': _employeeId,
      };

      final response = await _personnelRestService!.getDutyForNowByBranchAndEmpId(queryParams);
      if (response.success == true && response.data != null) {
        uncompletedDuties.assignAll(response.data!);
        print('Tamamlanmayan görevler yüklendi: ${uncompletedDuties.length}');
      } else {
        print('API yanıtı başarısız veya data null. Response: $response');
        uncompletedDuties.clear();
      }
    } catch (e) {
      print('Tamamlanmayan görevler yüklenirken hata: $e');
      uncompletedDuties.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void goToDutyDetail(String dutyId) {
    TTDNavigator().pushToMain(DutySituationPage(dutyId: dutyId));
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

  Future<void> getEmployeeInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getEmployeeInfo(queryParams);
        _branchId = response.branchId;
      } catch (e) {
        print('Employee bilgisi alınamadı: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}