import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../data/app_image.dart';
import 'image/svg_image.dart';
class CustomBloodSymbol extends StatelessWidget {
  final String bloodGroup;
  final double? height;
  final double? width;
  final double? fontSize;
  const CustomBloodSymbol({
    super.key,
    required this.bloodGroup,
    this.height = 60,
    this.width = 60, this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      // color: Colors.blue,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomSvgPicture(
            imagePath: bloodImage,
            height: 80,
            color: red,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Center(
                child: SmallText(
                  title: bloodGroup,
                  fontColor: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          Positioned(
            right: -4,
            child: SvgPicture.asset(
              bloodImage,
              color: red,
            ),
          ),
        ],
      ),
    );
  }
}
