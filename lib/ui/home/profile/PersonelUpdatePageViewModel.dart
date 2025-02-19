import 'package:ttd/rest/emp/PersonnelRestService.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';
import 'package:ttd/utils/servicelocator/TTDServiceLocator.dart';
import 'package:ttd/ui/ViewModelBase.dart';
import '../../../models/rest/requests/empUpdate/EmpUpdateRequest.dart';
import '../../home/NavigationPage.dart';



class PersonelUpdatePageViewModel extends ViewModelBase {
  late ITTDPersonelRestService? _personnelRestService =
  TTDServiceLocator().get<ITTDPersonelRestService>();

  PersonelUpdatePageViewModel() {
    initPage();
  }

  initPage() async {}

  updateEmployee(
      String id,
      String firstName,
      String lastName,
      String email,
      String departmentId,
      String age,
      String phoneNumber,
      String? dateOfStart,
      String title,
      bool status,
      String? branchId,
      ) async {
    try {
      if (email.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          age.isEmpty ||
          phoneNumber.isEmpty ||
          title.isEmpty) {
        throw Exception("All fields must be filled");
      }

      EmpUpdateRequest empUpdateRequest = EmpUpdateRequest(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        departmentId: departmentId,
        age: int.parse(age),
        phoneNumber: phoneNumber,
        dateOfStart: dateOfStart,
        title: title,
        status: status,
        branchId: branchId
      );

      print(empUpdateRequest.toJson());

      var response = await _personnelRestService!.employeeUpdate(empUpdateRequest);
      print('Response: $response');
      TTDNavigator().pushToMain(NavigationPage());
    } catch (e) {
      print('View Model Error: $e');
    }
  }
}