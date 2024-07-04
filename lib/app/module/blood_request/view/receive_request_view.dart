import 'package:blood_donation_app/app/module/blood_request/controller/blood_request_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_color.dart';
import '../../../widget/text/small_text.dart';

import 'package:timeago/timeago.dart' as timeago;

class ReceiveRequestView extends StatelessWidget {
  const ReceiveRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BloodRequestController());
    FirebaseAuth auth = FirebaseAuth.instance;
    var userId = auth.currentUser?.uid;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Request"),
        ),
        body: Column(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                labelPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              ),
            ),
            Expanded(
              child: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
                  stream: controller.fetchReceivedRequestsStream(userId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No received requests'));
                    } else {
                      var data = snapshot.data!;
                      var todayList = data['todayList']!;
                      var last7DaysList = data['last7DaysList']!;
                      var allRequests = data['allRequests']!;

                      return TabBarView(
                        children: [
                          buildRequestList(todayList),
                          buildRequestList(last7DaysList),
                          buildRequestList(allRequests),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRequestList(List<Map<String, dynamic>> requests) {
    return requests.isEmpty
        ? Center(
            child: Text(
              "No Received Request Found ! ! !",
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
              var senderDetails = request['senderDetails'];
              Timestamp timestamp = request['requestTime'] as Timestamp;
              DateTime dateTime = timestamp.toDate();

              // Format the DateTime to "time ago" format
              String timeAgo = timeago.format(dateTime);

              return Container(
                // width: 280,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                              NetworkImage(senderDetails['imageUrl']),
                          // Use NetworkImage or AssetImage based on your profile image source
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              senderDetails['name'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Sent $timeAgo',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SmallText(
                      title: 'Patient Problem: ${request['problem']}',
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: red,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Date: ${request['donateDate']}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.poppins(
                            color: greenText,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 18),
                        SizedBox(width: 5),
                        Expanded(
                          child: SmallText(
                            title: request['location'],
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
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
          );
  }
}
