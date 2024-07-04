import 'dart:async';
import 'dart:developer';

import 'package:blood_donation_app/app/module/home/view/home_view.dart';
import 'package:blood_donation_app/app/module/login/controller/login_controller.dart';
import 'package:blood_donation_app/app/module/login/view/login_view.dart';
import 'package:blood_donation_app/app/services/notification_services.dart';
import 'package:blood_donation_app/app/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../route/routes.dart';
import '../../signup/controller/signup_controller.dart';

class SplashController extends GetxController {

  final controller = Get.put(LoginController());
  final signupController = Get.put(SignupController());

  NotificationServices notificationServices = NotificationServices();

  // late BuildContext context;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit();
    // signupController.getLocation();
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value){
    //   print("Device token ===========> $value");
    // });
  }



  Future<void> checkLogin() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? email = pref.getString('email');
      String? password = pref.getString('password');
      if(email == null || email == "" && password == null || password == ""){
        // controller.emailController.text = email.toString();
        // controller.passwordController.text = password.toString();
        //
        // print("This  function is  called");
        // controller.login();
        // closeLoadingDialog();
        print("Login called from splash");
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginView()));
        // await Get.toNamed(RouteName.login);
        await Future.delayed(
          Duration(milliseconds: 100), ()=> Get.toNamed(RouteName.login),
        );
      }

      if(email == null || email == "" && password == null || password == ""){
        print("Login called from splash");
        await Future.delayed(
          const Duration(milliseconds: 100), ()=> Get.offAllNamed(RouteName.login),
        );
      }
      else {
        await Future.delayed(
          const Duration(milliseconds: 100), (){
          controller.emailController.text = email.toString();
          controller.passwordController.text = password.toString();
          print("This  function is  called");
          controller.login();
        },
        );

        // closeLoadingDialog();
      }
    } catch(e, stackTrace){
      print(e.toString());
      print(stackTrace);
    }
  }


}