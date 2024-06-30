import 'dart:async';

import 'package:blood_donation_app/app/data/app_image.dart';
import 'package:blood_donation_app/app/module/blood_request/controller/blood_request_controller.dart';
import 'package:blood_donation_app/app/module/blood_request/view/blood_request_view.dart';
import 'package:blood_donation_app/app/module/donate/view/donate_view.dart';
import 'package:blood_donation_app/app/module/donor/view/donor_details.dart';
import 'package:blood_donation_app/app/module/donor/view/donor_view.dart';
import 'package:blood_donation_app/app/module/home/controller/home_controller.dart';
import 'package:blood_donation_app/app/module/home/view/custom_drawer.dart';
import 'package:blood_donation_app/app/route/routes.dart';
import 'package:blood_donation_app/app/widget/blood_symbol_widget.dart';
import 'package:blood_donation_app/app/widget/image/svg_image.dart';
import 'package:blood_donation_app/app/widget/text/big_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_color.dart';
import '../../../widget/text/bold_text.dart';
import '../../donor/controller/donor_controller.dart';
import '../../profile/controller/profile_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../signup/controller/signup_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final profileController = Get.put(ProfileController());
    final bloodRequestController = Get.put(BloodRequestController());
    final donorController = Get.put(DonorController());

    final signUpController = Get.put(SignupController());

    var latitude = signUpController.latitude.value;
    var longitude = signUpController.longitude.value;

    LatLng myLatLong = LatLng(latitude, longitude);

    Future<void> onRefresh() async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uid = sp.getString("uid")!;
      await Future.delayed(
        Duration(milliseconds: 100),
        () async {
          await bloodRequestController.fetchReceivedRequests(uid);
        },
      );
    }

    return Scaffold(
      drawer: CustomDrawer(controller: profileController),
      appBar: AppBar(
        title: Text("Donate Blood"),
        surfaceTintColor: Colors.transparent,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Get.toNamed(RouteName.notification);
                },
                icon: Icon(
                  Icons.notifications,
                  color: red,
                  size: 32,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: SmallText(
                      title: "10",
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Icon(Icons.notifications),
          SizedBox(
            width: 10,
          ),

          InkWell(
            onTap: () {
              Get.toNamed(RouteName.profile);
            },
            child: Obx(
              () => profileController.userProfile.isEmpty
                  ? CircleAvatar(
                      backgroundImage: AssetImage(dpImage),
                    )
                  : Hero(
                      tag:
                          'donorImage-${profileController.userProfile['imageUrl']}',
                      child: CircleAvatar(
                        // radius: 50,
                        backgroundImage:
                            profileController.userProfile['imageUrl'] != null
                                ? NetworkImage(
                                    profileController.userProfile['imageUrl'])
                                : AssetImage(dpImage) as ImageProvider,
                      ),
                    ),
            ),
          ),

          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            height: 180,
            child: Obx(
                  () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: myLatLong,
                  zoom: 12,
                ),
                markers: donorController.markers.value,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuItemWidget(
                          onPress: () {
                            Get.toNamed(RouteName.donor);
                            // Get.to(()=>DonorView());
                          },
                          title: "Find Donors",
                          imagePath: bloodSearchImage,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MenuItemWidget(
                          onPress: () {
                            Get.toNamed(RouteName.donate);
                          },
                          title: "Donate",
                          imagePath: bloodDonateImage,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MenuItemWidget(
                          onPress: () {
                            Get.toNamed(RouteName.bloodRequest);
                          },
                          title: "Request Blood",
                          imagePath: bloodRequestImage,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MenuItemWidget(
                          onPress: () {
                            // Get.toNamed(RouteName.bloodRequest);
                          },
                          title: "Support",
                          imagePath: bloodRequestImage,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => bloodRequestController.isLoadingReceivedRequest.value
                          ? Center(child: CircularProgressIndicator())
                          : bloodRequestController.receivedRequests.isEmpty
                              ? SizedBox()
                              : Container(
                                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "My Blood Request",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(RouteName.receiveRequest);
                                              },
                                              child: Text(
                                                "View All",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Obx(
                                        () => bloodRequestController
                                                .receivedRequests.isEmpty
                                            ? SizedBox()
                                            : const SizedBox(
                                                height: 8,
                                              ),
                                      ),
                                      Container(
                                        height: 175,
                                        margin: EdgeInsets.only(left: 10),
                                        child: ListView.builder(
                                          itemCount: bloodRequestController
                                              .receivedRequests.length,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final bloodRequest =
                                                bloodRequestController
                                                    .receivedRequests[index];
                                            final senderDetails =
                                                bloodRequest['senderDetails'];
                                            final receiverDetails =
                                                bloodRequest['receiverDetails'];
            
                                            return Container(
                                              width: 280,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 22,
                                                        backgroundImage: NetworkImage(
                                                            senderDetails[
                                                                'imageUrl']),
                                                        // Use NetworkImage or AssetImage based on your profile image source
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            senderDetails['name'],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                          Text(
                                                            'Sent 2 mnt ago',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.green),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  SmallText(
                                                    title:
                                                        'Patient Problem: ${bloodRequest['problem']}',
                                                  ),
                                                  SizedBox(height: 4),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      'Date: ${bloodRequest['donateDate']}',
                                                      textAlign: TextAlign.end,
                                                      style: GoogleFonts.poppins(
                                                        color: greenText,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          color: Colors.red,
                                                          size: 18),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        child: SmallText(
                                                          title: bloodRequest[
                                                              'location'],
                                                          isBold: true,
                                                          fontWeight: FontWeight.w300,
                                                          // style: TextStyle(fontSize: 14, color: Colors.red),
                                                          // maxLines: 2,
                                                          // overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          // Handle cancel request
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal: 14,
                                                                  vertical: 6),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          // Handle accept request
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal: 14,
                                                                  vertical: 6),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Accept',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
            
                    ///
                    // Obx(
                    //   () => bloodRequestController.receivedRequests.isEmpty
                    //       ? SizedBox()
                    //       : Container(
                    //           height: 175,
                    //           margin: EdgeInsets.only(left: 10),
                    //           child: ListView.builder(
                    //             itemCount:
                    //                 bloodRequestController.receivedRequests.length,
                    //             physics: const BouncingScrollPhysics(),
                    //             scrollDirection: Axis.horizontal,
                    //             itemBuilder: (context, index) {
                    //               final bloodRequest =
                    //                   bloodRequestController.receivedRequests[index];
                    //               final senderDetails = bloodRequest['senderDetails'];
                    //               final receiverDetails =
                    //                   bloodRequest['receiverDetails'];
                    //
                    //               return Container(
                    //                 width: 280,
                    //                 padding: EdgeInsets.symmetric(
                    //                     horizontal: 10, vertical: 8),
                    //                 margin: EdgeInsets.only(right: 10),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.grey.shade100,
                    //                   borderRadius: BorderRadius.circular(12),
                    //                 ),
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         CircleAvatar(
                    //                           radius: 22,
                    //                           backgroundImage: NetworkImage(
                    //                               senderDetails['imageUrl']),
                    //                           // Use NetworkImage or AssetImage based on your profile image source
                    //                         ),
                    //                         SizedBox(width: 10),
                    //                         Column(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             Text(
                    //                               senderDetails['name'],
                    //                               style: TextStyle(
                    //                                   fontSize: 16,
                    //                                   fontWeight: FontWeight.bold),
                    //                             ),
                    //                             Text(
                    //                               'Sent 2 mnt ago',
                    //                               style: TextStyle(
                    //                                   fontSize: 12,
                    //                                   color: Colors.green),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     SizedBox(height: 10),
                    //                     SmallText(
                    //                       title:
                    //                           'Patient Problem: ${bloodRequest['problem']}',
                    //                     ),
                    //                     SizedBox(height: 4),
                    //                     Align(
                    //                       alignment: Alignment.centerRight,
                    //                       child: Text(
                    //                         'Date: ${bloodRequest['donateDate']}',
                    //                         textAlign: TextAlign.end,
                    //                         style: GoogleFonts.poppins(
                    //                           color: greenText,
                    //                           fontWeight: FontWeight.w500,
                    //                           fontSize: 12,
                    //                           fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     SizedBox(height: 2),
                    //                     Row(
                    //                       children: [
                    //                         Icon(Icons.location_on,
                    //                             color: Colors.red, size: 18),
                    //                         SizedBox(width: 5),
                    //                         Expanded(
                    //                           child: SmallText(
                    //                             title: bloodRequest['location'],
                    //                             isBold: true,
                    //                             fontWeight: FontWeight.w300,
                    //                             // style: TextStyle(fontSize: 14, color: Colors.red),
                    //                             // maxLines: 2,
                    //                             // overflow: TextOverflow.ellipsis,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     SizedBox(height: 5),
                    //                     Row(
                    //                       mainAxisAlignment: MainAxisAlignment.end,
                    //                       children: [
                    //                         InkWell(
                    //                           onTap: () {
                    //                             // Handle cancel request
                    //                           },
                    //                           child: Container(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 14, vertical: 6),
                    //                             decoration: BoxDecoration(
                    //                               color: Colors.red,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(20),
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 'Delete',
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     color: Colors.white),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         SizedBox(width: 10),
                    //                         InkWell(
                    //                           onTap: () {
                    //                             // Handle accept request
                    //                           },
                    //                           child: Container(
                    //                             padding: EdgeInsets.symmetric(
                    //                                 horizontal: 14, vertical: 6),
                    //                             decoration: BoxDecoration(
                    //                               color: Colors.green,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(20),
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 'Accept',
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     color: Colors.white),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    // ),
            
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Nearest ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      // color: Colors.red,
                      height: 125,
                      margin: const EdgeInsets.only(right: 10),
            
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        // padding: EdgeInsets.only(right: 10, ),
                        itemBuilder: (context, index) {
                          return Container(
                            // width: 280,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                        dpImage,
                                      ),
                                    ),
                                    Positioned(
                                      right: -10,
                                      top: -5,
                                      child: Container(
                                        height: 35,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: red),
                                        child: Center(
                                          child: SmallText(
                                            title: "Ab+",
                                            fontSize: 10,
                                            fontColor: whiteText,
                                            isBold: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                BigText(
                                  title: "Rifat Ahmed Rony",
                                  fontWeight: FontWeight.bold,
                                  maxLines: 1,
                                ),
                                SmallText(
                                  title: "2km",
                                  fontColor: greenText,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Blood Seeker",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      // color: Colors.red,
                      height: 155,
                      margin: const EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        // padding: EdgeInsets.only(right: 10, ),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 280,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage: AssetImage(
                                              dpImage,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                BigText(
                                                  title: "Rifat Ahmed Rony",
                                                  fontWeight: FontWeight.bold,
                                                  maxLines: 1,
                                                ),
                                                SmallText(
                                                  title: "2 min ago",
                                                  fontColor: greenText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CustomBloodSymbol(
                                        bloodGroup: "A+",
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 5,),
            
                                SizedBox(
                                  height: 2,
                                ),
            
                                SmallText(
                                  title:
                                      "Im asking for blood, I need 2 bag of AB+ Blood.",
                                  maxLines: 2,
                                ),
            
                                SizedBox(
                                  height: 5,
                                ),
            
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: Colors.redAccent,
                                        ),
                                        SmallText(title: "Dhaka Medical"),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: red,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Donate",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ready to donate",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      // color: Colors.red,
                      height: 155,
                      margin: const EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        // padding: EdgeInsets.only(right: 10, ),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 280,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage: AssetImage(
                                              dpImage,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                BigText(
                                                  title: "Rifat Ahmed Rony",
                                                  fontWeight: FontWeight.bold,
                                                  maxLines: 1,
                                                ),
                                                SmallText(
                                                  title: "2 km distance",
                                                  fontColor: greenText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CustomBloodSymbol(
                                        bloodGroup: "A+",
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 5,),
            
                                SizedBox(
                                  height: 2,
                                ),
            
                                SmallText(
                                  title:
                                      "Im ready to donate 1bag AB+ blood today. Among Gazipur",
                                  maxLines: 2,
                                ),
            
                                SizedBox(
                                  height: 5,
                                ),
            
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: red,
                                        ),
                                        SmallText(title: "Dhaka Medical"),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: red,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Request",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  final String imagePath;
  const MenuItemWidget({
    super.key,
    required this.onPress,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              color: Colors.red,
              height: 30,
              width: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
