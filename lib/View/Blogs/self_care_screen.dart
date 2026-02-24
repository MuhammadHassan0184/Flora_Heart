// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, avoid_print

import 'package:floraheart/View/Widgets/custom_cycle_card.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({super.key});

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  String selectedChip = "All";

  final List<String> chips = [
    "All",
    "Cycle Syncing",
    "Nutrition & Wellness",
    "Pain",
  ];

  final List<Map<String, String>> articles = [
    {
      "title": "Why You Feel Like a Social Butterfly During Ovulation..",
      "tag": "Cycle Syncing",
      "image": "assets/3girls.png",
    },
    {
      "title": "3 Foods to Fight the \"Period Bloat\"",
      "tag": "Nutrition & Wellness",
      "image": "assets/food.png",
    },
    {
      "title": "Heat vs. Cold: Which is better for cramps?",
      "tag": "Pain Management",
      "image": "assets/mountain.png",
    },
    {
      "title": "3 Foods to Fight the \"Period Bloat\"",
      "tag": "Nutrition & Wellness",
      "image": "assets/food.png",
    },
    {
      "title": "Heat vs. Cold: Which is better for cramps?",
      "tag": "Pain Management",
      "image": "assets/mountain.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Self Care",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            /// ---------------- RECOMMENDED SECTION ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 26,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutesName.allBlogsScreen);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: AppColors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            /// Horizontal Banner
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _recommendedCard(),
                    SizedBox(width: 10),
                    _recommendedCard(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: AppColors.grey.withOpacity(0.3)),
            ),

            SizedBox(height: 10),

            /// ---------------- CHIPS ----------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: chips.map((chip) {
                  final bool isSelected = selectedChip == chip;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChip = chip;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          chip,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 15),

            /// ---------------- ARTICLE LIST ----------------
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: articles
                  .where(
                    (article) =>
                        selectedChip == "All" || article["tag"] == selectedChip,
                  )
                  .map(
                    (article) => CustomArticleCard(
                      title: article["title"]!,
                      tag: article["tag"]!,
                      imagePath: article["image"]!,
                      onTap: () {
                        print(article["title"]);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _recommendedCard() {
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutesName.blogsDetailScreen);
        },
        child: Container(
          width: 270,
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.lightgrey,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Image.asset("assets/pexelsgirl.jpg", fit: BoxFit.cover),
        ),
      ),
      SizedBox(height: 10),
      SizedBox(
        width: 270,
        child: Text(
          "Unlock Your \"Superhuman\" Strength Window",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
        ),
      ),
    ],
  );
}
