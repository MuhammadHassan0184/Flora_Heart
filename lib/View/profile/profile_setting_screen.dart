// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_profile_field.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  int selectedIndex = 0;

  final List<String> avatars = [
    "assets/image27.png",
    "assets/Rectangle.png",
    "assets/image4.png",
    "assets/image7.png",
    "assets/image8.png",
    "assets/image9.png",
    "assets/image13.png",
    "assets/image15.png",
    "assets/image16.png",
    "assets/image21.png",
    "assets/image22.png",
    "assets/image24.png",
  ];

  TextEditingController? get lastNameController => null;

  TextEditingController? get firstNameController => null;

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
          "profile setting",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightgrey,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Image.asset(avatars[selectedIndex], fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("Choose Avatar", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              avatars[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Tick Icon
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            top: 40,
                            child: Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "First Name",
                hintText: "Enter your first name",
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomProfileField(
                label: "Last Name",
                hintText: "Enter your last name",
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(label: "Update", ontap: () {}),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
