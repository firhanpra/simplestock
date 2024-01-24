// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class TiToQuantity extends StatefulWidget {
  const TiToQuantity({super.key});

  @override
  State<TiToQuantity> createState() => _TiToQuantityState();
}

class _TiToQuantityState extends State<TiToQuantity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Quantity'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Text('Matcha Powder'),
              Divider(color: Colors.grey.withOpacity(0.4)),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.5,
                    child: Text(
                      'Exp',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        child: Text(
                          'In Stock',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: Get.width * 0.25,
                        child: Text(
                          'Kurangi',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.5,
                    child: Text(
                      '2024/01/01',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        child: TextField(
                          textAlign: TextAlign.center,
                        ).marginSymmetric(horizontal: 10),
                      ),
                      Container(
                        width: Get.width * 0.25,
                        child: TextField(
                          textAlign: TextAlign.center,
                        ).marginSymmetric(horizontal: 10),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
