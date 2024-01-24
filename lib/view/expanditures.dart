// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/model/ti_to_item_model.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../constant.dart';
import '../utils.dart';

class Expanditures extends StatefulWidget {
  const Expanditures({Key? key}) : super(key: key);

  @override
  State<Expanditures> createState() => _ExpandituresState();
}

class _ExpandituresState extends State<Expanditures> {
  var barcodeC = TextEditingController();
  var nameItem = ''.obs;
  var itemList = <ObjTiToItem>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  Future<void> getData() async {
    itemList.clear();
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isError(false);
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/out-item/${barcodeC.text}',
      );
      print(response.data);
      nameItem.value = response.data['item']['name'];
      itemList.value = (response.data['data'] as List)
          .map((e) => ObjTiToItem.fromJson(e))
          .toList();
      isLoading(false);
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error data.'),
      //   ),
      // );
      isError(true);
      isLoading(false);
    }
  }

  Future<void> submit() async {
    isLoading(true);
    var _list = <ObjTiToItem>[];
    _list.addAll(itemList);
    _list.removeWhere(
        (element) => element.outStock == 0 && element.inStock == 0);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = _list
        .map((e) => {
              "id": e.id,
              "date": DateFormat('yyyy-MM-dd').format(e.date!),
              "in_stock": e.inStock,
              "out_stock": e.outStock,
            })
        .toList();

    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/out-item',
        data: data,
      );
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil submit.'),
        ),
      );
      isLoading(false);
      getData();
    } catch (error) {
      isLoading(false);
      var err = error as DioException;
      print(err.response);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.response?.data['errors'] ?? 'Error data.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Check/use stock'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: barcodeC,
                  onChanged: (value) {
                    getData();
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
                ).marginSymmetric(horizontal: 10, vertical: 10),
              ),
              IconButton(
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));

                  if (res is String) {
                    barcodeC.text = res;
                    getData();
                  }
                },
                icon: Icon(Icons.qr_code_2_outlined),
              )
            ],
          ),
          Expanded(
            child: Obx(
              () => isLoading.value
                  ? Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CupertinoActivityIndicator()))
                  : ListView(children: [
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        color: Colors.blueGrey.shade300,
                        child: Center(
                          child: Text(
                            nameItem.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blueGrey.shade200,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Get.width * 0.4,
                              child: Text(
                                'Exp',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.3,
                                  child: Text(
                                    'In Stock',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.3,
                                  child: Text(
                                    'Kurangi',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      if (isError.value && itemList.isEmpty)
                        Center(
                            child: Text('Data tidak ditemukan').marginAll(20)),
                      ...itemList
                          .map((sub) => Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.4,
                                    child: Text(
                                      '${DateFormat('yyyy-MM-dd').format(sub.date!)}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                          width: Get.width * 0.3,
                                          child: Text(
                                            '${sub.inStock}',
                                            textAlign: TextAlign.center,
                                          )),
                                      SizedBox(
                                          width: Get.width * 0.3,
                                          child: SizedBox(
                                            width: Get.width * 0.3,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                MaxValueFormatter(sub.inStock!)
                                              ],
                                              controller: TextEditingController(
                                                  text: '${sub.outStock}'),
                                              onChanged: (value) {
                                                int intVal = value == ''
                                                    ? 0
                                                    : int.parse(value);
                                                if (intVal > sub.inStock!)
                                                  return;
                                                sub.outStock = intVal;
                                                print(sub.outStock);
                                              },
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                constraints: BoxConstraints(
                                                    maxHeight: 30),
                                                hintText: '0',
                                                border: OutlineInputBorder(),
                                              ),
                                            ).marginSymmetric(horizontal: 10),
                                          )),
                                    ],
                                  ),
                                ],
                              ))
                          .toList()
                    ]),
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 15),
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBrown1,
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading.value
                    ? null
                    : () {
                        submit();
                      },
                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
