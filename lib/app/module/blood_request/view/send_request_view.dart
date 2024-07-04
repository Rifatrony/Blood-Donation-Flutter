import 'dart:developer';

import 'package:blood_donation_app/app/module/blood_request/controller/blood_request_controller.dart';
import 'package:blood_donation_app/app/widget/buttons/dialog_button.dart';
import 'package:blood_donation_app/app/widget/text_form/custom_text_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_color.dart';
import '../../../widget/text/small_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../widget/text_form/app_text_form_field.dart';

class SendRequestView extends StatelessWidget {
  const SendRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BloodRequestController());

    FirebaseAuth auth = FirebaseAuth.instance;
    var userId = auth.currentUser?.uid;

    controller.getUid();
    // print(controller.uid.value);
    onRefresh() async {
      await Future.delayed(Duration(milliseconds: 1000), () {
        return controller.fetchSentRequestsStream(userId!);
      });
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Send Request"),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Obx(
            () => controller.isSentRequestLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        // Background color for the entire TabBar
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200,
                        ),
                        child: TabBar(
                          // controller: _tabController,
                          tabs: [
                            Tab(text: "Today"),
                            Tab(text: "Last 7 Days"),
                            Tab(text: "All"),
                          ],
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          labelStyle: GoogleFonts.sanchez(
                            fontSize: 13,
                          ),
                          unselectedLabelColor: Colors.black,
                          indicator: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<
                                Map<String, List<Map<String, dynamic>>>>(
                            stream: controller.fetchSentRequestsStream(userId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No received requests'));
                              } else {
                                var data = snapshot.data!;
                                var todayList = data['todayList']!;
                                var last7DaysList = data['last7DaysList']!;
                                var allRequests = data['allRequests']!;

                                return TabBarView(
                                  children: [
                                    buildSentRequestList(todayList, 'today'),
                                    buildSentRequestList(last7DaysList, '7day'),
                                    buildSentRequestList(allRequests, 'all'),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSentRequestList(List<Map<String, dynamic>> requests, String listType) {
    final controller = Get.find<BloodRequestController>();

    print("Type is ===============> $listType");
    return requests.isEmpty
        ? Center(
            child: Text(
              "No Send Request Found ! ! !",
              style: GoogleFonts.sanchez(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              var receiverDetails = request['receiverDetails'];

              Timestamp timestamp = request['requestTime'] as Timestamp;
              DateTime dateTime = timestamp.toDate();

              // Format the DateTime to "time ago" format
              String timeAgo = timeago.format(dateTime);

              return Container(
                // width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
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
                          backgroundImage:
                              NetworkImage(receiverDetails['imageUrl']),
                          // Use NetworkImage or AssetImage based on your profile image source
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              receiverDetails['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Request Send $timeAgo' ?? "",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.green),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  request['status'] ?? "P",
                                  style: GoogleFonts.sanchez(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: request['status'] == "Delete" ? red : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SmallText(
                      title: 'Patient Problem: ${request['problem']}',
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Date: ${request['donateDate']}',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          color: greenText,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 18),
                        const SizedBox(width: 5),
                        Expanded(
                          child: SmallText(
                            title: request['location'],
                            isBold: true,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        DialogButton(
                          onPress: () {

                            final String id = request['requestId'];

                            buildDeleteRequestDialog(controller, id);
                          },
                          title: "Delete",
                          color: red,
                          borderRadius: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if(listType != 'all')
                        DialogButton(
                          onPress: () {

                            final String date = request['donateDate'];
                            final String location = request['location'];
                            final String id = request['requestId'];

                            if (kDebugMode) {
                              // print('${request['donateDate']}');

                              // print('${request['location']}');
                              print("${request['requestId'] ?? "Not found"}");
                            }
                            buildRequestEditDialog(controller, date, location, id);
                          },
                          title: "Edit",
                          borderRadius: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  Future<dynamic> buildDeleteRequestDialog(BloodRequestController controller, id) {
    return Get.defaultDialog(
        title: "Delete",
        titleStyle: GoogleFonts.sanchez(
          color: red,
          // fontWeight: FontWeight.bold
        ),
        titlePadding: const EdgeInsets.only(
          bottom: 5,
          top: 15,
        ),
        contentPadding: EdgeInsets.symmetric(),
        content: Column(
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.sanchez(
                  color: Colors.black,
                ),
                text: "Are you sure",
                children: [
                  TextSpan(
                    text: " Delete ",
                    style: GoogleFonts.sanchez(
                      color: red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "the request?",
                    style: GoogleFonts.sanchez(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogButton(
                  onPress: () {
                    controller.updateStatus("Delete",id);
                    // deleteRequest(id);
                    Get.back();
                  },
                  title: "YES",
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 15,
                ),
                DialogButton(
                  onPress: () {
                    Get.back();
                  },
                  title: "NO",
                  color: red,
                ),
              ],
            ),
          ],
        ));
  }

  Future<dynamic> buildRequestEditDialog(BloodRequestController controller, String date, String location, String id) {

    TextEditingController dateController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    dateController.text = date;
    locationController.text = location;

    DateTime today = DateTime.now();
    DateTime oneMonthFromNow = DateTime(today.year, today.month + 1, today.day);

    return Get.defaultDialog(
        title: "Update",
        titlePadding: const EdgeInsets.only(
          bottom: 5,
          top: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        content: Column(
          children: [

            RichText(
              text: TextSpan(
                style: GoogleFonts.sanchez(
                  color: Colors.black,
                ),
                text: "You can update only",
                children: [
                  TextSpan(
                    text: " Date ",
                    style: GoogleFonts.sanchez(
                      color: red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "and",
                    style: GoogleFonts.sanchez(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " Location",
                    style: GoogleFonts.sanchez(
                      color: red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            AppTextForm(
              controller: dateController,
              hintText: "Selected date",
              isSuffix: true,
              suffixIcon: Icons.calendar_month,
              onPressSuffix: () async {
                DateTime initialDate = DateTime.tryParse(date) ?? today;
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: initialDate,
                  firstDate: today,
                  lastDate: oneMonthFromNow,
                );
                if (pickedDate != null) {
                  dateController.text = pickedDate.toIso8601String().split('T').first;
                }
              },

            ),
            const SizedBox(
              height: 10,
            ),
            AppTextForm(
              controller: locationController,
              hintText: "Selected Location",
              isPrefix: true,
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogButton(
                  onPress: () {
                    Get.back();
                    // controller.updateDateAndLocation();
                    // controller.checkFunction(dateController.text.trim().toString(), locationController.text.toString().trim());
                    controller.updateDateAndLocation(dateController.text.trim().toString(), locationController.text.toString().trim(), id);
                  },
                  title: "Submit",
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 15,
                ),
                DialogButton(
                  onPress: () {
                    Get.back();
                  },
                  title: "Cancel",
                  color: red,
                ),
              ],
            ),
          ],
        ));
  }
}
