import 'package:ttd/models/rest/responses/version/VersionControl.dart';

class GetDepartmentNameFromId {
  final String? id;
  final String? departmentName;
  final String? message;
  final bool? success;

  GetDepartmentNameFromId({
    this.id,
    this.departmentName,
    this.message,
    this.success,
  });

  factory GetDepartmentNameFromId.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception(
          "Invalid JSON structure: 'data' field is missing or null.");
    }

    return GetDepartmentNameFromId(
      id: data['id'] as String?,
      departmentName: data['departmentName'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}