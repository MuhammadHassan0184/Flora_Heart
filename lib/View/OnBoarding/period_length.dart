import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class PeriodLengthScreen extends StatefulWidget {
  final VoidCallback onNext;

  const PeriodLengthScreen({super.key, required this.onNext});

  @override
  State<PeriodLengthScreen> createState() => _PeriodLengthScreenState();
}

class _PeriodLengthScreenState extends State<PeriodLengthScreen> {
  final FixedExtentScrollController _controller = FixedExtentScrollController(
    initialItem: 2,
  );

  int selectedLength = 5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// Title
              Text(
                "How long do your periods\nlast?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),

              // SizedBox(height: 50),

              /// Picker
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildPicker(),

                    /// Divider line under selected value
                    Positioned(
                      bottom: size.height * 0.30,
                      child: Container(
                        width: 60,
                        height: 1,
                        color: AppColors.lightgrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              /// Continue Button
              CustomButton(label: "Continue", ontap: widget.onNext),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPicker() {
    return ShaderMask(
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
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedLength = index + 3; // 3 to 7
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 5, // 3,4,5,6,7
          builder: (context, index) {
            int value = index + 3;
            bool isSelected = value == selectedLength;

            return Center(
              child: Text(
                value.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSelected ? 26 : 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
