import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogsDetailScreen extends StatelessWidget {
  const BlogsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous screen
    final Map<String, String> data = Get.arguments ?? {
      "title": "Topic Detail",
      "tag": "General",
      "image": "assets/pexelsgirl.jpg",
      "content": "No content available."
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "All Detail"
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: data["image"]!.startsWith("assets/") 
                  ? Image.asset(
                      data["image"]!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data["image"]!,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    data["tag"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                data["title"]!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                data["content"]!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
