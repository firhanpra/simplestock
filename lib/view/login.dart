// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:inventory/constant.dart';
import 'package:inventory/view/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    isLoading(true);
    Map<String, dynamic> data = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };
    try {
      var response = await Dio().post(
        'https://stockskripsi.000webhostapp.com/api/auth/login',
        data: data,
      );
      isLoading(false);
      GetStorage().write('token', response.data['access_token']);
      GetStorage().write('role', response.data['data']['role']);
      GetStorage().write('name', response.data['data']['name']);
      GetStorage().write('birthdate', response.data['data']['birthdate']);
      GetStorage().write('email', response.data['data']['email']);
      Get.off(() => Home());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username atau password salah.'),
        ),
      );
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPurple2, kPurple],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://images.squarespace-cdn.com/content/v1/5fa1095912d2fc6dfc63ac9c/dd9b911d-7295-43fc-9452-17a585607187/logo.png',
                width: Get.width * 0.7,
              ),
              SizedBox(height: 50),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Masuk untuk melanjutkan',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 1100)),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
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
                      ).animate().fadeIn(delay: Duration(milliseconds: 1400)),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: kBrown1),
                                onPressed: isLoading.value
                                    ? null
                                    : () async {
                                        await login();
                                      },
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: Duration(milliseconds: 1700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().scaleXY(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 400)),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
