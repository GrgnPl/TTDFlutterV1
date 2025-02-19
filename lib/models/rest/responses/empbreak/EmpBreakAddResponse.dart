class EmpBreakAddResponse {
  String? message;
  bool? success; // String yerine bool kullanıyoruz

  EmpBreakAddResponse({required this.message, required this.success});

  factory EmpBreakAddResponse.fromJson(Map<String, dynamic> json) {
    return EmpBreakAddResponse(
      message: json['message'],
      success: json['success'] as bool?, // JSON'dan bool olarak alıyoruz
    );
  }
}