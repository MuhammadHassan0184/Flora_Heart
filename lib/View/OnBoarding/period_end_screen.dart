import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floraheart/Controllers/onboarding_controller.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/View/DashBoard/main_screen.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/Widgets/custom_calendar.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeriodEndScreen extends StatefulWidget {
  final VoidCallback onNext;

  const PeriodEndScreen({super.key, required this.onNext});

  @override
  State<PeriodEndScreen> createState() => _PeriodEndScreenState();
}

class _PeriodEndScreenState extends State<PeriodEndScreen> {
  late PeriodController periodCtrl;

  @override
  void initState() {
    super.initState();
    periodCtrl = Get.put(PeriodController(), permanent: true);
    periodCtrl.loadPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              "When did your last\nperiod end?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 40),

            // calendar widget replaced by shared CustomCalendar
            Obx(
              () => CustomCalendar(
                initialStartDate: periodCtrl.periodStart.value,
                initialEndDate: periodCtrl.periodEnd.value,
                onRangeSelected: (s, e) {
                  periodCtrl.setRange(s, e);
                },
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Continue",
                // ontap: () {
                //   Get.offAll(() => MainScreen());
                // },
                ontap: () async {
                  final onboarding = Get.find<OnboardingController>();
                  final user = FirebaseAuth.instance.currentUser;

                  if (periodCtrl.periodStart.value == null ||
                      periodCtrl.periodEnd.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select your period dates."),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    return;
                  }

                  onboarding.lastPeriodEnd =
                      "${periodCtrl.periodEnd.value!.day}-${periodCtrl.periodEnd.value!.month}-${periodCtrl.periodEnd.value!.year}";
                  onboarding.periodLength =
                      periodCtrl.periodEnd.value!
                          .difference(periodCtrl.periodStart.value!)
                          .inDays +
                      1;

                  // save onboarding user info plus range fields
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user!.uid)
                      .set({
                        "name": onboarding.name,
                        "dob": onboarding.dob,
                        "height": onboarding.height,
                        "weight": onboarding.weight,
                        "periodLength": onboarding.periodLength,
                        "cycleLength": onboarding.cycleLength,
                        "lastPeriodEnd": onboarding.lastPeriodEnd,
                        "periodStart": periodCtrl.periodStart.value!
                            .toIso8601String(),
                        "periodEnd": periodCtrl.periodEnd.value!
                            .toIso8601String(),
                      });

                  // also persist via controller (merge)
                  await periodCtrl.savePeriod();

                  Get.offAll(() => MainScreen());
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
