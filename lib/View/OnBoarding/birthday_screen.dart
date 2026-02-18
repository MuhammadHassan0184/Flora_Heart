import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:flutter/material.dart';

class BirthdayScreen extends StatelessWidget {

  final VoidCallback onNext;

  const BirthdayScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(height: 40),

        Text(
          "What's your birthday?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 40),

        pickerRow(),

        Spacer(),
        continueButton(onNext),
      ],
    );
  }

  Widget pickerRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 180,
        child: Row(
          children: [
            wheel(31),
            wheel(12),
            wheel(60, start: 1965),
          ],
        ),
      ),
    );
  }

  Widget wheel(int count, {int start = 1}) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) {
            return Center(
              child: Text("${start + index}"),
            );
          },
        ),
      ),
    );
  }
}
