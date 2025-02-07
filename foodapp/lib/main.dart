import 'package:flutter/material.dart';
import 'package:foodapp/core/services/services.dart';
import 'package:foodapp/routes.dart';
import 'package:get/get.dart';

import 'bindings/intialbindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      //routes: routes,
      getPages: routes,
      initialBinding: InitialBindings(),
    );
  }
}
