import 'package:flutter/material.dart';
import 'package:foodapp/controller/auth/signup_controller.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';

import '../../../core/class/handlingdataview.dart';
import '../../../core/constant/imgassets.dart';
import '../../../core/functions/validinput.dart';
import '../../widget/auth/custombuttonauth.dart';
import '../../widget/auth/customtextformauth.dart';
import '../../widget/auth/textsignup.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    Get.put(SignUpControllerImp());
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFFff5c30),
                    Color(0xFFe74b1a),
                  ])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Text(""),
            ),
            GetBuilder<SignUpControllerImp>(
              builder: (controller) => HandlingDataRequest(
                statusRequest: controller.statusRequest,
                widget: Container(
                  margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: controller.formstate,
                    child: Column(
                      children: [
                        Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            AppImageAsset.logo,
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.height / 10,
                            fit: BoxFit.cover,
                          ),
                        )),
                        SizedBox(
                          height: 20.0,
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: ListView(
                              children: [
                                Text(
                                  "Đăng ký",
                                  textAlign: TextAlign.center,
                                  style: AppWidget.HeadlineTextFeildStyle(),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                CustomTextFormAuth(
                                  isNumber: false,
                                  valid: (val) {
                                    return validInput(val!, 5, 100, 'username');
                                  },
                                  mycontroller: controller.username,
                                  hintText: 'Nhập tên tài khoản',
                                  labeltext: 'Tên tài khoản',
                                  iconData: Icons.person_outline,
                                ),
                                CustomTextFormAuth(
                                  isNumber: false,
                                  valid: (val) {
                                    return validInput(val!, 10, 40, 'email');
                                  },
                                  mycontroller: controller.email,
                                  hintText: 'Nhập địa chỉ Email',
                                  labeltext: 'Email',
                                  iconData: Icons.email_outlined,
                                ),
                                CustomTextFormAuth(
                                  isNumber: true,
                                  valid: (val) {
                                    return validInput(val!, 8, 11, 'phone');
                                  },
                                  mycontroller: controller.phone,
                                  hintText: 'Nhập số điện thoại',
                                  labeltext: 'Số điện thoại',
                                  iconData: Icons.phone_android_outlined,
                                ),
                                CustomTextFormAuth(
                                  isNumber: false,
                                  valid: (val) {
                                    return validInput(val!, 8, 30, 'password');
                                  },
                                  mycontroller: controller.password,
                                  hintText: 'Nhập mật khẩu',
                                  labeltext: 'Mật khẩu',
                                  iconData: Icons.lock_outline,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                CustomButtonAuth(
                                  text: 'ĐĂNG KÝ',
                                  onPressed: () {
                                    controller.signUp();
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        CustomTextSignUpOrSignIn(
                          textone: 'Bạn đã có tài khoản ? ',
                          texttwo: 'Đăng nhập',
                          onTap: () {
                            controller.goToSignIn();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
