// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/model/fullfill_model.dart';

import '../constant.dart';

class FullFillOrder extends StatefulWidget {
  const FullFillOrder({super.key});

  @override
  State<FullFillOrder> createState() => _FullFillOrderState();
}

class _FullFillOrderState extends State<FullFillOrder> {
  var fullfill = FullFillModel().obs;
  var isLoading = false.obs;

  Future<void> getData() async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/fullfill-order',
      );
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

  Future<void> submit(int id) async {
    isLoading(true);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = [
      {
        "id": id,
      }
    ];
    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/fullfill-order',
        data: data,
      );
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil konfirmasi.'),
        ),
      );
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
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Full Fill Order'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          TextField(
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
          Row(
            children: [
              Chip(
                backgroundColor: kBrown3,
                label: Text(
                  'Recent',
                  style: TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
                shape: StadiumBorder(),
              ),
              SizedBox(width: 5),
              Chip(
                backgroundColor: Colors.white,
                label: Text(
                  'Oldest',
                  style: TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
                shape: StadiumBorder(),
              ),
              SizedBox(width: 5),
              Chip(
                backgroundColor: Colors.white,
                label: Text(
                  'TI/TO',
                  style: TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
                shape: StadiumBorder(),
              ),
              SizedBox(width: 5),
              Chip(
                backgroundColor: Colors.white,
                label: Text(
                  'Gudang',
                  style: TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
                shape: StadiumBorder(),
              ),
              SizedBox(width: 5),
            ],
          ).marginSymmetric(horizontal: 10),
          Expanded(
            child: Obx(() => isLoading.value
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
                                    padding: EdgeInsets.symmetric(vertical: 5),
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
                                              MainAxisAlignment.spaceEvenly,
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
                                  ),
                                  ...e.orderItemDetails!
                                      .map((sub) => Row(
                                            children: [
                                              Container(
                                                width: Get.width * 0.5,
                                                child: Text(
                                                  sub.item ?? '',
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
                                                        '${sub.qty ?? ''}',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  Container(
                                                      width: Get.width * 0.25,
                                                      child: Text(
                                                        sub.unit ?? '',
                                                        textAlign:
                                                            TextAlign.center,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Order Status'),
                                            Text(
                                              e.orderStatus ?? '',
                                              style: TextStyle(color: kBrown2),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Order ID'),
                                            Text('${e.orderId}'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Order To'),
                                            Text(e.orderBy ?? ''),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Requestor'),
                                            Text(e.requestor ?? ''),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Full Fill By'),
                                            Text(e.fullFillBy ?? ''),
                                          ],
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kBrown1,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            submit(e.id!);
                                          },
                                          child: Text('Submit'),
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
          ),
        ],
      ),
    );
  }
}
