import 'package:ttd/models/rest/responses/version/VersionControl.dart';

class VersionControlResponse {
  final String? id;
  final String? versionName;
  final String? message;
  final bool? success;

  VersionControlResponse({
    this.id,
    this.versionName,
    this.message,
    this.success,
  });

  factory VersionControlResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception(
          "Invalid JSON structure: 'data' field is missing or null.");
    }

    return VersionControlResponse(
      id: data['id'] as String?,
      versionName: data['versionName'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}