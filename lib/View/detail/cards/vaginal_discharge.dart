// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_chip.dart';

class DischargeSection extends StatefulWidget {
  const DischargeSection({super.key});

  @override
  State<DischargeSection> createState() => _DischargeSectionState();
}

class _DischargeSectionState extends State<DischargeSection> {
  // ✅ Multiple selection list
  List<String> selectedDischarge = [];

  final List<Map<String, dynamic>> dischargeTypes = [
    {"label": "Dry", "icon": "assets/discharge.svg"},
    {"label": "Sticky", "icon": "assets/discharge.svg"},
    {"label": "Creamy", "icon": "assets/discharge.svg"},
    {"label": "Watery", "icon": "assets/discharge.svg"},
    {"label": "Egg White", "icon": "assets/discharge.svg"},
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
            "Vaginal Discharge",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dischargeTypes.map((type) {
              final label = type["label"];

              final isSelected = selectedDischarge.contains(label);

              return CustomSelectableChip(
                label: label,
                iconPath: type["icon"],
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedDischarge.remove(label); // ❌ Unselect
                    } else {
                      selectedDischarge.add(label); // ✅ Select
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
