import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogButton extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const DialogButton({
    Key? key,
    required this.onPress,
    required this.title,
    this.color = Colors.blue,
    this.padding, this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Use padding if provided
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
        ),
        child: Text(
          title,
          style: GoogleFonts.sanchez(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
