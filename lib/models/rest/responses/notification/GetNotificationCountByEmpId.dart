import 'dart:ffi';

class GetNotificationCountByEmpId {
  String? id;
  String? employeeId;
  String? notificationTitle;
  String? notificationBody;
  String? notificationDate;
  bool? status;

  GetNotificationCountByEmpId({
    required this.id,
    required this.employeeId,
    required this.notificationTitle,
    required this.notificationBody,
    required this.notificationDate,
    required this.status,
  });

  factory GetNotificationCountByEmpId.fromJson(Map<String, dynamic> json) {
    return GetNotificationCountByEmpId(
      id: json["id"] ?? "",
      employeeId: json["employeeId"],
      notificationTitle: json["notificationTitle"] ?? "",
      notificationBody: json["notificationBody"] ?? "",
      notificationDate: json["notificationDate"] ?? "",
      status: json["status"] as bool?,  // Burada bool? tipinde olmalı
    );
  }
}