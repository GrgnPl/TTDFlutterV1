import 'dart:ffi';

import 'Room.dart';

class RoomGetAllResponse  {
  List<Room>? listofroom;

  RoomGetAllResponse({
    required this.listofroom,
  });

  factory RoomGetAllResponse.fromJson(Map<String, dynamic> json) {
    return RoomGetAllResponse(
      listofroom: json['data'] == null ? null : List<Room>.from(json["data"].map((x) => Room.fromJson(x))),
    );
  }
}
/*
data: json["data"] == null ? null : List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
 */