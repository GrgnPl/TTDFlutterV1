class stock {
  String? message;
  bool? success;


  stock({required this.message, required this.success});

  factory stock.fromJson(Map<String, dynamic> json) {
    return stock(
      message: json['message'],
      success: json['success'],
    );
  }
}