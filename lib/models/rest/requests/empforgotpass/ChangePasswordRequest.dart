import '../RequestBase.dart';

class ChangePasswordRequest extends RequestBase {
  String? email;
  String? newPassword;
  String? privateKey;

  ChangePasswordRequest({this.email,this.newPassword,this.privateKey});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (email != null) json['email'] = email;
    if (newPassword != null) json['newPassword'] = newPassword;
    if (privateKey != null) json['privateKey'] = privateKey;
    return json;
  }
}

