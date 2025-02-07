import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (type == 'username') {
    if (!GetUtils.isUsername(val)) {
      return 'Không có giá trị tên đăng nhập';
    }
  }
  if (type == 'email') {
    if (!GetUtils.isEmail(val)) {
      return 'Không có giá trị email';
    }
  }
  if (type == 'phone') {
    if (!GetUtils.isPhoneNumber(val)) {
      return 'Không có giá trị số điện thoại';
    }
  }

  if (val.isEmpty) {
    return 'Vui lòng nhập giá trị';
  }
  if (val.length < min) {
    return 'Giá trị không nhỏ hơn $min';
  }
  if (val.length > max) {
    return 'Giá trị không lớn hơn $max';
  }
}
