import 'package:flutter/material.dart';

class BgTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  const BgTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: keyboardType,
      cursorColor: Colors.red,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
