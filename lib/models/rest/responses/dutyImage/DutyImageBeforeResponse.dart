import 'dart:ffi';

class DutyImageBeforeResponse {
  String? message;
  bool? success;

  DutyImageBeforeResponse({required this.message, required this.success});

  factory DutyImageBeforeResponse.fromJson(Map<String, dynamic> json) {
    return DutyImageBeforeResponse(
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}