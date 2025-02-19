class HallwayById {
  String? id;
  String? branchId;
  String? floorId;
  String? blockId;
  String? hallwayName;
  bool? status;
  String? qrCodeAdress;

  HallwayById({
    required this.id,
    required this.branchId,
    required this.floorId,
    required this.blockId,
    required this.hallwayName,
    required this.status,
    required this.qrCodeAdress,
  });

  factory HallwayById.fromJson(Map<String, dynamic> json) {
    return HallwayById(
      id: json['id'],
      branchId: json['branchId'],
      floorId: json['floorId'],
      blockId: json['blockId'],
      hallwayName: json['hallwayName'],
      status: json['status'],
      qrCodeAdress: json['qrCodeAdress'],
    );
  }
}