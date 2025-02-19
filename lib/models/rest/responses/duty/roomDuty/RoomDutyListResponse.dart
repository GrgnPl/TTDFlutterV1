import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';

class RoomDutyListResponse  {
  List<RoomDuty>? listOfRoomDuty;

  RoomDutyListResponse({
    required this.listOfRoomDuty,
  });

  factory RoomDutyListResponse.fromJson(Map<String, dynamic> json) {
    return RoomDutyListResponse(
      listOfRoomDuty: json['data'] == null ? null : List<RoomDuty>.from(json["data"].map((x) => RoomDuty.fromJson(x))),
    );
  }
}