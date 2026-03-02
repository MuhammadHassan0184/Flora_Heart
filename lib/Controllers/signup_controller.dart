// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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
    Get.snackbar("Error", "Please fill all fields.");
    return;
  }

  if (password != confirmPassword) {
    Get.snackbar("Error", "Passwords do not match.");
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
      Get.snackbar("Error", "Signup failed.");
    }
  } catch (e) {
    isLoading.value = false;
    Get.snackbar("Error", e.toString());
  }
}
}
