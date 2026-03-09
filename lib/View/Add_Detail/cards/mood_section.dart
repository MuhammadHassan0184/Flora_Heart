// ignore_for_file: deprecated_member_use

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Widgets/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodSection extends StatelessWidget {
  const MoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayDataController>();

    return Obx(() {
      final selectedMoods = controller.moods.toList();

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
                // onTap: () {
                //   setState(() {
                //     if (selectedMoods.contains(label)) {
                //       selectedMoods.remove(label); // ❌ Unselect
                //     } else {
                //       selectedMoods.add(label); // ✅ Select
                //     }
                //   });
                // },
                onTap: () async {
                  if (selectedMoods.contains(label)) {
                    selectedMoods.remove(label);
                  } else {
                    selectedMoods.add(label);
                  }

                  controller.moods.assignAll(selectedMoods); // ✅ Save moods
                  try {
                    await controller.saveTodayData(); // 🔥 Auto-save
                  } catch (e) {
                    print("Auto-save error: $e");
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
    });
  }
}
