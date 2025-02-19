import 'dart:ffi';

class DepartmentGetAllResponse {
  String? id;
  String? departmentName;


  DepartmentGetAllResponse({required this.id ,required this.departmentName});

  factory DepartmentGetAllResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentGetAllResponse(
      id: json["id;"] ?? "",
      departmentName: json["departmentName"],
    );
  }
}