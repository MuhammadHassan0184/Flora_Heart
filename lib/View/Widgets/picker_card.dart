import 'package:flutter/material.dart';

class PickerCard extends StatelessWidget {

  final Widget child;

  const PickerCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
