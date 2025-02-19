import 'package:ttd/models/rest/responses/lostProperty/LostProperty.dart';
import 'package:ttd/models/rest/responses/room/RoomDutyCount.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechninalError.dart';

class TechninalErrorResponse  {
  List<TechninalError>? listOfTechnicalError;

  TechninalErrorResponse({
    required this.listOfTechnicalError,
  });

  factory TechninalErrorResponse.fromJson(Map<String, dynamic> json) {
    return TechninalErrorResponse(
      listOfTechnicalError: json['data'] == null ? null : List<TechninalError>.from(json["data"].map((x) => TechninalError.fromJson(x))),
    );
  }
}