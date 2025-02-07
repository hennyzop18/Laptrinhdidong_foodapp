import 'package:flutter/material.dart';
import 'package:foodapp/controller/onboarding_controller.dart';
import 'package:get/get.dart';

import '../../../data/datasource/static/static.dart';
import '../../../widget/widget_support.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.onPageChanged(value);
        },
        itemCount: onBoardingList.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Image.asset(
                  onBoardingList[i].image!,
                  height: 420,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  onBoardingList[i].title!,
                  style: AppWidget.HeadlineTextFeildStyle(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    onBoardingList[i].body!,
                    style: AppWidget.LightTextFeildStyle(),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          );
        });
  }
}
