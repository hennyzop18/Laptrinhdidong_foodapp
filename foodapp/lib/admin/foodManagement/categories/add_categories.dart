import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/admin/foodManagement/categories/list_categories.dart';
import 'package:foodapp/widget/widget_support.dart';
import "package:http/http.dart" as http;
import 'package:foodapp/api_connect/api_connect.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryState extends StatefulWidget {
  const AddCategoryState({super.key});

  @override
  State<AddCategoryState> createState() => _AddCategoryStateState();
}

class _AddCategoryStateState extends State<AddCategoryState> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  File? img_path;
  String? img_data;
  String? img_name;
  ImagePicker imagePicker = new ImagePicker();
  addCatregoryAndSave() async {
    if (name.text != "" && description.text != "") {
      try {
        var res = await http.post(
          Uri.parse(API.addCategories),
          body: {
            'name': name.text,
            'description': description.text,
            "img_data": img_data,
            "img_name": img_name,
          },
        );
        print('Server response: ${res.body}');
        if (res.statusCode == 200) {
          var resBodyOfCategory = jsonDecode(res.body);
          if (resBodyOfCategory['success'] == true) {
            Fluttertoast.showToast(msg: 'Thêm danh mục thành công.');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListCategories()));
          } else {
            Fluttertoast.showToast(msg: resBodyOfCategory['error']);
          }
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đủ các hộp')),
      );
    }
  }

  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      img_path = File(getimage!.path);
      img_name = getimage.path.split('/').last;
      img_data = base64Encode(img_path!.readAsBytesSync());
      print(img_path);
      print(img_data);
      print(img_name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thêm danh mục sản phẩm'),
      ),
      body: Container(
        margin:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tên danh mục",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: name,
                  validator: (name) =>
                      name!.length < 3 ? 'Nhập danh mục đầy đủ' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Nhập danh mục',
                    hintStyle: AppWidget.semiBoldTextFeildStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Mô tả",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: description,
                  validator: (description) =>
                      description!.length < 3 ? 'Nhập mô tả đầy đủ' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Nhập mô tả chi tiết...',
                    hintStyle: AppWidget.semiBoldTextFeildStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(child: Text('Tải ảnh lên')),
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  child: img_path != null
                      ? Center(
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  img_path!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  _formkey.currentState!.validate();
                  addCatregoryAndSave();
                },
                child: Center(
                  child: Material(
                    elevation: 6.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Thêm danh mục",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
