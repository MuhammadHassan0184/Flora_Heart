import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:flutter/material.dart';

class PeriodEndScreen extends StatelessWidget {

  final VoidCallback onNext;

  const PeriodEndScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(height: 40),

        Text(
          "When did your last period end?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 30),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              onDateChanged: (date) {},
            ),
          ),
        ),

        continueButton(onNext),
      ],
    );
  }
}
