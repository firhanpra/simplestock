// To parse this JSON data, do
//
//     final fullFillModel = fullFillModelFromJson(jsonString);

import 'dart:convert';

FullFillModel fullFillModelFromJson(String str) =>
    FullFillModel.fromJson(json.decode(str));

String fullFillModelToJson(FullFillModel data) => json.encode(data.toJson());

class FullFillModel {
  String? message;
  List<Datum>? data;

  FullFillModel({
    this.message,
    this.data,
  });

  factory FullFillModel.fromJson(Map<String, dynamic> json) => FullFillModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  DateTime? date;
  String? orderStatus;
  String? orderId;
  String? orderBy;
  String? requestor;
  String? fullFillBy;
  List<OrderItemDetail>? orderItemDetails;

  Datum({
    this.id,
    this.date,
    this.orderStatus,
    this.orderId,
    this.orderBy,
    this.requestor,
    this.fullFillBy,
    this.orderItemDetails,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        orderStatus: json["order_status"],
        orderId: json["order_id"],
        orderBy: json["order_by"],
        requestor: json["requestor"],
        fullFillBy: json["full_fill_by"],
        orderItemDetails: json["order_item_details"] == null
            ? []
            : List<OrderItemDetail>.from(json["order_item_details"]!
                .map((x) => OrderItemDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "order_status": orderStatus,
        "order_id": orderId,
        "order_by": orderBy,
        "requestor": requestor,
        "full_fill_by": fullFillBy,
        "order_item_details": orderItemDetails == null
            ? []
            : List<dynamic>.from(orderItemDetails!.map((x) => x.toJson())),
      };
}

class OrderItemDetail {
  String? item;
  int? qty;
  String? category;
  String? unit;

  OrderItemDetail({
    this.item,
    this.qty,
    this.category,
    this.unit,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) =>
      OrderItemDetail(
        item: json["item"],
        qty: json["qty"],
        category: json["category"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "qty": qty,
        "category": category,
        "unit": unit,
      };
}
