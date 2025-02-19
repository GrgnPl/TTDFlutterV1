import 'dart:ffi';
import 'dart:io';

import 'package:ttd/models/rest/responses/duty/currentDuty/CurrentDutyResponse.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDutyListResponse.dart';
import 'package:ttd/ui/home/duty/DutyPage.dart';

import '../../../../data/settings/TTDSettingsRepository.dart';
import '../../../../models/rest/requests/dutyImage/DutyImageBeforeRequest.dart';
import '../../../../models/rest/responses/duty/roomDuty/RoomDuty.dart';
import '../../../../models/rest/responses/empupdate/EmpUpdateResponse.dart';
import '../../../../rest/emp/PersonnelRestService.dart';
import '../../../../utils/navigation/TTDNavigator.dart';
import '../../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../../ViewModelBase.dart';
import '../../dutyList/BeforeDutyListPage.dart';

class DutySituationPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  DutySituationPageViewModel() {
    initPage();
  }

  initPage() async {
    // Initial setup if needed
  }

  Future<CurrentDutyResponse?> getDutyInfo(String id) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': id};
        var response = await _personnelRestService!.getCurrentDutyById(queryParams);

        print('Response: $response'); // API yanıtını kontrol edelim

        return response;
      } catch (e, stacktrace) {
        print("Error fetching duty info: $e");
        print("StackTrace: $stacktrace");
        return null;
      }
    }
  }

  Future<EmpUpdateResponse?> dutyUpdate(String dutyId, String description) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': dutyId , 'dldDescription': description};
        var response = await _personnelRestService!.dutyUpdate(queryParams);

        print('Response: $response'); // API yanıtını kontrol edelim

        return response;
      } catch (e, stacktrace) {
        print("Error fetching duty info: $e");
        print("StackTrace: $stacktrace");
        return null;
      }
    }
  }



}