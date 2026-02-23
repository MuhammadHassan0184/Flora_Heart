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
    {"label": "Male Orgasm", "icon": "assets/male.svg"},
    {"label": "Female Orgasm", "icon": "assets/female.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sexual Activity",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: activities.map((activity) {
              final label = activity["label"];

              return CustomSelectableChip(
                label: label,
                iconPath: activity["icon"],
                isSelected: selectedActivity == label,
                onTap: () {
                  setState(() {
                    if (selectedActivity == label) {
                      selectedActivity = "";
                    } else {
                      selectedActivity = label;
                    }
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
