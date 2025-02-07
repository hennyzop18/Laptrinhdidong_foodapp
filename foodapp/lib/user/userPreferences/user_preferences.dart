import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class RememberUserPrefs {
  //Lưu thông tin người dùng
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString('currentUser', userJsonData);
  }

  //Lấy và đọc thông tin người dùng
  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString('currentUser');
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('currentUser');
  }

  static Future<void> saveUserAddress(newAddress) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('address', newAddress);
  }

  static Future<String?> readUserAddress() async {
    String? userAddress;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userAddress = preferences.getString('address');
    return userAddress;
  }
}
