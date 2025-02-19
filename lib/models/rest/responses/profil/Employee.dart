import 'dart:ffi';

class Employee {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? age;
  String? departmantId;
  String? title;
  String? dateOfStart;
  String? passwordSalt;
  bool? status;

  Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.age,
      required this.departmantId,
      required this.title,
      required this.dateOfStart,
      required this.passwordSalt,
      required this.status});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"] ?? "",
      firstName: json["firstName"],
      lastName: json["lastName"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      age: json["age"] ?? "",
      departmantId: json["departmantId"] ?? "",
      title: json["title"] ?? "",
      dateOfStart: json["dateOfStart"] ?? "",
      passwordSalt: json["passwordSalt"] ?? "",
      status: json["status"],
    );
  }
}
