import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const CustomButtonAuth({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 13),
        onPressed: onPressed,
        child: Text(text),
        color: Color(0Xffff5722),
        textColor: Colors.white,
      ),
    );
  }
}
