import 'package:ttd/models/rest/responses/duty/roomDuty/EmployeeInfo.dart';

import 'Tasks.dart';

class RoomDuty {
  String? id;
  String? roomName;
  String? hallwayName;
  String? floorName;
  String? branchName;
  String? blockName;
  List<EmployeeInfo> employeeName;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? createdDate;
  bool? status;
  String? dutyTagId;
  String? dutyTitle;
  List<Tasks> task;
  String? taskId;

  RoomDuty({
    this.id,
    this.roomName,
    this.hallwayName,
    this.floorName,
    this.branchName,
    this.blockName,
    required this.employeeName,
    this.createdUserId,
    this.dutyStartDate,
    this.dutyEndDate,
    this.createdDate,
    this.status,
    this.dutyTagId,
    this.dutyTitle,
    required this.task,
    this.taskId,
  });

  factory RoomDuty.fromJson(Map<String, dynamic> json) {
    return RoomDuty(
      id: json['id'],
      roomName: json['roomName'],
      hallwayName: json['hallwayName'],
      floorName: json['floorName'],
      branchName: json['branchName'],
      blockName: json['blockName'],
      employeeName: json['employeeName'] != null ? List<EmployeeInfo>.from(json['employeeName'].map((x) => EmployeeInfo.fromJson(x))) : [],
      createdUserId: json['createdUserId'],
      dutyStartDate: json['dutyStartDate'],
      dutyEndDate: json['dutyEndDate'],
      createdDate: json['createdDate'],
      status: json['status'],
      dutyTagId: json['dutyTagId'],
      dutyTitle: json['dutyTitle'],
      task: json['task'] != null ? List<Tasks>.from(json['task'].map((x) => Tasks.fromJson(x))) : [],
      taskId: json['taskId'],
    );
  }
}
