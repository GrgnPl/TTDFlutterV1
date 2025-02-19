import 'package:ttd/models/rest/responses/product/Product.dart';

class ProductGetAll  {
  List<Product>? listOfProduct;

  ProductGetAll({
    required this.listOfProduct,
  });

  factory ProductGetAll.fromJson(Map<String, dynamic> json) {
    return ProductGetAll(
      listOfProduct: json['data'] == null ? null : List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    );
  }
}