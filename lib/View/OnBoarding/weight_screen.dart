import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:floraheart/View/Widgets/picker_card.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {

  final VoidCallback onNext;

  const WeightScreen({super.key, required this.onNext});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {

  bool isKg = true;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(height: 40),

        Text(
          "What's your weight?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            unit("kg", isKg),
            SizedBox(width: 10),
            unit("lb", !isKg),
          ],
        ),

        SizedBox(height: 30),

        PickerCard(
          child: SizedBox(
            height: 180,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 150,
                builder: (context, index) {
                  return Center(
                    child: Text(
                      "${index + 30}",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        Spacer(),
        continueButton(widget.onNext),
      ],
    );
  }

  Widget unit(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKg = text == "kg";
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Color(0xffE91E63) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xffE91E63)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
