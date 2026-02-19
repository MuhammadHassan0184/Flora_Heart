import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String date;
  final String label;
  final Color backgroundColor;
  final Color circleColor;
  final Widget icon;

  const DateCard({
    super.key,
    required this.date,
    required this.label,
    required this.backgroundColor,
    required this.circleColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  child: icon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DatesRow extends StatelessWidget {
  const DatesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DateCard(
          date: "Jan 8-10",
          label: "Fertility Window",
          backgroundColor: Color(0xFFFCC4D6),
          circleColor: Color(0xFFF59FBC),
          icon: Image(image: AssetImage("assets/pinkleave.png")),
        ),
        const DateCard(
          date: "Jan 11",
          label: "Ovulation",
          backgroundColor: Color(0xFF89E125),
          circleColor: Color(0xFFDDFDB9),
          icon: Image(image: AssetImage("assets/greencircle.png")),
        ),
        DateCard(
          date: "Jan 15",
          label: "Next Period",
          backgroundColor: const Color(0xFFFB82A8),
          circleColor: const Color(0xFFF59FBC),
          icon: Image.asset("assets/drops.png"),
        ),
      ],
    );
  }
}
