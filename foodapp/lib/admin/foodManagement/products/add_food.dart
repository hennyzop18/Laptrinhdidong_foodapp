import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/admin/foodManagement/products/list_food.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../api_connect/api_connect.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String? selectedName;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  List<dynamic> data = [];
  File? img_path;
  String? img_data;
  String? img_name;
  ImagePicker imagePicker = new ImagePicker();
  Future<void> addfood() async {
    if (name.text != "" && description.text != "" && price.text != "") {
      try {
        String uri = API.addProduct;
        var res = await http.post(Uri.parse(uri), body: {
          "product_name": name.text,
          "description": description.text,
          "price": price.text,
          "id_dm": selectedName,
          "img_data": img_data,
          "img_name": img_name,
        });
        var response = jsonDecode(res.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: 'Thêm sản phẩm thành công.');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListFood()));
        } else {
          Fluttertoast.showToast(msg: response['error']);
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

  Future getAllName() async {
    String uri = API.viewCategories;
    var response =
        await http.get(Uri.parse(uri), headers: {'Accept': 'application/json'});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
    });
    print(jsonData);
    return 'success';
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
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Thêm sản phẩm'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tên sản phẩm",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên sản phẩm',
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
                Text(
                  "Mô tả",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      hintText: 'Mô tả chi tiết...',
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
                Text(
                  "Giá",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: price,
                    decoration: InputDecoration(
                      hintText: 'Nhập giá',
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
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
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
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
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
                  height: 20,
                ),
                Text(
                  'Chọn danh mục',
                  textAlign: TextAlign.center,
                  style: AppWidget.boldTextFeildStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: DropdownButton<String>(
                    value: selectedName,
                    hint: Text('Chọn vào đây'),
                    items: data.map<DropdownMenuItem<String>>((dynamic list) {
                      return DropdownMenuItem<String>(
                        value: list['id_dm'].toString(),
                        child: Text(list['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedName = value;
                        print(value);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    addfood();
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
                            "Thêm sản phẩm",
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
        ));
  }
}
