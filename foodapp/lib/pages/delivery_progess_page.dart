import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user/userPreferences/current_user.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  int total = 0;
  int quantity = 0;
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  List<Map<String, dynamic>> cartItems = [];

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
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
      print(cartItems);
    });
  }

  Widget displayCartReceipt() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: cartItems.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var cartItem = cartItems[index];
          int itemTotal =
              int.parse(cartItem['quantity']) * int.parse(cartItem['price']);
          total += itemTotal;
          quantity += int.parse(cartItem['quantity']);
          return Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("- " +
                        cartItem['quantity'] +
                        " x " +
                        cartItem['name'] +
                        " - " +
                        cartItem['total'] +
                        " đ"),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Xác nhận đặt hàng"),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cảm ơn bạn đã đặt hàng!",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text("Đây là biên lai của bạn!"),
                          SizedBox(
                            height: 25,
                          ),
                          Text(formattedDate),
                          SizedBox(height: 10),
                          Text("Họ và tên: " + _currentUser.user.name),
                          SizedBox(height: 10),
                          Text("--------------------"),
                          displayCartReceipt(),
                          Text("--------------------"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tổng món: " + quantity.toString()),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Tổng tiền:" + total.toString(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Phí ship: 15.000 đ"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Tổng thanh toán: \$" +
                                    (int.parse(total.toString()) + 15000)
                                        .toString(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Địa chỉ giao hàng: " +
                                  _currentUser.user.user_address),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Thời gian nhận hàng dự kiến: 4:10PM!"),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Xác nhận đặt hàng",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                          Icon(Icons.check),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ),
                );
              },
              icon: Icon(Icons.home),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.person),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mr. Duy",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              Text(
                "Tài xế",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.message),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
