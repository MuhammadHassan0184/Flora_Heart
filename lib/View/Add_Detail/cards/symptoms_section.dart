// ignore_for_file: deprecated_member_use

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_chip.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class SymptomsSection extends StatefulWidget {
  const SymptomsSection({super.key});

  @override
  State<SymptomsSection> createState() => _SymptomsSectionState();
}

class _SymptomsSectionState extends State<SymptomsSection> {
  final Set<String> expandedSections = {
    "Pain & Pelvic",
    "Digestive & Gut",
    "Energy & Sleep",
    "Skin & Body",
    "Vaginal & Fertility",
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayDataController>();

    return Obx(() {
      final selectedSymptoms = Map<String, Set<String>>.from(controller.symptoms);

      // ====== DATA ======
      final Map<String, List<Map<String, String>>> symptomsData = {
        "Pain & Pelvic": [
          {"label": "Cramps", "icon": "assets/cramp.svg"},
          {"label": "Ovulation Pain", "icon": "assets/ovulationpain.svg"},
          {"label": "Lower Back Pain", "icon": "assets/lowerbackpain.svg"},
          {"label": "Pelvic Pain", "icon": "assets/pelvicpain.svg"},
        ],
        "Digestive & Gut": [
          {"label": "Bloating", "icon": "assets/bloating.svg"},
          {"label": "Nausea", "icon": "assets/nausea.svg"},
          {"label": "Diarrhea", "icon": "assets/diarrhea.svg"},
          {"label": "Constipation", "icon": "assets/constipation.svg"},
          {"label": "Cravings", "icon": "assets/cravings.svg"},
        ],
        "Energy & Sleep": [
          {"label": "Fatigue", "icon": "assets/fatigue.svg"},
          {"label": "Brain Fog", "icon": "assets/brainfog.svg"},
          {"label": "Insomnia", "icon": "assets/insomnia.svg"},
          {"label": "High Energy", "icon": "assets/highenergy.svg"},
        ],
        "Skin & Body": [
          {"label": "Acne", "icon": "assets/acne.svg"},
          {"label": "Tender Breasts", "icon": "assets/tenderbreasts.svg"},
          {"label": "Headache", "icon": "assets/headache.svg"},
          {"label": "Oily Skin/Hair", "icon": "assets/oilyskinhair.svg"},
          {"label": "Chills/Hot Flashes", "icon": "assets/chillshotflashes.svg"},
        ],
        "Vaginal & Fertility": [
          {"label": "Cervical Mucus", "icon": "assets/cervicalmucus.svg"},
          {"label": "Spotting", "icon": "assets/spotting.svg"},
          {"label": "Itching", "icon": "assets/itching.svg"},
        ],
      };

      return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Symptoms",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          /// ====== Sections ======
          ...symptomsData.entries.map((section) {
            final title = section.key;
            final items = section.value;
            final isExpanded = expandedSections.contains(title);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Section Header
                GestureDetector(
                  onTap: () {
                    if (expandedSections.contains(title)) {
                      expandedSections.remove(title);
                    } else {
                      expandedSections.add(title);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                if (isExpanded)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((symptom) {
                      final label = symptom["label"]!;

                      // Get selected set for this section
                      final selectedSet = selectedSymptoms[title] ?? {};

                      final isSelected = selectedSet.contains(label);

                      return CustomSelectableChip(
                        label: label,
                        iconPath: symptom["icon"]!,
                        isSelected: isSelected,
                        // onTap: () {
                        //   setState(() {
                        //     // Initialize section if not exists
                        //     selectedSymptoms.putIfAbsent(
                        //       title,
                        //       () => <String>{},
                        //     );

                        //     if (isSelected) {
                        //       selectedSymptoms[title]!.remove(label);
                        //     } else {
                        //       selectedSymptoms[title]!.add(label);
                        //     }

                        //     // Optional: remove empty section
                        //     if (selectedSymptoms[title]!.isEmpty) {
                        //       selectedSymptoms.remove(title);
                        //     }
                        //   });
                        // },
                        onTap: () async {
                          selectedSymptoms.putIfAbsent(
                            title,
                            () => <String>{},
                          );
                          if (selectedSet.contains(label)) {
                            selectedSymptoms[title]!.remove(label);
                          } else {
                            selectedSymptoms[title]!.add(label);
                          }
                          if (selectedSymptoms[title]!.isEmpty)
                            selectedSymptoms.remove(title);

                          controller.symptoms.assignAll(
                            selectedSymptoms,
                          ); // ✅ Save symptoms
                          try {
                            await controller.saveTodayData(); // 🔥 Auto-save
                          } catch (e) {
                            print("Auto-save error: $e");
                          }
                        },
                      );
                    }).toList(),
                  ),

                SizedBox(height: 18),
              ],
            );
          }),
        ],
      ),
    );
    });
  }
}
