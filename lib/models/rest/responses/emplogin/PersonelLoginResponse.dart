class PersonelLoginResponse {
  String? employeeId;
  String? token;
  String? expiration;
  String? message;
  bool? success;

  PersonelLoginResponse({
    this.employeeId,
    this.token,
    this.expiration,
    required this.message,
    required this.success});

  factory PersonelLoginResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as Map<String, dynamic>?;
    
    return PersonelLoginResponse(
      employeeId: data?['employeeId'],
      token: data?['token'],
      expiration: data?['expiration'],
      message: json["message"],
      success: json["success"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': employeeId != null ? {
        'employeeId': employeeId,
        'token': token,
        'expiration': expiration,
      } : null,
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'PersonelLoginResponse{employeeId: $employeeId, token: $token, expiration: $expiration, message: $message, success: $success}';
  }
}