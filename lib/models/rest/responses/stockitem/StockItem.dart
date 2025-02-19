class StockItem {
  String id;
  String productId;
  String quantity;
  String entryDate;
  String description;
  List<String> roomId;
  String employeeId;

  StockItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.entryDate,
    required this.description,
    required this.roomId,
    required this.employeeId,

  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      entryDate: json['entryDate'],
      description: json['description'],
      roomId: List<String>.from(json['roomId']),
      employeeId: json['employeeId'],
    );
  }
}