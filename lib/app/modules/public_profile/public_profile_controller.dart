// lib/modules/public_profile/public_profile_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../profile/level-service.dart';

class PublicProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LevelService _levelService = LevelService();

  Rxn<Map<String, dynamic>> userData = Rxn<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> achievements = RxList<Map<String, dynamic>>();

  RxBool isLoading = true.obs;
  RxnString errorMessage = RxnString();

  RxInt currentLevel = 1.obs;
  RxDouble levelProgress = 0.0.obs;
  RxInt nextLevelXp = 1000.obs;

  @override
  void onInit() {
    super.onInit();
    // This controller ALWAYS expects a 'uid' from arguments.
    final String? userIdFromArgs = Get.arguments?['uid'];

    if (userIdFromArgs != null && userIdFromArgs.isNotEmpty) {
      fetchUserProfile(userIdFromArgs);
    } else {
      errorMessage.value = "User ID was not provided.";
      isLoading.value = false;
    }
  }

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
}