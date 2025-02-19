
class EmployeeName {
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

  EmployeeName({
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

  factory EmployeeName.fromJson(Map<String, dynamic> json) {
    return EmployeeName(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      departmentId: json['departmentId'],
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      dateOfStart: json['dateOfStart'],
      dateOfFinish: json['dateOfFinish'],
      title: json['title'],
      status: json['status'],
      branchId: json['branchId'],
      bloodGroup: json['bloodGroup'],
      birthDay: json['birthDay'],
      educationalStatus: json['educationalStatus'],
      lowerSize: json['lowerSize'],
      upperSize: json['upperSize'],
      shoeSize: json['shoeSize'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactNumber: json['emergencyContactNumber'],
      emergencyContactRelationship: json['emergencyContactRelationship'],
    );
  }
  @override
  String toString() {
    return 'EmployeeName(id: $id, firstName: $firstName, lastName: $lastName, email: $email, departmentId: $departmentId, age: $age, phoneNumber: $phoneNumber, dateOfStart: $dateOfStart, dateOfFinish: $dateOfFinish, title: $title, status: $status, branchId: $branchId, bloodGroup: $bloodGroup, birthDay: $birthDay, educationalStatus: $educationalStatus, lowerSize: $lowerSize, upperSize: $upperSize, shoeSize: $shoeSize, emergencyContactName: $emergencyContactName, emergencyContactNumber: $emergencyContactNumber, emergencyContactRelationship: $emergencyContactRelationship)';
  }

}