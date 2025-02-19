import '../RequestBase.dart';

class EmployeeAssignment {
  String id;
  String firstName;
  String lastName;
  String email;
  String departmentId;
  int age;
  String phoneNumber;
  String dateOfStart;
  String dateOfFinish;
  String title;
  bool status;
  String branchId;
  String bloodGroup;
  String birthDay;
  String educationalStatus;
  String lowerSize;
  String upperSize;
  int shoeSize;
  String emergencyContactName;
  String emergencyContactNumber;
  String emergencyContactRelationship;

  EmployeeAssignment({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.departmentId,
    required this.age,
    required this.phoneNumber,
    required this.dateOfStart,
    required this.dateOfFinish,
    required this.title,
    required this.status,
    required this.branchId,
    required this.bloodGroup,
    required this.birthDay,
    required this.educationalStatus,
    required this.lowerSize,
    required this.upperSize,
    required this.shoeSize,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    required this.emergencyContactRelationship,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'departmentId': departmentId,
    'age': age,
    'phoneNumber': phoneNumber,
    'dateOfStart': dateOfStart,
    'dateOfFinish': dateOfFinish,
    'title': title,
    'status': status,
    'branchId': branchId,
    'bloodGroup': bloodGroup,
    'birthDay': birthDay,
    'educationalStatus': educationalStatus,
    'lowerSize': lowerSize,
    'upperSize': upperSize,
    'shoeSize': shoeSize,
    'emergencyContactName': emergencyContactName,
    'emergencyContactNumber': emergencyContactNumber,
    'emergencyContactRelationship': emergencyContactRelationship,
  };
}

class TaskAssignment {
  String taskName;
  String taskDescription;
  String departmentId;
  bool status;

  TaskAssignment({
    required this.taskName,
    required this.taskDescription,
    required this.departmentId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'taskName': taskName,
    'taskDescription': taskDescription,
    'departmentId': departmentId,
    'status': status,
  };
}

class DutyAssignment {
  String id;
  String roomId;
  String hallwayId;
  String floorId;
  String branchId;
  String blockId;
  List<EmployeeAssignment> employeeId;
  String createdUserId;
  String dutyStartDate;
  String dutyEndDate;
  String startTime;
  String endTime;
  String createdDate;
  bool status;
  String dutyTitle;
  String dutyTagId;
  List<TaskAssignment> task;
  String taskId;
  String dldDescription;

  DutyAssignment({
    required this.id,
    required this.roomId,
    required this.hallwayId,
    required this.floorId,
    required this.branchId,
    required this.blockId,
    required this.employeeId,
    required this.createdUserId,
    required this.dutyStartDate,
    required this.dutyEndDate,
    required this.startTime,
    required this.endTime,
    required this.createdDate,
    required this.status,
    required this.dutyTitle,
    required this.dutyTagId,
    required this.task,
    required this.taskId,
    required this.dldDescription,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomId': roomId,
    'hallwayId': hallwayId,
    'floorId': floorId,
    'branchId': branchId,
    'blockId': blockId,
    'employeeId': employeeId.map((employee) => employee.toJson()).toList(),
    'createdUserId': createdUserId,
    'dutyStartDate': dutyStartDate,
    'dutyEndDate': dutyEndDate,
    'startTime': startTime,
    'endTime': endTime,
    'createdDate': createdDate,
    'status': status,
    'dutyTitle': dutyTitle,
    'dutyTagId': dutyTagId,
    'task': task.map((task) => task.toJson()).toList(),
    'taskId': taskId,
    'dldDescription': dldDescription,
  };
}

class DutyAssignmentRequest extends RequestBase {
  List<DutyAssignment> duty;
  String employeeId;

  DutyAssignmentRequest({
    required this.duty,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() => {
    'duty': duty.map((duty) => duty.toJson()).toList(),
    'employeeId': employeeId,
  };
}