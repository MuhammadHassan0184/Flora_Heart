import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String date;
  final String label;
  final List<Color> gradientColors;
  final List<Color> circleGradient;
  final Widget icon;

  const DateCard({
    super.key,
    required this.date,
    required this.label,
    required this.gradientColors,
    required this.circleGradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          // color: backgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
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
                    // color: circleColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: circleGradient,
                    ),
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
        DateCard(
          date: "Jan 8–13",
          label: "Fertility Window",
          gradientColors: [
            Color(0xFFFDD7DD), // soft top pink
            Color(0xFFF28A95), // darker bottom pink
          ],
          circleGradient: [Color(0xFFFDE2E6), Color(0xFFF6AAB5)],
          icon: Image.asset("assets/pinkleave.png"),
        ),
        DateCard(
          date: "Jan 11",
          label: "Ovulation",
          gradientColors: [
            Color(0xFFE1FCB9), // light green
            Color(0xFFA6E63F), // darker green
          ],
          circleGradient: [Color(0xFFEFFFCC), Color(0xFFC9F079)],
          icon: Image.asset("assets/greencircle.png"),
        ),
        DateCard(
          date: "Jan 15",
          label: "Next Period",
          gradientColors: [
            Color(0xFFFDAAB1), // light red
            Color(0xFFFF3F5E), // darker red
          ],
          circleGradient: [Color(0xFFFFC6CD), Color(0xFFFF6B80)],
          icon: Image.asset("assets/drops.png"),
        ),
      ],
    );
  }
}
