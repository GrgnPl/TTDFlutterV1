import 'HallwayById.dart';

class HallwayByIdResponse {
  List<HallwayById>? listOfHallways;
  String? message;
  bool? success;

  HallwayByIdResponse({
    required this.listOfHallways,
    this.message,
    this.success,
  });

  factory HallwayByIdResponse.fromJson(Map<String, dynamic> json) {
    return HallwayByIdResponse(
      listOfHallways: json['data'] != null
          ? List<HallwayById>.from(
          json['data'].map((x) => HallwayById.fromJson(x)))
          : null,
      message: json['message'],
      success: json['success'],
    );
  }
}