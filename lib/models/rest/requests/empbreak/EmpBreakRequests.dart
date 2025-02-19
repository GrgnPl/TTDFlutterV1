import 'dart:ffi';

import '../RequestBase.dart';

class EmpBreakRequests extends RequestBase {
  String? employeeId;
  String? breakDescription;
  int? breakTime;
  String? userId;
  String? breakDate;

  EmpBreakRequests({this.employeeId, this.breakDescription,this.breakTime,this.userId,this.breakDate});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (employeeId != null) json['employeeId'] = employeeId;
    if (breakDescription != null) json['breakDescription'] = breakDescription;
    if (breakDescription != null) json['breakDescription'] = breakDescription;
    if (breakTime != null) json['breakTime'] = breakTime;
    if (userId != null) json['userId'] = userId;
    if (breakDate != null) json['breakDate'] = breakDate;
    return json;
  }
}