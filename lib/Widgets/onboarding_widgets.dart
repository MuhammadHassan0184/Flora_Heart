import 'package:flutter/material.dart';

Widget progressBar(int step) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LinearProgressIndicator(
          value: step / 8,
          backgroundColor: Colors.white24,
          color: Color(0xffE91E63),
          minHeight: 4,
        ),
        SizedBox(height: 6),
        Text(
          "$step / 8",
          style: TextStyle(color: Colors.white54),
        ),
      ],
    ),
  );
}

Widget continueButton(VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xffE91E63),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Continue",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ),
  );
}
