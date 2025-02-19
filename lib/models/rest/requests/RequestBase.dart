import 'package:http/http.dart' as http;
import '../../../rest/RestServiceManager.dart';
import 'MultipartRequestBase.dart';

abstract class RequestBase implements MultipartRequestBase {
  Map<String, dynamic> toJson();

  @override
  void appendTo(http.MultipartRequest request) {
  }
}