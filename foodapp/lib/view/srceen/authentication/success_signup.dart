import 'package:flutter/material.dart';
import 'package:foodapp/controller/auth/successsignup_controller.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';

import '../../widget/auth/custombuttonauth.dart';

class SuccessSignUp extends StatelessWidget {
  const SuccessSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SuccessSignUpControllerImp controller =
        Get.put(SuccessSignUpControllerImp());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Thành công',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 151, 151, 151)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 200,
                color: Colors.red,
              ),
            ),
            Text(
              'Chức mừng bạn!',
              style: AppWidget.boldTextFeildStyle(),
            ),
            Text('Bạn đã đăng ký thành công'),
            Spacer(),
            Container(
              width: double.infinity,
              child: CustomButtonAuth(
                text: 'ĐI ĐẾN ĐĂNG NHẬP',
                onPressed: () {
                  controller.goToPageLogin();
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
