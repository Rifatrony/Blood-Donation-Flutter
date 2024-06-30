import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool? isVisible;
  final bool? isPrefix;
  final bool? isSuffix;
  final bool? isReadOnly;
  final VoidCallback? onPressSuffix;
  const CustomTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.isPrefix = false,
    this.isVisible = false, this.suffixIcon, this.isSuffix, this.onPressSuffix, this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isVisible!,
      readOnly: isReadOnly!,
      keyboardType: keyboardType,
      style: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 13,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: isPrefix == true? Icon(prefixIcon) : null,

        suffixIcon: isSuffix == true
            ? GestureDetector(
                onTap: isSuffix == true ? onPressSuffix : null,
                child: Icon(suffixIcon),
              )
            : null,
      ),
    );
  }
}
