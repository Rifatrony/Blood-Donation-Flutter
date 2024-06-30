import 'package:blood_donation_app/app/module/splash/controller/splash_controller.dart';
import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
