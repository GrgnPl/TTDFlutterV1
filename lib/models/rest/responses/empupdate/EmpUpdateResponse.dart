class EmpUpdateResponse {
  String? message;
  bool? success;

  EmpUpdateResponse({required this.message, required this.success});

  factory EmpUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EmpUpdateResponse(
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}