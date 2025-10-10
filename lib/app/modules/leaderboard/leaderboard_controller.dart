// lib/modules/leaderboard/leaderboard_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GETTER TO EXPOSE THE CURRENT USER'S ID
  String? get currentUserId => _auth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
    return _firestore
        .collection('users')
        .orderBy('xp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .toList();
    });
  }
}