import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var challenges = <QueryDocumentSnapshot>[].obs;
  var completedChallenges = <String>{}.obs; // Set of completed challenge IDs
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChallenges();
    fetchCompletedChallenges();
  }

  Future<void> fetchChallenges() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('challenges').get();
      challenges.assignAll(snapshot.docs);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompletedChallenges() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore.collection('users').doc(userId).collection('completedChallenges').get();
    completedChallenges.assignAll(snapshot.docs.map((doc) => doc.id).toSet());
  }

  bool hasCompleted(String challengeId) {
    return completedChallenges.contains(challengeId);
  }
}
