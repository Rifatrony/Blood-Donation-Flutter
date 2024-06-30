import 'package:blood_donation_app/app/module/home/view/sidebar_menu_item_widget.dart';
import 'package:blood_donation_app/app/module/profile/controller/profile_controller.dart';
import 'package:blood_donation_app/app/route/routes.dart';
import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/app_image.dart';
import '../../../widget/text/big_text.dart';
import '../../../widget/text/small_text.dart';

class CustomDrawer extends StatelessWidget {
  final ProfileController controller;

  const CustomDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          /// Header Container
          Container(
            width: double.maxFinite,
            color: red,
            child: Column(
              children: [
                Container(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.userProfile['imageUrl'] != null
                      ? NetworkImage(controller.userProfile['imageUrl'])
                      : AssetImage(dpImage) as ImageProvider,
                ),
                SizedBox(
                  height: 10,
                ),
                BigText(
                  title: controller.userProfile['name'] ?? 'Name not available',
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
              ],
            ),
          ),

          Divider(
            height: 0.5,
            color: Colors.grey.shade300,
          ),

          /// Item Container

          SizedBox(
            height: 15,
          ),

          SidebarMenuItemWidget(
            onPress: () {},
            title: 'Home',
          ),

          SidebarMenuItemWidget(
            onPress: () {},
            title: 'My Request',
          ),

          SidebarMenuItemWidget(
            onPress: () {
              Get.back();
              Get.toNamed(RouteName.sendRequest);
            },
            title: 'My Sent Request',
          ),

          SizedBox(
            height: 15,
          ),

          Divider(
            height: 0.5,
            color: Colors.grey.shade300,
          ),

          SizedBox(
            height: 15,
          ),

          SidebarMenuItemWidget(
            onPress: () {},
            title: 'Settings',
          ),

          SizedBox(
            height: 15,
          ),

          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Logout",
            ),
          ),

          Spacer(),

          Text(
            "V 1.5",
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
