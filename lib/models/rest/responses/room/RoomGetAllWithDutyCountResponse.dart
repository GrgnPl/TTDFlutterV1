import 'dart:ffi';

class RoomGetAllWithDutyCountResponse {
  String? roomId;
  int? count;

  RoomGetAllWithDutyCountResponse({required this.roomId, required this.count});

  factory RoomGetAllWithDutyCountResponse.fromJson(Map<String, dynamic> json) {
    return RoomGetAllWithDutyCountResponse(
      roomId: json["roomId"] ?? "",
      count: json["count"] as int?,
    );
  }
}