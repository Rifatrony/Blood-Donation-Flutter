import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:blood_donation_app/app/widget/text/big_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            BigText(
              title: "Today",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: 3,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only( bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: red,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            title: "Notification Title",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          SmallText(
                            title: "Notification Desc",
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            fontColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            BigText(
              title: "Yesterday",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: 5,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only( bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: red,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            title: "Notification Title",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          SmallText(
                            title: "Notification Desc",
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            fontColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            BigText(
              title: "Last 7 Days",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            SizedBox(height: 10,),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: 8,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only( bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: red,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            title: "Notification Title",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          SmallText(
                            title: "Notification Desc",
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            fontColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
