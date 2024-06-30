import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgPicture extends StatelessWidget {
  final String imagePath;
  final Color? color;
  final double? height;
  final double? width;
  const CustomSvgPicture({super.key, required this.imagePath, this.color = Colors.red, this.height = 80, this.width = 40});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(imagePath,
      height: height,
      width: width,
      color: color,
    );
  }
}
