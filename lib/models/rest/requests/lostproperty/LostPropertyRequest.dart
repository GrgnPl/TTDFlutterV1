import 'dart:ffi';

import '../RequestBase.dart';

class LostPropertyRequest extends RequestBase {
  String? propertyName;
  String? description;
  String? roomId;
  String? employeeId;
  String? itemDiscoveryDate;
  String? finishDate;
  bool? itemValuable;
  bool? delivered;
  String? employeeName;

  LostPropertyRequest({
  this.propertyName,
  this.description,
  this.roomId,
  this.employeeId,
  this.itemDiscoveryDate,
  this.finishDate,
  this.itemValuable,
  this.delivered,
  this.employeeName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (propertyName != null) json['propertyName'] = propertyName;
    if (description != null) json['description'] = description;
    if (roomId != null) json['roomId'] = roomId;
    if (employeeId != null) json['employeeId'] = employeeId;
    if (itemDiscoveryDate != null) json['itemDiscoveryDate'] = itemDiscoveryDate;
    if (finishDate != null) json['finishDate'] = finishDate;
    if (itemValuable != null) json['itemValuable'] = itemValuable;
    if (delivered != null) json['delivered'] = delivered;
    if (employeeName != null) json['employeeName'] = employeeName;

    return json;
  }

  @override
  String toString() {
    return 'LostPropertyRequest { '
        'propertyName: $propertyName, '
        'description: $description, '
        'roomId: $roomId,'
        'employeeId: $employeeId,'
        'itemDiscoveryDate : $itemDiscoveryDate,'
        'finishDate : $finishDate,'
        'itemValuable: $itemValuable,'
        'delivered : $delivered ,'
        'employeeName: $employeeName }';
  }
}