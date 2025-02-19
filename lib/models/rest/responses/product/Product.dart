class Product {
  final String id;
  final String name;
  final int threshold;
  final int price;
  final int stockQuantity;
  final String categoryId;
  final String departmentId;
  final String supplierId;
  final String warehouseLocation;
  final bool disposable;

  Product({
    required this.id,
    required this.name,
    required this.threshold,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    required this.departmentId,
    required this.supplierId,
    required this.warehouseLocation,
    required this.disposable,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      threshold: json['threshold'],
      price: json['price'],
      stockQuantity: json['stockQuantity'],
      categoryId: json['categoryId'],
      departmentId: json['departmentId'],
      supplierId: json['supplierId'],
      warehouseLocation: json['warehouseLocation'],
      disposable: json['disposable'],
    );
  }
}