import 'package:get/get.dart';

import '../../../models/rest/responses/profil/EmployeeGetAllResponse.dart';
import '../../../rest/emp/PersonnelRestService.dart';
import '../../../services/common/TTDApplicationService.dart';
import '../../../utils/servicelocator/TTDServiceLocator.dart';

class EmployeeDutyLocationsPageViewModel extends GetxController {
  late ITTDPersonelRestService _personnelRestService;
  RxList<String> corridors = <String>[].obs;
  RxList<String> branches = <String>[].obs;

  EmployeeDutyLocationsPageViewModel() {
    _personnelRestService = TTDServiceLocator().get<ITTDPersonelRestService>();
    fetchEmployeeDutyLocations();
  }

  Future<void> fetchEmployeeDutyLocations() async {
    try {
      String? employeeId = TTDApplicationService.authModel?.employeeId;

      if (employeeId != null) {
        // Çalışan bilgilerini getir
        await _getEmployeeInfo(employeeId);

        // Şube ve koridor bilgilerini getir
        if (_employeeInfo?.branchId != null) {
          await _getBranchById(_employeeInfo!.branchId!);
          await _getHallwaysByBranchId(_employeeInfo!.branchId!);
        }
      }
    } catch (e) {
      print("Error fetching employee duty locations: $e");
    }
  }

  EmployeeGetAllResponse? _employeeInfo;

  Future<void> _getEmployeeInfo(String employeeId) async {
    try {
      var queryParams = {'id': employeeId};
      var response = await _personnelRestService.getEmployeeInfo(queryParams);
      _employeeInfo = response;
    } catch (e) {
      print("Error fetching employee info: $e");
    }
  }

  Future<void> _getBranchById(String branchId) async {
    try {
      var queryParams = {'id': branchId};
      var response = await _personnelRestService.getBranchById(queryParams);
      if (response != null) {
        branches.add(response.branchName ?? "Unknown Branch");
      }
    } catch (e) {
      print("Error fetching branch: $e");
    }
  }

  Future<void> _getHallwaysByBranchId(String branchId) async {
    try {
      print("gidecek id koridor için $branchId");
      var queryParams = {'id': branchId};
      var response = await _personnelRestService.getHallwayById(queryParams);
      if (response != null && response.listOfHallways != null) {
        corridors.addAll(response.listOfHallways!
            .map((hallway) => hallway.hallwayName ?? "Unknown Hallway")
            .toList());
      }
    } catch (e) {
      print("Error fetching hallways: $e");
    }
  }
}