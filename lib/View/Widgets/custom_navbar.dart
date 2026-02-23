// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onCenterTap;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem("assets/home.svg", "Home", 0),
          _navItem("assets/calendar.svg", "Calendar", 1),
          _centerButton(),
          _navItem("assets/selfcare.svg", "Self Care", 2),
          _navItem("assets/profile.svg", "Profile", 3),
        ],
      ),
    );
  }

  Widget _navItem(String iconPath, String label, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected
                ? Colors.black
                : Colors.grey, // optional color tint
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutesName.todayScreen);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
