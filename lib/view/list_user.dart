// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/model/userlist_model.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  var userList = UserListModel().obs;
  var isLoading = false.obs;
  Future<void> getData() async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    isLoading(true);
    try {
      var response = await dio.get(
        'https://stockskripsi.000webhostapp.com/api/user',
      );
      userList.value = UserListModel.fromJson(response.data);
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
        title: Text('List User'),
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
                  children: userList.value.data!
                      .map((e) => Theme(
                            data: ThemeData(
                                colorScheme: ColorScheme.light(),
                                dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(e.name ?? ''),
                              childrenPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                ListTile(
                                  visualDensity: VisualDensity.compact,
                                  minLeadingWidth: 0,
                                  leading: Icon(
                                    Icons.email,
                                    size: 15,
                                  ),
                                  title: Text(
                                    e.email ?? '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity.compact,
                                  minLeadingWidth: 0,
                                  leading: Icon(
                                    Icons.calendar_month,
                                    size: 15,
                                  ),
                                  title: Text(
                                    '${DateFormat('yyyy-MM-dd').format(e.birthdate!)}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity.compact,
                                  minLeadingWidth: 0,
                                  leading: Icon(
                                    Icons.store,
                                    size: 15,
                                  ),
                                  title: Text(
                                    e.store?.name ?? '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
        ),
      ),
    );
  }
}
