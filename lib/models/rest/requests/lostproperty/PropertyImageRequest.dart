
import 'dart:io';

import 'package:ttd/models/rest/requests/RequestBase.dart';

class PropertyImageRequest extends RequestBase {
  String? PropertyId;
  File? Image;

  PropertyImageRequest({
    required this.PropertyId,
    this.Image,
  });

  Map<String, dynamic> toJson() {
    return {
      'PropertyId': PropertyId,
      'Image': Image?.path,
    };
  }
}