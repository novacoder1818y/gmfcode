// lib/modules/dashboard/dashboard_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _updateLastLogin();
  }

  /// Updates the 'lastLogin' field for the current user in Firestore.
  Future<void> _updateLastLogin() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'lastLogin': FieldValue.serverTimestamp()});
        print("Updated lastLogin for user ${currentUser.uid}");
      } catch (e) {
        // This can happen if the user document doesn't exist yet, which is unlikely
        // after login. You can handle this error if necessary.
        print("Error updating lastLogin: $e");
      }
    }
  }
}