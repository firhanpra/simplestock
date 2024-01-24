import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/constant.dart';
import 'package:inventory/view/stock_opname.dart';

import '../model/fullfill_model.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var searchC = TextEditingController();
  var fullfill = FullFillModel().obs;
  var isLoading = false.obs;
  var status = ''.obs;

  Future<void> submit(int id, DateTime date) async {
    isLoading(true);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = {
      "_method": 'PUT',
      "arrived_date": DateFormat('yyyy-MM-dd').format(date),
    };

    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/order-history/$id',
        data: data,
      );
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil konfirmasi.'),
        ),
      );
      isLoading(false);
      getData(
          tabStatus: _tabController?.index == 0
              ? 'ongoing'
              : _tabController?.index == 1
                  ? 'to_receive'
                  : 'history');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error data.'),
        ),
      );
      isLoading(false);
    }
  }

  Future<void> getData({String tabStatus = 'ongoing'}) async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
          'https://stockskripsi.000webhostapp.com/api/order-history',
          queryParameters: {
            "status": tabStatus,
            "search": searchC.text,
            if (status.value == 'DESC' || status.value == 'ASC')
              "sort": status.value,
            if (status.value == 'gudang') "type": "gudang",
          });
      inspect(response.requestOptions);
      fullfill.value = FullFillModel.fromJson(response.data);
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

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      return picked;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        switch (_tabController!.index) {
          case 0:
            getData();
            break;
          case 1:
            getData(tabStatus: 'to_receive');
            break;
          case 2:
            getData(tabStatus: 'history');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Order History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Ongoing'),
            Tab(text: 'To Receive'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          TextField(
            controller: searchC,
            onChanged: (value) {
              getData(
                  tabStatus: _tabController?.index == 0
                      ? 'ongoing'
                      : _tabController?.index == 1
                          ? 'to_receive'
                          : 'history');
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.all(15),
              hintText: 'Search',
              filled: true,
              fillColor: Colors.yellow.shade50,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kBrown1),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kBrown1),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ).marginSymmetric(horizontal: 10),
          Obx(
            () => Row(
              children: [
                GestureDetector(
                  onTap: () {
                    status.value = 'DESC';
                    getData(
                        tabStatus: _tabController?.index == 0
                            ? 'ongoing'
                            : _tabController?.index == 1
                                ? 'to_receive'
                                : 'history');
                  },
                  child: Chip(
                    backgroundColor:
                        status.value == 'DESC' ? kBrown3 : Colors.white,
                    label: Text(
                      'Recent',
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    status.value = 'ASC';
                    getData(
                        tabStatus: _tabController?.index == 0
                            ? 'ongoing'
                            : _tabController?.index == 1
                                ? 'to_receive'
                                : 'history');
                  },
                  child: Chip(
                    backgroundColor:
                        status.value == 'ASC' ? kBrown3 : Colors.white,
                    label: Text(
                      'Oldest',
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    status.value = 'gudang';
                    getData(
                        tabStatus: _tabController?.index == 0
                            ? 'ongoing'
                            : _tabController?.index == 1
                                ? 'to_receive'
                                : 'history');
                  },
                  child: Chip(
                    backgroundColor:
                        status.value == 'gudang' ? kBrown3 : Colors.white,
                    label: Text(
                      'Gudang',
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(width: 5),
              ],
            ).marginSymmetric(horizontal: 10),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < 3; i++)
                  Obx(() => isLoading.value
                      ? Center(
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CupertinoActivityIndicator()))
                      : ListView(
                          children: fullfill.value.data!
                              .map((e) => Theme(
                                    data: ThemeData(
                                        colorScheme: ColorScheme.light(),
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      title: Text(
                                          '${DateFormat('yyyy-MM-dd').format(e.date!)}'),
                                      children: [
                                        Container(
                                          color: Colors.blueGrey.shade200,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: Get.width * 0.5,
                                                child: Text(
                                                  'SKU',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: Get.width * 0.25,
                                                    child: Text(
                                                      'Jumlah',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: Get.width * 0.25,
                                                    child: Text(
                                                      'Satuan',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...e.orderItemDetails!
                                            .map((sub) => Row(
                                                  children: [
                                                    Container(
                                                      width: Get.width * 0.5,
                                                      child: Text(
                                                        sub.item ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                            width: Get.width *
                                                                0.25,
                                                            child: Text(
                                                              '${sub.qty ?? ''}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                        Container(
                                                            width: Get.width *
                                                                0.25,
                                                            child: Text(
                                                              sub.unit ?? '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Divider(color: Colors.grey),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Order Status'),
                                                  Text(
                                                    e.orderStatus ?? '',
                                                    style: TextStyle(
                                                        color: kBrown2),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Order ID'),
                                                  Text('${e.orderId}'),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Order To'),
                                                  Text(e.orderBy ?? ''),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Requestor'),
                                                  Text(e.requestor ?? ''),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Full Fill By'),
                                                  Text(e.fullFillBy ?? ''),
                                                ],
                                              ),
                                              if (i == 1)
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: kBrown1,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    _selectDate(context)
                                                        .then((value) {
                                                      if (value == null) return;
                                                      submit(e.id!, value);
                                                    });
                                                  },
                                                  child: Text(
                                                      'Konfirmasi Tanggal Kedatangan'),
                                                ),
                                              Divider(color: Colors.grey),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
