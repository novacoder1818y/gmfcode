import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChallengesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var challenges = <QueryDocumentSnapshot>[].obs;
  var completedChallenges = <String>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChallengesAndCompletions();
  }

  /// Fetches all challenges and the user's completed challenge IDs.
  Future<void> fetchChallengesAndCompletions() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;

      if (kDebugMode) {
        print("Fetching challenges for user: $userId");
      }

      if (userId == null) {
        // THIS IS THE FIX:
        // Instead of calling Get.snackbar directly, we schedule it to run
        // right after the build process is complete.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Error",
            "Please log in to see challenges.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        });

        challenges.clear();
        completedChallenges.clear();
        isLoading.value = false;
        return;
      }

      // Fetch all challenges from the main collection
      final challengesSnapshot = await _firestore.collection('challenges').get();

      if (kDebugMode) {
        print("Found ${challengesSnapshot.docs.length} challenges in Firestore.");
      }

      challenges.assignAll(challengesSnapshot.docs);

      // Fetch the IDs of challenges this user has already completed
      final completedSnapshot = await _firestore.collection('users').doc(userId).collection('completedChallenges').get();
      completedChallenges.assignAll(completedSnapshot.docs.map((doc) => doc.id).toSet());

      if (kDebugMode) {
        print("User has completed ${completedSnapshot.docs.length} challenges.");
      }

    } on FirebaseException catch (e) {
      Get.snackbar("Firebase Error", "Could not fetch challenges: ${e.message}");
      if (kDebugMode) {
        print("Firebase Error: ${e.code} - ${e.message}");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool hasCompleted(String challengeId) {
    return completedChallenges.contains(challengeId);
  }

  void markAsCompleted(String challengeId) {
    completedChallenges.add(challengeId);
    challenges.refresh();
  }
}