import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/controller/home_controller.dart';
import 'package:foodapp/core/class/handlingdataview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodapp/linkapi.dart';
import 'package:foodapp/pages/details.dart';
import 'package:foodapp/user/userPreferences/current_user.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_connect/api_connect.dart';
import '../../user/userPreferences/user_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  final textController = TextEditingController();
  String searchQuery = "";
  String? userAddress;
  List categories = [];
  List products_category = [];
  List product = [];
  int selectedCategoryIndex = 0;

  Future<void> getCategories() async {
    String uri = API.viewCategories;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        categories = jsonDecode(res.body);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    userAddress = _currentUser.user.user_address;
  }

  Future<void> getproducts_category(String categoryId) async {
    String uri = API.viewProductWithCategory + '?id_dm=' + categoryId;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        products_category.clear();
        products_category.addAll(jsonDecode(res.body));
        print(products_category);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getProducts() async {
    String uri = API.viewProduct;
    try {
      var res = await http.get(Uri.parse(uri));

      setState(() {
        product = jsonDecode(res.body);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget userName() {
    if (_currentUser.user.name != null) {
      String truncatedName = _currentUser.user.name;
      ;
      if (truncatedName.length > 12) {
        truncatedName = truncatedName.substring(0, 10) + "...";
      }

      return Text(
        'Hello\n' + truncatedName + ',',
        style: AppWidget.boldTextFeildStyle(),
      );
    } else {
      return Text(
        'Hello user',
        style: AppWidget.boldTextFeildStyle(),
      );
    }
  }

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 225, 218, 218),
        title: Text("Địa chỉ:"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "Nhập địa chỉ của bạn.."),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text("Hủy"),
          ),
          MaterialButton(
            onPressed: () async {
              String newAddress = textController.text;
              String username = _currentUser.user.user_name;
              // Update the address in the database
              await updateUserAddress(username, newAddress);
              // Update the address in the shared preferences
              await RememberUserPrefs.saveUserAddress(newAddress);
              // Update the address in the UI
              setState(() {
                userAddress = newAddress;
              });
              // Close the dialog
              Navigator.pop(context);
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  Future<void> updateUserAddress(String username, String newAddress) async {
    final uri = API.updateUser;
    final response = await http.post(
      Uri.parse(uri),
      body: {
        'username': username,
        'address': newAddress,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print('Address updated successfully');
      } else {
        print('Failed to update address: ${data['error']}');
      }
    } else {
      print('Failed to update address: ${response.statusCode}');
    }
  }

  ontheload() async {
    getCategories();
    getProducts();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget showItem() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        String truncatedName = category['name'];

        if (truncatedName.length > 8) {
          truncatedName = truncatedName.substring(0, 5) + "...";
        }
        return GestureDetector(
          onTap: () {
            selectedCategoryIndex = index;
            getproducts_category(category['id_dm']);
          },
          child: Container(
            width: 100,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: index == selectedCategoryIndex
                  ? Border.all(color: Colors.black, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              elevation: 5.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      API.hostConnectAdminCategory + '/' + category['img_path'],
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      truncatedName,
                      style: AppWidget.semiBoldTextFeildStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget allItemsVertically() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: product.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            product[index]['id'],
                            product[index]['img_path'],
                            product[index]['product_name'],
                            product[index]['price'],
                            product[index]['description'],
                            product[index]['id_dm'],
                          )));
            },
            child: Container(
              margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          API.hostConnectAdminProduct +
                              '/' +
                              product[index]['img_path'],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              product[index]['product_name'],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              product[index]['description'],
                              style: AppWidget.LightTextFeildStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              product[index]['price'] + ' đ',
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget items_category() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: products_category.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var product = products_category[index];
          String truncatedName = product['product_name'];
          String truncateDescription = product['description'];

          if (truncatedName.length > 15) {
            truncatedName = truncatedName.substring(0, 12) + "...";
          }
          if (truncateDescription.length > 17) {
            truncateDescription = truncateDescription.substring(0, 17) + "...";
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            product['id'],
                            product['img_path'],
                            product['product_name'],
                            product['price'],
                            product['description'],
                            product['id_dm'],
                          )));
            },
            child: Container(
              margin: EdgeInsets.all(4),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          API.hostConnectAdminProduct +
                              '/' +
                              product['img_path'],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        truncatedName,
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        truncateDescription,
                        style: AppWidget.LightTextFeildStyle(),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        product['price'] + ' đ',
                        style: AppWidget.semiBoldTextFeildStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeControllerImp());
    return Scaffold(
        body: GetBuilder<HomeControllerImp>(
            builder: (controller) => HandlingDataView(
                  statusRequest: controller.statusRequest,
                  widget: SingleChildScrollView(
                    child: Container(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Tìm kiếm món",
                                    hintStyle: TextStyle(fontSize: 18),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 60,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.notifications_active_outlined,
                                        size: 30,
                                        color: Colors.grey[600],
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "Một mùa hè sản khoái",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Hoàn tiền 20%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: -20,
                                    right: -20,
                                    child: Container(
                                      height: 160,
                                      width: 160,
                                      decoration: BoxDecoration(
                                          color: Color(0xffc0392b),
                                          borderRadius:
                                              BorderRadius.circular(160)),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Giao hàng nhanh",
                                      style:
                                          AppWidget.semiBoldTextFeildStyle()),
                                  Text("Thức ăn tuyệt vời",
                                      style: AppWidget.LightTextFeildStyle()),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Giao hàng ngay",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          openLocationSearchBox(context),
                                      child: Row(
                                        children: [
                                          Text(
                                            userAddress != null &&
                                                    userAddress!.isNotEmpty
                                                ? userAddress!
                                                : "Nhập địa chỉ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 10),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.categories.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 170, 170),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 70,
                                        width: 70,
                                        child: SvgPicture.network(
                                          "${AppLink.imageCategories}/${controller.categories[index]['category_image']}",
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      Text(
                                        '${controller.categories[index]['category_name']}',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Các món cho bạn',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  itemCount: 3,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    return Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Image.asset(
                                            'assets/images/pizza2.png',
                                            height: 100,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Colors.black.withOpacity(0.4),
                                          ),
                                          width: 120,
                                          height: 180,
                                        ),
                                        Positioned(
                                          left: 10,
                                          bottom: 0,
                                          child: Text(
                                            'Pizza double cheese',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })),
                          SizedBox(
                            height: 20.0,
                          ),
                          allItemsVertically(),
                        ],
                      ),
                    ),
                  ),
                )));
  }
}
