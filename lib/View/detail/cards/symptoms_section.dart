// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_chip.dart';

class SymptomsSection extends StatefulWidget {
  const SymptomsSection({super.key});

  @override
  State<SymptomsSection> createState() => _SymptomsSectionState();
}

class _SymptomsSectionState extends State<SymptomsSection> {
  final Map<String, String> selectedSymptoms = {};

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

  final Set<String> expandedSections = {
    "Pain & Pelvic",
    "Digestive & Gut",
    "Energy & Sleep",
    "Skin & Body",
    "Vaginal & Fertility",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Symptoms",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

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
                    setState(() {
                      if (isExpanded) {
                        expandedSections.remove(title);
                      } else {
                        expandedSections.add(title);
                      }
                    });
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

                const SizedBox(height: 10),

                if (isExpanded)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((symptom) {
                      final label = symptom["label"]!;
                      final isSelected = selectedSymptoms[title] == label;

                      return CustomSelectableChip(
                        label: label,
                        iconPath: symptom["icon"]!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedSymptoms.remove(title); // deselect
                            } else {
                              selectedSymptoms[title] =
                                  label; // select only in this section
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 18),
              ],
            );
          }),
        ],
      ),
    );
  }
}
