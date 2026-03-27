// ignore_for_file: avoid_print

import 'package:floraheart/Controllers/dashboard_controller.dart';
import 'package:floraheart/View/Blogs/self_care_screen.dart';
import 'package:floraheart/View/Calendar/calendar_screen.dart';
import 'package:floraheart/View/DashBoard/home_screen.dart';
import 'package:floraheart/Widgets/custom_navbar.dart';
import 'package:floraheart/View/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DashboardController dashboardController = Get.put(DashboardController());

  final List<Widget> _screens = [
    const HomeScreen(),
    CalendarScreen(),
    SelfCareScreen(),
    ProfileScreen(),
  ];

  void _onItemSelected(int index) {
    dashboardController.updateIndex(index);
  }

  void _onCenterTap() {
    print("Center button tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[dashboardController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => CustomBottomBar(
          selectedIndex: dashboardController.selectedIndex.value,
          onItemSelected: _onItemSelected,
          onCenterTap: _onCenterTap,
        ),
      ),
    );
  }
}
