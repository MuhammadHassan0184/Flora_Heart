// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/Controllers/dashboard_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/Controllers/today_data_controller.dart';
// import 'package:floraheart/Services/notification_service.dart';
import 'package:floraheart/Widgets/custom_date_card.dart';
import 'package:floraheart/Widgets/custom_edit_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:floraheart/Controllers/today_controller.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  double get _waveProgress => _waveController.value;

  final user = FirebaseAuth.instance.currentUser;

  /// ✅ Controllers (SAFE INIT)
  late TodayDataController todayCtrl;
  late PeriodController periodCtrl;

  @override
  void initState() {
    super.initState();

    /// ✅ Assign AFTER put
    todayCtrl = Get.find<TodayDataController>();
    periodCtrl = Get.find<PeriodController>();

    // Notification scheduling is now handled by TodayController onInit
    if (!Get.isRegistered<TodayController>()) {
      Get.put(TodayController(), permanent: true);
    }

    /// Animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _waveController.addListener(() {
      setState(() {});
    });

    _waveController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              dashboardController.updateIndex(3);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1DDDD)),
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(50),
              ),
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    child: user?.photoURL != null
                        ? Image.asset(user!.photoURL!)
                        : Image.asset("assets/girl.png", width: 30, height: 30),
                  );
                },
              ),
            ),
          ),
        ),
        title: SizedBox(
          height: 30,
          child: SvgPicture.asset("assets/homelogo.svg"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset("assets/bell.svg", width: 23),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [CustomEditButton()],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- PERIOD TRACKER ----------------
            SizedBox(height: 30),
            Obx(() {
              int day = periodCtrl.cycleDay;
              bool isRunning = periodCtrl.isPeriodRunning;
              int highlighted = isRunning ? day : 0;
              if (highlighted > 28) highlighted = 28;

              return Center(
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
                        highlightedDots: highlighted,
                      ),
                    ),

                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: WaveWidget(
                          config: CustomConfig(
                            gradients: [
                              [
                                AppColors.primary.withOpacity(0.6),
                                AppColors.primary.withOpacity(0.4),
                              ],
                              [
                                AppColors.primary.withOpacity(0.4),
                                AppColors.primary.withOpacity(0.2),
                              ],
                            ],
                            durations: [5000, 7000],
                            heightPercentages: [
                              0.5 * _waveProgress,
                              0.52 * _waveProgress,
                            ],
                          ),
                          backgroundColor: Colors.white,
                          waveAmplitude: 15,
                          size: Size(double.infinity, double.infinity),
                        ),
                      ),
                    ),

                    // ClipOval(
                    //   child: SizedBox(
                    //     width: 150,
                    //     height: 150,
                    //     child: TweenAnimationBuilder<double>(
                    //       tween: Tween(begin: 0, end: 1),
                    //       duration: const Duration(seconds: 2),
                    //       curve: Curves.easeOut,
                    //       builder: (context, value, child) {
                    //         double fillFactor = isRunning ? 0.6 : 0.3;
                    //         return Stack(
                    //           alignment: Alignment.bottomCenter,
                    //           children: [
                    //             Container(color: Colors.white),
                    //             FractionallySizedBox(
                    //               heightFactor: fillFactor * value,
                    //               widthFactor: 1,
                    //               child: Container(
                    //                 decoration: BoxDecoration(
                    //                   gradient: LinearGradient(
                    //                     begin: Alignment.topCenter,
                    //                     end: Alignment.bottomCenter,
                    //                     colors: [
                    //                       AppColors.primary.withOpacity(0.6),
                    //                       AppColors.primary.withOpacity(0.3),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),

                    // Center text
                    Container(
                      width: 150,
                      height: 160,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isRunning ? "Period" : "Cycle",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.darkbrown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Day $day",
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
                            "$day",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            /// Dates Row
            Obx(() {
              if (!periodCtrl.isLoaded.value ||
                  periodCtrl.periodStart.value == null) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DatesRow(
                  fertilityWindow: periodCtrl.fertilityWindow,
                  ovulationDate: periodCtrl.ovulationDate,
                  nextPeriodDate: periodCtrl.nextPeriodDate,
                ),
              );
            }),

            const SizedBox(height: 20),

            /// ---------------- TIP CONTAINER ----------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: SvgPicture.asset("assets/bulb.svg"),
                title: const Text(
                  "Tip of the day!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                /// 🔥 SAFE TIP DISPLAY
                subtitle: Obx(() {
                  try {
                    return Text(
                      todayCtrl.getDailyTip(periodCtrl),
                      style: const TextStyle(fontSize: 12),
                    );
                  } catch (e) {
                    return const Text("Loading tip...");
                  }
                }),
              ),
            ),
            // const SizedBox(height: 10),

            //           /// --- TEST NOTIFICATION BUTTON ---
            //           TextButton.icon(
            //             onPressed: () {
            //               Get.find<TodayController>().testNotification();
            //             },
            //             icon: Icon(Icons.notifications_active, color: AppColors.primary),
            //             label: Text("Test Daily Notification", style: TextStyle(color: AppColors.primary)),
            //           ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// ---------------- DOT CIRCLE ----------------
class DotCirclePainter extends CustomPainter {
  final int totalDots;
  final int highlightedDots;

  DotCirclePainter({required this.totalDots, required this.highlightedDots});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final dotPaint = Paint()..color = Colors.pink.withOpacity(0.3);
    final activePaint = Paint()..color = Colors.pink;

    for (int i = 0; i < totalDots; i++) {
      final angle = (i / totalDots) * 2 * pi;
      final x = center.dx + radius * 0.88 * cos(angle);
      final y = center.dy + radius * 0.88 * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        2.5,
        i < highlightedDots ? activePaint : dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
