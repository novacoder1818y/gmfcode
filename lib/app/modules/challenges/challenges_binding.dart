import 'package:get/get.dart';
import 'challenges_controller.dart';

/// Injects the ChallengesController so it's available to the view.
class ChallengesBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut will create the controller only when it's needed for the first time.
    Get.lazyPut<ChallengesController>(() => ChallengesController());
  }
}
