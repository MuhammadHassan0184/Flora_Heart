// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_chip.dart';
import 'package:flutter/material.dart';

class MoodSection extends StatefulWidget {
  const MoodSection({super.key});

  @override
  State<MoodSection> createState() => _MoodSectionState();
}

class _MoodSectionState extends State<MoodSection> {
  // ✅ Change from String to List
  List<String> selectedMoods = [];

  final List<Map<String, dynamic>> moods = [
    {"label": "Anxious", "icon": "assets/anxious.svg"},
    {"label": "Sad", "icon": "assets/sad.svg"},
    {"label": "Happy", "icon": "assets/happy.svg"},
    {"label": "Calm", "icon": "assets/calm.svg"},
    {"label": "Angry", "icon": "assets/angry.svg"},
    {"label": "Energetic", "icon": "assets/energetic.svg"},
    {"label": "Confused", "icon": "assets/confused.svg"},
    {"label": "Depressed", "icon": "assets/depressed.svg"},
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
          Text(
            "Mood",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          /// Chips Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moods.map((mood) {
              final label = mood["label"];

              return CustomSelectableChip(
                label: label,
                iconPath: mood["icon"],
                isSelected: selectedMoods.contains(label),
                onTap: () {
                  setState(() {
                    if (selectedMoods.contains(label)) {
                      selectedMoods.remove(label); // ❌ Unselect
                    } else {
                      selectedMoods.add(label); // ✅ Select
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
