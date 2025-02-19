import 'dart:ffi';

class GetAllRoomByBranchId  {
  String? id;
  String? roomName;
  String? roomDescription;
  String? floorName;
  String? hallwayName;
  String? blockName;
  String? branchName;
  String? roomNumber;
  bool? status;
  String? qrCodeAdress;


  GetAllRoomByBranchId({
    required this.id,
    required this.roomName ,
    required this.roomDescription,
    required this.floorName,
    required this.hallwayName,
    required this.blockName,
    required this.branchName,
    required this.roomNumber,
    required this.status,
    required this.qrCodeAdress,
    });

  factory GetAllRoomByBranchId.fromJson(Map<String, dynamic> json) {
    return GetAllRoomByBranchId(
      id: json["id"] ?? "",
      roomName: json["roomName"],
      roomDescription: json["roomDescription"] ?? "",
      floorName: json["floorName"] ?? "",
      hallwayName: json["hallwayName"] ?? "",
      blockName: json["blockName"] ?? "",
      branchName: json["branchName"] ?? "",
      roomNumber: json["roomNumber"] ?? "",
      status: json["status"],
      qrCodeAdress: json["qrCodeAdress"] ?? "",

    );
  }
}