import 'package:get/get.dart';
import 'auth_controller.dart';

/// Injects the AuthController to make it available to the AuthView.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}