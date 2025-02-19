import 'package:ttd/models/rest/responses/duty/roomDuty/EmployeeInfo.dart';

import '../../additionaltask/Task.dart';

class DutyByIdResponse {
  final String id;
  final String roomId;
  final String hallwayId;
  final String floorId;
  final String branchId;
  final String blockId;
  final List<EmployeeInfo> employeeId;
  final String createdUserId;
  final String dutyStartDate;
  final String? dutyEndDate;
  final String createdDate;
  final bool status;
  final String dutyTitle;
  final String dutyTagId;
  final List<Task> task;
  final String taskId;

  DutyByIdResponse({
    required this.id,
    required this.roomId,
    required this.hallwayId,
    required this.floorId,
    required this.branchId,
    required this.blockId,
    required this.employeeId,
    required this.createdUserId,
    required this.dutyStartDate,
    this.dutyEndDate,
    required this.createdDate,
    required this.status,
    required this.dutyTitle,
    required this.dutyTagId,
    required this.task,
    required this.taskId,
  });

  factory DutyByIdResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data']; // Veriyi 'data' altından al
    return DutyByIdResponse(
      id: data['id'] ?? '',
      roomId: data['roomId'] ?? '',
      hallwayId: data['hallwayId'] ?? '',
      floorId: data['floorId'] ?? '',
      branchId: data['branchId'] ?? '',
      blockId: data['blockId'] ?? '',
      employeeId: data['employeeId'] != null ? List<EmployeeInfo>.from(data['employeeId'].map((x) => EmployeeInfo.fromJson(x))) : [],
      createdUserId: data['createdUserId'] ?? '',
      dutyStartDate: data['dutyStartDate'] ?? '',
      dutyEndDate: data['dutyEndDate'], // Null olabilir.
      createdDate: data['createdDate'] ?? '',
      status: data['status'] ?? false,
      dutyTitle: data['dutyTitle'] ?? '',
      dutyTagId: data['dutyTagId'] ?? '',
      task: data['task'] != null ? List<Task>.from(data['task'].map((x) => Task.fromJson(x))) : [],
      taskId: data['taskId'] ?? '',
    );
  }
}