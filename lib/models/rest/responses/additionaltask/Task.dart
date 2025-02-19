 class Task {
  String? taskName;
  String? taskDescription;
  String? departmentId;
  bool? status;

  Task({this.taskName, this.taskDescription, this.departmentId,this.status});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      departmentId: json['departmentId'],
      status: json['status'],
    );
  }
}