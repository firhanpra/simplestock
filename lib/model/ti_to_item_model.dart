// To parse this JSON data, do
//
//     final tiToItemModel = tiToItemModelFromJson(jsonString);

import 'dart:convert';

TiToItemModel tiToItemModelFromJson(String str) =>
    TiToItemModel.fromJson(json.decode(str));

String tiToItemModelToJson(TiToItemModel data) => json.encode(data.toJson());

class TiToItemModel {
  String? message;

  List<TiToItemModelDatum>? data;

  TiToItemModel({
    this.message,
    this.data,
  });

  factory TiToItemModel.fromJson(Map<String, dynamic> json) => TiToItemModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TiToItemModelDatum>.from(
                json["data"]!.map((x) => TiToItemModelDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TiToItemModelDatum {
  String? name;
  List<ObjTiToItem>? data;

  TiToItemModelDatum({
    this.name,
    this.data,
  });

  factory TiToItemModelDatum.fromJson(Map<String, dynamic> json) =>
      TiToItemModelDatum(
        name: json["name"],
        data: json["data"] == null
            ? []
            : List<ObjTiToItem>.from(
                json["data"]!.map((x) => ObjTiToItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ObjTiToItem {
  int? id;
  int? itemId;
  String? name;
  String? barcode;
  int? inStock;
  int? outStock;
  DateTime? date;

  ObjTiToItem({
    this.id,
    this.itemId,
    this.name,
    this.barcode,
    this.inStock,
    this.outStock,
    this.date,
  });

  factory ObjTiToItem.fromJson(Map<String, dynamic> json) => ObjTiToItem(
        id: json["id"],
        itemId: json["item_id"],
        name: json["name"],
        barcode: json["barcode"],
        inStock: json["in_stock"],
        outStock: 0,
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "name": name,
        "barcode": barcode,
        "in_stock": inStock,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
