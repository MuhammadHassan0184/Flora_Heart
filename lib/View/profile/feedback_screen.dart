// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_profile_field.dart';
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

    // Encode subject and body
    final String subject = Uri.encodeComponent("App Feedback");
    final String body = Uri.encodeComponent(
      "Name: $name\nEmail: $email\n\nMessage:\n$message",
    );

    final Uri emailUri = Uri.parse(
      "mailto:info@thewebconcept.com?subject=$subject&body=$body",
    );

    debugPrint("Attempting to send email...");
    debugPrint("Email URI: $emailUri");

    try {
      final canLaunchResult = await canLaunchUrl(emailUri);
      debugPrint("Can launch email URI? $canLaunchResult");

      if (canLaunchResult) {
        final launchResult = await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint("Email launch result: $launchResult");
      } else {
        debugPrint("Could not launch the email app.");
      }
    } catch (e) {
      debugPrint("Error while launching email: $e");
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
          "Bug Report & Feedback",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
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
