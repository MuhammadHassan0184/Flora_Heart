// ignore_for_file: avoid_print

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FlowSelector extends StatelessWidget {
  const FlowSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayDataController>();

    return Obx(() {
      final selectedIndex = controller.flow.value;

  Widget buildItem({
    required int index,
    required String title,
    required String asset,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     selectedIndex = index;
      //   });
      // },
      onTap: () async {
        controller.flow.value = index; // ✅ Save flow
        try {
          await controller.saveTodayData(); // 🔥 Auto-save to Firebase
        } catch (e) {
          print("Auto-save error: $e");
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(asset, fit: BoxFit.contain),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.grey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildItem(index: 0, title: "Light", asset: "assets/lightdrop.svg"),
          buildItem(index: 1, title: "Medium", asset: "assets/mediumdrop.svg"),
          buildItem(index: 2, title: "Heavy", asset: "assets/heavydrops.svg"),
          buildItem(
            index: 3,
            title: "Disaster",
            asset: "assets/disasterdrops.svg",
          ),
        ],
      );
    });
  }
}
