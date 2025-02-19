import 'DutyData.dart';

class GetAllDutyByBranchIdResponse {
  List<DutyData>? listOfDuty;


  GetAllDutyByBranchIdResponse({
    required this.listOfDuty,
  });

  factory GetAllDutyByBranchIdResponse.fromJson(Map<String, dynamic> json) {
    return GetAllDutyByBranchIdResponse(
      listOfDuty: json['data'] == null ? null : List<DutyData>.from(json["data"].map((x) => DutyData.fromJson(x))),
    );
  }
}



