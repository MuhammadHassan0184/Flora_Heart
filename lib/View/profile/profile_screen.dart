// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_profile_listtile.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // optional for scrolling
        child: Column(
          mainAxisSize: MainAxisSize.min, // removes default extra space
          children: [
            // Red header
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Profile card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: const EdgeInsets.all(15),
              transform: Matrix4.translationValues(
                0.0,
                -35.0,
                0.0,
              ), // slightly up
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile picture
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Image.asset("assets/image27.png", fit: BoxFit.cover),
                  ),
                  SizedBox(width: 15),
                  // Name & email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sara Hoseini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2), // smaller space
                        Text(
                          'sarahoseini@gmail.com',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Edit button
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutesName.profileSettingScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 15),
                          SizedBox(width: 3),
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cycle Information card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // remove extra space
                children: [
                  Text(
                    "Cycle Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  CustomProfileListtile(
                    image: "assets/cycleinfo.svg",
                    title: "Average Cycle Length",
                    subtitle: "28 Days",
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtile(
                    image: "assets/pdrops.svg",
                    title: "Average Period Duration",
                    subtitle: "5 Days - Last period started 14 Jan, 2026",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Health and Body card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // remove extra space
                children: [
                  Text(
                    "Health & Body",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  CustomProfileListtile(
                    image: "assets/dob.svg",
                    title: "Date of Birth",
                    subtitle: "28 Jan, 1995",
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtile(
                    image: "assets/height.svg",
                    title: "Height",
                    subtitle: "05.06",
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtile(
                    image: "assets/weight.svg",
                    title: "Weight",
                    subtitle: "60 kg",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // remove extra space
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  CustomProfileListtow(
                    image: "assets/password.svg",
                    title: "Password",
                    onTap: () {
                      Get.toNamed(AppRoutesName.passwordScreen);
                    },
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtow(image: "assets/faq.svg", title: "FAQ", onTap: () {
                    Get.toNamed(AppRoutesName.faqScreen);
                  },),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtow(
                    image: "assets/report.svg",
                    title: "Bug report & Feedback",
                    onTap: () {
                      Get.toNamed(AppRoutesName.feedbackScreen);
                    },
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtow(
                    image: "assets/star.svg",
                    title: "Rate us on Google Play",
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtow(
                    image: "assets/share.svg",
                    title: "Share with friends",
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.3),
                    height: 1, // reduce divider spacing
                  ),
                  CustomProfileListtow(
                    image: "assets/privacy.svg",
                    title: "Privacy Policy",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutesName.loginScreen);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                    SizedBox(width: 7),
                    Icon(Icons.logout, color: AppColors.white, size: 18),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
