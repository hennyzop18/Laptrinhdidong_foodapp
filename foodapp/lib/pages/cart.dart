import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/api_connect/api_connect.dart';
import 'package:foodapp/pages/delivery_progess_page.dart';
import 'package:foodapp/pages/payment.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user/userPreferences/current_user.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStrings = prefs.getStringList('cartItems') ?? [];

    setState(() {
      cartItems = cartItemsStrings
          .where((item) =>
              jsonDecode(item)['user_id'] == _currentUser.user.user_id)
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  Widget ListItems() {
    return ListView.builder(
      itemCount: cartItems.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = cartItems[index];

        return Container(
          margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    API.hostConnectAdminProduct + '/' + item['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item['name']),
                subtitle: Text('Số lượng: ${item['quantity']}'),
                trailing: Text(
                  '${int.parse(item['total'])} đ',
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                onLongPress: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Xác nhận xóa'),
                        content:
                            Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Không'),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          TextButton(
                            child: Text('Có'),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm ?? false) {
                    await _deleteItem(item['id']);
                    _loadCartItems();
                  }
                }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: Text(
                'Giỏ hàng',
                style: AppWidget.boldTextFeildStyle(),
              ),
            ),
            ListItems(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Tổng tiền:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  ' ${_calculateTotal()} đ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage()));
              },
              child: Text(
                'Tiếp tục đặt hàng',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotal() {
    int total = 0;

    for (Map<String, dynamic> item in cartItems) {
      total += int.parse(item['total']);
    }

    return total;
  }

  Future<void> _deleteItem(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStrings = prefs.getStringList('cartItems') ?? [];

    cartItemsStrings.removeWhere((item) {
      Map<String, dynamic> cartItem = jsonDecode(item);
      if (cartItem["user_id"] == _currentUser.user.user_id) {
        return cartItem["id"] == itemId;
      }
      return false;
    });

    await prefs.setStringList('cartItems', cartItemsStrings);

    setState(() {
      cartItems = cartItemsStrings
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }
}
