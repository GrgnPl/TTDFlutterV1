class EmpForgotPasswordResponse {
  String? message;
  bool? success;


  EmpForgotPasswordResponse({required this.message, required this.success});

  factory EmpForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return EmpForgotPasswordResponse(
      message: json['message'],
      success: json['success'],
    );
  }
}