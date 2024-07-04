import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/custom_toast.dart';

class BloodRequestController extends GetxController {

  final dateController = TextEditingController();
  final locationController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    // searchController.addListener(_searchDonors);
    ever(firebaseUser, (user) {
      if (user != null) {
        // fetchSentRequests(user.uid);
        // fetchReceivedRequests(user.uid);
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
  final isSentRequestLoading = false.obs;
  RxList<Map<String, dynamic>> sentRequests = RxList<Map<String, dynamic>>();
  final isReceivedRequestLoading = false.obs;
  RxList<Map<String, dynamic>> receivedRequests = RxList<Map<String, dynamic>>();

  bool isToday(Timestamp timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = timestamp.toDate();
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    return today == checkDate;
  }

  bool isLast7Days(Timestamp timestamp) {
    final now = DateTime.now();
    final dateToCheck = timestamp.toDate();
    return now.difference(dateToCheck).inDays <= 7 && !isToday(timestamp);
  }

  bool isLast24Hours(Timestamp timestamp) {
    final now = DateTime.now();
    final dateToCheck = timestamp.toDate();
    return now.difference(dateToCheck).inHours < 24;
  }

  Stream<Map<String, List<Map<String, dynamic>>>> fetchReceivedRequestsStream(String userId) {
    return _firestore
        .collection('blood_requests')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> allRequests = [];
      List<Map<String, dynamic>> todayList = [];
      List<Map<String, dynamic>> last7DaysList = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['senderDetails'] = await getUserDetails(requestData['senderId']);
        requestData['receiverDetails'] = await getUserDetails(requestData['receiverId']);

        if (requestData.containsKey('requestTime')) {
          Timestamp requestTime = requestData['requestTime'];
          requestData['timestamp'] = requestTime; // Ensure timestamp is present

          if (isToday(requestTime)) {
            todayList.add(requestData);
          } else if (isLast7Days(requestTime)) {
            last7DaysList.add(requestData);
          }
        }
        allRequests.add(requestData);
      }

      return {
        'allRequests': allRequests,
        'todayList': todayList,
        'last7DaysList': last7DaysList,
      };
    });
  }

  Stream<Map<String, List<Map<String, dynamic>>>> fetchSentRequestsStream(String userId) {
    return _firestore
        .collection('blood_requests')
        .where('senderId', isEqualTo: userId)
        .where('status', isEqualTo: 'Pending')  // Filter for status 'Pending'
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> allRequests = [];
      List<Map<String, dynamic>> todayList = [];
      List<Map<String, dynamic>> last7DaysList = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['senderDetails'] = await getUserDetails(requestData['senderId']);
        requestData['receiverDetails'] = await getUserDetails(requestData['receiverId']);
        requestData['requestId'] = doc.id;  // Add requestId to the data

        if (requestData.containsKey('requestTime')) {
          Timestamp requestTime = requestData['requestTime'];
          requestData['timestamp'] = requestTime; // Ensure timestamp is present

          if (isLast24Hours(requestTime)) {
            todayList.add(requestData);
          } else if (isLast7Days(requestTime)) {
            last7DaysList.add(requestData);
          } else {
            allRequests.add(requestData);
          }
        } else {
          allRequests.add(requestData);
        }
      }

      // Sort lists by requestTime (most recent first)
      allRequests.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      todayList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      last7DaysList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      return {
        'allRequests': allRequests,
        'todayList': todayList,
        'last7DaysList': last7DaysList,
      };
    });
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

  void updateRequestCommonFunction(String requestId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update(updatedData);
      CustomToast().successToast("Request Updated Successfully");
    } catch (e) {
      print("================== Error ==================");
      print(e.toString());
      Get.snackbar("Error", "Failed to update request: $e");
    }
  }

  void updateDateAndLocation(String date, String location, String id) {
    Map<String, dynamic> updatedData = {
      'location': location,
      'donateDate': date,
    };
    updateRequestCommonFunction(id, updatedData);
  }

  void updateStatus(String status, String id) {
    Map<String, dynamic> updatedData = {
      'status': status,
    };
    updateRequestCommonFunction(id, updatedData);
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).delete();
      CustomToast().successToast("Request Deleted Successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete request: $e");
    }
  }

  void checkFunction(String date, String location) {
    //donateDate
    //location
    // print(object)
    print(date);
    print(location);
  }





  @override
  void dispose() {
    // TODO: implement dispose
    patientNameController.dispose();
    patientNumberController.dispose();
    dateController.dispose();
    locationController.dispose();
    super.dispose();
  }
}