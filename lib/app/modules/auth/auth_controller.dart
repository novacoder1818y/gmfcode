// lib/modules/auth/auth_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 1. ADD THIS IMPORT FOR YOUR ROUTE NAMES
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // UI State Management
  var isLogin = true.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Form Text Editing Controllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // --- UI Methods ---
  void toggleForm() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // --- Firebase Sign Up Method ---
  Future<void> signUpWithEmail() async {
    if (fullNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
        await userCredential.user!.sendEmailVerification();
        emailController.clear();
        passwordController.clear();
        _showVerificationDialog();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Sign Up Failed', e.message ?? 'An unknown error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Firebase Sign In Method ---
  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password are required.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.reload();
        final refreshedUser = _auth.currentUser;

        if (refreshedUser != null && !refreshedUser.emailVerified) {
          await _auth.signOut();
          Get.snackbar('Verification Required', 'Please check your inbox and verify your email address.', backgroundColor: Colors.orange, colorText: Colors.white);
        }
        else
          {
            emailController.clear();
            passwordController.clear();
            Get.offAllNamed(Routes.DASHBOARD);
          }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'An unknown error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- UPDATED: Sign Out Method with Confirmation and Navigation ---
  void signOut() {
    Get.defaultDialog(
      title: "Confirm Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      textCancel: "Cancel",
      onConfirm: () async {
        try {
          await _auth.signOut();
          // 2. ADD THIS LINE TO EXPLICITLY NAVIGATE
          // This removes all previous pages and pushes the Auth page.
          Get.offAllNamed(Routes.AUTH);
        } catch (e) {
          Get.snackbar('Error', 'Failed to sign out. Please try again.',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }

  // --- Helper Methods ---
  Future<void> _createUserDocument(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.set({
      'name': fullNameController.text.trim(),
      'email': user.email,
      'uid': user.uid,
      'joinedDate': Timestamp.now(),
      'points': 0,
    });
  }

  void _showVerificationDialog() {
    Get.defaultDialog(
      title: "Verify Your Email",
      middleText: "A verification link has been sent to your email. Please verify your account to log in.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        isLogin.value = true;
        Get.back();
      },
    );
  }
}