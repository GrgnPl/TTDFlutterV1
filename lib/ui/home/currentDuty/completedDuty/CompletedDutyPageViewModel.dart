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
import '../../../../models/rest/responses/duty/dutyForNow/DutyForNowResponse.dart';
import '../../../../rest/emp/PersonnelRestService.dart';
import '../../../../services/common/TTDApplicationService.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';
class CompletedDutyPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  RxList<DutyForNowData> dutyList = <DutyForNowData>[].obs;
  var isLoading = false.obs;

  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator()
      .get<ITTDSettingsRepository>();
  String? _employeeId;
  String? _branchId;

  String? get employeeId => _employeeId;

  CompletedDutyPageViewModel() {
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
        await fetchCompletedTasks();
      }
    }
  }

  Future<void> fetchCompletedTasks() async {
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

      final response = await _personnelRestService.getDutyForNowByBranchAndEmpIdForPassive(queryParams);
      if (response.success == true && response.data != null) {
        dutyList.assignAll(response.data!);
        if (dutyList.isNotEmpty) {
          print('İlk görev verisi: ${dutyList[0].toJson()}');
        }
        print('Tamamlanan görevler yüklendi: ${dutyList.length}');
      } else {
        print('API yanıtı başarısız veya data null. Response: $response');
        dutyList.clear();
      }
    } catch (e) {
      print('Tamamlanan görevler yüklenirken hata: $e');
      dutyList.clear();
    } finally {
      isLoading.value = false;
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
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}