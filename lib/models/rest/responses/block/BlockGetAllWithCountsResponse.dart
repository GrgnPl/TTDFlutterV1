import 'dart:ffi';

class BlockGetAllWithCountsResponse {
  String? id;
  String? blockCount;
  Int? floorCount;
  Int? hallwayCount;
  Int? roomCount;

  BlockGetAllWithCountsResponse({required this.id,required this.blockCount ,required this.floorCount,required this.hallwayCount,required this.roomCount});

  factory BlockGetAllWithCountsResponse.fromJson(Map<String, dynamic> json) {
    return BlockGetAllWithCountsResponse(
      id: json["id"] ?? "",
      blockCount: json["blockCount"],
      floorCount: json["floorCount"] ?? "",
      hallwayCount: json["hallwayCount"] ?? "",
      roomCount: json["roomCount"] ?? "",
    );
  }
}