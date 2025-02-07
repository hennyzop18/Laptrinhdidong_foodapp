import 'package:flutter/material.dart';
import 'package:foodapp/core/constant/routes.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../core/class/statusrequest.dart';
import '../../core/functions/handingdatacontroller.dart';
import '../../core/services/services.dart';
import '../../data/datasource/remote/auth/login.dart';

abstract class LoginController extends GetxController {
  login();
  goToSignUp();
}

class LoginControllerImp extends LoginController {
  LoginData loginData = LoginData(Get.find());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  bool isShowPassword = true;

  MyServices myservices = Get.find();

  StatusRequest statusRequest = StatusRequest.none;

  showPassword() {
    isShowPassword = isShowPassword == true ? false : true;
    update();
  }

  @override
  login() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      var response = await loginData.postdata(email.text, password.text);
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == 'success') {
          myservices.sharedPreferences
              .setString('id', response['data']['user_id']);
          myservices.sharedPreferences
              .setString('username', response['data']['user_name']);
          myservices.sharedPreferences
              .setString('email', response['data']['user_email']);
          myservices.sharedPreferences
              .setString('phone', response['data']['user_phone']);
          myservices.sharedPreferences.setString('step', '2');
          Get.offNamed(AppRoute.bottomNav);
        } else {
          Get.defaultDialog(
              title: 'Cảnh báo', middleText: 'Email hoặc mật khẩu sai!');
          statusRequest = StatusRequest.failure;
        }
      }
      update();
    } else {
      print('Not Valid');
    }
  }

  @override
  goToSignUp() {
    Get.offNamed(AppRoute.signUp);
  }

  @override
  void onInit() {
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      String? token = value;
    });

    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
