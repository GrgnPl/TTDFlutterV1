class StatusUpdateResponse {
  String? message;
  bool? success;

  StatusUpdateResponse({required this.message, required this.success});

  factory StatusUpdateResponse.fromJson(Map<String, dynamic> json) {
    return StatusUpdateResponse(
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}