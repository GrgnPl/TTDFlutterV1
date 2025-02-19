class AuthModel {
    String? employeeId;
    String? token;
    String? expiration;
    AuthModel({required this.employeeId, required this.token, required this.expiration});

    @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (employeeId != null) json['employeeId'] = employeeId;
    if (token != null) json['token'] = token;
    if (token != null) json['expiration'] = expiration;

    return json;
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      employeeId: json['employeeId'],
      token: json['token'],
      expiration: json['expiration'],
    );
  }



}
