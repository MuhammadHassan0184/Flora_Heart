import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';

class WeightScreen extends StatefulWidget {
  final VoidCallback onNext;

  const WeightScreen({super.key, required this.onNext});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  bool isKg = true;
  double selectedWeight = 40.0;

  final FixedExtentScrollController _controller = FixedExtentScrollController(
    initialItem: 1000,
  );

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

              /// UNIT TOGGLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitButton("kg", isKg),
                  SizedBox(width: 16),
                  _unitButton("lb", !isKg),
                ],
              ),

              SizedBox(height: 25),

              /// SELECTED VALUE BOX
              Container(
                width: double.infinity,
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    selectedWeight.toStringAsFixed(2),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
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
                      setState(() {
                        selectedWeight = 30 + index * 0.01;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 2000,
                      builder: (context, index) {
                        double value = 30 + index * 0.01;
                        bool isSelected =
                            value.toStringAsFixed(2) ==
                            selectedWeight.toStringAsFixed(2);

                        return Center(
                          child: Text(
                            value.toStringAsFixed(2),
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
                      },
                    ),
                  ),
                ),
              ),
              Spacer(),

              SizedBox(height: 20),

              /// CONTINUE BUTTON
              CustomButton(label: "Continue", ontap: widget.onNext),

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
        setState(() {
          isKg = text == "kg";
        });
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
