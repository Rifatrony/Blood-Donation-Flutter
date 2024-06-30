import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? fontColor;
  final int? maxLines;
  final FontWeight? fontWeight;
  const BigText({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.fontColor = Colors.black,
    this.maxLines = 1,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.lato(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
