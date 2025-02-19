import 'package:ttd/models/rest/responses/additionaltask/AdditionalTask.dart';

import 'Task.dart';

class AdditionalTaskGetAllResponse {
  List<AdditionalTask>? listOfAdditionalTask;
  String? message;
  bool? success;

  AdditionalTaskGetAllResponse({
    required this.listOfAdditionalTask,
    this.message,
    this.success
  });

  factory AdditionalTaskGetAllResponse.fromJson(Map<String, dynamic> json) {
    return AdditionalTaskGetAllResponse(
      listOfAdditionalTask: json['data'] == null ? null : List<AdditionalTask>.from(json["data"].map((x) => AdditionalTask.fromJson(x))),
    );
  }
}
