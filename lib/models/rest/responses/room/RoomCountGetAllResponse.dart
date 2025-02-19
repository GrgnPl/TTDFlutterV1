import 'package:ttd/models/rest/responses/room/RoomDutyCount.dart';

class RoomCountGetAllResponse  {
  List<RoomDutyCount>? listOfRoomDutyCount;

  RoomCountGetAllResponse({
    required this.listOfRoomDutyCount,
  });

  factory RoomCountGetAllResponse.fromJson(Map<String, dynamic> json) {
    return RoomCountGetAllResponse(
      listOfRoomDutyCount: json['data'] == null ? null : List<RoomDutyCount>.from(json["data"].map((x) => RoomDutyCount.fromJson(x))),
    );
  }
}