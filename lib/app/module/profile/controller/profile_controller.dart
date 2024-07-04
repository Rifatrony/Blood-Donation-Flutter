import 'package:blood_donation_app/app/utils/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  var isSwitched = false.obs;
  var canToggleSwitch = false.obs;
  var remainingDaysForNextDonation = 0.obs; // Add this variable

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxMap<String, dynamic> userProfile = RxMap<String, dynamic>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _fetchUserProfile);
  }

  Stream<Map<String, dynamic>> get userProfileStream {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user != null) {
        return _firestore.collection('users').doc(user.uid).snapshots().map((snapshot) {
          return snapshot.data() as Map<String, dynamic>;
        });
      } else {
        return Stream.value({});
      }
    });
  }

  void _fetchUserProfile(User? user) async {
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      userProfile.value = doc.data() as Map<String, dynamic>;
      _checkLastDonateDate(userProfile['lastDonate']);
    }
  }

  void _checkLastDonateDate(String? lastDonateDate) {
    if (lastDonateDate != null) {
      DateTime lastDonate = DateFormat('yyyy-MM-dd').parse(lastDonateDate);
      DateTime now = DateTime.now();
      DateTime nextDonationDate = lastDonate.add(const Duration(days: 90));
      remainingDaysForNextDonation.value = nextDonationDate.difference(now).inDays;

      if (remainingDaysForNextDonation.value <= 0) {
        canToggleSwitch.value = true;
        remainingDaysForNextDonation.value = 0; // Reset to 0 if negative
      } else {
        canToggleSwitch.value = false;
      }
    } else {
      canToggleSwitch.value = true;
      remainingDaysForNextDonation.value = 0;
    }
  }

  void toggleSwitch(bool value) {
    if (canToggleSwitch.value) {
      isSwitched.value = value;
    } else {
      CustomToast().errorToast('You can donate after ${remainingDaysForNextDonation.value} days');
      // Get.snackbar('Cannot Toggle', );
    }
  }
}
