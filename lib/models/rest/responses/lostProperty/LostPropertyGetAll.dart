class LostPropertyGetAll {
  String? data;
  String? message;
  bool? success;

  LostPropertyGetAll({required this.data,required this.message, required this.success});

  factory LostPropertyGetAll.fromJson(Map<String, dynamic> json) {
    return LostPropertyGetAll(
      data: json['data'],
      message: json['message'],
      success: json['success'], // bool tipinde olduğunu varsayarak değişiklik yaptım
    );
  }
}