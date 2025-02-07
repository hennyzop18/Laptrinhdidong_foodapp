import 'package:flutter/material.dart';
import 'package:foodapp/controller/auth/test_controller.dart';
import 'package:get/get.dart';

import 'core/class/handlingdataview.dart';

class TextView extends StatelessWidget {
  const TextView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TestController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        backgroundColor: Colors.red,
      ),
      body: GetBuilder<TestController>(builder: (controller) {
        return HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  return Text('${controller.data}');
                }));
      }),
    );
  }
}
