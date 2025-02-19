import 'package:ttd/models/rest/requests/RequestBase.dart';

class EmpUpdateRequest extends RequestBase {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? departmentId;
  int? age;
  String? phoneNumber;
  String? dateOfStart;
  String? title;
  bool status;
  String? branchId;

  EmpUpdateRequest({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.age,
    this.phoneNumber,
    this.dateOfStart,
    this.title,
    required this.status,
    this.branchId
  });

  Map<String, dynamic> toJson() => {
    'id':id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'departmentId':departmentId,
    'age': age,
    'phoneNumber': phoneNumber,
    'dateOfStart': dateOfStart,
    'title': title,
    'status':status,
    'branchId':branchId
  };
}