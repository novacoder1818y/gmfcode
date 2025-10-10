// lib/modules/public_profile/public_profile_binding.dart

import 'package:get/get.dart';
import 'public_profile_controller.dart';

class PublicProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublicProfileController>(() => PublicProfileController());
  }
}