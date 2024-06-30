import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/custom_toast.dart';
import '../../profile/controller/profile_controller.dart';

import 'dart:ui' as ui;

import '../../signup/controller/signup_controller.dart';

class DonorController extends GetxController {
  final List<String> bloodGroupList = [
    'All',
    'A +',
    'B +',
    'AB +',
    'O +',
    'A -',
    'B -',
    'AB -',
    'O -',
  ];

  final countryCode = "880".obs;
  final selectedBloodIndex = 0.obs;
  final selectedBloodGroup = 'All'.obs;
  final searchController = TextEditingController();

  final patientNameController = TextEditingController();
  final patientNumberController = TextEditingController();
  final patientProblemController = TextEditingController();
  final dateController = TextEditingController();
  final ageController = TextEditingController();
  final bloodAmountController = TextEditingController();
  final locationController = TextEditingController();
  final referenceController = TextEditingController();
  final commentsController = TextEditingController();

  final bloodAmount = 1.0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  RxList<Map<String, dynamic>> otherUsers = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> filteredUsers = RxList<Map<String, dynamic>>();
  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> mySendRequestList =
      RxList<Map<String, dynamic>>();

  var selectedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    searchController.addListener(_searchDonors);
    ever(firebaseUser, (user) {
      if (user != null) {
        fetchAllDonors(user);
      } else {}
    });
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = '${picked.toLocal()}'.split(' ')[0];
    }
  }

  // Future<void> fetchAllDonors(User? user) async {
  //   try {
  //     if (user != null) {
  //       isLoading.value = true;
  //       QuerySnapshot querySnapshot = await _firestore.collection('users').get();
  //
  //       otherUsers.value = querySnapshot.docs
  //           .map((doc) => doc.data() as Map<String, dynamic>)
  //           .where((data) => data['uid'] != user.uid)
  //           .toList();
  //       filterUsers();
  //       isLoading.value = false;
  //     } else {
  //       print("No User Found!!!");
  //     }
  //   } catch (e) {
  //     print("Error fetching donors: ${e.toString()}");
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchAllDonors(User? user) async {
    try {
      if (user != null) {
        isLoading.value = true;
        QuerySnapshot querySnapshot =
            await _firestore.collection('users').get();

        otherUsers.value = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((data) => data['uid'] != user.uid)
            .toList();

        filterUsers();
        // Update markers after fetching donors
        updateMarkers();

        isLoading.value = false;
      } else {
        print("No User Found!!!");
      }
    } catch (e) {
      print("Error fetching donors: ${e.toString()}");
      isLoading.value = false;
    }
  }

  final RxSet<Marker> markers = <Marker>{}.obs;
  final signUpController = Get.find<SignupController>();


  void updateMarkers() async {
    final newMarkers = <Marker>{};

    // Add a default marker for the current user's location
    var currentUserLat = signUpController.latitude.value;
    var currentUserLng = signUpController.longitude.value;
    var currentUserLatLng = LatLng(currentUserLat, currentUserLng);

    newMarkers.add(
      Marker(
        markerId: MarkerId('current_user'),
        position: currentUserLatLng,
        // infoWindow: InfoWindow(
        //     title: "Rony", // Assuming you have the current user's name in the controller
        //     snippet: '${signUpController.bloodGroup.value} ${signUpController.phone.value}' // Assuming you have the current user's blood group and phone in the controller
        // ),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), // Using default marker with Azure color
      ),
    );

    // Add markers for all other donors
    for (var donor in otherUsers) {
      final lat = double.parse(donor['latitude']);
      final lng = double.parse(donor['longitude']);
      final markerId = MarkerId(donor['uid']);
      var imageUrl = donor['imageUrl'];
      var bytes = (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
          .buffer
          .asUint8List();
      final resizedBytes = await resizeAndCircleImage(bytes, 100);

      newMarkers.add(
        Marker(
          markerId: markerId,
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: donor['name'],
              snippet: '${donor['bloodGroup']}   ${donor['phone']}'
          ),
          icon: BitmapDescriptor.fromBytes(resizedBytes),
        ),
      );
    }

    markers.value = newMarkers;
  }


  Future<Uint8List> resizeAndCircleImage(Uint8List bytes, int size) async {
    final codec = await ui.instantiateImageCodec(bytes,
        targetWidth: size, targetHeight: size);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();

    final radius = size / 2;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    paint.shader = ui.ImageShader(image, ui.TileMode.clamp, ui.TileMode.clamp,
        Matrix4.identity().storage);
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  void _searchDonors() {
    filterUsers();
  }

  void filterUsers() {
    String query = searchController.text.toLowerCase();
    String selectedGroup = selectedBloodGroup.value.toLowerCase();
    filteredUsers.value = otherUsers.where((user) {
      bool matchesQuery = user['name'].toLowerCase().contains(query) ||
          user['email'].toLowerCase().contains(query) ||
          user['phone'].contains(query) ||
          user['bloodGroup'].toLowerCase().contains(query);
      bool matchesBloodGroup = selectedGroup == 'all' ||
          user['bloodGroup'].toLowerCase() == selectedGroup;
      return matchesQuery && matchesBloodGroup;
    }).toList();
  }

  void updateBloodGroupFilter(String group, int index) {
    selectedBloodIndex.value = index;
    selectedBloodGroup.value = group;
    filterUsers();
  }

  makingPhoneCall(String number) async {
    final Uri url = Uri(scheme: "tel", path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can not launch");
    }
  }

  void sendRequest(int index) async {
    if (patientNameController.text.isEmpty) {
      CustomToast().errorToast("Patient name Required");
      return;
    } else if (bloodAmountController.text.isEmpty) {
      CustomToast().errorToast("Blood Amount Required");
      return;
    } else if (patientNumberController.text.isEmpty) {
      CustomToast().errorToast("Blood Amount Required");
      return;
    } else if (patientProblemController.text.isEmpty) {
      CustomToast().errorToast("Patient Problem Required");
      return;
    } else if (dateController.text.isEmpty) {
      CustomToast().errorToast("Date Required");
      return;
    } else if (locationController.text.isEmpty) {
      CustomToast().errorToast("Blood Location Required");
      return;
    } else {
      final currentUser = Get.find<ProfileController>().firebaseUser.value;
      final userDetails = filteredUsers[index];

      // Check if a request already exists
      bool requestExists =
          await checkIfRequestExists(currentUser?.uid, userDetails['uid']);
      if (requestExists) {
        CustomToast().errorToast("Request already sent to this person");
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('blood_requests').add({
          'senderId': currentUser?.uid,
          'receiverId': userDetails['uid'],
          'name': patientNameController.text,
          'phoneNumber': patientNumberController.text,
          'problem': patientProblemController.text,
          'age': ageController.text.isEmpty ? "" : ageController.text,
          'location': locationController.text,
          'donateDate': dateController.text,
          'bloodAmount': bloodAmountController.text,
          'bloodGroup': userDetails['bloodGroup'],
          // 'requestTime': ,
          'reference':
              referenceController.text.isEmpty ? "" : referenceController.text,
          'comments':
              commentsController.text.isEmpty ? "" : commentsController.text,
        });

        CustomToast().successToast("Request Sent Successfully");
      } catch (e) {
        Get.snackbar("Error", "Failed to send request: $e");
      }
    }
  }

  Future<bool> checkIfRequestExists(String? senderId, String receiverId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('blood_requests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloodAmount.close();
    searchController.dispose();
    patientNameController.dispose();
  }
}
