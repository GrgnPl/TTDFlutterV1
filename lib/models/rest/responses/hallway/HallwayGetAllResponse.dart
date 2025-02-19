import 'package:ttd/models/rest/responses/hallway/Hallway.dart';

class HallwayGetAllResponse  {
  List<Hallway>? listofHallway;

  HallwayGetAllResponse({
    required this.listofHallway,
  });

  factory HallwayGetAllResponse.fromJson(Map<String, dynamic> json) {
    return HallwayGetAllResponse(
      listofHallway: json['data'] == null ? null : List<Hallway>.from(json["data"].map((x) => Hallway.fromJson(x))),
    );
  }
}