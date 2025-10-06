import 'package:get/get.dart';

/// Manages the state for the authentication screen.
class AuthController extends GetxController {
  // A reactive boolean to track if the user is on the Login or Signup form.
  var isLogin = true.obs;

  // Reactive booleans to manage the visibility of passwords.
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  /// Toggles between the Login and Signup forms.
  void toggleForm() {
    isLogin.value = !isLogin.value;
  }

  /// Toggles the visibility of the main password field.
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggles the visibility of the confirm password field (for signup).
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
}