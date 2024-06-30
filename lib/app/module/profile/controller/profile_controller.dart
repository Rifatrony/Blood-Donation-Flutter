import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isSwitched = false.obs;

  void toggleSwitch(bool value) {
    isSwitched.value = value;
  }

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

  void _fetchUserProfile(User? user) async {
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      userProfile.value = doc.data() as Map<String, dynamic>;
    }
  }
}