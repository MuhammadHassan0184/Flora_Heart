// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_chip.dart';

class SexualActivitySection extends StatefulWidget {
  const SexualActivitySection({super.key});

  @override
  State<SexualActivitySection> createState() => _SexualActivitySectionState();
}

class _SexualActivitySectionState extends State<SexualActivitySection> {
  String selectedActivity = "";

  final List<Map<String, dynamic>> activities = [
    {"label": "None", "icon": "assets/none.svg"},
    {"label": "Protected", "icon": "assets/protected.svg"},
    {"label": "Unprotected", "icon": "assets/unprotected.svg"},
    {"label": "Male Orgasm", "icon": "assets/maleorgasm.svg"},
    {"label": "Female Orgasm", "icon": "assets/femaleorgasm.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sexual Activity",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          /// Chips Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activities.map((activity) {
              return CustomSelectableChip(
                label: activity["label"],
                iconPath: activity["icon"],
                isSelected: selectedActivity == activity["label"],
                onTap: () {
                  setState(() {
                    selectedActivity = activity["label"];
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
