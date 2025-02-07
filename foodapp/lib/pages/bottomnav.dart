import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/view/srceen/home.dart';
import 'package:foodapp/pages/cart.dart';
import 'package:foodapp/pages/profile.dart';
import 'package:foodapp/pages/order.dart';
import 'package:foodapp/user/userPreferences/current_user.dart';
import 'package:get/get.dart';

import '../user/userPreferences/user_preferences.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomePage homepage;
  late Profile profile;
  late Cart cart;
  late Order order;

  ontheload() {
    homepage = HomePage();
    cart = Cart();
    profile = Profile();
    order = Order();
    pages = [homepage, cart, order, profile];
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
                height: 65,
                backgroundColor: Colors.white,
                color: Colors.black,
                animationDuration: Duration(milliseconds: 500),
                onTap: (int index) {
                  setState(() {
                    currentTabIndex = index;
                  });
                },
                items: [
                  Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                  ),
                ]),
            body: pages[currentTabIndex],
          );
        });
  }
}
