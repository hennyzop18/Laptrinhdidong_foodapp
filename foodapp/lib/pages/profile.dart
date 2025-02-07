import 'package:flutter/material.dart';
import 'package:foodapp/view/srceen/authentication/login.dart';
import 'package:foodapp/user/userPreferences/current_user.dart';
import 'package:foodapp/user/userPreferences/user_preferences.dart';
import 'package:foodapp/widget/widget_support.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultRes = await Get.dialog(
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        title: Text(
          "Sign Out",
          style: AppWidget.boldTextFeildStyle(),
        ),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text("Sign Out"),
            onPressed: () {
              Get.back(result: 'loggedOut');
            },
          ),
        ],
      ),
    );

    if (resultRes == 'loggedOut') {
      //xóa người dùng khỏi dữ liệu thiết bị
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(LogIn());
      });
    }
  }

  Widget userInfoProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Text(
            userData,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        children: [
          Center(
            child: Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(60),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      "images/user.jpg",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          SizedBox(height: 20),
          userInfoProfile(Icons.abc, _currentUser.user.name),
          SizedBox(height: 20),
          userInfoProfile(Icons.person, _currentUser.user.user_name),
          SizedBox(height: 20),
          userInfoProfile(Icons.email, _currentUser.user.user_email),
          SizedBox(height: 20),
          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  signOutUser();
                },
                borderRadius: BorderRadius.circular(32),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
