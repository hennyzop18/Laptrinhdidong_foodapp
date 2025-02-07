import 'package:flutter/material.dart';

class CustomTextFormAuth extends StatelessWidget {
  final String hintText, labeltext;
  final IconData? iconData;
  final TextEditingController? mycontroller;
  final String? Function(String?)? valid;
  final bool isNumber;
  final bool? obscureText;
  final void Function()? onTapIcon;

  const CustomTextFormAuth({
    super.key,
    required this.hintText,
    required this.labeltext,
    required this.iconData,
    required this.mycontroller,
    this.valid,
    required this.isNumber,
    this.obscureText,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        keyboardType: isNumber
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: valid,
        controller: mycontroller,
        obscureText: obscureText == null || obscureText == false ? false : true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          label: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(labeltext),
          ),
          suffixIcon: InkWell(
            child: Icon(iconData),
            onTap: onTapIcon,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
