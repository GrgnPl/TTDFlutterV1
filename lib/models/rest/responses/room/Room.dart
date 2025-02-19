import 'dart:ffi';

class Room  {
  String? id;
  String? roomName;
  String? roomDescription;
  String? floorId;
  String? hallwayId;
  String? blockId;
  String? branchId;
  String? roomNumber;
  String? qrCodeAdress;
  bool? status;

  Room({
    required this.id,
    required this.roomName ,
    required this.roomDescription,
    required this.floorId,
    required this.hallwayId,
    required this.blockId,
    required this.branchId,
    required this.roomNumber,
    required this.qrCodeAdress,
    required this.status});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"] ?? "",
      roomName: json["roomName"],
      roomDescription: json["roomDescription"] ?? "",
      floorId: json["floorId"] ?? "",
      hallwayId: json["hallwayId"] ?? "",
      blockId: json["blockId"] ?? "",
      branchId: json["branchId"] ?? "",
      roomNumber: json["roomNumber"] ?? "",
      qrCodeAdress: json["qrCodeAdress"] ?? "",
      status: json["status"],
    );
  }
}