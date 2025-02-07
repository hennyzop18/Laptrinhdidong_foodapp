import 'package:foodapp/core/constant/routes.dart';
import 'package:get/get.dart';

abstract class SuccessSignUpController extends GetxController {
  goToPageLogin();
}

class SuccessSignUpControllerImp extends SuccessSignUpController {
  @override
  void goToPageLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
