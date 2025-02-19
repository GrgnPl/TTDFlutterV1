import 'package:ttd/models/rest/responses/lostProperty/LostProperty.dart';
import 'package:ttd/models/rest/responses/room/RoomDutyCount.dart';

class LostPropertyGetAllResponse  {
  List<LostProperty>? listOfLostProperty;

  LostPropertyGetAllResponse({
    required this.listOfLostProperty,
  });

  factory LostPropertyGetAllResponse.fromJson(Map<String, dynamic> json) {
    return LostPropertyGetAllResponse(
      listOfLostProperty: json['data'] == null ? null : List<LostProperty>.from(json["data"].map((x) => LostProperty.fromJson(x))),
    );
  }
}