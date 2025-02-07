import 'package:flutter/material.dart';
import 'package:foodapp/controller/onboarding_controller.dart';
import 'package:get/get.dart';

class CustomButtonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomButtonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 30),
      child: MaterialButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
          onPressed: () {
            controller.next();
          },
          child: Text(
            'Tiếp',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )),
    );
  }
}
