// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/model/ti_to_item_model.dart';
import 'package:inventory/utils.dart';
import 'package:inventory/view/ti_to_store.dart';

import '../constant.dart';

class TiTo extends StatefulWidget {
  const TiTo({super.key});

  @override
  State<TiTo> createState() => _TiToState();
}

class _TiToState extends State<TiTo> {
  var titoModel = TiToItemModel().obs;
  var isLoading = false.obs;

  Future<void> getData(int id) async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/transfer-io/items/$id',
      );
      print(response.data);
      titoModel.value = TiToItemModel.fromJson(response.data);
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

  Future<void> submit(int id, DateTime date) async {
    isLoading(true);
    var _list = <ObjTiToItem>[];
    titoModel.value.data?.forEach((element) {
      _list.addAll(element.data!);
    });
    // _list.removeWhere((element) => element.outStock == 0);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = {
      "store_id": id,
      "date_order": DateFormat('yyyy-MM-dd').format(date),
      "items": _list
          .map((e) => {
                "id": e.id,
                "item_id": e.itemId,
                "date": DateFormat('yyyy-MM-dd').format(e.date!),
                "in_stock": e.inStock,
                "out_stock": e.outStock,
              })
          .toList(),
    };

    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/transfer-io',
        data: data,
      );
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil submit.'),
        ),
      );
      isLoading(false);
      getData(Get.arguments);
    } catch (error) {
      isLoading(false);

      var err = error as DioException;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.response?.data['errors'] ?? 'Error data.'),
        ),
      );
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      helpText: 'Pilih tanggal order',
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
    getData(Get.arguments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('TI/TO'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          ).marginSymmetric(horizontal: 10, vertical: 10),
          Expanded(
              child: Obx(() => isLoading.value
                  ? Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CupertinoActivityIndicator()))
                  : ListView(
                      children: [
                        ...titoModel.value.data!
                            .map(
                              (e) => expansionTile(e),
                            )
                            .toList()
                      ],
                    ))),
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
                        _selectDate(context).then((value) {
                          if (value == null) return;
                          submit(Get.arguments, value);
                        });
                      },
                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Theme expansionTile(TiToItemModelDatum e) {
    return Theme(
      data: ThemeData(
          colorScheme: ColorScheme.light(), dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(e.name ?? ''),
        children: [
          Container(
            color: Colors.blueGrey.shade200,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.4,
                  child: Text(
                    'Exp',
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: Get.width * 0.3,
                      child: Text(
                        'In Stock',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
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
          ...e.data!
              .map((sub) => Row(
                    children: [
                      Container(
                        width: Get.width * 0.4,
                        child: Text(
                          '${DateFormat('yyyy-MM-dd').format(sub.date!)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: Get.width * 0.3,
                              child: Text(
                                '${sub.inStock}',
                                textAlign: TextAlign.center,
                              )),
                          Container(
                              width: Get.width * 0.3,
                              child: Container(
                                width: Get.width * 0.3,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaxValueFormatter(sub.inStock!)
                                  ],
                                  controller: TextEditingController(
                                      text: '${sub.outStock}'),
                                  onChanged: (value) {
                                    int intVal =
                                        value == '' ? 0 : int.parse(value);
                                    if (intVal > sub.inStock!) return;
                                    sub.outStock = intVal;
                                    print(sub.outStock);
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    constraints: BoxConstraints(maxHeight: 30),
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
        ],
      ),
    );
  }
}
