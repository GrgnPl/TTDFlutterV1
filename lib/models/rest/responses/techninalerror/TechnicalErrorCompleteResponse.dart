class TechnicalErrorCompleteResponse {
  String? message;
  bool? success;

  TechnicalErrorCompleteResponse({required this.message, required this.success});

  factory TechnicalErrorCompleteResponse.fromJson(Map<String, dynamic> json) {
    return TechnicalErrorCompleteResponse(
      message: json['message'],
      success: json['success'],
    );
  }
}