import 'package:blood_donation_app/app/module/donor/controller/donor_controller.dart';
import 'package:blood_donation_app/app/module/login/controller/login_controller.dart';
import 'package:blood_donation_app/app/module/profile/controller/profile_controller.dart';
import 'package:blood_donation_app/app/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../data/app_image.dart';
import '../../../utils/app_color.dart';
import '../../../widget/text/big_text.dart';
import '../../../widget/text/small_text.dart';
import '../../../widget/text_form/custom_text_form.dart';

class DonorDetailsView extends StatelessWidget {
  const DonorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final int index = Get.arguments as int;
    final controller = Get.find<DonorController>();

    return FutureBuilder<bool>(
      future: controller.checkIfRequestExists(
        Get.find<ProfileController>().firebaseUser.value?.uid,
        controller.filteredUsers[index]['uid'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Error loading data"),
            ),
          );
        }

        bool requestExists = snapshot.data ?? false;
        // bool requestExists = snapshot.data ?? false;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Donor Details"),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'donorImage-$index',
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: controller.filteredUsers[index]['imageUrl'] != null
                              ? NetworkImage(controller.filteredUsers[index]['imageUrl'],
                          ) as ImageProvider
                              : AssetImage(dpImage) as ImageProvider,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(
                            maxLines: 2,
                            title: controller.filteredUsers[index]['name'],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          SmallText(
                            title: "Last Donate: ${controller.filteredUsers[index]['lastDonate']}",
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          SmallText(
                            title: "Blood Group: ${controller.filteredUsers[index]['bloodGroup']}",
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          InkWell(
                            onTap: () {
                              controller.makingPhoneCall(controller.filteredUsers[index]['phone']);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "${controller.filteredUsers[index]['phone']}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.call,
                                  size: 15,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SmallText(
                                    title: "His total Donations",
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  BigText(
                                    title: "05 times",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5,),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SmallText(
                      maxLines: 3,
                      title: "Area of Donate: Shafipur, Mouchak, Kaliakair, Konabari, Gazipur",
                    ),
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Patient Information",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: red,
                            ),
                          ),
                          SizedBox(height: 15,),
                          CustomTextForm(
                            controller: controller.patientNameController,
                            hintText: "Patient Name",
                            isPrefix: true,
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomTextForm(
                                  controller: controller.ageController,
                                  hintText: "Patient age",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 2,
                                child: CustomTextForm(
                                  controller: controller.bloodAmountController,
                                  hintText: "Blood Amount(1 Bag..)",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),

                          IntlPhoneField(
                            controller: controller.patientNumberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              labelText: 'Phone Number',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
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

                          CustomTextForm(
                            controller: controller.patientProblemController,
                            hintText: "Patient Problem",
                            prefixIcon: Icons.phone,
                          ),
                          const SizedBox(height: 10,),

                          CustomTextForm(
                            controller: controller.dateController,
                            hintText: "Date",
                            isSuffix: true,
                            isReadOnly: true,
                            suffixIcon: Icons.calendar_month,
                            onPressSuffix: () {
                              controller.pickDate(context);
                            },
                          ),
                          const SizedBox(height: 10,),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextForm(
                                  controller: controller.locationController,
                                  hintText: "Location",
                                  prefixIcon: Icons.phone,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: CustomTextForm(
                                  controller: controller.referenceController,
                                  hintText: "Reference (Optional)",
                                  prefixIcon: Icons.phone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          CustomTextForm(
                            controller: controller.commentsController,
                            hintText: "Comments (Optional)",
                            prefixIcon: Icons.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: requestExists ? null : () {
                print(controller.filteredUsers[index]['uid']);
                final currentUser = Get.find<ProfileController>().firebaseUser.value;
                if (currentUser != null) {
                  controller.sendRequest(index);
                } else {
                  print("Current user is null");
                  CustomToast().errorToast("Login First");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: requestExists ? Colors.grey : red,
                elevation: 5,
              ),
              child: Text(
                requestExists ? "Request Already Sent" : "Send Request",
                style: GoogleFonts.poppins(
                  color: whiteText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

