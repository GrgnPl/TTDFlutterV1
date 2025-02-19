import 'package:ttd/models/rest/responses/empbreak/EmployeeBreak.dart';

class EmployeeBreakGetAllResponse  {
  List<EmployeeBreak>? listofroom;

  EmployeeBreakGetAllResponse({
    required this.listofroom,
  });

  factory EmployeeBreakGetAllResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeBreakGetAllResponse(
      listofroom: json['data'] == null ? null : List<EmployeeBreak>.from(json["data"].map((x) => EmployeeBreak.fromJson(x))),
    );
  }
}