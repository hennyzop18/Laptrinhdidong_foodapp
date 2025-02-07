import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../api_connect/api_connect.dart';
import '../../widget/widget_support.dart';
import '../home_admin.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List userData = [];

  Future<void> deleteUser(String id) async {
    String uri = API.deleteUser;
    bool? confirmDelete = false;

    try {
      confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận xóa'),
            content: Text('Bạn có chắc chắn muốn xóa người dùng này?'),
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

      if (confirmDelete == true) {
        var res = await http.post(Uri.parse(uri), body: {'id': id});
        var response = jsonDecode(res.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: 'Đã xóa thành công');
          getUser();
        } else {
          Fluttertoast.showToast(msg: 'Có lỗi');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getUser() async {
    String uri = API.viewUser;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        userData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  onload() {
    getUser();
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
        title: Text('Danh sách người dùng'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: userData.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          String truncatedName = userData[index]['name'],
              truncateEmail = userData[index]['email'],
              truncateAddress = userData[index]['address'];
          if (truncatedName.length > 15) {
            truncatedName = truncatedName.substring(0, 12) + "...";
          }
          if (truncateEmail.length > 20) {
            truncateEmail = truncateEmail.substring(0, 19) + "...";
          }
          if (truncateAddress.length > 20) {
            truncateAddress = truncateAddress.substring(0, 19) + "...";
          }
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                'Họ và tên: ' + truncatedName,
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                'Email: ' + truncateEmail,
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                'Địa chỉ: ' + truncateAddress,
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteUser(userData[index]['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
