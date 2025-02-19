import 'package:ttd/models/rest/responses/hallway/Hallway.dart';
import 'package:ttd/models/rest/responses/stockitem/StockItem.dart';

class StockItemGetAllDetailsResponse  {
  List<StockItem>? listOfStockItem;

  StockItemGetAllDetailsResponse({
    required this.listOfStockItem,
  });

  factory StockItemGetAllDetailsResponse.fromJson(Map<String, dynamic> json) {
    return StockItemGetAllDetailsResponse(
      listOfStockItem: json['data'] == null ? null : List<StockItem>.from(json["data"].map((x) => StockItem.fromJson(x))),
    );
  }
}