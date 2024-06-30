import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodRequestController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    // searchController.addListener(_searchDonors);
    ever(firebaseUser, (user) {
      if (user != null) {
        fetchSentRequests(user.uid);
        fetchReceivedRequests(user.uid);
      } else {
        sentRequests.clear();
        receivedRequests.clear();
      }

    });
  }

  final uid = "".obs;

  Future<void> getUid() async {
    final pref = await SharedPreferences.getInstance();
    uid.value = pref.getString('uid')!;
    log("Receive UID from SP is ====> $uid");
  }

  final patientNameController = TextEditingController();
  final patientNumberController = TextEditingController();

  final bloodGroupList = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  final selectedIndex = (-1).obs;
  final selectedBloodGroup = "".obs;
  final isLoadingReceivedRequest = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rx<User?> firebaseUser = Rx<User?>(null);
  RxList<Map<String, dynamic>> sentRequests = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> receivedRequests = RxList<Map<String, dynamic>>();


  Future<void> fetchReceivedRequests(String userId) async {
    try {
      isLoadingReceivedRequest.value = true;
      QuerySnapshot querySnapshot = await _firestore
          .collection('blood_requests')
          .where('receiverId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> requests = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['senderDetails'] = await getUserDetails(requestData['senderId']);
        requestData['receiverDetails'] = await getUserDetails(requestData['receiverId']);
        requests.add(requestData);
      }

      receivedRequests.assignAll(requests);
      isLoadingReceivedRequest.value = false;
    } catch (e) {
      print("Error fetching received requests: $e");
      isLoadingReceivedRequest.value = false;
    }
  }

  Future<void> fetchSentRequests(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('blood_requests')
          .where('senderId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> requests = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['senderDetails'] = await getUserDetails(requestData['senderId']);
        requestData['receiverDetails'] = await getUserDetails(requestData['receiverId']);
        requests.add(requestData);
      }

      sentRequests.assignAll(requests);
    } catch (e) {
      print("Error fetching sent requests: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print("User document does not exist for ID: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching user details for ID $userId: $e");
      return null;
    }
  }
}