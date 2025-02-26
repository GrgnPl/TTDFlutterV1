class DutyForNowResponse {
  List<DutyForNowData>? data;
  bool? success;
  String? message;

  DutyForNowResponse({this.data, this.success, this.message});

  DutyForNowResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DutyForNowData>[];
      json['data'].forEach((v) {
        data!.add(DutyForNowData.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}

class DutyForNowData {
  String? id;
  String? roomId;
  String? hallwayId;
  String? floorId;
  String? branchId;
  String? blockId;
  List<Employee>? employeeId;
  String? createdUserId;
  String? dutyStartDate;
  String? dutyEndDate;
  String? startTime;
  String? endTime;
  String? createdDate;
  bool? status;
  String? dutyTitle;
  String? dutyTagId;
  List<Task>? task;
  String? taskId;
  String? dldDescription;

  DutyForNowData({
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
    this.dutyTitle,
    this.dutyTagId,
    this.task,
    this.taskId,
    this.dldDescription,
  });

  DutyForNowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    hallwayId = json['hallwayId'];
    floorId = json['floorId'];
    branchId = json['branchId'];
    blockId = json['blockId'];
    if (json['employeeId'] != null) {
      employeeId = <Employee>[];
      json['employeeId'].forEach((v) {
        employeeId!.add(Employee.fromJson(v));
      });
    }
    createdUserId = json['createdUserId'];
    dutyStartDate = json['dutyStartDate'];
    dutyEndDate = json['dutyEndDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    createdDate = json['createdDate'];
    status = json['status'];
    dutyTitle = json['dutyTitle'];
    dutyTagId = json['dutyTagId'];
    if (json['task'] != null) {
      task = <Task>[];
      json['task'].forEach((v) {
        task!.add(Task.fromJson(v));
      });
    }
    taskId = json['taskId'];
    dldDescription = json['dldDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roomId'] = roomId;
    data['hallwayId'] = hallwayId;
    data['floorId'] = floorId;
    data['branchId'] = branchId;
    data['blockId'] = blockId;
    if (employeeId != null) {
      data['employeeId'] = employeeId!.map((v) => v.toJson()).toList();
    }
    data['createdUserId'] = createdUserId;
    data['dutyStartDate'] = dutyStartDate;
    data['dutyEndDate'] = dutyEndDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['dutyTitle'] = dutyTitle;
    data['dutyTagId'] = dutyTagId;
    if (task != null) {
      data['task'] = task!.map((v) => v.toJson()).toList();
    }
    data['taskId'] = taskId;
    data['dldDescription'] = dldDescription;
    return data;
  }
}

class Employee {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? departmentId;
  int? age;
  String? phoneNumber;
  String? dateOfStart;
  String? dateOfFinish;
  String? title;
  bool? status;
  String? branchId;
  String? bloodGroup;
  String? birthDay;
  String? educationalStatus;
  String? lowerSize;
  String? upperSize;
  int? shoeSize;
  String? emergencyContactName;
  String? emergencyContactNumber;
  String? emergencyContactRelationship;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.age,
    this.phoneNumber,
    this.dateOfStart,
    this.dateOfFinish,
    this.title,
    this.status,
    this.branchId,
    this.bloodGroup,
    this.birthDay,
    this.educationalStatus,
    this.lowerSize,
    this.upperSize,
    this.shoeSize,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.emergencyContactRelationship,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    departmentId = json['departmentId'];
    age = json['age'];
    phoneNumber = json['phoneNumber'];
    dateOfStart = json['dateOfStart'];
    dateOfFinish = json['dateOfFinish'];
    title = json['title'];
    status = json['status'];
    branchId = json['branchId'];
    bloodGroup = json['bloodGroup'];
    birthDay = json['birthDay'];
    educationalStatus = json['educationalStatus'];
    lowerSize = json['lowerSize'];
    upperSize = json['upperSize'];
    shoeSize = json['shoeSize'];
    emergencyContactName = json['emergencyContactName'];
    emergencyContactNumber = json['emergencyContactNumber'];
    emergencyContactRelationship = json['emergencyContactRelationship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['departmentId'] = departmentId;
    data['age'] = age;
    data['phoneNumber'] = phoneNumber;
    data['dateOfStart'] = dateOfStart;
    data['dateOfFinish'] = dateOfFinish;
    data['title'] = title;
    data['status'] = status;
    data['branchId'] = branchId;
    data['bloodGroup'] = bloodGroup;
    data['birthDay'] = birthDay;
    data['educationalStatus'] = educationalStatus;
    data['lowerSize'] = lowerSize;
    data['upperSize'] = upperSize;
    data['shoeSize'] = shoeSize;
    data['emergencyContactName'] = emergencyContactName;
    data['emergencyContactNumber'] = emergencyContactNumber;
    data['emergencyContactRelationship'] = emergencyContactRelationship;
    return data;
  }
}

class Task {
  String? taskName;
  String? taskDescription;
  String? departmentId;
  bool? status;

  Task({
    this.taskName,
    this.taskDescription,
    this.departmentId,
    this.status,
  });

  Task.fromJson(Map<String, dynamic> json) {
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    departmentId = json['departmentId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['departmentId'] = departmentId;
    data['status'] = status;
    return data;
  }
} 