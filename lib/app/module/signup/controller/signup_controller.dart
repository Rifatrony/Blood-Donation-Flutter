import 'dart:async';
import 'dart:io';

import 'package:blood_donation_app/app/module/splash/controller/splash_controller.dart';
import 'package:blood_donation_app/app/utils/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../route/routes.dart';
import 'package:path/path.dart' as path;

import '../../../services/notification_services.dart';

class SignupController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getLocation();
    notificationServices.getDeviceToken().then((value){
      print("Device token ===========> $value");
      deviceToken.value = value;
    });
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }
  var selectedBloodGroup = Rxn<String>();

  final deviceToken = "".obs;

  // final SplashController

  final latitude = 24.0522954.obs;
  final longitude = 90.2869617.obs;
  var address = 'Getting Address..'.obs;
  late StreamSubscription<Position> streamSubscription;

  getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      getAddressFromLatLang(position);
      print('Latitude is ${position.latitude}');
      print('Longitude is ${position.longitude}');
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.value = 'Address : ${place.locality},${place.country}';
    // print('Address: ${place.subAdministrativeArea}');
  }

  final List<String> bloodGroupList = [
    'A +',
    'B +',
    'AB +',
    'O +',
    'A -',
    'B -',
    'AB -',
    'O -',
  ];

  void setSelectedBloodGroup(String? value) {
    selectedBloodGroup.value = value;
  }

  Rx<XFile?> image = Rx<XFile?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image.value = pickedImage;
    }
  }

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final lastDonateController = TextEditingController();
  final passwordController = TextEditingController();


  final age = 0.obs;

  final countryCode = "880".obs;

  final didHadLastDonate = false.obs;

  final isLoading = false.obs;

  final isVisible = true.obs;

  void toggleLastDonate() {
    didHadLastDonate.value = !didHadLastDonate.value;
  }

  NotificationServices notificationServices = NotificationServices();



  var selectedDate = Rxn<DateTime>();

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate.value = picked;
      lastDonateController.text = '${picked.toLocal()}'.split(' ')[0];
    }
  }

  Future<XFile> resizeImage(XFile file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/temp_image.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 85,
      minWidth: 512,
    );

    print("Result is $result");
    return XFile(result!.path);
  }

  Future<String?> uploadImage(XFile file) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images/${file.name}');
      final uploadTask = storageRef.putFile(File(file.path));

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  signUp() async {

    age.value = int.parse(ageController.text);
    if (nameController.text.isEmpty) {
      CustomToast().errorToast('Name Required');
      return;
    } else if (image.value == null) {
      CustomToast().errorToast('Image Required');
      return;
    } else if (emailController.text.isEmpty) {
      CustomToast().errorToast('Email Required');
      return;
    } else if (phoneController.text.isEmpty) {
      CustomToast().errorToast('Number Required');
      return;
    }

    else if (age.value < 18) {
      CustomToast().errorToast('Age Should be at least 18');
      return;
    }
    else if (didHadLastDonate.value == true &&
        lastDonateController.text.isEmpty) {
      CustomToast().errorToast('Select Last Donate Date');
      return;
    } else if (selectedBloodGroup.value == null ||
        selectedBloodGroup.value == "") {
      CustomToast().errorToast('Select your blood group');
      return;
    }


    else if (passwordController.text.isEmpty) {
      CustomToast().errorToast('Password Required');
      return;
    } else {
      try {
        isLoading.value = true;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          // String? imageUrl;

          String fileName = path.basename(image.value!.path);
          Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('uploads/$fileName');
          UploadTask uploadTask =
              firebaseStorageRef.putFile(File(image.value!.path));
          TaskSnapshot taskSnapshot = await uploadTask;

          // Get the image URL
          String imageUrl = await taskSnapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': nameController.text,
            'age': age.value.toString(),
            'email': emailController.text,
            'phone': "+${countryCode.value}${phoneController.text}",
            'lastDonate': didHadLastDonate.value == false
                ? ""
                : lastDonateController.text,
            'bloodGroup': selectedBloodGroup.value,
            'imageUrl': imageUrl ?? '',
            'latitude': latitude.value.toString(),
            'longitude': longitude.value.toString(),
            'deviceToken': deviceToken.toString(),
          });

          Get.snackbar("Success", "Registration Successful");
          Get.toNamed(RouteName.login);
          isLoading.value = false;

          clearFormFields();
        }
        isLoading.value = false;
      } catch (e) {
        print(e.toString());
        Get.snackbar("Sign Up Error", e.toString(),
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
      }
    }
  }

  void clearFormFields() {
    nameController.clear();
    ageController.clear();
    emailController.clear();
    phoneController.clear();
    lastDonateController.clear();
    passwordController.clear();
    selectedBloodGroup.value = null;
    didHadLastDonate.value = false;
    image.value = null;
  }
}
