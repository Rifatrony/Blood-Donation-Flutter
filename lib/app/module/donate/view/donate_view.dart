import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/blood_symbol_widget.dart';
import '../../../widget/text/big_text.dart';
import '../../../widget/text/small_text.dart';

class DonateView extends StatelessWidget {
  const DonateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate"),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: 8,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        // padding: EdgeInsets.only(right: 10, ),
        itemBuilder: (context, index){
          return Container(
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10 ),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)
            ),
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
                          ),

                          SizedBox(width: 8,),


                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  title: "Rifat Ahmed Rony",
                                  fontWeight: FontWeight.bold,
                                  maxLines: 1,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: SmallText(
                                        maxLines: 2,
                                        title: "Dhaka Medical",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: CustomBloodSymbol(bloodGroup: "A+",),
                    ),
                  ],
                ),
                // SizedBox(height: 5,),


                // SizedBox(height: 2,),

                // SmallText(
                //   title: "Im asking for blood, I need 2 bag of AB+ Blood.",
                //   maxLines: 2,
                // ),

                // SizedBox(height: 5,),
                //
                //
                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [

                //
                //     Container(
                //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                //       decoration: BoxDecoration(
                //         color: Colors.redAccent,
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Donate",
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

              ],
            ),
          );
        },
      ),
    );
  }
}
