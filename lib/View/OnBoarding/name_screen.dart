import 'package:floraheart/Controllers/onboarding_controller.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameScreen extends StatefulWidget {
  final VoidCallback onNext;

  const NameScreen({super.key, required this.onNext});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final controller = Get.put(OnboardingController());
  final onboarding = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// Title (centered like image)
              Text(
                "What's your name?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hint: Text("Enter your Name"),
                          filled: true,
                          fillColor: AppColors.white,

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12, // 👈 reduced height
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // CustomButton(label: "Continue", ontap: widget.onNext),
              // CustomButton(
              //   label: "Continue",
              //   ontap: () {
              //     onboarding.name = controller.text;
              //     widget.onNext();
              //   },
              // ),
              CustomButton(
                label: "Continue",
                ontap: () {
                  if (controller.text.trim().isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter your name",
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  onboarding.name = controller.text.trim();
                  widget.onNext();
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
