// lib/modules/auth/login.dart

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
          controller: controller.emailController, // Connect to controller
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
            controller: controller.passwordController, // Connect to controller
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
        const SizedBox(height: 40),
        Obx(
              () => controller.isLoading.value
              ? const CircularProgressIndicator()
              : NeonButton(
            text: 'Login',
            onTap: controller.signInWithEmail, // Call sign-in method
            gradientColors: const [Colors.cyan, Colors.blueAccent],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}