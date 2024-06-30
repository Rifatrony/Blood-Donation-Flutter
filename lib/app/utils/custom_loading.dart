 import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

void customLoading(){
   Get.dialog(
     const Center(
       child: SpinKitWave(
         color: Colors.red,
         size: 30,
       ),
     ),
     barrierDismissible: false,
   );
}

closeLoadingDialog() {
 Get.back();
}