import 'package:ttd/models/rest/responses/profil/GetByImagesByEmployeeId.dart';

class GetByImagesByEmployeeIdResponse {
  List<GetByImagesByEmployeeId>? listOfProfilePhoto;
  String? message;
  bool? success;

  GetByImagesByEmployeeIdResponse({
    required this.listOfProfilePhoto,
    this.message,
    this.success,
  });

  factory GetByImagesByEmployeeIdResponse.fromJson(Map<String, dynamic> json) {
    return GetByImagesByEmployeeIdResponse(
      listOfProfilePhoto: json['data'] != null
          ? List<GetByImagesByEmployeeId>.from(json["data"].map((x) => GetByImagesByEmployeeId.fromJson(x)))
          : null,
      message: json['message'],
      success: json['success'],
    );
  }
}