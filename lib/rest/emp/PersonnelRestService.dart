import 'package:ttd/models/domain/common/AuthModel.dart';
import 'package:ttd/models/rest/requests/appointedDuty/DutyAssignmentRequest.dart';
import 'package:ttd/models/rest/requests/empbreak/EmpBreakRequests.dart';
import 'package:ttd/models/rest/requests/empforgotpass/ChangePasswordRequest.dart';
import 'package:ttd/models/rest/requests/empforgotpass/EmpForgotPasswordRequest.dart';
import 'package:ttd/models/rest/requests/emplogin/EmpLoginRequest.dart';
import 'package:ttd/models/rest/requests/employeeImage/AddEmployeeImageRequest.dart';
import 'package:ttd/models/rest/requests/empregister/EmpRegisterRequest.dart';
import 'package:ttd/models/rest/requests/lostproperty/LostPropertyRequest.dart';
import 'package:ttd/models/rest/requests/lostproperty/PropertyImageRequest.dart';
import 'package:ttd/models/rest/requests/profile/GetByIdEmployee.dart';
import 'package:ttd/models/rest/requests/technicalerror/TechnicalErrorImageRequest.dart';
import 'package:ttd/models/rest/requests/technicalerror/TechnicalErrorRequest.dart';
import 'package:ttd/models/rest/responses/branch/BranchByIdResponse.dart';
import 'package:ttd/models/rest/responses/department/GetDepartmentNameFromId.dart';
import 'package:ttd/models/rest/responses/duty/currentDuty/CurrentDutyResponse.dart';
import 'package:ttd/models/rest/responses/duty/dutyByEmployeeId/DutyByEmployeeIdRepsonse.dart';
import 'package:ttd/models/rest/responses/duty/dutyById/DutyByIdResponse.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDutyListResponse.dart';
import 'package:ttd/models/rest/responses/empbreak/EmployeeBreak.dart';
import 'package:ttd/models/rest/responses/empbreak/EmployeeBreakGetAllResponse.dart';
import 'package:ttd/models/rest/responses/empforgotpass/EmpForgotPasswordResponse.dart';
import 'package:ttd/models/rest/responses/hallway/HallwayByIdResponse.dart';
import 'package:ttd/models/rest/responses/hallway/HallwayGetAllResponse.dart';
import 'package:ttd/models/rest/responses/lostProperty/LostPropertyGetAllResponse.dart';
import 'package:ttd/models/rest/responses/materialmanagement/MaterialManagementGetAllResponse.dart';
import 'package:ttd/models/rest/responses/notification/GetNotificationCountByEmpIdResponse.dart';
import 'package:ttd/models/rest/responses/notification/StatusUpdateResponse.dart';
import 'package:ttd/models/rest/responses/product/ProductGetAll.dart';
import 'package:ttd/models/rest/responses/profil/AddEmployeeResponse.dart';
import 'package:ttd/models/rest/responses/profil/EmployeeGetAllResponse.dart';
import 'package:ttd/models/rest/responses/profil/GetByImagesByEmployeeIdResponse.dart';
import 'package:ttd/models/rest/responses/room/GetAllRoomByBranchId.dart';
import 'package:ttd/models/rest/responses/room/GetAllRoomByBranchIdResponse.dart';
import 'package:ttd/models/rest/responses/room/RoomCountGetAllResponse.dart';
import 'package:ttd/models/rest/responses/room/RoomGetAllResponse.dart';
import 'package:ttd/models/rest/responses/room/roomGetById.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechnicalErrorCompleteResponse.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechninalErrorResponse.dart';
import 'package:ttd/models/rest/responses/version/VersionControlResponse.dart';
import 'package:ttd/models/rest/responses/duty/dutyForNow/DutyForNowResponse.dart';

import '../../data/settings/TTDSettingsRepository.dart';
import '../../models/rest/requests/RequestBase.dart';
import '../../models/rest/requests/dutyImage/DutyImageBeforeRequest.dart';
import '../../models/rest/requests/empUpdate/EmpUpdateRequest.dart';
import '../../models/rest/requests/stockitem/StockItemRequest.dart';
import '../../models/rest/responses/additionaltask/AdditionalTaskGetAllResponse.dart';
import '../../models/rest/responses/duty/DutyGetAllResponse.dart';
import '../../models/rest/responses/duty/dutyByBranchId/GetAllDutyByBranchIdResponse.dart';
import '../../models/rest/responses/duty/startDuty/StartDutyResponse.dart';
import '../../models/rest/responses/dutyImage/DutyImageBeforeResponse.dart';
import '../../models/rest/responses/empbreak/EmpBreakAddResponse.dart';
import '../../models/rest/responses/emplogin/PersonelLoginResponse.dart';
import '../../models/rest/responses/empupdate/EmpUpdateResponse.dart';
import '../../models/rest/responses/lostProperty/LostPropertyGetAll.dart';
import '../../models/rest/responses/stockitem/stock.dart';
import '../../utils/servicelocator/TTDServiceLocator.dart';
import '../RequestType.dart';
import '../RestServiceManager.dart';

abstract class ITTDPersonelRestService {

  ///Login ,Register,ForgotPassword,RememberMe Method
  Future<PersonelLoginResponse> employeeLogin(EmpLoginRequest empLoginRequest);
  Future<PersonelLoginResponse> employeeRegister(EmpRegisterRequest empRegisterRequest);
  Future<EmpForgotPasswordResponse> changePassword(ChangePasswordRequest changePasswordRequest);
  Future<EmpForgotPasswordResponse> employeeForgotPass(Map<String, dynamic> queryParams);
  Future<EmpForgotPasswordResponse> employeeCheckKey(Map<String, dynamic> queryParams);

  ///Get Employee Info, Employee Info Update, Employee Add Profile Photo,
  Future<AddEmployeeResponse> addEmployeeImage(AddEmployeeImageRequest request);
  Future<EmployeeGetAllResponse> getEmployeeInfo(Map<String, dynamic> queryParams);
  Future<EmpUpdateResponse> employeeUpdate(EmpUpdateRequest empUpdateRequest);
  Future<GetByImagesByEmployeeIdResponse> getImagesEmployeeById(Map<String, dynamic> queryParams);

  ///Notification
  Future<GetNotificationCountByEmpIdResponse> getNotificationCountByEmpId(Map<String, dynamic> queryParams);
  Future<StatusUpdateResponse> notificationUpdateById(Map<String, dynamic> queryParams);
  ///VersionControl


  Future<VersionControlResponse> versionControl(Map<String, dynamic> queryParams);

  ///WorkingHours System
  Future<EmpForgotPasswordResponse> startWorkingHoursSystem(Map<String, dynamic> queryParams);
  Future<EmpForgotPasswordResponse> finishWorkingHoursSystem(Map<String, dynamic> queryParams);

  ///Employee Break
  Future<EmpBreakAddResponse> employeeBreak(EmpBreakRequests empBreakRequests);

  ///Department

  Future<GetDepartmentNameFromId> getDepartmentNameFromID(Map<String, dynamic> queryParams);

  /// Duty
  Future<AddEmployeeResponse> dutyAssignment(DutyAssignmentRequest dutyAssignmentRequest);
  Future<DutyImageBeforeResponse> addDutyImageBefore(DutyImageBeforeRequest request);
  Future<DutyImageBeforeResponse> addDutyImageAfter(DutyImageBeforeRequest request);
  Future<StartDutyResponse> startDuty(Map<String, dynamic> queryParams);
  Future<StartDutyResponse> finishDuty(Map<String, dynamic> queryParams);
  Future<RoomDutyListResponse> getDutyFromRoomId(Map<String, dynamic> queryParams);
  Future<GetAllRoomByBranchIdResponse> getRoomByBranchById(Map<String, dynamic> queryParams);
  Future<DutyByIdResponse> getDutyById(Map<String, dynamic> queryParams);
  Future<BranchByIdResponse> getBranchById(Map<String, dynamic> queryParams);
  Future<HallwayByIdResponse> getHallwayById(Map<String, dynamic> queryParams);
  Future<GetAllDutyByBranchIdResponse> getDutyDetailsForDateByBranchId(Map<String, dynamic> queryParams);
  Future<CurrentDutyResponse> getCurrentDutyById(Map<String, dynamic> queryParams);
  Future<DutyByEmployeeIdResponse> getDutyByEmployeeId(Map<String, dynamic> queryParams);
  Future<EmpUpdateResponse> dutyUpdate(Map<String, dynamic> queryParams);


  /// Lost Property
  Future<LostPropertyGetAll> addLostProperty(LostPropertyRequest lostPropertyRequest);
  Future<AddEmployeeResponse> addLostPropertyImage(PropertyImageRequest request);
  Future<LostPropertyGetAllResponse> getAllLostProperty();


  ///Technical Error
  Future<TechninalErrorResponse> getTechnicalErrorByDeparmentId(Map<String, dynamic> queryParams);
  Future<LostPropertyGetAll> addTechnicalError(TechnicalErrorRequest technicalErrorRequest);
  Future<LostPropertyGetAll> updateTechnicalError(TechnicalErrorRequest technicalErrorRequest);
  Future<AddEmployeeResponse> addTechnicalErrorImageLast(TechnicalErrorImageRequest request);
  Future<AddEmployeeResponse> addTechnicalErrorImageFirst(TechnicalErrorImageRequest request);
  Future<TechnicalErrorCompleteResponse> finishTechnicalDuty(Map<String, dynamic> queryParams);


  Future<HallwayGetAllResponse> getAllHallway();
  Future<DutyGetAllResponse> getAllDuty();
  Future<ProductGetAll> getAllProductByDepartmentId(Map<String, dynamic> queryParams);
  Future<RoomDutyListResponse> getLastDuties();



  Future<MaterialManagementGetAllResponse> getAllMaterialUsage();



  Future<AdditionalTaskGetAllResponse> getAllAdditionalTasks();
  Future<stock> addStockItem(StockItemRequest stockItemRequest);

  ///Room
  Future<RoomCountGetAllResponse> getAllRoomDutyCount();
  Future<RoomGetAllResponse> getAllRoom();
  Future<roomGetById> getByRoomId(Map<String, dynamic> queryParams);

  Future<DutyForNowResponse> getDutyForNowByBranchAndEmpIdForPassive(Map<String, dynamic> queryParams);
  Future<DutyForNowResponse> getDutyForNowByBranchAndEmpId(Map<String, dynamic> queryParams);

}

class TTDPersonelRestService implements ITTDPersonelRestService {
  late final ITTDSettingsRepository _settingsRepository = TTDServiceLocator().get<ITTDSettingsRepository>();

  Future<String> _getServerUrl() async {
    var serverUrl = await _settingsRepository.getSetting("ServerUrl");
    if (serverUrl == null) {
      throw Exception("Server URL not set.");
    }
    return serverUrl;
  }
  ///Employee Login,Register,Forgot Pass,Info
  Future<PersonelLoginResponse> employeeLogin(
      EmpLoginRequest empLoginRequest) async {
    var endpoint = 'EmployeeAuth/Login';
    var url = await _getServerUrl();
    
    var rawResponse = await RestServiceManager.call(
      url, endpoint, null, empLoginRequest, RequestType.POST
    );
    print('Raw API Response: $rawResponse'); // Ham API yanıtını yazdır
    
    PersonelLoginResponse personelLoginResponse = PersonelLoginResponse.fromJson(rawResponse);
    print('Parsed Response: $personelLoginResponse'); // Parse edilmiş yanıtı yazdır
    
    return personelLoginResponse;
  }
  Future<EmpBreakAddResponse> employeeBreak(
      EmpBreakRequests empBreakRequests) async {
    var endpoint = 'EmployeeBreak/Add';
    var url = await _getServerUrl();
    EmpBreakAddResponse employeeBreakGetAllResponse =
    EmpBreakAddResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, empBreakRequests, RequestType.POST));
    print(employeeBreakGetAllResponse);
    return employeeBreakGetAllResponse;
  }

  Future<PersonelLoginResponse> employeeRegister(
      EmpRegisterRequest empRegisterRequest) async {
    var endpoint = 'EmployeeAuth/Register';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    PersonelLoginResponse personelLoginResponse =
        PersonelLoginResponse.fromJson(await RestServiceManager.call(
            url, endpoint, null, empRegisterRequest, RequestType.POST));
    return personelLoginResponse;
  }

  Future<EmpForgotPasswordResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    var endpoint = 'EmployeeAuth/ChangeForgottenPassword';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpForgotPasswordResponse empForgotPasswordResponse =
    EmpForgotPasswordResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, changePasswordRequest, RequestType.POST));
    return empForgotPasswordResponse;
  }
  Future<EmpForgotPasswordResponse> employeeCheckKey(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'EmployeeAuth/CheckKey';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpForgotPasswordResponse empForgotPasswordResponse =
    EmpForgotPasswordResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return empForgotPasswordResponse;
  }

  Future<EmpForgotPasswordResponse> employeeForgotPass(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'EmployeeAuth/ForgotPassword';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpForgotPasswordResponse empForgotPasswordResponse =
    EmpForgotPasswordResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return empForgotPasswordResponse;
  }

  Future<EmployeeGetAllResponse> getEmployeeInfo(Map<String, dynamic> queryParams) async {
    var endpoint = 'Employee/GetById';
    var url = await _getServerUrl();
    EmployeeGetAllResponse employeeGetAllResponse = EmployeeGetAllResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(employeeGetAllResponse);
    return employeeGetAllResponse;
  }

  ///WorkingHours System

  Future<EmpForgotPasswordResponse> startWorkingHoursSystem(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'WorkingHoursSystem/QrCodeWorkingHoursAdd';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpForgotPasswordResponse empForgotPasswordResponse =
    EmpForgotPasswordResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return empForgotPasswordResponse;
  }

  Future<EmpForgotPasswordResponse> finishWorkingHoursSystem(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'WorkingHoursSystem/QrCodeWorkingHoursAdd';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpForgotPasswordResponse empForgotPasswordResponse =
    EmpForgotPasswordResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return empForgotPasswordResponse;
  }

  ///Department
  Future<GetDepartmentNameFromId> getDepartmentNameFromID(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'Department/GetByDepertmanId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    GetDepartmentNameFromId departmentNameFromId =
    GetDepartmentNameFromId.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return departmentNameFromId;
  }

  ///Technical Error
  Future<TechninalErrorResponse> getTechnicalErrorByDeparmentId(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'TechninalError/GetAllByDepartmentId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    TechninalErrorResponse techninalErrorResponse =
    TechninalErrorResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return techninalErrorResponse;
  }

  Future<TechnicalErrorCompleteResponse> finishTechnicalDuty(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'TechninalError/TechnicalErrorComplete';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    TechnicalErrorCompleteResponse technicalErrorCompleteResponse =
    TechnicalErrorCompleteResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return technicalErrorCompleteResponse;
  }

  Future<LostPropertyGetAll> addTechnicalError(
      TechnicalErrorRequest technicalErrorRequest) async {
    var endpoint = 'TechninalError/TechniclErrorMobileAdd';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    LostPropertyGetAll lostPropertyGetAll =
    LostPropertyGetAll.fromJson(await RestServiceManager.call(
        url, endpoint, null, technicalErrorRequest, RequestType.POST));
    return lostPropertyGetAll;
  }

  Future<LostPropertyGetAll> updateTechnicalError(
      TechnicalErrorRequest technicalErrorRequest) async {
    var endpoint = 'TechninalError/TechnicalErrorUpdate';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    LostPropertyGetAll lostPropertyGetAll =
    LostPropertyGetAll.fromJson(await RestServiceManager.call(
        url, endpoint, null, technicalErrorRequest, RequestType.POST));
    return lostPropertyGetAll;
  }

  Future<AddEmployeeResponse> addTechnicalErrorImageFirst(TechnicalErrorImageRequest request) async {
    var endpoint = 'TechnicalErrorImage/TechnicalErrorImageCreate';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    print('Request: ${request.toJson()}');
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART, isLoading: false, isMultipart: true, filePath: request.Image?.path);

    if (response == null) {
      print('Response null');
      throw Exception('Response is null');
    }

    AddEmployeeResponse addEmployeeResponse = AddEmployeeResponse.fromJson(response);
    print(addEmployeeResponse);
    return addEmployeeResponse;

  }

  Future<AddEmployeeResponse> addTechnicalErrorImageLast(TechnicalErrorImageRequest request) async {
    var endpoint = 'TechnicalErrorImage/Add';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    print('Request: ${request.toJson()}');
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART, isLoading: false, isMultipart: true, filePath: request.Image?.path);

    if (response == null) {
      print('Response null');
      throw Exception('Response is null');
    }

    AddEmployeeResponse addEmployeeResponse = AddEmployeeResponse.fromJson(response);
    print(addEmployeeResponse);
    return addEmployeeResponse;

  }

  ///Room
  Future<roomGetById> getByRoomId(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'Room/GetByRoomId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    roomGetById roomGetByIdresponse =
    roomGetById.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return roomGetByIdresponse;
  }
  Future<RoomGetAllResponse> getAllRoom() async {
    var endpoint = 'Room/GetAllRooms';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    RoomGetAllResponse roomGetAllResponse = RoomGetAllResponse.fromJson(
        await RestServiceManager.call(
            url, endpoint, null, null, RequestType.GET));
    return roomGetAllResponse;
  }

  Future<RoomCountGetAllResponse> getAllRoomDutyCount() async {
    var endpoint = 'Duty/GetRoomStatusCount';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    RoomCountGetAllResponse roomCountGetAllResponse =
    RoomCountGetAllResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, null, RequestType.GET));
    return roomCountGetAllResponse;
  }

  ///Lost Property
  Future<LostPropertyGetAll> addLostProperty(
      LostPropertyRequest lostPropertyRequest) async {
    var endpoint = 'LostProperty/AddLostPropertyWithImage';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    LostPropertyGetAll lostPropertyGetAll =
    LostPropertyGetAll.fromJson(await RestServiceManager.call(
        url, endpoint, null, lostPropertyRequest, RequestType.POST));
    return lostPropertyGetAll;
  }

  Future<LostPropertyGetAllResponse> getAllLostProperty() async {
    var endpoint = 'LostProperty/GetAll';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    LostPropertyGetAllResponse getAllResponse = LostPropertyGetAllResponse.fromJson(
        await RestServiceManager.call(
            url, endpoint, null, null, RequestType.GET));
    return getAllResponse;
  }

  Future<RoomDutyListResponse> getLastDuties() async {
    var endpoint = 'Duty/GetLatestDuties';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    RoomDutyListResponse roomDutyListResponse = RoomDutyListResponse.fromJson(
        await RestServiceManager.call(
            url, endpoint, null, null, RequestType.GET));
    return roomDutyListResponse;
  }
  Future<MaterialManagementGetAllResponse> getAllMaterialUsage() async {
    var endpoint = 'MaterialManagement/GetAll';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    MaterialManagementGetAllResponse managementGetAllResponse = MaterialManagementGetAllResponse.fromJson(
        await RestServiceManager.call(url, endpoint, null, null, RequestType.GET));
    return managementGetAllResponse;
  }

  Future<HallwayGetAllResponse> getAllHallway() async {
    var endpoint = 'Hallway/GetAll';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    HallwayGetAllResponse hallwayGetAllResponse =
        HallwayGetAllResponse.fromJson(await RestServiceManager.call(
            url, endpoint, null, null, RequestType.GET));
    return hallwayGetAllResponse;
  }

  ///VersionControl
  Future<VersionControlResponse> versionControl(
      Map<String, dynamic> queryParams) async {
    var endpoint = 'Version/GetByName';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    VersionControlResponse versionControlResponse =
    VersionControlResponse.fromJson(await RestServiceManager.call(
        url,
        endpoint,
        null,
        null,
        RequestType.GET,
        queryParams: queryParams));
    return versionControlResponse;
  }
  Future<GetAllDutyByBranchIdResponse> getDutyDetailsForDateByBranchId(Map<String, dynamic> queryParams) async {
      var endpoint = 'Duty/GetDutyDetailsForDateByBranchId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    GetAllDutyByBranchIdResponse getAllDutyByBranchIdResponse = GetAllDutyByBranchIdResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(getAllDutyByBranchIdResponse);
    return getAllDutyByBranchIdResponse;
  }


  Future<EmpUpdateResponse> dutyUpdate(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/DldUpdate';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    EmpUpdateResponse dutyUpdateResponse = EmpUpdateResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(dutyUpdateResponse);
    return dutyUpdateResponse;
  }

  Future<GetByImagesByEmployeeIdResponse> getImagesEmployeeById(Map<String, dynamic> queryParams) async {
    var endpoint = 'EmployeeImage/GetByImagesByEmployeeId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    GetByImagesByEmployeeIdResponse employeeIdResponse = GetByImagesByEmployeeIdResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(employeeIdResponse);
    return employeeIdResponse;
  }
  Future<GetNotificationCountByEmpIdResponse> getNotificationCountByEmpId(Map<String, dynamic> queryParams) async {
    var endpoint = 'PermanentNotification/GetAllByEmployeeId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    // Log queryParams
    print("Fetching notification count with queryParams: $queryParams");

    try {
      var response = await RestServiceManager.call(
          url,
          endpoint,
          null,
          null,
          RequestType.GET,
          queryParams: queryParams
      );

      // Log raw response
      print("Raw response from RestServiceManager: $response");

      GetNotificationCountByEmpIdResponse getNotificationCountByEmpIdResponse = GetNotificationCountByEmpIdResponse.fromJson(response);

      // Log parsed response
      print("Parsed GetNotificationCountByEmpIdResponse: $getNotificationCountByEmpIdResponse");

      return getNotificationCountByEmpIdResponse;
    } catch (e) {
      // Log any errors
      print("Error occurred while fetching notification count: $e");
      rethrow;
    }
  }

  Future<StatusUpdateResponse> notificationUpdateById(Map<String, dynamic> queryParams) async {
    var endpoint = 'PermanentNotification/StatusUpdate';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    // Log queryParams
    print("Status Update notification queryParams: $queryParams");

    try {
      var response = await RestServiceManager.call(
          url,
          endpoint,
          null,
          null,
          RequestType.GET,
          queryParams: queryParams
      );

      // Log raw response
      print("Raw response from RestServiceManager: $response");

      StatusUpdateResponse statusUpdateResponse = StatusUpdateResponse.fromJson(response);

      // Log parsed response
      print("Parsed statusUpdateResponse: $statusUpdateResponse");

      return statusUpdateResponse;
    } catch (e) {
      // Log any errors
      print("Error occurred while fetching notification count: $e");
      rethrow;
    }
  }
  Future<RoomDutyListResponse> getDutyFromRoomId(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetAllDutyByRoomId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    return RoomDutyListResponse.fromJson(response);
  }

  Future<HallwayByIdResponse> getHallwayById(Map<String, dynamic> queryParams) async {
    var endpoint = 'Hallway/GetAllHallwayByBranchId';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    return HallwayByIdResponse.fromJson(response);
  }
  Future<GetAllRoomByBranchIdResponse> getRoomByBranchById(Map<String, dynamic> queryParams) async {
    var endpoint = 'Room/GetAllByBranchId';
    var url = await _getServerUrl();
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    return GetAllRoomByBranchIdResponse.fromJson(response);
  }
  Future<BranchByIdResponse> getBranchById(Map<String, dynamic> queryParams) async {
    var endpoint = 'Branch/GetByBranchId';
    var url = await _getServerUrl();
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    return BranchByIdResponse.fromJson(response);
  }

  Future<DutyByEmployeeIdResponse> getDutyByEmployeeId(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetDutybyEmployeeId';
    var url = await _getServerUrl();
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    return DutyByEmployeeIdResponse.fromJson(response);
  }

  Future<DutyByIdResponse> getDutyById(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetByDutyId';
    var url = await _getServerUrl();
    var response = await RestServiceManager.call(url, endpoint,null,null,RequestType.GET, queryParams: queryParams);

    return DutyByIdResponse.fromJson(response);
  }

  Future<CurrentDutyResponse> getCurrentDutyById(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetByDutyId';
    var url = await _getServerUrl();
    var response = await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams);

    print('API Response: $response');

    return CurrentDutyResponse.fromJson(response);
  }


  Future<StartDutyResponse>   startDuty(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/StartDutyWithEmployee';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    StartDutyResponse startDutyResponse = StartDutyResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(startDutyResponse);
    return startDutyResponse;
  }
  Future<StartDutyResponse> finishDuty(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/FinishDuty';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    StartDutyResponse startDutyResponse = StartDutyResponse.fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    print(startDutyResponse);
    return startDutyResponse;
  }

  Future<DutyGetAllResponse> getAllDuty() async {
    var endpoint = 'Duty/GetAll';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    DutyGetAllResponse dutyGetAllResponse = DutyGetAllResponse
        .fromJson(await RestServiceManager.call(
        url, endpoint, null, null, RequestType.GET));
    return dutyGetAllResponse;
  }

  Future<ProductGetAll> getAllProductByDepartmentId(Map<String, dynamic> queryParams) async {
      var endpoint = 'Product/GetAllByDepartmentId';
    var url = await _getServerUrl();

    ProductGetAll productGetAll = ProductGetAll
        .fromJson(await RestServiceManager.call(url, endpoint, null, null, RequestType.GET, queryParams: queryParams));
    return productGetAll;
  }
  Future<DutyImageBeforeResponse> addDutyImageBefore(DutyImageBeforeRequest request) async {
    var endpoint = 'DutyImageBefore/Add';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART,isLoading: false,isMultipart: true,filePath: request.Image?.path);
    DutyImageBeforeResponse dutyImageBeforeResponse = DutyImageBeforeResponse.fromJson(response);
    print(dutyImageBeforeResponse);
    return dutyImageBeforeResponse;
  }

  Future<AddEmployeeResponse> dutyAssignment(
      DutyAssignmentRequest dutyAssignmentRequest) async {
    var endpoint = 'Duty/DutyAssignment';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    AddEmployeeResponse dutyAssigmentResponse =
    AddEmployeeResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, dutyAssignmentRequest, RequestType.POST));
    return dutyAssigmentResponse;
  }

  Future<DutyImageBeforeResponse> addDutyImageAfter(DutyImageBeforeRequest request) async {
    var endpoint = 'DutyImageAfter/Add';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART,isLoading: false,isMultipart: true,filePath: request.Image?.path);
    DutyImageBeforeResponse dutyImageBeforeResponse = DutyImageBeforeResponse.fromJson(response);
    print(dutyImageBeforeResponse);
    return dutyImageBeforeResponse;
  }

  Future<AddEmployeeResponse> addEmployeeImage(AddEmployeeImageRequest request) async {
    var endpoint = 'EmployeeImage/Add';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    print('Request: ${request.toJson()}');
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART, isLoading: false, isMultipart: true, filePath: request.Image?.path);

    if (response == null) {
      print('Response null');
      throw Exception('Response is null');
    }

    AddEmployeeResponse addEmployeeResponse = AddEmployeeResponse.fromJson(response);
    print(addEmployeeResponse);
    return addEmployeeResponse;

  }

  Future<AddEmployeeResponse> addLostPropertyImage(PropertyImageRequest request) async {
    var endpoint = 'LostPropertyImage/Add';
    var url = await _getServerUrl(); // Dinamik olarak server URL'si alınır

    print('Request: ${request.toJson()}');
    var response = await RestServiceManager.call(url, endpoint, null, request, RequestType.MULTIPART, isLoading: false, isMultipart: true, filePath: request.Image?.path);

    if (response == null) {
      print('Response null');
      throw Exception('Response is null');
    }

    AddEmployeeResponse addEmployeeResponse = AddEmployeeResponse.fromJson(response);
    print(addEmployeeResponse);
    return addEmployeeResponse;

  }


  Future<AdditionalTaskGetAllResponse> getAllAdditionalTasks() async {
    var endpoint = 'AdditionalTask/GetAll';
    var url = await _getServerUrl();
    AdditionalTaskGetAllResponse additionalTaskGetAllResponse =
    AdditionalTaskGetAllResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, null, RequestType.GET));
    return additionalTaskGetAllResponse;
    }

  Future<EmpUpdateResponse> employeeUpdate(
      EmpUpdateRequest empUpdateRequest) async {
    var endpoint = 'Employee/Update';
    var url = await _getServerUrl();
    EmpUpdateResponse empUpdateResponse =
    EmpUpdateResponse.fromJson(await RestServiceManager.call(
        url, endpoint, null, empUpdateRequest, RequestType.POST));
    return empUpdateResponse;
    }

  Future<stock> addStockItem(StockItemRequest stockItemRequest) async {
    var endpoint = 'StockItem/Add';
    var url = await _getServerUrl();
    stock _stock = stock.fromJson(
        await RestServiceManager.call(
            url,
            endpoint,
            null,
            stockItemRequest,
            RequestType.POST
        )
    );
    print("Gelen Response $_stock");
    return _stock;
  }

  @override
  Future<DutyForNowResponse> getDutyForNowByBranchAndEmpIdForPassive(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetDutyForNowByBranchAndEmpIdForPassive';
    var url = await _getServerUrl();
    
    var response = await RestServiceManager.call(
      url, 
      endpoint, 
      null, 
      null, 
      RequestType.GET,
      queryParams: queryParams
    );
    
    return DutyForNowResponse.fromJson(response);
  }

  @override
  Future<DutyForNowResponse> getDutyForNowByBranchAndEmpId(Map<String, dynamic> queryParams) async {
    var endpoint = 'Duty/GetDutyForNowByBranchAndEmpId';
    var url = await _getServerUrl();
    
    var response = await RestServiceManager.call(
      url, 
      endpoint, 
      null, 
      null, 
      RequestType.GET,
      queryParams: queryParams
    );
    
    return DutyForNowResponse.fromJson(response);
  }
}
