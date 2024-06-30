import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? fontColor;
  final int? maxLines;
  final FontWeight? fontWeight;
  const BoldText({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.fontColor = Colors.black,
    this.maxLines = 1,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
