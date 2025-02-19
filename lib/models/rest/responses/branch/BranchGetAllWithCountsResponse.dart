import 'dart:ffi';

class BranchGetAllWithCountsResponse {
  String? id;
  Int? blockCount;
  Int? floorCount;
  Int? hallwayCount;
  Int? roomCount;

  BranchGetAllWithCountsResponse({required this.id, required this.blockCount,required this.floorCount, required this.hallwayCount, required this.roomCount});

  factory BranchGetAllWithCountsResponse.fromJson(Map<String, dynamic> json) {
    return BranchGetAllWithCountsResponse(
      id: json["id"] ?? "",
      blockCount: json["blockCount"] ?? "",
      floorCount: json["floorCount"] ?? "",
      hallwayCount: json["hallwayCount"] ?? "",
      roomCount: json["roomCount"] ?? "",
    );
  }
}