import 'dart:io';

import '../RequestBase.dart';

class LostPropertyImageRequest extends RequestBase {
  String? PropertyId;
  File? Image;

  LostPropertyImageRequest({
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