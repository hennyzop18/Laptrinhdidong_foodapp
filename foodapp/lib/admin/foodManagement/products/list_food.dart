import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/admin/foodManagement/products/add_food.dart';
import 'package:foodapp/admin/foodManagement/products/edit_food.dart';
import 'package:foodapp/admin/home_admin.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:http/http.dart' as http;
import '../../../api_connect/api_connect.dart';

class ListFood extends StatefulWidget {
  const ListFood({super.key});

  @override
  State<ListFood> createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  List productsData = [];

  Map<String, String> categoryMap = {};

  Future<void> deleteProduct(String id) async {
    String uri = API.deleteProduct;
    bool? confirmDelete = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmDelete = true;
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        var res = await http.post(Uri.parse(uri), body: {'id': id});
        var response = jsonDecode(res.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: 'Đã xóa thành công');
          getProducts();
        } else {
          Fluttertoast.showToast(msg: 'Có lỗi');
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> getProducts() async {
    String uri = API.viewProduct;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        productsData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getCategories() async {
    String uri = API.viewCategories;
    try {
      var res = await http.get(Uri.parse(uri));
      var response = jsonDecode(res.body);

      setState(() {
        for (var item in response) {
          categoryMap[item['id_dm']] = item['name'];
        }
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  onload() {
    getProducts();
    getCategories();
  }

  @override
  void initState() {
    onload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeAdmin(),
                ),
              );
            }),
        centerTitle: true,
        title: Text("Danh sách sản phẩm"),
      ),
      body: ListView.builder(
          itemCount: productsData.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFood(
                      productsData[index]['id'],
                      productsData[index]['product_name'],
                      productsData[index]['price'],
                      productsData[index]['description'],
                      productsData[index]['img_path'],
                      productsData[index]['id_dm'],
                    ),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                  API.hostConnectAdminProduct +
                                      '/' +
                                      productsData[index]['img_path'],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 5, top: 7, right: 5, bottom: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productsData[index]['product_name'].length >
                                          15
                                      ? '${productsData[index]['product_name'].substring(0, 14)}...'
                                      : productsData[index]['product_name'],
                                  style: AppWidget.boldTextFeildStyle(),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      productsData[index]['price'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ' đ',
                                      style: AppWidget.semiBoldTextFeildStyle(),
                                    ),
                                  ],
                                ),
                                Text(
                                  productsData[index]['description'].length > 25
                                      ? '${productsData[index]['description'].substring(0, 23)}...'
                                      : productsData[index]['description'],
                                ),
                                Text(
                                  '${categoryMap[productsData[index]['id_dm']] ?? 'Không xác định'}',
                                  style: AppWidget.LightTextFeildStyle(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteProduct(productsData[index]['id']);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFood(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
