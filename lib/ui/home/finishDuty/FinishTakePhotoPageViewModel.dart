import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ttd/ui/home/duty/DutyPage.dart';

import '../../../data/settings/TTDSettingsRepository.dart';
import '../../../models/domain/common/AuthModel.dart';
import '../../../models/domain/common/LoginModel.dart';
import '../../../models/rest/requests/dutyImage/DutyImageBeforeRequest.dart';
import '../../../models/rest/responses/duty/roomDuty/RoomDuty.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';
import '../../ViewModelBase.dart';
import '../dutyList/BeforeDutyListPage.dart';
import 'AfterDutyListPage.dart';

class FinishTakePhotoPageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
  late ITTDSettingsRepository? _ittdSettingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();
  RoomDuty? _roomInfo;  // Private field
  String? _dutyID;
  String? _employeeId;

  String? get employeeId => _employeeId;
  RoomDuty? get roomInfo => _roomInfo;  // Public getter
  String? get dutyInfo => _dutyID;  // Public getter

  FinishTakePhotoPageViewModel() {
    initPage();
  }
  initPage() async {
    await controlRemember();
    await fetch();
  }

  Future<void> fetch() async {
    await fetchEmployeeInfoAndRooms();
  }

  Future<void> fetchEmployeeInfoAndRooms() async {
    if (_employeeId != null) {
      await getEmployeeInfo(_employeeId!);
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
      }
    }
  }

  Future<void> getEmployeeInfo(String id) async {
    try {
      var queryParams = {'id': id};
      var response = await _personnelRestService!.getEmployeeInfo(queryParams);
    } catch (e) {
      print('Employee bilgisi alınamadı: $e');
    }
  }


  Future<void> processImageUpload(String roomId, File image, int imageNumber) async {
    await getDutyFromRoomId(roomId);

    if (_roomInfo?.id != null) {
      await uploadImage(_roomInfo!.id!, image, imageNumber);
    } else {
      print("Duty ID alınamadı, resim yükleme başarısız.");
    }
  }

  Future<void> getDutyFromRoomId(String roomId) async {
    if (_personnelRestService != null) {
      try {
        var queryParams = {'id': roomId};
        var response = await _personnelRestService!.getDutyFromRoomId(queryParams);

        if (response?.listOfRoomDuty != null && response!.listOfRoomDuty!.isNotEmpty) {
          //_roomInfo = response.listOfRoomDuty!.first;
          _roomInfo = response.listOfRoomDuty!.where((element){
            return element.employeeName.any((employee) => employee.id == _employeeId);
          }).first;
          print('Duty ID: ${_roomInfo?.id}');
        } else {
          print("Duty not found for the given roomId.");
        }
      } catch (e, stacktrace) {
        print("Error fetching dutyId: $e");
        print("StackTrace: $stacktrace");
      }
    }
  }

  Future<void> uploadImage(String dutyId, File image, int imageNumber) async {
    try {
      var request = DutyImageBeforeRequest(
        DutyId: dutyId,
        ImageDate: DateTime.now().toIso8601String(),
        ImageNumber: imageNumber,
        Image: image,
      );
      var response = await _personnelRestService!.addDutyImageAfter(request);
      if (response != null) {
        print('Image uploaded successfully');
        TTDNavigator().pushToMain(AfterDutyListPage(dutyId: dutyId));
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  gotoDutyList(String dutyId) {
    TTDNavigator().pushToMain(AfterDutyListPage(dutyId: dutyId));
  }



}

