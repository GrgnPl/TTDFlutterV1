import '../RequestBase.dart';

class EmpForgotPasswordRequest extends RequestBase {
  String? email;

  EmpForgotPasswordRequest({this.email});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (email != null) json['email'] = email;
    return json;
  }
}