// ignore_for_file: deprecated_member_use, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floraheart/Widgets/custom_profile_listtile.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  Future<DocumentSnapshot> getUserData() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Profile card skeleton
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grey.withOpacity(0.3),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 180,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        // Cycle Information skeleton
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 130,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: 80,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: 60,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Health & body skeleton
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(height: 15),
                              ...List.generate(
                                3,
                                (index) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              width: 70,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (index < 2) ...[
                                      SizedBox(height: 10),
                                      Container(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Settings skeleton
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(height: 15),
                              ...List.generate(
                                6,
                                (index) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 150,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (index < 5) ...[
                                      SizedBox(height: 10),
                                      Container(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Button Skeleton
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          // var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            // optional for scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min, // removes default extra space
              children: [
                // Red header
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Profile card
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.all(15),
                  transform: Matrix4.translationValues(
                    0.0,
                    -35.0,
                    0.0,
                  ), // slightly up
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Profile picture
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: user?.photoURL != null
                              ? Image.asset(user!.photoURL!, fit: BoxFit.cover)
                              : Image.asset(
                                  "assets/image27.png",
                                  fit: BoxFit.cover,
                                ),
                          //                       child: user?.photoURL != null
                          // ? Image.network(user!.photoURL!, fit: BoxFit.cover)
                          // : Image.asset(
                          //     "assets/image27.png",
                          //     fit: BoxFit.cover,
                          //   ),
                        ),
                      ),
                      SizedBox(width: 15),
                      // Name & email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              // user?.displayName ?? 'Your Name',
                              data["name"] ?? "Your Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2), // smaller space
                            Text(
                              user?.email ?? 'email@example.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit button
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutesName.profileSettingScreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 15),
                              SizedBox(width: 3),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Cycle Information card
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // remove extra space
                    children: [
                      Text(
                        "Cycle Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      CustomProfileListtile(
                        image: "assets/cycleinfo.svg",
                        title: "Average Cycle Length",
                        // subtitle: "28 Days",
                        subtitle: "${data["cycleLength"]} Days",
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtile(
                        image: "assets/pdrops.svg",
                        title: "Average Period Duration",
                        // subtitle: "5 Days - Last period started 14 Jan, 2026",
                        subtitle: "${data["periodLength"]} Days",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                // Health and Body card
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // remove extra space
                    children: [
                      Text(
                        "Health & Body",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomProfileListtile(
                        image: "assets/dob.svg",
                        title: "Date of Birth",
                        // subtitle: "28 Jan, 1995",
                        subtitle: data["dob"] ?? "",
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtile(
                        image: "assets/height.svg",
                        title: "Height",
                        // subtitle: "05.06",
                        subtitle: data["height"] ?? "",
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtile(
                        image: "assets/weight.svg",
                        title: "Weight",
                        // subtitle: "60 kg",
                        subtitle: data["weight"] ?? "",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // remove extra space
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomProfileListtow(
                        image: "assets/password.svg",
                        title: "Password",
                        onTap: () {
                          Get.toNamed(AppRoutesName.passwordScreen);
                        },
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtow(
                        image: "assets/faq.svg",
                        title: "FAQ",
                        onTap: () {
                          Get.toNamed(AppRoutesName.faqScreen);
                        },
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtow(
                        image: "assets/report.svg",
                        title: "Bug report & Feedback",
                        onTap: () {
                          Get.toNamed(AppRoutesName.feedbackScreen);
                        },
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtow(
                        image: "assets/star.svg",
                        title: "Rate us on Google Play",
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtow(
                        image: "assets/share.svg",
                        title: "Share with friends",
                        onTap: () {
                          Share.share(
                            "Check out this amazing app! Download it from: https://yourappstorelink.com",
                            subject: "Amazing App",
                          );
                        },
                      ),
                      Divider(
                        color: AppColors.grey.withOpacity(0.3),
                        height: 1, // reduce divider spacing
                      ),
                      CustomProfileListtow(
                        image: "assets/privacy.svg",
                        title: "Privacy Policy",
                        onTap: () {
                          Get.toNamed(AppRoutesName.privacyPolicyScreen);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Center(
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white, // popup background color
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 50,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Cancel Button
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.lightgrey,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.back(); // close popup
                                    },
                                    child: const Text("Cancel"),
                                  ),

                                  // Logout Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () async {
                                      // Firebase logout
                                      await FirebaseAuth.instance.signOut();
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user == null) {
                                        print(
                                          "No user logged in — logout successful",
                                        );
                                      } else {
                                        print(
                                          "User is still logged in: ${user.email}",
                                        );
                                      }
                                      // Then navigate to login screen
                                      Get.offAllNamed(
                                        AppRoutesName.loginScreen,
                                      );
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: true, // tap outside to close
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log Out",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Icon(Icons.logout, color: AppColors.white, size: 18),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
