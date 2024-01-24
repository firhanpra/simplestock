// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:inventory/model/store_model.dart';

class ListStore extends StatefulWidget {
  const ListStore({super.key});

  @override
  State<ListStore> createState() => _ListStoreState();
}

class _ListStoreState extends State<ListStore> {
  var listStore = StoreModel().obs;
  var isLoading = false.obs;
  Future<void> getData() async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/store',
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
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('List Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(
          () => isLoading.value
              ? Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CupertinoActivityIndicator()))
              : ListView(
                  children: listStore.value.data!
                      .map((e) => ListTile(
                            onTap: () {
                              Get.back(result: [e.id, e.name]);
                            },
                            title: Text(e.name ?? ''),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ))
                      .toList(),
                ),
        ),
      ),
    );
  }
}
