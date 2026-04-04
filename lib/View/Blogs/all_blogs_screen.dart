// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/Widgets/custom_cycle_card.dart';
import 'package:floraheart/Widgets/custom_search_bar.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBlogsScreen extends StatefulWidget {
  const AllBlogsScreen({super.key});

  @override
  State<AllBlogsScreen> createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  String searchQuery = "";
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
      "image": "assets/smilinggirls.jpg",
      "content":
          "During the ovulation phase, your estrogen and testosterone levels peak. This hormonal surge often leads to increased energy, higher confidence, and a natural desire to socialize. It's the perfect time for meetings, parties, and connecting with others. Understanding this cycle helps you plan your social calendar to match your body's natural rhythms, allowing you to shine when you feel your best.",
    },
    {
      "title": "3 Foods to Fight the \"Period Bloat\"",
      "tag": "Nutrition & Wellness",
      "image": "assets/foodie.jpg",
      "content":
          "Period bloating is a common symptom caused by changes in progesterone and estrogen levels. To combat this, try incorporating these three foods: 1. Bananas, which are rich in potassium and help regulate fluid balance. 2. Ginger, a natural anti-inflammatory that aids digestion. 3. Leafy Greens like spinach, which provides magnesium to reduce water retention. Staying hydrated and reducing salt intake can also significantly help.",
    },
    {
      "title": "Heat vs. Cold: Which is better for cramps?",
      "tag": "Pain & Management",
      "image": "assets/HandC.jpg",
      "content":
          "When dealing with period cramps, heat is generally the preferred choice. Heat helps relax the uterine muscles and increases blood flow to the area, which can significantly reduce pain. A heating pad or a warm bath is often very effective. Cold therapy is less common for cramps but can be useful if there is specific inflammation or if you find it more soothing. Most experts recommend heat as the primary home remedy for menstrual discomfort.",
    },
    {
      "title": "Unlock Your \"Superhuman\" Strength Window",
      "tag": "Cycle Syncing",
      "image": "assets/pexelsgirl.jpg",
      "content":
          "Did you know there's a specific time in your cycle when you're naturally stronger? During the follicular phase, particularly leading up to ovulation, your body is primed for high-intensity workouts and strength training. Lower progesterone levels during this time mean your body can bounce back faster and handle heavier loads. By timing your toughest workouts to these 'superhuman' windows, you can maximize your fitness gains and work with your body's strengths.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "All Blogs"),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
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
                  .where((article) {
                    final matchesChip =
                        selectedChips == "All" ||
                        article["tag"] == selectedChips;

                    final matchesSearch = article["title"]!
                        .toLowerCase()
                        .contains(searchQuery);

                    return matchesChip && matchesSearch;
                  })
                  .map(
                    (article) => CustomArticleCard(
                      title: article["title"]!,
                      tag: article["tag"]!,
                      imagePath: article["image"]!,
                      onTap: () {
                        Get.toNamed(
                          AppRoutesName.blogsDetailScreen,
                          arguments: article,
                        );
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
