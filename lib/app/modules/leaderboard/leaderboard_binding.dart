// lib/modules/leaderboard/leaderboard_binding.dart

import 'package:get/get.dart';
import 'leaderboard_controller.dart';

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
  }
}