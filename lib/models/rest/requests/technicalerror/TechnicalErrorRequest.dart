import '../RequestBase.dart';

class TechnicalErrorRequest extends RequestBase {
  String? errorTitle;
  String? errorDescription;
  String? roomId;
  String? complecetedDate;
  String? employeeId;
  String? departmentId;
  String? description;


  TechnicalErrorRequest({
    this.errorTitle,
    this.errorDescription,
    this.roomId,
    this.complecetedDate,
    this.employeeId,
    this.departmentId,
    this.description
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (errorTitle != null) json['errorTitle'] = errorTitle;
    if (errorDescription != null) json['errorDescription'] = errorDescription;
    if (roomId != null) json['roomId'] = roomId;
    if (complecetedDate != null) json['complecetedDate'] = complecetedDate;
    if (employeeId != null) json['employeeId'] = employeeId;
    if (departmentId != null) json['departmentId'] = departmentId;
    if (description != null) json['description'] = description;

    return json;
  }

  @override
  String toString() {
    return 'TechnicalErrorRequest { '
        'errorTitle: $errorTitle, '
        'errorDescription: $errorDescription, '
        'roomId: $roomId,'
        'complecetedDate: $complecetedDate,'
        'employeeId: $employeeId,'
        'departmentId: $departmentId,'
        'description: $description}';
  }
}