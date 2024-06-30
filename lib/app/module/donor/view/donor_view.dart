import 'package:blood_donation_app/app/data/app_image.dart';
import 'package:blood_donation_app/app/module/donor/controller/donor_controller.dart';
import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:blood_donation_app/app/widget/blood_symbol_widget.dart';
import 'package:blood_donation_app/app/widget/text/big_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:blood_donation_app/app/widget/text_form/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../route/routes.dart';

class DonorView extends StatelessWidget {
  const DonorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DonorController());

    _onRefresh() async {
      await Future.delayed(Duration(milliseconds: 100), () {
        controller.searchController.clear();
        controller.selectedBloodIndex.value = 0;
        controller.selectedBloodGroup.value = 'All';
        controller.fetchAllDonors(controller.firebaseUser.value);
      });
    }

    TextSpan _highlightText(String text, String query, TextStyle style) {
      if (query.isEmpty) {
        return TextSpan(text: text, style: style);
      }
      final match = text.toLowerCase().indexOf(query.toLowerCase());
      if (match == -1) {
        return TextSpan(text: text, style: style);
      }
      return TextSpan(
        children: [
          TextSpan(text: text.substring(0, match), style: style),
          TextSpan(
            text: text.substring(match, match + query.length),
            style: style.copyWith(backgroundColor: Colors.yellow),
          ),
          TextSpan(text: text.substring(match + query.length), style: style),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("All Donor List"),
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextForm(
                      controller: controller.searchController,
                      hintText: "Search",
                      isPrefix: true,
                      prefixIcon: Icons.search,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: red,
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.bloodGroupList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.updateBloodGroupFilter(
                            controller.bloodGroupList[index], index);
                      },
                      child: Obx(
                            () => Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: controller.selectedBloodIndex.value ==
                                index
                                ? red
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              controller.bloodGroupList[index],
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color:
                                controller.selectedBloodIndex.value ==
                                    index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              controller.filteredUsers.isEmpty
                  ? Center(child: Text("No Donor Found"))
                  : ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  var user = controller.filteredUsers[index];
                  var query = controller.searchController.text;
                  var textStyle = TextStyle(
                    color: Colors.black,
                  );

                  return GestureDetector(
                    onTap: () {
                      print("Click ${user['uid']}");
                      Get.toNamed(RouteName.donorDetails, arguments: index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'donorImage-$index',
                            child: CircleAvatar(
                              backgroundImage: user['imageUrl'] != null
                                  ? NetworkImage(user['imageUrl'])
                                  : AssetImage(dpImage)
                              as ImageProvider,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: _highlightText(
                                    user['name'] ??
                                        'Name not available',
                                    query,
                                    textStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: red,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: _highlightText(
                                          user['email'] ??
                                              'Email not available',
                                          query,
                                          textStyle.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.makingPhoneCall(
                                        user['phone']);
                                  },
                                  child: RichText(
                                    text: _highlightText(
                                      user['phone'] ?? '',
                                      query,
                                      textStyle.copyWith(
                                        color: Colors.blue,
                                        decoration: TextDecoration
                                            .underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomBloodSymbol(
                            bloodGroup: user['bloodGroup'] ?? '',
                            height: 50,
                            width: 50,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
