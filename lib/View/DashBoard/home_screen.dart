// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/View/Widgets/custom_date_card.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'dart:math';

// Add the wave package
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _waveProgress = 0.0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    // Controller to simulate progress for 3 seconds
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _waveController.addListener(() {
      setState(() {
        _waveProgress = _waveController.value;
      });
    });

    _waveController.forward(); // start animation
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/girl.png",
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        title: SizedBox(
          height: 30,
          child: SvgPicture.asset(
            "assets/homelogo.svg",
            fit: BoxFit.contain,
            width: 35,
            height: 35,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset("assets/bell.svg", width: 23, height: 23),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutesName.todayScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      width: 71,
                      height: 29,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.grey.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            "assets/PinkDrops.svg",
                            width: 21,
                            height: 21,
                          ),
                          Text("Edit", style: TextStyle(color: AppColors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // ---------------- PERIOD TRACKER ----------------
            SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer soft pink border
                  Container(
                    width: 210,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                        width: 12,
                      ),
                    ),
                  ),

                  // Dots on border
                  CustomPaint(
                    size: Size(213, 210),
                    painter: DotCirclePainter(
                      totalDots: 28,
                      highlightedDots: 4,
                    ),
                  ),

                  // Inner wave circle using wave package
                  ClipOval(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: WaveWidget(
                        config: CustomConfig(
                          gradients: [
                            [
                              AppColors.primary.withOpacity(0.6),
                              AppColors.primary.withOpacity(0.4)
                            ],
                            [
                              AppColors.primary.withOpacity(0.4),
                              AppColors.primary.withOpacity(0.2)
                            ],
                          ],
                          durations: [5000, 7000],
                          heightPercentages: [0.5 * _waveProgress, 0.52 * _waveProgress],
                        ),
                        backgroundColor: Colors.white,
                        waveAmplitude: 15,
                        size: Size(double.infinity, double.infinity),
                      ),
                    ),
                  ),

                  // Center text
                  Container(
                    width: 150,
                    height: 160,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Period",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkbrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Day 3",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkbrown,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Current day indicator
                  Positioned(
                    right: 25,
                    top: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Text(
                          "4",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DatesRow(),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              padding: EdgeInsets.all(3),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: SvgPicture.asset("assets/bulb.svg"),
                title: Text(
                  "Tip of the day!",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in justo nunc...",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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

// ---------------- DOT CIRCLE ----------------
class DotCirclePainter extends CustomPainter {
  final int totalDots;
  final int highlightedDots;

  DotCirclePainter({required this.totalDots, required this.highlightedDots});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final dotPaint = Paint()
      ..color = Colors.pink.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final activeDotPaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    for (int i = 0; i < totalDots; i++) {
      final angle = (i / totalDots) * 2 * pi;
      final x = center.dx + radius * 0.88 * cos(angle);
      final y = center.dy + radius * 0.88 * sin(angle);
      canvas.drawCircle(
        Offset(x, y),
        2.5,
        i < highlightedDots ? activeDotPaint : dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
