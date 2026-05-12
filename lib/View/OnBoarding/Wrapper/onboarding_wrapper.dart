import 'package:floraheart/View/OnBoarding/birthday_screen.dart';
import 'package:floraheart/View/OnBoarding/cycle_regularity_screen.dart';
import 'package:floraheart/View/OnBoarding/height_screen.dart';
import 'package:floraheart/View/OnBoarding/name_screen.dart';
import 'package:floraheart/View/OnBoarding/period_end_screen.dart';
import 'package:floraheart/View/OnBoarding/period_length.dart';
import 'package:floraheart/View/OnBoarding/weight_screen.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  final RxInt currentIndex = 0.obs;

  final int totalSteps = 7;

  void next() {
    if (currentIndex.value < totalSteps - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previous() {
    if (currentIndex.value > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),

            /// ===== TOP HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => Row(
                children: [
                  /// Back Arrow (Hidden on First Page)
                  if (currentIndex.value > 0)
                    GestureDetector(
                      onTap: previous,
                      child: const Icon(Icons.arrow_back, size: 22),
                    )
                  else
                    const SizedBox(width: 22),

                  const SizedBox(width: 15),

                  /// Progress Bar
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final fullWidth = constraints.maxWidth;
                        final progress =
                            fullWidth * ((currentIndex.value + 1) / totalSteps);

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              /// Grey Background Line
                              Container(
                                height: 4,
                                width: fullWidth,
                                color: Colors.grey.shade300,
                              ),

                              /// Pink Progress Line
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 4,
                                width: progress,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// Step Counter
                  Text(
                    "${currentIndex.value + 1}/$totalSteps",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )),
            ),

            const SizedBox(height: 30),

            /// ===== PAGE VIEW =====
            Expanded(
              child: PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  currentIndex.value = index;
                },
                children: [
                  NameScreen(onNext: next),
                  BirthdayScreen(onNext: next),
                  WeightScreen(onNext: next),
                  HeightScreen(onNext: next),
                  PeriodLengthScreen(onNext: next),
                  CycleRegularityScreen(onNext: next),
                  PeriodEndScreen(onNext: next),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
