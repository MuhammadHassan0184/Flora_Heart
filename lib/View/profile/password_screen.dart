// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_profile_field.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> updatePassword() async {
    try {
      if (newPasswordController.text != confirmPasswordController.text) {
        Get.snackbar(
          "Error",
          "Passwords do not match",
          backgroundColor: AppColors.primary.withOpacity(0.1),
          colorText: AppColors.primary,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPasswordController.text);

        Get.snackbar(
          "Success",
          "Password updated successfully",
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );

        /// Navigate to Main Screen
        Get.offAllNamed(AppRoutesName.profileScreen);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomProfileField(
              controller: newPasswordController,
              label: "New Password",
              hintText: "Enter new password",
              isPassword: true,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomProfileField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              hintText: "Confirm password",
              isPassword: true,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              label: "Update",
              ontap: () {
                updatePassword();
              },
            ),
          ),
        ],
      ),
    );
  }
}
