import 'dart:ffi';

class LostProperty  {
  String? id;
  String? propertyName;
  String? description;
  String? roomId;
  String? employeeId;
  String? itemDiscoveryDate;
  String? finishDate;
  bool? itemValuable;
  bool? delivered;
  String? employeeName;

  LostProperty({
    required this.id,
    required this.propertyName ,
    required this.description,
    required this.roomId,
    required this.employeeId,
    required this.itemDiscoveryDate,
    required this.finishDate,
    required this.itemValuable,
    required this.delivered,
    required this.employeeName});

  factory LostProperty.fromJson(Map<String, dynamic> json) {
    return LostProperty(
      id: json["id"] ?? "",
      propertyName: json["propertyName"],
      description: json["description"] ?? "",
      roomId: json["roomId"] ?? "",
      employeeId: json["employeeId"] ?? "",
      itemDiscoveryDate: json["itemDiscoveryDate"] ?? "",
      finishDate: json["finishDate"] ?? "",
      itemValuable: json["itemValuable"] ?? "",
      delivered: json["delivered"] ?? "",
      employeeName: json["employeeName"] ?? "",
    );
  }
}