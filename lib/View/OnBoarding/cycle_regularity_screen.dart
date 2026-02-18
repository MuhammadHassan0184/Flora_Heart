import 'package:floraheart/View/Widgets/onboarding_widgets.dart';
import 'package:flutter/material.dart';

class CycleRegularityScreen extends StatefulWidget {

  final VoidCallback onNext;

  const CycleRegularityScreen({super.key, required this.onNext});

  @override
  State<CycleRegularityScreen> createState() =>
      _CycleRegularityScreenState();
}

class _CycleRegularityScreenState
    extends State<CycleRegularityScreen> {

  bool isRegular = true;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(height: 40),

        Text(
          "How long does your cycle last?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            toggle("Regular", isRegular),
            SizedBox(width: 10),
            toggle("Irregular", !isRegular),
          ],
        ),

        Spacer(),
        continueButton(widget.onNext),
      ],
    );
  }

  Widget toggle(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRegular = text == "Regular";
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
