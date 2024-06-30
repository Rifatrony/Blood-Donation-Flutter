import 'package:blood_donation_app/app/utils/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../route/routes.dart';
import '../../../utils/custom_loading.dart';
import '../../signup/controller/signup_controller.dart';

class LoginController extends GetxController {

  // final controller = Get.put(SignupController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  final isVisible = true.obs;

  final isRemembered = false.obs;

  void toggleRememberMe() {
    isRemembered.value = !isRemembered.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty) {
      CustomToast().errorToast("Email Required");
      return;
    }
    else if (passwordController.text.isEmpty) {
      CustomToast().errorToast("Password Required");
      return;
    }
    else {
      try {
        // email = emailController.text;
        // password = passwordController.text;
        isLoading.value = true;
        // customLoading();
        print("Have email and password");
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          // CustomToast().errorToast("Welcome Back");
          // Get.snackbar("Success", "Login Successful");
          await Future.delayed(Duration(milliseconds: 100), () async {
            Get.offAllNamed(RouteName.home);
            print(user.uid);

            // passwordController.text = "";
            isLoading.value = false;
            print("user is ============> ${user.uid}");
            final pref = await SharedPreferences.getInstance();
            pref.setString('uid', user.uid);
            if(isRemembered.value){
              _saveLogin();
            }
          },);

        }
      } catch (e) {
        print(e.toString());
        // Get.snackbar("Login Error", e.toString(), backgroundColor: Colors.redAccent, snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
        // closeLoadingDialog();
      }
    }
  }

  Future<void> _saveLogin() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('email', emailController.text);
    pref.setString('password', passwordController.text);
    pref.setBool('isLoggedIn', true);
  }

  Future<void> signOut() async {
    try {
      // Show a loading indicator or perform other necessary actions
      // isLoading.value = true;
      customLoading();

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      final pref = await SharedPreferences.getInstance();
      pref.clear();

      // Navigate to the login screen or any other appropriate screen
      Get.offAllNamed(RouteName.login);

      // Update the isLoading state
      // isLoading.value = false;

      // Optionally, you can show a toast or snackbar to inform the user of successful sign out
      CustomToast().successToast("Signed out successfully");
    } catch (e) {
      print(e.toString());
      // Handle any errors that occur during sign-out
      CustomToast().errorToast("Sign-out error: ${e.toString()}");
      // isLoading.value = false;
    }
  }

}