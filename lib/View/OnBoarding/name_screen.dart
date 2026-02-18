import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  final VoidCallback onNext;

  const NameScreen({super.key, required this.onNext});

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
                              color: AppColors.lightgrey,
                              width: 1.5,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
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

              CustomButton(label: "Continue", ontap: onNext),

              /// Continue Button (Full width rounded)
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //     onPressed: onNext,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primary,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       elevation: 0,
              //     ),
              //     child: Text(
              //       "Continue",
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //         color: AppColors.white,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
