// To parse this JSON data, do
//
//     final stockOpname = stockOpnameFromJson(jsonString);

import 'dart:convert';

StockOpnameModel stockOpnameFromJson(String str) =>
    StockOpnameModel.fromJson(json.decode(str));

String stockOpnameToJson(StockOpnameModel data) => json.encode(data.toJson());

class StockOpnameModel {
  String? message;
  List<ObjStockOpname>? data;

  StockOpnameModel({
    this.message,
    this.data,
  });

  factory StockOpnameModel.fromJson(Map<String, dynamic> json) =>
      StockOpnameModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ObjStockOpname>.from(
                json["data"]!.map((x) => ObjStockOpname.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ObjStockOpname {
  int? itemId;
  String? name;
  String? category;
  String? unit;
  int? qty;
  int? currentQty;

  ObjStockOpname({
    this.itemId,
    this.name,
    this.category,
    this.unit,
    this.qty,
    this.currentQty,
  });

  factory ObjStockOpname.fromJson(Map<String, dynamic> json) => ObjStockOpname(
        itemId: json["item_id"] ?? json["id"],
        name: json["name"],
        category: json["category"],
        unit: json["unit"] ?? '',
        qty: json["qty"] ?? 0,
        currentQty: json["current_qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "name": name,
        "category": category,
        "qty": qty,
      };
}
