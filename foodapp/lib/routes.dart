import 'package:foodapp/core/middleware/mymiddleware.dart';
import 'package:foodapp/pages/bottomnav.dart';
import 'package:foodapp/view/srceen/authentication/success_signup.dart';
import 'package:foodapp/view/srceen/home.dart';
import 'package:foodapp/view/srceen/onboarding.dart';
import 'package:get/get.dart';

import 'core/constant/routes.dart';
import 'view/srceen/authentication/login.dart';
import 'view/srceen/authentication/signup.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: '/', page: () => OnBoarding(), middlewares: [MyMiddleWare()]),

  //GetPage(name: '/', page: () => TextView()),
  GetPage(name: AppRoute.login, page: () => LogIn()),
  GetPage(name: AppRoute.signUp, page: () => SignUp()),
  GetPage(name: AppRoute.successSignUp, page: () => SuccessSignUp()),
  //home
  GetPage(name: AppRoute.homepage, page: () => HomePage()),
  GetPage(name: AppRoute.bottomNav, page: () => BottomNav()),
];
