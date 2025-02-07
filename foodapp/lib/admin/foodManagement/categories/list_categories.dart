import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/admin/foodManagement/categories/add_categories.dart';
import 'package:foodapp/admin/foodManagement/categories/edit_categories.dart';
import 'package:foodapp/admin/home_admin.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:http/http.dart' as http;
import '../../../api_connect/api_connect.dart';

class ListCategories extends StatefulWidget {
  const ListCategories({super.key});

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  List categoriesData = [];

  Future<void> deleteCategory(String id_dm) async {
    String uri = API.deleteCategories;
    bool? confirmDelete = false;

    try {
      confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận xóa'),
            content: Text('Bạn có chắc chắn muốn xóa danh mục này?'),
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
        var res = await http.post(Uri.parse(uri), body: {'id_dm': id_dm});
        var response = jsonDecode(res.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: 'Đã xóa thành công');
          getCategories();
        } else {
          Fluttertoast.showToast(msg: 'Có lỗi');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getCategories() async {
    String uri = API.viewCategories;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        categoriesData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  onload() {
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
        title: Text("Danh sách danh mục"),
      ),
      body: ListView.builder(
          itemCount: categoriesData.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCategory(
                        categoriesData[index]['id_dm'],
                        categoriesData[index]['name'],
                        categoriesData[index]['description'],
                        categoriesData[index]['img_path'],
                      ),
                    ),
                  );
                },
                title: Text(
                  categoriesData[index]['name'],
                  style: AppWidget.boldTextFeildStyle(),
                ),
                subtitle: Text(categoriesData[index]['description']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteCategory(categoriesData[index]['id_dm']);
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryState(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
