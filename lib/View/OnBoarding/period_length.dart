import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:flutter/material.dart';

class PeriodLengthScreen extends StatelessWidget {

  final VoidCallback onNext;

  const PeriodLengthScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(height: 40),

        Text(
          "How long do your periods last?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 40),

        picker(10, start: 2, suffix: " days"),

        Spacer(),
        continueButton(onNext),
      ],
    );
  }

  Widget picker(int count, {int start = 1, String suffix = ""}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 180,
        child: ListWheelScrollView.useDelegate(
          itemExtent: 40,
          physics: FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: count,
            builder: (context, index) {
              return Center(
                child: Text("${start + index}$suffix"),
              );
            },
          ),
        ),
      ),
    );
  }
}
