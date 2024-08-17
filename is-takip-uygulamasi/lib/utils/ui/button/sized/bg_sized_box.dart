import 'package:flutter/material.dart';

class BgSizedBox extends StatelessWidget {
  final double height, width;
  const BgSizedBox({super.key, this.height = 10, this.width = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
