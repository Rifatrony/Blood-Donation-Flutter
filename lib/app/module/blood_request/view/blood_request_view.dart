import 'package:blood_donation_app/app/module/blood_request/controller/blood_request_controller.dart';
import 'package:blood_donation_app/app/utils/app_color.dart';
import 'package:blood_donation_app/app/widget/text/big_text.dart';
import 'package:blood_donation_app/app/widget/text/small_text.dart';
import 'package:blood_donation_app/app/widget/text_form/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodRequestView extends StatelessWidget {
  const BloodRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BloodRequestController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Post A Request"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            BigText(
              title: "Select Blood Group",
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10,),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                childAspectRatio: 7.5/6.5
              ),
              shrinkWrap: true,
              primary: false,
              itemCount: controller.bloodGroupList.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    controller.selectedIndex.value = index;
                    controller.selectedBloodGroup.value = controller.bloodGroupList[index];
                  },
                  child: Obx(()=>
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.selectedIndex.value == index
                              ? Colors.red
                              : Colors.grey.shade200,
                          width: controller.selectedIndex.value == index
                              ? 1.5
                              : 0
                        ),
                        shape: BoxShape.circle,
                        color: controller.selectedIndex.value == index
                            ? Colors.red.shade100.withOpacity(0.2)
                            : Colors.grey.shade200,
                      ),
                      child: Center(
                        child: BigText(
                          title: controller.bloodGroupList[index],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16,),

            CustomTextForm(
              controller: controller.patientNameController,
              hintText: "Patient Name",
              isPrefix: true,
              prefixIcon: Icons.person_outline_rounded,
            ),

            SizedBox(height: 10,),

            CustomTextForm(
              controller: controller.patientNumberController,
              hintText: "Patient Number",
              isPrefix: true,
              prefixIcon: Icons.phone,
            ),

            SizedBox(height: 10,),

            CustomTextForm(
              controller: controller.patientNameController,
              hintText: "Patient Problem",
              prefixIcon: Icons.phone,
            ),

            SizedBox(height: 10,),

            CustomTextForm(
              controller: controller.patientNameController,
              hintText: "Location",
              prefixIcon: Icons.phone,
            ),

            SizedBox(height: 10,),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(title: "Gender",
                      fontWeight: FontWeight.bold,
                    ),
                    Text("Gender Dropdown"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(title: "Date",
                      fontWeight: FontWeight.bold,
                    ),
                    Text("Date Dropdown"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SmallText(
            title: "Send Request",
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
