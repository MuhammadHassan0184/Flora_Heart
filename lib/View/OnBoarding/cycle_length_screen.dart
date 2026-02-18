import 'package:flutter/material.dart';
import '../widgets/onboarding_widgets.dart';

class CycleLengthScreen extends StatelessWidget {
  final VoidCallback onNext;

  CycleLengthScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        progressBar(7),
        SizedBox(height: 40),

        Text(
          "How long does your cycle last?",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 40),

        Expanded(
          child: ListWheelScrollView.useDelegate(
            itemExtent: 60,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 20,
              builder: (context, index) {
                return Center(
                  child: Text(
                    "${index + 21} days",
                    style: TextStyle(
                        color: Colors.white, fontSize: 22),
                  ),
                );
              },
            ),
          ),
        ),

        continueButton(onNext),
      ],
    );
  }
}
