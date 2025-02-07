import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connect/api_connect.dart';
import '../user/userPreferences/current_user.dart';

class Details extends StatefulWidget {
  String id, image, name, price, description, id_dm;
  Details(
      this.id, this.image, this.name, this.price, this.description, this.id_dm);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  int a = 1, total = 0;

  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStrings = prefs.getStringList('cartItems') ?? [];

    bool itemExists = false;
    int indexToUpdate = -1;
    int existingQuantity = 0;

    for (int i = 0; i < cartItemsStrings.length; i++) {
      Map<String, dynamic> cartItem = jsonDecode(cartItemsStrings[i]);
      if (cartItem['user_id'] == _currentUser.user.user_id) {
        if (cartItem['id'] == widget.id) {
          itemExists = true;
          indexToUpdate = i;
          existingQuantity = int.parse(cartItem['quantity']);
          break;
        }
      }
    }

    if (itemExists) {
      existingQuantity += a;
      total = existingQuantity * int.parse(widget.price);
    } else {
      total = a * int.parse(widget.price);
    }

    Map<String, dynamic> product = {
      'id': widget.id,
      'image': widget.image,
      'user_id': _currentUser.user.user_id,
      'name': widget.name,
      'price': widget.price,
      'quantity': itemExists ? existingQuantity.toString() : a.toString(),
      'total': total.toString(),
    };

    String productString = jsonEncode(product);

    if (itemExists) {
      cartItemsStrings[indexToUpdate] = productString;
    } else {
      cartItemsStrings.add(productString);
    }

    await prefs.setStringList('cartItems', cartItemsStrings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng')),
    );
  }

  Future<void> clearCartByUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStrings = prefs.getStringList('cartItems') ?? [];

    cartItemsStrings.removeWhere((item) {
      Map<String, dynamic> cartItem = jsonDecode(item);
      return cartItem['user_id'] == _currentUser.user.user_id;
    });

    await prefs.setStringList('cartItems', cartItemsStrings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa tất cả sản phẩm của bạn khỏi giỏ hàng')),
    );
  }

  Future<void> clearCart() async {
    await clearCartByUser();
  }

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              API.hostConnectAdminProduct + '/' + widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.3,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                // GestureDetector(
                //   onTap: () async {
                //     await clearCart();
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width / 7,
                //     padding: EdgeInsets.all(7),
                //     decoration: BoxDecoration(
                //         color: Colors.black,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Center(
                //       child: Container(
                //         padding: EdgeInsets.all(3),
                //         decoration: BoxDecoration(
                //           color: Colors.grey,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Icon(
                //           Icons.delete_forever_outlined,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                      total = total - int.parse(widget.price);
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  a.toString(),
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    ++a;
                    total = total + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              widget.description,
              maxLines: 4,
              style: AppWidget.LightTextFeildStyle(),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text(
                  "Thời gian giao hàng",
                  style: AppWidget.LightTextFeildStyle(),
                ),
                SizedBox(
                  width: 25.0,
                ),
                Icon(
                  Icons.alarm,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "15 phút",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thành tiền",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      Text(
                        total.toString(),
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await addToCart();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Thêm vào giỏ hàng",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
