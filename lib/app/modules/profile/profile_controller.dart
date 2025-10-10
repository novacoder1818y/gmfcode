// lib/modules/profile/profile_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'level-service.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LevelService _levelService = LevelService();

  // Observables remain the same
  Rxn<Map<String, dynamic>> userData = Rxn<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> completedChallenges = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> achievements = RxList<Map<String, dynamic>>();
  RxBool isLoading = true.obs;
  RxnString errorMessage = RxnString();
  RxInt currentLevel = 1.obs;
  RxDouble levelProgress = 0.0.obs;
  RxInt nextLevelXp = 1000.obs;

  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    // --- THIS LOGIC IS THE FIX ---

    // 1. Check if a user ID was passed as an argument from the leaderboard.
    final String? userIdFromArgs = Get.arguments?['uid'];

    // 2. Determine which user ID to fetch. Prioritize the one from arguments.
    final String targetUserId = userIdFromArgs ?? currentUser?.uid ?? '';

    // 3. Fetch the profile for the determined target user.
    if (targetUserId.isNotEmpty) {
      fetchUserProfile(targetUserId);
    } else {
      // This case handles when the user is not logged in and no ID was passed.
      errorMessage.value = "No user found.";
      isLoading.value = false;
    }
  }

  // No changes are needed in the methods below. They already work correctly with a given uid.
  Future<void> fetchUserProfile(String uid) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        _calculateLevelData();
      } else {
        errorMessage.value = "User profile not found.";
        isLoading.value = false;
        return;
      }

      QuerySnapshot challengesSnapshot = await _firestore.collection('users').doc(uid).collection('completedChallenges').get();
      completedChallenges.value = challengesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      QuerySnapshot achievementsSnapshot = await _firestore.collection('users').doc(uid).collection('achievements').get();
      achievements.value = achievementsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    } on FirebaseException catch (e) {
      errorMessage.value = "Error fetching profile: ${e.message}";
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateLevelData() {
    if (userData.value != null && userData.value!['xp'] != null) {
      final int totalXp = userData.value!['xp'];
      currentLevel.value = _levelService.calculateLevel(totalXp);
      levelProgress.value = _levelService.calculateLevelProgress(totalXp);
      nextLevelXp.value = _levelService.getNextLevelXp(totalXp);
    }
  }

  Future<void> updateUserName(String newName) async {
    if (newName.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty.', backgroundColor: Colors.red);
      return;
    }
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar('Error', 'You must be logged in to update your profile.');
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      await _firestore.collection('users').doc(currentUser.uid).update({'name': newName});
      await currentUser.updateDisplayName(newName);
      userData.value?['name'] = newName;
      userData.refresh();
      Get.back(); // Close loading
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Your name has been updated successfully.', backgroundColor: Colors.green);
    } on FirebaseException catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to update name: ${e.message}', backgroundColor: Colors.red);
    }
  }
}