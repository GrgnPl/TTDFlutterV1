import 'package:ttd/models/rest/responses/duty/EmployeeAtanan.dart';

import 'roomDuty/Tasks.dart';

class Duty {
  String? id;
  String? roomId;
  String? hallwayId;
  String? floorId;
  String? branchId;
  String? blockId;
  List<EmployeeAtanan> employeeId;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? createdDate;
  bool? status;
  String? dutyTitle;
  String? dutyTagId;
  List<Tasks> task;
  String? taskId;

  Duty({
    this.id,
    this.roomId,
    this.hallwayId,
    this.floorId,
    this.branchId,
    this.blockId,
    required this.employeeId,
    this.createdUserId,
    this.dutyStartDate,
    this.dutyEndDate,
    this.createdDate,
    this.status,
    this.dutyTitle,
    this.dutyTagId,
    required this.task,
    this.taskId,
  });

  factory Duty.fromJson(Map<String, dynamic> json) {
    return Duty(
      id: json['id'] ?? "",
      roomId: json['roomId'],
      hallwayId: json['hallwayId'],
      floorId: json['floorId'],
      branchId: json['branchId'],
      blockId: json['blockId'],
      employeeId: json['employeeId'] != null ? List<EmployeeAtanan>.from(json['employeeId'].map((x) => EmployeeAtanan.fromJson(x))) : [],
      createdUserId: json['createdUserId'],
      dutyStartDate: json['dutyStartDate'],
      dutyEndDate: json['dutyEndDate'],
      createdDate: json['createdDate'],
      status: json['status'],
      dutyTitle: json['dutyTitle'],
      dutyTagId: json['dutyTagId'],
      task: json['task'] != null ? List<Tasks>.from(json['task'].map((x) => Tasks.fromJson(x))) : [],
      taskId: json['taskId'],
    );
  }
}
