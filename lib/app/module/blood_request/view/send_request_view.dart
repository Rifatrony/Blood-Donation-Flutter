import 'dart:developer';

import 'package:blood_donation_app/app/module/blood_request/controller/blood_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_color.dart';
import '../../../widget/text/small_text.dart';

class SendRequestView extends StatelessWidget {
  const SendRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BloodRequestController());

    print(controller.uid.value);

    return Scaffold(
      appBar: AppBar(
        title: Text("All Send Request"),
      ),
      body: Obx(
        () => FutureBuilder(
            future: controller.fetchReceivedRequests(controller.uid.value),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error loading data"),
                );
              }
              return Obx(
                () => controller.sentRequests.isEmpty
                    ? Center(
                        child: SmallText(
                          title: "No Request found",
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.sentRequests.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final bloodRequest = controller.sentRequests[index];
                          final senderDetails = bloodRequest['senderDetails'];
                          final receiverDetails =
                              bloodRequest['receiverDetails'];

                          return Container(
                            // width: 280,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: EdgeInsets.only(
                                right: 10, left: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          receiverDetails['imageUrl']),
                                      // Use NetworkImage or AssetImage based on your profile image source
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          receiverDetails['name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                                        color: Colors.red, size: 18),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: SmallText(
                                        title: bloodRequest['location'],
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // Handle cancel request
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
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
              );
            }),
      ),
    );
  }
}
