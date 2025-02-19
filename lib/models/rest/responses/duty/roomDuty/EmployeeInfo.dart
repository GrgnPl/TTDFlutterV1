class EmployeeInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? departmentId;
  int? age;
  String? phoneNumber;
  String? dateOfStart;
  String? title;
  bool? status;

  EmployeeInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.age,
    this.phoneNumber,
    this.dateOfStart,
    this.title,
    this.status,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      departmentId: json['departmentId'],
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      dateOfStart: json['dateOfStart'],
      title: json['title'],
      status: json['status'],
    );
  }
}