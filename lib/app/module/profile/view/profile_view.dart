import 'package:blood_donation_app/app/module/profile/controller/profile_controller.dart';
import 'package:blood_donation_app/app/widget/text/big_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/app_image.dart';
import '../../../utils/app_color.dart';
import '../../../widget/profile_menu_widget.dart';
import '../../login/controller/login_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final loginController = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text("Profile"),
      ),
      body: Obx(
        () => controller.userProfile.isEmpty
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'donorImage-${controller.userProfile['imageUrl']}',
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.userProfile['imageUrl'] !=
                                  null
                              ? NetworkImage(controller.userProfile['imageUrl'])
                              : AssetImage(dpImage) as ImageProvider,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BigText(
                      title: controller.userProfile['name'] ??
                          'Name not available',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SmallText(
                        title:
                            "${controller.userProfile['email'] ?? 'Name not available'}"),
                    SizedBox(
                      height: 2,
                    ),
                    SmallText(
                        title:
                            "Last Donate: ${controller.userProfile['lastDonate'] ?? 'Name not available'}"),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade100,
                            ),
                            child: Column(
                              children: [
                                SmallText(
                                  title: "Donations",
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                BigText(
                                  title: "05",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade100,
                            ),
                            child: Column(
                              children: [
                                SmallText(
                                  title: "My Request",
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                BigText(
                                  title: "13",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.home,
                      title: 'I want to Donate',
                      isForwardIcon: false,
                      child: Obx(
                        () => Switch(
                          value: controller.isSwitched.value,
                          onChanged: (value) {
                            controller.isSwitched.value = value;
                          },
                          activeColor: red,
                          activeTrackColor: Colors.red.shade100,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.edit,
                      title: 'Edit Profile',
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.bloodtype_outlined,
                      title: 'Blood Request',
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy and Policy',
                    ),
                    ProfileMenuWidget(
                      onPress: () {},
                      icon: Icons.info_outline,
                      title: 'About Us',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: (){
                        Get.defaultDialog(
                            title: "Warning",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            content: Column(
                              children: [
                                Text("Are you sure you want to logout"),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          loginController.signOut();
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: SmallText(
                                              title: "Yes",
                                              fontColor: whiteText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            color: Colors.blue,
                                          ),
                                          child: Center(
                                            child: SmallText(
                                              title: "No",
                                              fontColor: whiteText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 10,
                          left: 10,
                          right: 10,
                        ),
                        // color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              size: 18,
                              color: red,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            SmallText(
                              title: "Logout",
                              fontColor: red,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
