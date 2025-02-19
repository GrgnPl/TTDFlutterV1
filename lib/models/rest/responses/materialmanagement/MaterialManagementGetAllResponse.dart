
import 'package:ttd/models/rest/responses/materialmanagement/MaterialManagement.dart';

class MaterialManagementGetAllResponse  {
  List<MaterialManagement>? listOfMaterial;

  MaterialManagementGetAllResponse({
    required this.listOfMaterial,
  });

  factory MaterialManagementGetAllResponse.fromJson(Map<String, dynamic> json) {
    return MaterialManagementGetAllResponse(
      listOfMaterial: json['data'] == null ? null : List<MaterialManagement>.from(json["data"].map((x) => MaterialManagement.fromJson(x))),
    );
  }
}