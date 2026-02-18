import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:flutter/material.dart';

class HeightScreen extends StatelessWidget {
  final VoidCallback onNext;

  const HeightScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "What's your height?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 40),

            Container(
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
                    wheel(8, start: 3, suffix: " ft"),
                    wheel(12, start: 0, suffix: " in"),
                  ],
                ),
              ),
            ),

            Spacer(),
            continueButton(onNext),
          ],
        ),
      ),
    );
  }

  Widget wheel(int count, {int start = 0, String suffix = ""}) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) {
            return Center(child: Text("${start + index}$suffix"));
          },
        ),
      ),
    );
  }
}
