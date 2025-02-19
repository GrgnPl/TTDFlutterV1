import '../RequestBase.dart';

class Room {
  String id;
  String roomName;
  String roomDescription;
  String? floorId; // Boş olabilir
  String? hallwayId; // Boş olabilir
  String? blockId; // Boş olabilir
  String? branchId; // Boş olabilir
  String roomNumber;
  String qrCodeAdress; // Boş olabilir
  bool status;

  Room({
    required this.id,
    required this.roomName,
    required this.roomDescription,
    this.floorId,
    this.hallwayId,
    this.blockId,
    this.branchId,
    required this.roomNumber,
    required this.qrCodeAdress,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomName': roomName,
    'roomDescription': roomDescription,
    'floorId': floorId ?? '', // Boş değerleri önlemek için
    'hallwayId': hallwayId ?? '',
    'blockId': blockId ?? '',
    'branchId': branchId ?? '',
    'roomNumber': roomNumber,
    'qrCodeAdress': qrCodeAdress ?? '', // Düzelttik
    'status': status,
  };

  @override
  String toString() {
    return 'Room { '
        'id: $id, '
        'roomName: $roomName, '
        'roomDescription: $roomDescription, '
        'floorId: ${floorId ?? "null"}, '
        'hallwayId: ${hallwayId ?? "null"}, '
        'blockId: ${blockId ?? "null"}, '
        'branchId: ${branchId ?? "null"}, '
        'roomNumber: $roomNumber, '
        'qrCodeAdress: ${qrCodeAdress ?? "null"}, '
        'status: $status '
        '}';
  }
}

class StockItemRequest extends RequestBase {
  String productId;
  int quantity;
  String entryDate;
  String description;
  List<Room> roomId;
  String employeeId;

  StockItemRequest({
    required this.productId,
    required this.quantity,
    required this.entryDate,
    required this.description,
    required this.roomId,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'entryDate': entryDate,
    'description': description,
    'roomId': roomId.map((room) => room.toJson()).toList(),
    'employeeId': employeeId,
  };

  @override
  String toString() {
    return 'StockItemRequest { '
        'productId: $productId, '
        'quantity: $quantity, '
        'entryDate: $entryDate, '
        'description: $description, '
        'roomId: ${roomId.map((room) => room.toString()).toList()}, '
        'employeeId: $employeeId, '
        '}';
  }
}