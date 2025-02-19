import 'dart:ffi';

class Hallway  {
  String? id;
  String? branchId;
  String? blockId;
  String? floorId;
  String? hallwayName;
  bool? status;
  String? qrCodeAdress;

  Hallway({
    required this.id,
    required this.branchId ,
    required this.blockId,
    required this.floorId,
    required this.hallwayName,
    required this.status,
    required this.qrCodeAdress});

  factory Hallway.fromJson(Map<String, dynamic> json) {
    return Hallway(
      id: json["id"] ?? "",
      branchId: json["branchId"],
      blockId: json["blockId"] ?? "",
      floorId: json["floorId"] ?? "",
      hallwayName: json["hallwayName"] ?? "",
      status: json["status"],
      qrCodeAdress: json["qrCodeAdress"] ?? "",
    );
  }
}