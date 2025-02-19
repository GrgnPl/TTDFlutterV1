class Tasks {
  String? taskName;
  String? taskDescription;
  String? departmentId;
  bool status;

  Tasks({
    required this.taskName,
    required this.taskDescription,
    required this.departmentId,
    required this.status,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      taskName: json["taskName"] ?? "",
      taskDescription: json["taskDescription"] ?? "",
      departmentId: json["departmentId"] ?? "",
      status: json["status"] ?? false,
    );
  }
  @override
  String toString() {
    return 'Tasks(taskName: $taskName, taskDescription: $taskDescription, departmentId: $departmentId, status: $status)';
  }

}