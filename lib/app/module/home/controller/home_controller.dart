import 'package:blood_donation_app/app/data/app_image.dart';
import 'package:get/get.dart';

import '../data/main_item_class.dart';

class HomeController extends GetxController{
  final itemList = [
    MainItem(title: "Find Donors", imageUrl: bloodSearchImage),
    MainItem(title: "Donate", imageUrl: bloodDonateImage),
    MainItem(title: "Support", imageUrl: bloodDonateImage),
    MainItem(title: "Blood Request", imageUrl: bloodRequestImage),
    MainItem(title: "Blood Request", imageUrl: bloodRequestImage),
  ];
}