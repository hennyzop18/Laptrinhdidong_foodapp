import 'package:flutter/material.dart';
import 'package:foodapp/core/constant/imgassets.dart';
import 'package:foodapp/core/functions/validinput.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';

import '../../../controller/auth/login_controller.dart';
import '../../../core/class/handlingdataview.dart';
import '../../widget/auth/custombuttonauth.dart';
import '../../widget/auth/customtextformauth.dart';
import '../../widget/auth/textsignup.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
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
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Text(""),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      AppImageAsset.logo,
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    ),
                  )),
                  SizedBox(
                    height: 50.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: GetBuilder<LoginControllerImp>(
                      builder: (controller) => HandlingDataRequest(
                        statusRequest: controller.statusRequest,
                        widget: Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: controller.formstate,
                            child: ListView(
                              children: [
                                Text(
                                  "Đăng nhập",
                                  textAlign: TextAlign.center,
                                  style: AppWidget.HeadlineTextFeildStyle(),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                CustomTextFormAuth(
                                  isNumber: false,
                                  valid: (val) {
                                    return validInput(val!, 5, 100, 'email');
                                  },
                                  mycontroller: controller.email,
                                  hintText: 'Nhập email',
                                  labeltext: 'Email',
                                  iconData: Icons.email_outlined,
                                ),
                                CustomTextFormAuth(
                                  isNumber: false,
                                  obscureText: controller.isShowPassword,
                                  onTapIcon: () {
                                    controller.showPassword();
                                  },
                                  valid: (val) {
                                    return validInput(val!, 8, 30, 'password');
                                  },
                                  mycontroller: controller.password,
                                  hintText: 'Nhập mật khẩu',
                                  labeltext: 'Mật khẩu',
                                  iconData: Icons.lock_outline,
                                ),
                                // InkWell(
                                //   child: Text(
                                //     "Quên mật khẩu?",
                                //     textAlign: TextAlign.end,
                                //     style: AppWidget.semiBoldTextFeildStyle(),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                CustomButtonAuth(
                                  text: 'ĐĂNG NHẬP',
                                  onPressed: () {
                                    controller.login();
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                CustomTextSignUpOrSignIn(
                                  textone: 'Không có tài khoản ? ',
                                  texttwo: 'Đăng ký',
                                  onTap: () {
                                    controller.goToSignUp();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
