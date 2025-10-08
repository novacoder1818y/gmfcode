// lib/modules/auth/signup.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../widgets/neon_button.dart';
import 'auth_controller.dart';

class SignupWidget extends GetView<AuthController> {
  const SignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create Your Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        TextFormField(
          controller: controller.fullNameController, // Connect to controller
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
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
            text: 'Sign Up',
            onTap: controller.signUpWithEmail, // Call sign-up method
            gradientColors: const [Colors.purpleAccent, Colors.pinkAccent],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}