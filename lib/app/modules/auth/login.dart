import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../widgets/neon_button.dart';
import 'auth_controller.dart';

class LoginWidget extends GetView<AuthController> {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome Back!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Obx(
              () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        // --- THIS IS THE NEW FEATURE ---
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(context),
              child: const Text('Forgot Password?'),
            ),
          ),
        ),
        // --- END OF NEW FEATURE ---

        const SizedBox(height: 20),
        Obx(
              () => controller.isLoading.value
              ? const CircularProgressIndicator()
              : NeonButton(
            text: 'Login',
            onTap: controller.signInWithEmail,
            gradientColors: const [Colors.cyan, Colors.blueAccent],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  // --- THIS IS THE NEW DIALOG WIDGET ---
  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();
    Get.defaultDialog(
      title: "Reset Password",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter your email address to receive a password reset link."),
          const SizedBox(height: 20),
          TextFormField(
            controller: resetEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      confirm: Obx(
            () => controller.isLoading.value
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () {
            controller.sendPasswordResetEmail(resetEmailController.text);
          },
          child: const Text("Send Link"),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }
}