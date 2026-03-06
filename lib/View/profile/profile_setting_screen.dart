// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floraheart/View/Widgets/custom_appbar.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_profile_field.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  int selectedIndex = 0;
  late String displayName;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final List<String> avatars = [
    "assets/image27.png",
    "assets/Rectangle.png",
    "assets/image4.png",
    "assets/image7.png",
    "assets/image8.png",
    "assets/image9.png",
    "assets/image13.png",
    "assets/image15.png",
    "assets/image16.png",
    "assets/image21.png",
    "assets/image22.png",
    "assets/image24.png",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      displayName = user.displayName ?? '';

      // Split display name into first and last name
      final nameParts = displayName.split(' ');
      if (nameParts.isNotEmpty) {
        firstNameController.text = nameParts[0];
        if (nameParts.length > 1) {
          lastNameController.text = nameParts.sublist(1).join(' ');
        }
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile Setting"
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightgrey,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Image.asset(avatars[selectedIndex], fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("Choose Avatar", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              avatars[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Tick Icon
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            top: 40,
                            child: Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "First Name",
                hintText: "Enter your first name",
                controller: firstNameController,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "Last Name",
                hintText: "Enter your last name",
                controller: lastNameController,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Update",
                ontap: () async {
                  final firstName = firstNameController.text.trim();
                  final lastName = lastNameController.text.trim();

                  if (firstName.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter your first name",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    String fullName = '$firstName $lastName'.trim();
                    final user = FirebaseAuth.instance.currentUser;

                    await user?.updateDisplayName(fullName);

                    // Save selected avatar path as photoURL
                    await user?.updatePhotoURL(avatars[selectedIndex]);

                    Get.snackbar(
                      "Success",
                      "Profile updated successfully",
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );

                    // Navigate back
                    Get.offNamed(AppRoutesName.mainScreen);
                    // Get.back();
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to update profile: $e",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
