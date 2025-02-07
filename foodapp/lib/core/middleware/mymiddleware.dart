import 'package:flutter/material.dart';
import 'package:foodapp/core/constant/routes.dart';
import 'package:foodapp/core/services/services.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPreferences.getString('step') == '2') {
      return RouteSettings(name: AppRoute.homepage);
    }
    if (myServices.sharedPreferences.getString('step') == '1') {
      return RouteSettings(name: AppRoute.login);
    }
    return null;
  }
}
