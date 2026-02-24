// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/View/Widgets/custom_cycle_card.dart';
import 'package:floraheart/View/Widgets/custom_search_bar.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class AllBlogsScreen extends StatefulWidget {
  const AllBlogsScreen({super.key});

  @override
  State<AllBlogsScreen> createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  String selectedChips = "All";

  final List<String> chip = [
    "All",
    "Cycle Syncing",
    "Nutrition & Wellness",
    "Pain & Management",
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
      "tag": "Pain & Management",
      "image": "assets/mountain.png",
    },
    {
      "title": "3 Foods to Fight the \"Period Bloat\"",
      "tag": "Nutrition & Wellness",
      "image": "assets/food.png",
    },
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
      "tag": "Pain & Management",
      "image": "assets/mountain.png",
    },
    {
      "title": "3 Foods to Fight the \"Period Bloat\"",
      "tag": "Nutrition & Wellness",
      "image": "assets/food.png",
    },
    {
      "title": "Heat vs. Cold: Which is better for cramps?",
      "tag": "Pain & Management",
      "image": "assets/mountain.png",
    },
  ];

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
          "All Blogs",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomSearchBar(),
          ),
          SizedBox(height: 15),

          /// ---------------- CHIP ----------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: chip.map((chip) {
                final bool isSelected = selectedChips == chip;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChips = chip;
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
          Expanded(
            child: ListView(
              children: articles
                  .where(
                    (article) =>
                        selectedChips == "All" ||
                        article["tag"] == selectedChips,
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
          ),
        ],
      ),
    );
  }
}
