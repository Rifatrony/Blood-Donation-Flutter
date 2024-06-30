import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? fontColor;
  final int? maxLines;
  final FontWeight? fontWeight;
  final bool? isBold;
  const SmallText({
    super.key,
    required this.title,
    this.fontSize = 12,
    this.fontColor = Colors.black,
    this.maxLines = 1, this.fontWeight = FontWeight.normal, this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: isBold! ? FontWeight.bold : fontWeight ,
      ),
    );
  }
}
