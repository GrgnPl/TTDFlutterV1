
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/room/Room.dart';

import 'DutyByEmployeeId.dart';

class DutyByEmployeeIdResponse  {
  List<DutyByEmployeeId>? listOfDutyByEmpId;

  DutyByEmployeeIdResponse({
    required this.listOfDutyByEmpId,
  });

  factory DutyByEmployeeIdResponse.fromJson(Map<String, dynamic> json) {
    return DutyByEmployeeIdResponse(
      listOfDutyByEmpId: json['data'] == null ? null : List<DutyByEmployeeId>.from(json["data"].map((x) => DutyByEmployeeId.fromJson(x))),
    );
  }
}