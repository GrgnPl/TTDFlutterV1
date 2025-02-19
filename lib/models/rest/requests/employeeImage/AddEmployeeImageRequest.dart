
import 'dart:io';

import 'package:ttd/models/rest/requests/RequestBase.dart';

class AddEmployeeImageRequest extends RequestBase {
  String? EmployeeId;
  File? Image;

  AddEmployeeImageRequest({
    required this.EmployeeId,
    this.Image,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeId': EmployeeId,
      'Image': Image?.path,
    };
  }
}