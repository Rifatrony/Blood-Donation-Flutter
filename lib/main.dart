import 'dart:io';

import 'package:blood_donation_app/app/module/home/view/home_view.dart';
import 'package:blood_donation_app/app/module/splash/controller/splash_controller.dart';
import 'package:blood_donation_app/app/module/splash/view/splash_view.dart';
import 'package:blood_donation_app/app/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/route/pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDVOqqyyTj8kCEiFfZP2Da2MwvLZEAuFsk",
      appId: "1:973844892742:android:597eb5854006948ee18e47",
      messagingSenderId: "973844892742",
      projectId: "blood-donation-flutter-8571a",
      storageBucket: "blood-donation-flutter-8571a.appspot.com",
    )
  ) : await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set the status bar color to transparent
      statusBarIconBrightness: Brightness.dark, // Use this for light status bar icons
    ),
  );

  final controller = Get.put(SplashController());
  // controller.checkLogin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
        initialRoute: RouteName.splash,
        getPages: AppPages.routes,

      // home: SplashView(),
    );
  }
}

