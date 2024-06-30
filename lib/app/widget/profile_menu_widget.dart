import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class ProfileMenuWidget extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final String title;
  final bool? isForwardIcon;
  final Widget? child;
  const ProfileMenuWidget({
    super.key,
    required this.onPress,
    required this.icon,
    required this.title,
    this.isForwardIcon = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),
        onPressed: onPress,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5,),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                // margin: EdgeInsets.only(left: -),
                decoration: BoxDecoration(
                  color: red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10,),
              Expanded(child: Text(title)),
              isForwardIcon == true ? const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ): child!,
            ],
          ),
        ),
      ),
    );
  }
}
