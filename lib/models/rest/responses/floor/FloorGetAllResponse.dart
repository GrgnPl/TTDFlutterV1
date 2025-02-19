  import 'dart:ffi';

  class FloorGetAllResponse {
    String? id;
    String? branchId;
    String? blockId;
    String? floorName;

    FloorGetAllResponse({required this.id,required this.branchId ,required this.blockId,required this.floorName});

    factory FloorGetAllResponse.fromJson(Map<String, dynamic> json) {
      return FloorGetAllResponse(
        id: json["id"] ?? "",
        branchId: json["branchId"],
        blockId: json["blockId"] ?? "",
        floorName: json["floorName"] ?? "",
      );
    }
  }