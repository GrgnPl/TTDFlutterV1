class WorkAccidentGetAllResponse {
  String id;
  String insuranceRegistrationNumber;
  String identificationNumber;
  String employeeId;
  String fatherName;
  String birthDay;
  String? placeOfBirth;
  String? mission;
  String? dateOfStart;
  String? accidentDate;
  String? numberOfEmployees;
  String? workingStartDate;
  String? address;
  String? phoneNumber;
  String? lossOfLimb;
  String? lossOfLimbText;
  String? description;
  List<String> workAccidentAdmin;

  WorkAccidentGetAllResponse({
    required this.id,
    required this.insuranceRegistrationNumber,
    required this.identificationNumber,
    required this.employeeId,
    required this.fatherName,
    required this.birthDay,
    required this.placeOfBirth,
    required this.mission,
    required this.dateOfStart,
    required this.accidentDate,
    required this.numberOfEmployees,
    required this.workingStartDate,
    required this.address,
    required this.phoneNumber,
    required this.lossOfLimb,
    required this.lossOfLimbText,
    required this.description,
    required this.workAccidentAdmin,

  });

  factory WorkAccidentGetAllResponse.fromJson(Map<String, dynamic> json) {
    return WorkAccidentGetAllResponse(
      id: json['id'],
      insuranceRegistrationNumber: json['insuranceRegistrationNumber'],
      identificationNumber: json['identificationNumber'],
      employeeId: json['employeeId'],
      fatherName: json['fatherName'],
      birthDay: json["birthDay"],
      placeOfBirth: json["placeOfBirth"],
      mission: json["mission"],
      dateOfStart: json["dateOfStart"],
      accidentDate: json["accidentDate"],
      numberOfEmployees: json["numberOfEmployees"],
      workingStartDate: json["workingStartDate"],
      address: json["address"],
      phoneNumber: json["phoneNumber"],
      lossOfLimb: json["lossOfLimb"],
      lossOfLimbText: json["lossOfLimbText"],
      description: json["description"],
      workAccidentAdmin: List<String>.from(json['workAccidentAdmin']),
    );
  }
}