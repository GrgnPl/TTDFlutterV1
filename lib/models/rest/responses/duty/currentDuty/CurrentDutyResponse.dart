import '../roomDuty/EmployeeInfo.dart';
import '../roomDuty/Tasks.dart';

class CurrentDutyResponse {
  String? id;
  String? roomId;
  String? hallwayId;
  String? floorId;
  String? branchId;
  String? blockId;
  List<EmployeeInfo> employeeInfo;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? createdDate;
  bool? status;
  String? dutyTagId;
  String? dutyTitle;
  List<Tasks> task;
  String? taskId;

  CurrentDutyResponse({
    this.id,
    this.roomId,
    this.hallwayId,
    this.floorId,
    this.branchId,
    this.blockId,
    required this.employeeInfo,
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

  factory CurrentDutyResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data']; // 'data' anahtarını çekelim

    return CurrentDutyResponse(
      id: data['id'],
      roomId: data['roomId'],
      hallwayId: data['hallwayId'],
      floorId: data['floorId'],
      branchId: data['branchId'],
      blockId: data['blockId'],
      employeeInfo: data['employeeId'] != null
          ? List<EmployeeInfo>.from(data['employeeId'].map((x) => EmployeeInfo.fromJson(x)))
          : [],
      createdUserId: data['createdUserId'],
      dutyStartDate: data['dutyStartDate'],
      dutyEndDate: data['dutyEndDate'],
      createdDate: data['createdDate'],
      status: data['status'],
      dutyTagId: data['dutyTagId'],
      dutyTitle: data['dutyTitle'],
      task: data['task'] != null ? List<Tasks>.from(data['task'].map((x) => Tasks.fromJson(x))) : [],
      taskId: data['taskId'],
    );
  }
}