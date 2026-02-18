import 'package:floraheart/View/OnBoarding/birthday_screen.dart';
import 'package:floraheart/View/OnBoarding/cycle_length_screen.dart';
import 'package:floraheart/View/OnBoarding/cycle_regularity_screen.dart';
import 'package:floraheart/View/OnBoarding/height_screen.dart';
import 'package:floraheart/View/OnBoarding/name_screen.dart';
import 'package:floraheart/View/OnBoarding/period_end_screen.dart';
import 'package:floraheart/View/OnBoarding/period_length.dart';
import 'package:floraheart/View/OnBoarding/weight_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final int totalSteps = 7;

  void next() {
    if (currentIndex < totalSteps - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previous() {
    if (currentIndex > 0) {
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
            const SizedBox(height: 15),

            /// ===== TOP HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  /// Back Arrow (Hidden on First Page)
                  if (currentIndex > 0)
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
                            fullWidth * ((currentIndex + 1) / totalSteps);

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
                                color: const Color(0xffE91E63),
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
                    "${currentIndex + 1}/$totalSteps",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ===== PAGE VIEW =====
            Expanded(
              child: PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  NameScreen(onNext: next),
                  BirthdayScreen(onNext: next),
                  WeightScreen(onNext: next),
                  HeightScreen(onNext: next),
                  PeriodLengthScreen(onNext: next),
                  CycleRegularityScreen(onNext: next),
                  CycleLengthScreen(onNext: next),
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
