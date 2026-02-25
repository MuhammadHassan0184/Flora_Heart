// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16), // inner padding
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // background color
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.3), // border color
                ),
                borderRadius: BorderRadius.circular(20), // rounded corners
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Privacy Policy – FloraHeart",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Effective Date: 1 January 2001\n\n"
                    "FloraHeart is a period and menstrual cycle tracking application developed by TheWebConcept. We respect your privacy and are committed to protecting your personal information.\n\n"
                    "Information We Collect\n"
                    "FloraHeart collects only the data you choose to provide, such as:\n"
                    "• Menstrual cycle and period dates\n"
                    "• Symptoms, moods, and wellness information\n"
                    "• Optional sexual activity logs\n\n"
                    "We may also collect anonymous device and usage data to improve app performance.\n\n"
                    "How We Use Information\n"
                    "Your data is used only to:\n"
                    "• Track cycles and provide predictions\n"
                    "• Show reminders and insights\n"
                    "• Improve app functionality and stability\n\n"
                    "We do not use your data for advertising.\n\n"
                    "Data Sharing\n"
                    "We do not sell, share, or rent your personal or health data to third parties.\n"
                    "Data may be disclosed only if required by law.\n\n"
                    "Data Security & Control\n"
                    "• Your data is stored securely\n"
                    "• You can edit or delete your data anytime within the app\n"
                    "• Uninstalling the app removes locally stored data\n\n"
                    "Children’s Privacy\n"
                    "FloraHeart is not intended for users under the age of 13.\n\n"
                    "Contact Us\n"
                    "Developer: TheWebConcept\n"
                    "Email: info@thewebconcept.com\n"
                    "Website: thewebconcept.com",
                    style: TextStyle(
                      fontSize: 14,
                      // height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
