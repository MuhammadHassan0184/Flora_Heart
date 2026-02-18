import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';

class HeightScreen extends StatefulWidget {
  final VoidCallback onNext;

  const HeightScreen({super.key, required this.onNext});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int selectedFeet = 5;
  int selectedInches = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              /// Title
              Text(
                "What’s your height?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 50),

              /// Feet & Inches Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Feet Column
                  Column(
                    children: [
                      Text(
                        "Feet",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        width: 60,
                        child: Stack(
                          children: [
                            buildFeetWheel(),

                            /// Underline at bottom of selected number
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                ), // shift line down
                                child: Container(
                                  height: 2,
                                  width: 40,
                                  color: AppColors.lightgrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 30),

                  Column(
                    children: [
                      Text(
                        "Inches",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        width: 60,
                        child: Stack(
                          children: [
                            buildInchesWheel(),

                            /// Underline at bottom of selected number
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                ), // shift line down
                                child: Container(
                                  height: 2,
                                  width: 40,
                                  color: AppColors.lightgrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Spacer(),

              /// Continue Button
              CustomButton(label: "Continue", ontap: widget.onNext),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeetWheel() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 40,
      perspective: 0.001,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedFeet = index + 3;
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 6, // 3 to 8
        builder: (context, index) {
          int value = index + 3;
          bool isSelected = value == selectedFeet;
          return Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.red : Colors.grey[400],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInchesWheel() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 40,
      perspective: 0.001,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedInches = index;
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 12,
        builder: (context, index) {
          bool isSelected = index == selectedInches;
          return Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.red : Colors.grey[400],
              ),
            ),
          );
        },
      ),
    );
  }
}
