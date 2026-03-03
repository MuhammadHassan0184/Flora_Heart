// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floraheart/Services/auth_service.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> signup(String confirmPassword) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Get.snackbar("Error", "Please fill all fields.");
      Get.snackbar(
        "Error",
        "Please fill all fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF06292), // your pink theme
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: 15,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 300),
      );
      return;
    }

    if (password != confirmPassword) {
      // Get.snackbar("Error", "Passwords do not match.");
      Get.snackbar(
        "Error",
        "Passwords do not match.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF06292),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 15,
        icon: const Icon(Icons.lock_outline, color: Colors.white),
      );
      return;
    }

    try {
      isLoading.value = true;

      User? user = await _authService.signUp(email, password);

      isLoading.value = false;

      if (user != null) {
        print("User created successfully: ${user.uid}");

        // ✅ NAVIGATE IMMEDIATELY
        Get.offAllNamed(AppRoutesName.mainScreen);
      } else {
        // Get.snackbar("Error", "Signup failed.");
        Get.snackbar(
          "Error",
          "Signup failed.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF06292),
          colorText: Colors.white,
          margin: const EdgeInsets.all(20),
          borderRadius: 15,
          icon: const Icon(Icons.close, color: Colors.white),
        );
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Error", e.toString());
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF06292),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 15,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
