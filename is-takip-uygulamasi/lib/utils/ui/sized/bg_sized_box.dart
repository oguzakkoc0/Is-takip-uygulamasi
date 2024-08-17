import 'package:flutter/material.dart';

class BgSizedBox extends StatelessWidget {
  final double width;
  final double height;

  // Varsayılan değerler ile bir constructor oluşturun
  const BgSizedBox({
    super.key,
    this.width = 0.0,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
