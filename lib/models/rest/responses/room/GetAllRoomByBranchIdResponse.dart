

import 'GetAllRoomByBranchId.dart';

class GetAllRoomByBranchIdResponse  {
  List<GetAllRoomByBranchId>? listOfRooms;

  GetAllRoomByBranchIdResponse({
    required this.listOfRooms,
  });

  factory GetAllRoomByBranchIdResponse.fromJson(Map<String, dynamic> json) {
    return GetAllRoomByBranchIdResponse(
      listOfRooms: json['data'] == null ? null : List<GetAllRoomByBranchId>.from(json["data"].map((x) => GetAllRoomByBranchId.fromJson(x))),
    );
  }
}