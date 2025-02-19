import 'dart:ffi';

class FloorGetAllWithCountsResponse {
  String? id;
  String? blockCount;
  String? floorCount;
  Int? hallwayCount;
  Int? roomCount;

  FloorGetAllWithCountsResponse({required this.id,required this.blockCount ,required this.floorCount,required this.hallwayCount, required this.roomCount});

  factory FloorGetAllWithCountsResponse.fromJson(Map<String, dynamic> json) {
    return FloorGetAllWithCountsResponse(
      id: json["id"] ?? "",
      blockCount: json["blockCount"],
      floorCount: json["floorCount"] ?? "",
      hallwayCount: json["hallwayCount"] ?? "",
      roomCount: json["roomCount"] ?? "",
    );
  }
}