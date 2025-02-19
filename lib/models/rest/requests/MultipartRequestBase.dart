import 'package:http/http.dart' as http;

abstract class MultipartRequestBase {
  void appendTo(http.MultipartRequest request);
}