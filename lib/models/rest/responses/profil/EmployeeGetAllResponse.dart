import 'dart:ffi';

import 'Employee.dart';

class EmployeeGetAllResponse {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? age;
  String? departmentId;
  String? title;
  String? dateOfStart;
  String? dateOfFinish;
  bool? status;
  String? branchId;
  String? bloodGroup;
  String? birthDay;
  String? educationalStatus;
  String? lowerSize;
  String? upperSize;
  int? shoeSize;
  String? emergencyContactName;
  String? emergencyContactNumber;
  String? emergencyContactRelationship;

  EmployeeGetAllResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.age,
    this.departmentId,
    this.title,
    this.dateOfStart,
    this.dateOfFinish,
    this.status,
    this.branchId,
    this.bloodGroup,
    this.birthDay,
    this.educationalStatus,
    this.lowerSize,
    this.upperSize,
    this.shoeSize,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.emergencyContactRelationship,
  });

  factory EmployeeGetAllResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data != null) {
      return EmployeeGetAllResponse(
        id: data['id'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        age: data['age'],
        departmentId: data['departmentId'],
        title: data['title'],
        dateOfStart: data['dateOfStart'],
        dateOfFinish: data['dateOfFinish'],
        status: data['status'],
        branchId: data['branchId'],
        bloodGroup: data['bloodGroup'],
        birthDay: data['birthDay'],
        educationalStatus: data['educationalStatus'],
        lowerSize: data['lowerSize'],
        upperSize: data['upperSize'],
        shoeSize: data['shoeSize'],
        emergencyContactName: data['emergencyContactName'],
        emergencyContactNumber: data['emergencyContactNumber'],
        emergencyContactRelationship: data['emergencyContactRelationship'],
      );
    } else {
      throw Exception("Invalid JSON structure: 'data' field is missing or null.");
    }
  }

  @override
  String toString() {
    return 'EmployeeGetAllResponse('
        'id: $id, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'email: $email, '
        'phoneNumber: $phoneNumber, '
        'age: $age, '
        'departmentId: $departmentId, '
        'title: $title, '
        'dateOfStart: $dateOfStart, '
        'dateOfFinish: $dateOfFinish, '
        'status: $status, '
        'branchId: $branchId, '
        'bloodGroup: $bloodGroup, '
        'birthDay: $birthDay, '
        'educationalStatus: $educationalStatus, '
        'lowerSize: $lowerSize, '
        'upperSize: $upperSize, '
        'shoeSize: $shoeSize, '
        'emergencyContactName: $emergencyContactName, '
        'emergencyContactNumber: $emergencyContactNumber, '
        'emergencyContactRelationship: $emergencyContactRelationship'
        ')';
  }
}