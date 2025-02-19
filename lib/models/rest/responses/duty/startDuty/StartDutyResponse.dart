class StartDutyResponse {
  String? message;
  bool? success;

  StartDutyResponse({required this.message, required this.success});

  factory StartDutyResponse.fromJson(Map<String, dynamic> json) {
    return StartDutyResponse(
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}