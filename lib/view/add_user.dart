// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:inventory/view/list_store.dart';

import '../constant.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var isLoading = false.obs;
  var nameC = TextEditingController();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var confirmPassC = TextEditingController();
  var birthC = TextEditingController(text: 'Pilih tanggal lahir');
  var nameStoreC = TextEditingController(text: 'Pilih store');
  var birthDate = DateTime(1990).obs;
  int? idStore;

  Future<void> submit() async {
    isLoading(true);
    Dio dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer ${GetStorage().read('token')}';
    var data = {
      'name': nameC.text,
      'email': emailC.text,
      'password': passwordC.text,
      'password_confirmation': confirmPassC.text,
      'birthdate': DateFormat('yyyy-MM-dd').format(birthDate.value),
      'store_id': idStore,
    };
    print(data);
    try {
      var response = await dio.post(
        'https://stockskripsi.000webhostapp.com/api/user',
        data: data,
      );
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil tambah user.'),
        ),
      );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != birthDate.value) {
      birthDate.value = picked;
      birthC.text = DateFormat('yyyy-MM-dd').format(birthDate.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Tambah User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            TextField(
              controller: emailC,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            TextField(
              controller: confirmPassC,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            TextField(
              controller: birthC,
              onTap: () => _selectDate(context),
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Birthdate',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            TextField(
              controller: nameStoreC,
              onTap: () {
                Get.to(() => ListStore())?.then((value) {
                  if (value == null) return;
                  idStore = value[0];
                  nameStoreC.text = value[1];
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                labelText: 'Store',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ).marginOnly(bottom: 15),
            Obx(
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
          ],
        ),
      ),
    );
  }
}
