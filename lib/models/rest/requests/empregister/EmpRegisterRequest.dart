import 'package:ttd/models/rest/requests/RequestBase.dart';

import 'package:ttd/models/rest/requests/RequestBase.dart';

class EmpRegisterRequest extends RequestBase {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  int? age;
  String? departmentId;
  String? phoneNumber;
  String? dateOfStart;
  String? title;
  bool? status;

  EmpRegisterRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.age,
    this.departmentId,
    this.phoneNumber,
    this.dateOfStart,
    this.title,
    this.status,
  });

  Map<String, dynamic> toJson() => {
  'email': email,
  'password': password,
  'firstName': firstName,
  'lastName': lastName,
  'age': age,
  'departmentId': departmentId,
  'phoneNumber': phoneNumber,
  'dateOfStart': dateOfStart,
  'title': title,
  'status': status,
  };
}