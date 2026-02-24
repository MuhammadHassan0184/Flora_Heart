// ignore_for_file: avoid_print

import 'package:floraheart/View/Blogs/self_care_screen.dart';
import 'package:floraheart/View/Calendar/calendar_screen.dart';
import 'package:floraheart/View/DashBoard/home_screen.dart';
import 'package:floraheart/View/Widgets/custom_navbar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CalendarScreen(),
    SelfCareScreen(),
    Center(child: Text("Profile Screen")),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCenterTap() {
    print("Center button tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onCenterTap: _onCenterTap,
      ),
    );
  }
}
