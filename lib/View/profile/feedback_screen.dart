// ignore_for_file: deprecated_member_use

import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/Widgets/custom_profile_field.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> sendEmail() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String message = messageController.text.trim();

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@thewebconcept.com',
      query: Uri.encodeFull(
        'subject=App Feedback&body=Name: $name\nEmail: $email\n\nMessage:\n$message',
      ),
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Bug Report & Feedback"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "Your Name",
                hintText: "Enter your name",
                controller: nameController,
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "Your Email",
                hintText: "Enter your email",
                controller: emailController,
              ),
            ),

            const SizedBox(height: 15),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [Text("Message", style: TextStyle(fontSize: 14))],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 13),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(17),
              ),
              child: TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type Your Note..",
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Send",
                // ontap: () {
                //   debugPrint("Send button tapped");
                //   sendEmail();
                // },
                ontap: () {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      messageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields")),
                    );
                  } else {
                    sendEmail();
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
