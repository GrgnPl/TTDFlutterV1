import '../RequestBase.dart';

class EmpLoginRequest extends RequestBase {
  String? phoneNumber;
  String? password;
  String? fireBaseId;

  EmpLoginRequest({this.phoneNumber, this.password,required this.fireBaseId});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (phoneNumber != null) json['phoneNumber'] = phoneNumber;
    if (password != null) json['password'] = password;
    if (fireBaseId != null) json['fireBaseId'] = fireBaseId;
    return json;
  }
}