import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../RequestBase.dart';

class DutyImageBeforeRequest extends RequestBase {
  String? DutyId;
  String? ImageDate;
  int? ImageNumber;
  File? Image;

  DutyImageBeforeRequest({
    required this.DutyId,
    required this.ImageDate,
    required this.ImageNumber,
    this.Image,
  });

  Map<String, dynamic> toJson() {
    return {
      'DutyId': DutyId,
      'ImageDate': ImageDate,
      'ImageNumber': ImageNumber,
      'Image': Image?.path,
    };
  }
}