import 'package:blood_donation_app/app/route/routes.dart';
import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:blood_donation_app/app/utils/custom_loading.dart';
import 'package:blood_donation_app/app/widget/text/bold_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:blood_donation_app/app/widget/text_form/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 180,
              ),
              Text("Login"),
              SizedBox(
                height: 20,
              ),
              CustomTextForm(
                controller: controller.emailController,
                hintText: "Email",
                isPrefix: true,
                prefixIcon: Icons.email,
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => CustomTextForm(
                  isVisible: controller.isVisible.value,
                  controller: controller.passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  isPrefix: true,
                  isSuffix: true,
                  suffixIcon: controller.isVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onPressSuffix: () {
                    controller.isVisible.value = !controller.isVisible.value;
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        controller.toggleRememberMe();
                      },
                      child: SmallText(
                        title: "Remember Me",
                      )),
                  Obx(() => Checkbox(
                        value: controller.isRemembered.value,
                        activeColor: greenText,
                        onChanged: (value) {
                          controller.toggleRememberMe();
                        },
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 50,
                // color: Colors.blue,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const SmallText(
                            title: "Login",
                            fontColor: Colors.white,
                          ),
                  ),
                ),
              ),
             const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SmallText(
                    title: "No Account yet?",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(RouteName.signup);
                    },
                    child: const BoldText(
                      title: "Sign Up.",
                      fontColor: greenText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "This is Center Short Toast",
                      toastLength: Toast.LENGTH_SHORT,
                      fontSize: 16.0);
                  // customLoading();
                },
                child: const SmallText(
                  title: "Forget Password???",
                  fontColor: red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
