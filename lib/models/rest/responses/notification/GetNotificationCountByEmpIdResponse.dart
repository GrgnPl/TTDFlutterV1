import 'package:ttd/models/rest/responses/notification/GetNotificationCountByEmpId.dart';

class GetNotificationCountByEmpIdResponse {
  List<GetNotificationCountByEmpId> data;
  String? message;
  bool? success;

  GetNotificationCountByEmpIdResponse({required this.data, required this.message, required this.success});

  factory GetNotificationCountByEmpIdResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<GetNotificationCountByEmpId> dataList = [];

    if (list != null) {
      dataList = list.map((i) => GetNotificationCountByEmpId.fromJson(i)).toList();
    }

    return GetNotificationCountByEmpIdResponse(
      data: dataList,
      message: json['message'],
      success: json['success'],
    );
  }
}