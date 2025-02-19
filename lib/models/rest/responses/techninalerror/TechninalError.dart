import 'dart:ffi';

class TechninalError  {
  String? id;
  String? errorTitle;
  String? errorDescription;
  String? roomName;
  String? createdDate;
  String? complecetedDate;
  String? employeeName;
  bool? status;
  String? qrCodeAddress;
  String? departmentId;

  TechninalError({
    required this.id,
    required this.errorTitle ,
    required this.errorDescription,
    required this.roomName,
    required this.createdDate,
    required this.complecetedDate,
    required this.employeeName,
    required this.status,
    required this.qrCodeAddress,
    required this.departmentId});

  factory TechninalError.fromJson(Map<String, dynamic> json) {
    return TechninalError(
      id: json["id"] ?? "",
      errorTitle: json["errorTitle"],
      errorDescription: json["errorDescription"] ?? "",
      roomName: json["roomName"] ?? "",
      createdDate: json["createdDate"] ?? "",
      complecetedDate: json["complecetedDate"] ?? "",
      employeeName: json["employeeName"] ?? "",
      status: json["status"],
      qrCodeAddress: json["qrCodeAddress"] ?? "",
      departmentId: json["departmentId"] ?? "",
    );
  }
  @override
  String toString() {
    return 'TechnicalErrorData(id: $id, errorTitle: $errorTitle, errorDescription: $errorDescription, roomName: $roomName, createdDate: $createdDate, departmentID : $departmentId})';
  }

}