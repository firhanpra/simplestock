import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:inventory/view/ti_to.dart';
import 'package:inventory/view/ti_to_quantity.dart';

import '../constant.dart';
import '../model/store_model.dart';

class TiToStore extends StatefulWidget {
  const TiToStore({super.key});

  @override
  State<TiToStore> createState() => _TiToStoreState();
}

class _TiToStoreState extends State<TiToStore> {
  var isLoading = false.obs;
  var listStore = StoreModel().obs;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/transfer-io/stores?order=DESC',
      );
      listStore.value = StoreModel.fromJson(response.data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Select Store'),
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
              child: Obx(
            () => isLoading.value
                ? Center(
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CupertinoActivityIndicator()))
                : ListView(
                    children: listStore.value.data!
                        .map((data) => ListTile(
                              title: Text(
                                data.name ?? '',
                              ),
                              onTap: () {
                                Get.to(() => TiTo(), arguments: data.id);
                              },
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                              ),
                            ))
                        .toList(),
                  ),
          ))
        ],
      ),
    );
  }
}
