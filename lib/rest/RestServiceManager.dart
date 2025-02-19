import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ttd/models/domain/common/AuthModel.dart';

import 'package:ttd/models/rest/requests/RequestBase.dart';
import 'package:ttd/services/common/TTDApplicationService.dart';
import '../models/rest/requests/MultipartRequestBase.dart';
import 'RequestType.dart';


class RestServiceManager {
  static const multipartheader = {'Content-Type': 'multipart/form-data'};
  static const defaultheader = {'Content-Type': 'application/json'};

  static dynamic call(
      String url,
      String endpoint,
      Map<String, String>? requestHeader,
      RequestBase? requestBase,
      RequestType requestType, {
        String? filePath,
        bool isLoading = true,
        bool isMultipart = false,
        Map<String, dynamic>? queryParams,
      }) async {
    Map<String, String> header = {};

    MultipartRequest? multipartRequest;
    String _multipartRequestType = 'POST';
    String _multipartRequestFileType = 'Image';
    var auth_key;
    header['accept'] = '*/*';

    if (TTDApplicationService.authModel != null) {
      auth_key = TTDApplicationService.authModel!.token;
    }

    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    Uri uri = Uri.parse(url + endpoint);

    if (requestType == RequestType.GET && queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    if (!isMultipart) {
      if (requestHeader != null) {
        header.addAll(requestHeader);
      }
      if (auth_key != null && auth_key!.isNotEmpty) {
        header['Authorization'] = 'Bearer $auth_key';
      }
      header.addAll(defaultheader);
    } else {
      multipartRequest = http.MultipartRequest(_multipartRequestType, uri);
      var uploadData = requestBase!.toJson();
      uploadData.forEach((key, value) {
        multipartRequest!.fields[key] = value.toString();
      });
      if (auth_key != null && auth_key!.isNotEmpty) {
        multipartRequest.headers.addAll({'Authorization': "Bearer $auth_key"});
      } else {
        print('Authorization key is null or empty');
      }
      if (filePath != null) {
        var multipartFile = await http.MultipartFile.fromPath(_multipartRequestFileType, filePath);
        multipartRequest.files.add(multipartFile);
      } else {
        print('File path is null');
      }
      multipartRequest.headers.addAll(multipartheader);
    }

    try {
      var response;
      switch (requestType) {
        case RequestType.POST:
          response = await http.post(uri, headers: header, body: jsonEncode(requestBase != null ? requestBase.toJson() : null));
          break;
        case RequestType.MULTIPART:
          response = await multipartRequest!.send();
          break;
        case RequestType.GET:
          response = await http.get(uri, headers: header);
          break;
        default:
          response = await http.get(uri, headers: header);
          break;
      }

      if (response is http.StreamedResponse) {
        response = await http.Response.fromStream(response);
      }

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonDecode(response.body);
        case 400:
          var decodedResponse = jsonDecode(response.body);
          return decodedResponse;
        case 401:
          var decodedResponse = jsonDecode(response.body);
          return decodedResponse;
        default:
          var decodedResponse = jsonDecode(response.body);
          return decodedResponse;
      }
    } catch (ex, stackTrace) {
      print('Exception occurred: $ex');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
