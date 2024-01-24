// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/constant.dart';

import '../model/stock_opname_model.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  DateTime? _selectedDate;
  TextEditingController _searchController = TextEditingController();
  var rawList = StockOpnameModel().obs;
  var itemList = StockOpnameModel().obs;
  Map<String, List<ObjStockOpname>> separatedData = {};
  var postDataList = <ObjStockOpname>[];
  bool isSearching = false;
  var isLoading = false.obs;

  void _search() {
    String query = _searchController.text.toLowerCase();
    print(query);

    itemList.update((val) {
      val?.data?.clear();
      rawList.value.data?.forEach((element) {
        if (element.name!.toLowerCase().contains(query)) {
          val?.data?.add(element);
        }
      });
    });
    plottingData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        getData();
      });
    }
  }

  Future<void> getData() async {
    String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/order-item?search=&date=$date',
      );
      rawList.value = StockOpnameModel.fromJson(response.data);
      itemList.value = StockOpnameModel.fromJson(response.data);
      inspect(itemList.value);
      plottingData();
      isLoading(false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error data.'),
        ),
      );
      isLoading(false);
    }
  }

  plottingData() {
    // Memisahkan data ke dalam list berdasarkan kategori
    separatedData = {};
    postDataList.clear();
    for (var item in itemList.value.data!) {
      String category = item.category!;
      if (!separatedData.containsKey(category)) {
        separatedData[category] = [];
      }
      separatedData[category]!.add(item);
    }

    setState(() {});
  }

  Future<void> postStock() async {
    isLoading(true);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = {
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      'order_item_details': postDataList
          .where((element) => element.qty != 0)
          .map((e) => {
                "item_id": e.itemId,
                "qty": e.qty,
              })
          .toList(),
    };
    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/order-item',
        data: data,
      );
      print(response.data);
      isLoading(false);
      getData();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error data.'),
        ),
      );
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: isSearching
            ? AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: isSearching ? 200.0 : 0.0,
                child: TextField(
                  onChanged: (value) {
                    _search();
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari barang..',
                    border: InputBorder.none,
                  ),
                ),
              )
            : Text('Order Barang'),
        actions: [
          IconButton(
            icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  getData();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 5),
                Text(_selectedDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
              ],
            ),
          ).marginAll(15),
          Expanded(
              child: Obx(
            () => isLoading.value
                ? Center(
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CupertinoActivityIndicator()))
                : _selectedDate == null
                    ? Center(
                        child: Text(
                          'Silahkan pilih tanggal terlebih dahulu',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView(
                        children: _buildItems(),
                      ),
          )),
          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrown1,
                foregroundColor: Colors.white,
              ),
              onPressed: _selectedDate == null
                  ? null
                  : () {
                      postStock();
                    },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> widgets = [];

    separatedData.forEach((key, value) {
      postDataList.addAll(value);
      widgets.add(
        Theme(
          data: ThemeData(
              colorScheme: ColorScheme.light(),
              dividerColor: Colors.transparent),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(vertical: 15),
            title: Text(
              key,
            ),
            children: [
              Row(
                children: [
                  Container(
                    width: Get.width * 0.5,
                    child: Text(
                      'SKU',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        child: Text(
                          'Jumlah',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: Get.width * 0.25,
                        child: Text(
                          'Satuan',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              ...value.map((e) {
                var qty = postDataList
                    .firstWhere((element) => element.itemId == e.itemId)
                    .qty;
                return Row(
                  children: [
                    Container(
                      width: Get.width * 0.5,
                      child: Text(
                        e.name!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: Get.width * 0.25,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: '$qty'),
                            onChanged: (value) {
                              postDataList
                                  .firstWhere(
                                      (element) => element.itemId == e.itemId)
                                  .qty = int.parse(value == '' ? '0' : value);
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              constraints: BoxConstraints(maxHeight: 30),
                              hintText: '0',
                              border: OutlineInputBorder(),
                            ),
                          ).marginSymmetric(horizontal: 10),
                        ),
                        Container(
                            width: Get.width * 0.25,
                            child: Text(
                              e.unit!,
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ],
                );
              }).toList(),
              Divider(color: Colors.grey),
            ],
          ),
        ),
      );
    });

    return widgets;
  }
}
