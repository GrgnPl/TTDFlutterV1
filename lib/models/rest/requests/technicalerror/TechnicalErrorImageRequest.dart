
import 'dart:io';

import '../RequestBase.dart';

class TechnicalErrorImageRequest extends RequestBase {
  String? TechnicalErrorId;
  File? Image;

  TechnicalErrorImageRequest({
    required this.TechnicalErrorId,
    this.Image,
  });

  Map<String, dynamic> toJson() {
    return {
      'TechnicalErrorId': TechnicalErrorId,
      'Image': Image?.path,
    };
  }
}