// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TestsBottomSheet {
  static void show(BuildContext context) {
    String ovulationResult = "";
    String pregnancyResult = "";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildTestSection({
              required String title,
              required String selectedValue,
              required Function(String) onSelect,
            }) {
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOption(
                            label: "Positive",
                            iconPath: "assets/positive.svg", // 👈 your svg
                            isSelected: selectedValue == "Positive",
                            onTap: () => onSelect("Positive"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildOption(
                            label: "Negative",
                            iconPath: "assets/negative.svg", // 👈 your svg
                            isSelected: selectedValue == "Negative",
                            onTap: () => onSelect("Negative"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag indicator
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Title
                  const Text(
                    "Tests",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// Ovulation Section
                  buildTestSection(
                    title: "Ovulation Test",
                    selectedValue: ovulationResult,
                    onSelect: (value) {
                      setModalState(() {
                        ovulationResult = value;
                      });
                    },
                  ),

                  /// Pregnancy Section
                  buildTestSection(
                    title: "Pregnancy Test",
                    selectedValue: pregnancyResult,
                    onSelect: (value) {
                      setModalState(() {
                        pregnancyResult = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  /// Done Button
                  CustomButton(
                    label: "Done",
                    ontap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required String iconPath, // 👈 add this
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// SVG ICON
            SvgPicture.asset(
              iconPath,
              height: 14,
              width: 14,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : Colors.grey.shade400,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 8),

            /// TEXT
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
