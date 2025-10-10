// lib/modules/auth/auth_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Public getter for FirebaseAuth instance
  FirebaseAuth get auth => _auth;

  var isLogin = true.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

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

  void toggleForm() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

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
        _showVerificationDialog();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Sign Up Failed', e.message ?? 'An unknown error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Get.back(); // Close the dialog
      Get.snackbar('Success', 'A password reset link has been sent to your email.', backgroundColor: Colors.green, colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An unknown error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


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
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'An unknown error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

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
          Get.offAllNamed(Routes.AUTH);
        } catch (e) {
          Get.snackbar('Error', 'Failed to sign out. Please try again.',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
    );
  }

  Future<void> _createUserDocument(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.set({
      'name': fullNameController.text.trim(),
      'email': user.email,
      'uid': user.uid,
      'joinedDate': Timestamp.now(),
      'points': 0,
      'xp': 0,
      'level': 1,
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