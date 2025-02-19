  import 'dart:ffi';

class EmployeeBreak  {
  String? id;
  String? employeeId;
  String? userId;
  String? breakDescription;
  String? breakTime;
  String? breakDate;
  bool? status;

  EmployeeBreak({
    required this.id,
    required this.employeeId ,
    required this.userId,
    required this.breakDescription,
    required this.breakTime,
    required this.breakDate,
    required this.status});

  factory EmployeeBreak.fromJson(Map<String, dynamic> json) {
    return EmployeeBreak(
      id: json["id"] ?? "",
      employeeId: json["employeeId"],
      userId: json["userId"] ?? "",
      breakDescription: json["breakDescription"] ?? "",
      breakTime: json["breakTime"] ?? "",
      breakDate: json["breakDate"] ?? "",
      status: json["status"],
    );
  }
}