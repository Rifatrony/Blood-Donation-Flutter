import 'dart:io';

import 'package:blood_donation_app/app/module/signup/controller/signup_controller.dart';
import 'package:blood_donation_app/app/widget/text/bold_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:blood_donation_app/app/widget/text_form/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../route/routes.dart';
import '../../../utils/app_color.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 30,),
            // Center(
            //   child: BoldText(
            //     title: "Sign up form Design",
            //   ),
            // ),

            SizedBox(height: 10,),


            Center(
              child: Stack(
                children: [
                  Obx(()=>
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.image.value == null
                          ? null
                          : FileImage(File(controller.image.value!.path,),),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: (){
                          print("Pick Image");
                          controller.pickImage();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20,),

            CustomTextForm(
              controller: controller.nameController,
              hintText: "Name",
            ),

            SizedBox(height: 10,),

            CustomTextForm(
              controller: controller.emailController,
              hintText: "Email",
            ),

            SizedBox(height: 10,),

            IntlPhoneField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Phone Number',
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              initialCountryCode: 'BD',
              onChanged: (phone) {
                print("Complete Number is ${phone.completeNumber}");
              },


              onCountryChanged: (country) {

                controller.countryCode.value = country.fullCountryCode;
                print('Country Code from Controller to: ' + controller.countryCode.value);
              },
            ),

            SizedBox(height: 10,),

            Obx(() {
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        //   borderSide: BorderSide(
                        //     color: controller.selectedBloodGroup.value == null
                        //         ?  red : Colors.green,
                        //     width: 1.0,
                        //   ),
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: controller.selectedBloodGroup.value == null
                                ?  Colors.grey : Colors.green,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: controller.selectedBloodGroup.value == null
                                ?  Colors.red : Colors.green,
                            width: 1.0,
                          ),
                        ),
                      ),
                      hint: Text(
                        'Select a blood group',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                      ),
                      value: controller.selectedBloodGroup.value,
                      onChanged: (String? newValue) {
                        print(newValue);
                        controller.setSelectedBloodGroup(newValue);
                      },
                      items: controller.bloodGroupList.map((String bloodGroup) {
                        return DropdownMenuItem<String>(
                          value: bloodGroup,
                          child: Text(
                            bloodGroup,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.ageController,
                      decoration: InputDecoration(
                        hintText: "Age: 23",
                        labelText: "Age",
                        isDense: true,
                        hintStyle: GoogleFonts.lato(
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey.shade100,
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            )
                        ),

                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        int? age = int.tryParse(value);
                        if (age == null) {
                          return 'Please enter a valid number';
                        }
                        if (age <= 18) {
                          return 'Age must be more than 18';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 8,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                    onTap: () {
                      controller.toggleLastDonate();
                    },
                    child: Obx(()=>
                      SmallText(
                        title: controller.didHadLastDonate.value
                            ? "Select your last donate Date below"
                            : "Select if you donate BLOOD before",
                        fontColor: greenText,
                      ),
                    )
                ),


                Obx(() => Checkbox(
                  value: controller.didHadLastDonate.value,
                  activeColor: greenText,

                  onChanged: (value) {
                    controller.toggleLastDonate();
                  },
                )),

              ],
            ),

            // SizedBox(height: 20,),

            Obx(()=>
              Visibility(
                visible: controller.didHadLastDonate.value,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                        controller: controller.lastDonateController,
                        hintText: "Select Last Donate Date",
                        isSuffix: true,
                        isReadOnly: true,
                        suffixIcon: Icons.calendar_month,
                        onPressSuffix: (){
                          controller.pickDate(context);
                        },

                      ),
                    ),


                    SizedBox(width: 10,),

                    Expanded(
                      child: CustomTextForm(
                        keyboardType: TextInputType.number,
                        controller: controller.totalLastDonateController,
                        hintText: "Total Donate",
                        // isSuffix: true,
                        // isReadOnly: true,
                        // suffixIcon: Icons.calendar_month,
                        // onPressSuffix: (){
                        //   controller.pickDate(context);
                        // },

                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 8,),

            Obx(()=>
              CustomTextForm(
                controller: controller.passwordController,
                hintText: "Password",
                isVisible: controller.isVisible.value,
                isSuffix: true,
                suffixIcon: controller.isVisible.value ? Icons.visibility : Icons.visibility_off,
                onPressSuffix: (){
                  controller.isVisible.value =! controller.isVisible.value;
                },
              ),
            ),

            SizedBox(height: 20,),

            InkWell(
              onTap: (){
                controller.signUp();
              },
              child: Container(
                height: 50,
                // padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(()=>
                  Center(
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : SmallText(
                            title: "Sign Up",
                            fontColor: Colors.white,
                          ),

                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallText(
                  title: "Already have Account?",
                ),

                SizedBox(width: 5,),

                InkWell(
                  onTap: (){
                    Get.offAllNamed(RouteName.login);
                  },
                  child: BoldText(
                    title: "Login",
                    fontColor: greenText,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
