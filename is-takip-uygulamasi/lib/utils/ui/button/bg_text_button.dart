import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonTitle;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(backgroundColor: Colors.blue),
        child: Text(
          buttonTitle,
        ));
  }
}
