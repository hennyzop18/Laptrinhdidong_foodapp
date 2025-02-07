import 'package:flutter/material.dart';
import 'package:foodapp/core/constant/routes.dart';
import 'package:foodapp/data/datasource/remote/auth/signup.dart';
import 'package:get/get.dart';

import '../../core/class/statusrequest.dart';
import '../../core/functions/handingdatacontroller.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController email;
  late TextEditingController phone;

  StatusRequest statusRequest = StatusRequest.none;

  SignupData signupData = SignupData(Get.find());

  List data = [];
  @override
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      var response = await signupData.postdata(
          username.text, password.text, email.text, phone.text);
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == 'success') {
          //data.addAll(response['data']);
          Get.offNamed(AppRoute.successSignUp);
        } else {
          Get.defaultDialog(
              title: 'Cảnh báo',
              middleText: 'Email hoặc số điện thoại đã tồn tại!');
          statusRequest = StatusRequest.failure;
        }
      }
      update();
    } else {
      print('Not Valid');
    }
  }

  @override
  goToSignIn() {
    Get.offAllNamed(AppRoute.login);
  }

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }
}
