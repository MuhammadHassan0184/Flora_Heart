// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  height: 40,
  child: TextField(
    textAlignVertical: TextAlignVertical.center, // 👈 important
    decoration: InputDecoration(
      isDense: true, // 👈 reduces default height
      contentPadding: EdgeInsets.symmetric(vertical: 0),

      prefixIcon: Icon(Icons.search, color: AppColors.grey),

      hintText: "Search for article..",
      hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
    ),
  ),
);
  }
}