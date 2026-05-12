import 'package:floraheart/Controllers/onboarding_controller.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:get/get.dart';

class WeightScreen extends StatefulWidget {
  final VoidCallback onNext;

  const WeightScreen({super.key, required this.onNext});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final RxBool isKg = true.obs;
  final RxDouble selectedWeight = 60.00.obs;

  final FixedExtentScrollController _controller = FixedExtentScrollController(
    initialItem: (60 - 1) * 10,
  );

  // final FixedExtentScrollController _controller = FixedExtentScrollController(
  //   initialItem: 1000,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// TITLE
              Text(
                "What’s your weight?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 35),

              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitButton("kg", isKg.value),
                  const SizedBox(width: 16),
                  _unitButton("lb", !isKg.value),
                ],
              )),

              SizedBox(height: 25),

              Container(
                width: double.infinity,
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Center(
                  child: Obx(() => Text(
                    selectedWeight.value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )),
                ),
              ),

              SizedBox(height: 20),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 10),

              /// WHEEL PICKER
              SizedBox(
                height: 230,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.2, 0.8, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      int whole = 1 + (index ~/ 10);
                      int decimal = index % 10;
                      selectedWeight.value = double.parse("$whole.$decimal");
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: (250 - 1 + 1) * 10, // 1.0 → 250.9
                      builder: (context, index) {
                        int whole = 1 + (index ~/ 10);
                        int decimal = index % 10;

                        String valueString = "$whole.$decimal";

                        double value = double.parse(valueString);

                        return Obx(() {
                          bool isSelected = value == selectedWeight.value;

                          return Center(
                            child: Text(
                              valueString,
                              style: TextStyle(
                                fontSize: isSelected ? 22 : 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),

              Spacer(),

              SizedBox(height: 20),

              /// CONTINUE BUTTON
              // CustomButton(
              //   label: "Continue",
              //   ontap: () {
              //     final onboarding = Get.find<OnboardingController>();

              //     onboarding.weight = "$selectedWeight ${isKg ? "kg" : "lb"}";

              //     widget.onNext();
              //   },
              // ),
              CustomButton(
                label: "Continue",
                ontap: () {
                  if (selectedWeight.value <= 0) {
                    Get.snackbar(
                      "Error",
                      "Please select your weight",
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  final onboarding = Get.find<OnboardingController>();
                  onboarding.weight = "${selectedWeight.value} ${isKg.value ? "kg" : "lb"}";
                  widget.onNext();
                },
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unitButton(String text, bool active) {
    return GestureDetector(
      onTap: () {
        isKg.value = text == "kg";
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 44,
        width: 120, // important for equal size
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
