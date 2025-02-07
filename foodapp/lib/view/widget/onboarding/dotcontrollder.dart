import 'package:flutter/material.dart';
import 'package:foodapp/controller/onboarding_controller.dart';
import 'package:get/get.dart';

import '../../../data/datasource/static/static.dart';

class CustomDotControllerOnBoarding extends StatelessWidget {
  const CustomDotControllerOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImp>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onBoardingList.length,
            (index) => AnimatedContainer(
              margin: EdgeInsets.only(right: 5),
              duration: Duration(milliseconds: 500),
              width: controller.currentPage == index ? 20 : 8,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black38),
            ),
          )
        ],
      ),
    );
  }
}
