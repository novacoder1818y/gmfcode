// lib/modules/profile/profile_binding.dart

import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // THIS IS THE FIX:
    // fenix: true re-creates the controller every time the page is visited.
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}