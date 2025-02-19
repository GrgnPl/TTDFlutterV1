class AddEmployeeResponse {
  String? message;
  bool? success;

  AddEmployeeResponse({required this.message, required this.success});

  factory AddEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return AddEmployeeResponse(
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}