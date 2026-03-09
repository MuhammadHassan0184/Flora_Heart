// ignore_for_file: deprecated_member_use

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_chip.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class DischargeSection extends StatelessWidget {
  const DischargeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayDataController>();

    return Obx(() {
      final selectedDischarge = controller.discharge.toList();

  final List<Map<String, dynamic>> dischargeTypes = [
    {"label": "Dry", "icon": "assets/discharge.svg"},
    {"label": "Sticky", "icon": "assets/discharge.svg"},
    {"label": "Creamy", "icon": "assets/discharge.svg"},
    {"label": "Watery", "icon": "assets/discharge.svg"},
    {"label": "Egg White", "icon": "assets/discharge.svg"},
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
                // onTap: () {
                //   setState(() {
                //     if (isSelected) {
                //       selectedDischarge.remove(label); // ❌ Unselect
                //     } else {
                //       selectedDischarge.add(label); // ✅ Select
                //     }
                //   });
                // },
                onTap: () async {
                  if (selectedDischarge.contains(label)) {
                    selectedDischarge.remove(label);
                  } else {
                    selectedDischarge.add(label);
                  }
                  controller.discharge.assignAll(
                    selectedDischarge,
                  ); // ✅ Save discharge
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
