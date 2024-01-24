// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:inventory/constant.dart';
import 'package:inventory/view/add_user.dart';
import 'package:inventory/view/expanditures.dart';
import 'package:inventory/view/fullfill_order.dart';
import 'package:inventory/view/list_store.dart';
import 'package:inventory/view/list_user.dart';
import 'package:inventory/view/login.dart';
import 'package:inventory/view/order_history.dart';
import 'package:inventory/view/order_item.dart';
import 'package:inventory/view/stock_opname.dart';
import 'package:inventory/view/ti_to.dart';
import 'package:inventory/view/ti_to_store.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var page = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => page.value == 0
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  'https://www.mas-software.com/wp-content/uploads/2022/01/BLOG-77.jpg.webp',
                                ),
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: Get.width,
                                color: Colors.black.withOpacity(0.2),
                                child: SafeArea(
                                  child: Center(
                                    child: Text(
                                      'Kopi Kenangan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24,
                                          color: Colors.white),
                                    ).marginAll(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${GetStorage().read('name')}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   'Gandaria City 1',
                                      //   style: TextStyle(
                                      //       fontSize: 15, color: Colors.white),
                                      // ),
                                    ],
                                  )
                                ],
                              )
                                  .marginAll(15)
                                  .animate()
                                  .fade(duration: Duration(milliseconds: 500)),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Search',
                            filled: true,
                            fillColor: kBrown3,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBrown, width: 2),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBrown, width: 2),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ).marginSymmetric(horizontal: 30),
                      ],
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: GridView.count(
                        childAspectRatio: 3 / 4,
                        crossAxisCount: 3,
                        crossAxisSpacing: 30,
                        padding: EdgeInsets.all(15),
                        children: [
                          if (GetStorage().read('role') == 'user')
                            _buildMenuItem(
                              context,
                              'Stock Opname',
                              Icons.inventory,
                              () {
                                Get.to(() => StockOpname());
                              },
                            ),
                          _buildMenuItem(
                            context,
                            'Order History',
                            Icons.history,
                            () {
                              Get.to(() => OrderHistory());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'TI/TO',
                            Icons.swap_horizontal_circle_sharp,
                            () {
                              Get.to(() => TiToStore());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'Full Fill Order',
                            Icons.file_download_outlined,
                            () {
                              Get.to(() => FullFillOrder());
                            },
                          ),
                          if (GetStorage().read('role') == 'user')
                            _buildMenuItem(
                              context,
                              'Order Barang',
                              Icons.shopping_cart,
                              () {
                                Get.to(() => OrderItem());
                              },
                            ),
                          if (GetStorage().read('role') == 'user')
                            _buildMenuItem(
                              context,
                              'Check/use stock',
                              Icons.qr_code_scanner,
                              () {
                                Get.to(() => Expanditures());
                              },
                            ),
                          if (GetStorage().read('role') == 'admin')
                            _buildMenuItem(
                              context,
                              'Tambah User',
                              Icons.person_add,
                              () {
                                Get.to(() => AddUser());
                              },
                            ),
                          if (GetStorage().read('role') == 'admin')
                            _buildMenuItem(
                              context,
                              'List User',
                              Icons.person_search,
                              () {
                                Get.to(() => ListUser());
                              },
                            ),
                        ],
                      )
                          .animate()
                          .scaleXY(duration: Duration(milliseconds: 300)),
                    ),
                  ],
                ),
              )
            : page.value == 1
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text(
                            'FAQ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme.light(),
                                  dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text('Apa itu FIFO?'),
                                childrenPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                children: [
                                  Text(
                                      'FIFO (First In First Out) merupakan salah satu metode manajemen persediaan dengan cara memakai stok barang di gudang sesuai dengan waktu masuknya. Stok yang pertama kali masuk ke gudang adalah stok yang harus pertama kali keluar dari gudang.')
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 44,
                            ),
                            // Tidak ada foto di sini
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${GetStorage().read('name')}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('${GetStorage().read('email')}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_month),
                            title: Text('${GetStorage().read('birthdate')}'),
                          ),
                          ListTile(
                            onTap: () {
                              GetStorage().erase();
                              Get.off(() => Login());
                            },
                            textColor: Colors.red,
                            iconColor: Colors.red,
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                          ),
                          // Tambahkan informasi profil lainnya sesuai kebutuhan
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 10,
          backgroundColor: kBrown,
          selectedItemColor: kPurple1,
          unselectedItemColor: Colors.black45,
          currentIndex: page.value,
          onTap: (value) => page.value = value,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_mark),
              label: 'FAQ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40.0,
                      color: Colors.amber.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${title}\n',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
