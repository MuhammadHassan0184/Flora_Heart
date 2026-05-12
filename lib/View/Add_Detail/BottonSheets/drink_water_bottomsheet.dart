import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DrinkWaterBottomSheet {
  static void show(BuildContext context) {
    final controller = Get.find<TodayDataController>();
    final RxInt selectedGlasses = ((controller.drinkWater.value / 250).round()).obs;
    if (selectedGlasses.value == 0 && controller.drinkWater.value > 0) {
      selectedGlasses.value = 1; // logical fallback
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        const int totalGoal = 2000;
        return Obx(() {
          int currentML = selectedGlasses.value * 250;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Indicator
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
                    "Drink Water",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// Card Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        /// Progress Text
                        Text(
                          "$currentML ml / $totalGoal ml",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Glass Grid
                        Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          children: List.generate(10, (index) {
                            bool isFilled = index < selectedGlasses.value;

                            return GestureDetector(
                              onTap: () {
                                selectedGlasses.value = index + 1;
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "250 ml",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isFilled
                                          ? AppColors.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  /// SVG GLASS
                                  SvgPicture.asset(
                                    "assets/drinkwater.svg",
                                    height: 50,
                                    width: 35,
                                    color: isFilled
                                        ? AppColors.primary
                                        : Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Done Button
                  CustomButton(
                    label: "Done",
                    ontap: () async {
                      controller.drinkWater.value = selectedGlasses.value * 250;
                      await controller.saveTodayData();
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          });
      },
    );
  }
}
