import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(title: 'Thoát', middleText: '...', actions: [
    ElevatedButton(
        onPressed: () {
          exit(0);
        },
        child: Text('Xác nhận')),
    ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text('Hủy bỏ')),
  ]);
  return Future.value(true);
}
