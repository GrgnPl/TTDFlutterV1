import 'dart:ffi';

class EmployeeAtanan {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? departmantId;
  int? age;
  String? phoneNumber;
  String? dateOfStart;
  String? title;
  bool? status;

  EmployeeAtanan(
      {required this.id,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.departmantId,
        required this.age,
        required this.phoneNumber,
        required this.dateOfStart,
        required this.title,
        required this.status});

  factory EmployeeAtanan.fromJson(Map<String, dynamic> json) {
    return EmployeeAtanan(
      id: json["id"] ?? "",
      firstName: json["firstName"],
      lastName: json["lastName"] ?? "",
      email: json["email"] ?? "",
      departmantId: json["departmantId"] ?? "",
      age: json["age"],
      phoneNumber: json["phoneNumber"] ?? "",
      dateOfStart: json["dateOfStart"] ?? "",
      title: json["title"] ?? "",
      status: json["status"],
    );
  }
}
