import '../../additionaltask/Task.dart';

class DutyByEmployeeId {
  String? id;
  String? roomName;
  String? roomDescription;
  String? floorId;
  String? hallwayId;
  String? blockId;
  String? branchId;
  String? roomNumber;
  String? qrCodeAddress;
  bool? status;
  DutyDetails? dutyDetails;

  DutyByEmployeeId({
    this.id,
    this.roomName,
    this.roomDescription,
    this.floorId,
    this.hallwayId,
    this.blockId,
    this.branchId,
    this.roomNumber,
    this.qrCodeAddress,
    this.status,
    this.dutyDetails,
  });

  factory DutyByEmployeeId.fromJson(Map<String, dynamic> json) {
    return DutyByEmployeeId(
      id: json['id'] ?? "",
      roomName: json['roomName'],
      roomDescription: json['roomDescription'],
      floorId: json['floorId'],
      hallwayId: json['hallwayId'],
      blockId: json['blockId'],
      branchId: json['branchId'],
      roomNumber: json['roomNumber'],
      qrCodeAddress: json['qrCodeAddress'],
      status: json['status'],
      dutyDetails: json['dutyDetails'] != null ? DutyDetails.fromJson(json['dutyDetails']) : null,
    );
  }
}

class DutyDetails {
  String? id;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? createdDate;
  bool? status;
  String? dutyTitle;
  String? dutyTagId;
  List<Task>? task;

  DutyDetails({
    this.id,
    this.createdUserId,
    this.dutyStartDate,
    this.dutyEndDate,
    this.createdDate,
    this.status,
    this.dutyTitle,
    this.dutyTagId,
    this.task,
  });

  factory DutyDetails.fromJson(Map<String, dynamic> json) {
    return DutyDetails(
      id: json['id'],
      createdUserId: json['createdUserId'],
      dutyStartDate: json['dutyStartDate'],
      dutyEndDate: json['dutyEndDate'],
      createdDate: json['createdDate'],
      status: json['status'],
      dutyTitle: json['dutyTitle'],
      dutyTagId: json['dutyTagId'],
      task: json['task'] != null ? List<Task>.from(json['task'].map((x) => Task.fromJson(x))) : [],
    );
  }
}