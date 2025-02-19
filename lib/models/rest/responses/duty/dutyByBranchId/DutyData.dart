import '../roomDuty/Tasks.dart';
import 'EmployeeName.dart';

class DutyData {
  String? id;
  String? roomId;
  String? hallwayId;
  String? floorId;
  String? branchId;
  String? blockId;
  List<EmployeeName>? employeeId;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? startTime;
  String? endTime;
  String? createdDate;
  bool? status;
  String? dutyTitle;
  String? dutyTagId;
  List<Tasks>? task;
  String? taskId;
  String? dldDescription;

  DutyData({
    this.id,
    this.roomId,
    this.hallwayId,
    this.floorId,
    this.branchId,
    this.blockId,
    this.employeeId,
    this.createdUserId,
    this.dutyStartDate,
    this.dutyEndDate,
    this.startTime,
    this.endTime,
    this.createdDate,
    this.status,
    this.dutyTagId,
    this.dutyTitle,
    this.task,
    this.taskId,
    this.dldDescription,
  });

  factory DutyData.fromJson(Map<String, dynamic> json) {
    return DutyData(
      id: json['id'],
      roomId: json['roomId'],
      hallwayId: json['hallwayId'],
      floorId: json['floorId'],
      branchId: json['branchId'],
      blockId: json['blockId'],
      employeeId: (json['employeeId'] as List?)
          ?.map((e) => EmployeeName.fromJson(e))
          .toList(),
      createdUserId: json['createdUserId'],
      dutyStartDate: json['dutyStartDate'],
      dutyEndDate: json['dutyEndDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      createdDate: json['createdDate'],
      status: json['status'],
      dutyTitle: json['dutyTitle'],
      dutyTagId: json['dutyTagId'],
      task: (json['task'] as List?)
          ?.map((e) => Tasks.fromJson(e))
          .toList(),
      taskId: json['taskId'],
      dldDescription: json['dldDescription'],
    );
  }

  @override
  String toString() {
    return 'DutyData(id: $id, roomId: $roomId, dutyTitle: $dutyTitle, employeeId: $employeeId, task: $task)';
  }
}
