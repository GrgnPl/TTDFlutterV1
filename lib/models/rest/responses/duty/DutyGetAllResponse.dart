
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/room/Room.dart';

class DutyGetAllResponse  {
  List<Duty>? listOfDuty;

  DutyGetAllResponse({
    required this.listOfDuty,
  });

  factory DutyGetAllResponse.fromJson(Map<String, dynamic> json) {
    return DutyGetAllResponse(
      listOfDuty: json['data'] == null ? null : List<Duty>.from(json["data"].map((x) => Duty.fromJson(x))),
    );
  }
}