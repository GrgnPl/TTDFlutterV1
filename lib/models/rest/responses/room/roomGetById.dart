import 'package:ttd/models/rest/responses/duty/roomDuty/EmployeeInfo.dart';


class roomGetById {
  final String id;
  final String roomName;
  final String roomDescription;
  final String floorId;
  final String hallwayId;
  final String blockId;
  final String branchId;
  final String roomNumber;
  final String qrCodeAddress;
  final bool status;

  roomGetById({
    required this.id,
    required this.roomName,
    required this.roomDescription,
    required this.floorId,
    required this.hallwayId,
    required this.blockId,
    required this.branchId,
    required this.roomNumber,
    required this.qrCodeAddress,
    required this.status,
  });

  factory roomGetById.fromJson(Map<String, dynamic> json) {
    var data = json['data']; // Veriyi 'data' altından al
    return roomGetById(
      id: data['id'] ?? '',
      roomName: data['roomName'] ?? '',
      roomDescription: data['roomDescription'] ?? '',
      floorId: data['floorId'] ?? '',
      hallwayId: data['hallwayId'] ?? '',
      blockId: data['blockId'] ?? '',
      branchId: data['branchId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      qrCodeAddress: data['qrCodeAddress'] ?? '',
      status: data['status'] ?? false,
    );
  }
}