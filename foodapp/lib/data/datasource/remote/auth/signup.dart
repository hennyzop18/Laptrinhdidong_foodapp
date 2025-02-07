import 'package:foodapp/linkapi.dart';

import '../../../../core/class/crud.dart';

class SignupData {
  Crud crud;

  SignupData(this.crud);

  postdata(String username, String password, String email, String phone) async {
    var response = await crud
        .postData("http://192.168.110.56/fastfoodhoangyen/auth/signup.php", {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
    });
    return response.fold((l) => l, (r) => r);
  }
}
