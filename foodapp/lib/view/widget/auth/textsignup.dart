import 'package:flutter/material.dart';

import '../../../widget/widget_support.dart';

class CustomTextSignUpOrSignIn extends StatelessWidget {
  final textone;
  final texttwo;
  final void Function()? onTap;
  const CustomTextSignUpOrSignIn({
    super.key,
    this.textone,
    this.texttwo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textone,
          style: TextStyle(fontSize: 18),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            texttwo,
            style: AppWidget.semiBoldTextFeildStyle(),
          ),
        )
      ],
    );
  }
}
