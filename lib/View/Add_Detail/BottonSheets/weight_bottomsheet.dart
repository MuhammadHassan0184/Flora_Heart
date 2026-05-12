// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:get/get.dart';

class WeightBottomSheet extends StatefulWidget {
  const WeightBottomSheet({super.key});

  @override
  State<WeightBottomSheet> createState() => _WeightBottomSheetState();
}

class _WeightBottomSheetState extends State<WeightBottomSheet> {
  final RxString selectedUnit = "Kg".obs;
  final RxDouble selectedValue = 60.00.obs;
  late FixedExtentScrollController scrollController;

  late List<double> kgValues;
  late List<double> lbValues;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<TodayDataController>();

    // Generate weight list (1kg – 250kg)
    kgValues = List.generate(250, (index) => (index + 1).toDouble());
    lbValues = kgValues.map((kg) => kg * 2.20462).toList();

    selectedUnit.value = controller.weightUnit.value;
    double currentWeight = controller.weight.value;

    double initialWeight = currentWeight > 0 ? currentWeight : 60.0;

    // Convert to display unit for picker logic
    double displayValue = initialWeight;
    if (selectedUnit.value == "Lb") {
      displayValue = initialWeight * 2.20462;
    }

    List<double> values = selectedUnit.value == "Kg" ? kgValues : lbValues;
    int initialIndex = values.indexWhere(
      (v) => v.toStringAsFixed(0) == displayValue.toStringAsFixed(0),
    );
    if (initialIndex == -1) initialIndex = 59;

    scrollController = FixedExtentScrollController(initialItem: initialIndex);
    selectedValue.value = values[initialIndex];
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Obx(() {
          List<double> values = selectedUnit.value == "Kg" ? kgValues : lbValues;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Weight",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitToggle("Kg"),
                  const SizedBox(width: 12),
                  _unitToggle("Lb"),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    selectedValue.value.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  controller: scrollController,
                  itemExtent: 40,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    selectedValue.value = values[index];
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: values.length,
                    builder: (context, index) {
                      double value = values[index];
                      bool isSelected =
                          value.toStringAsFixed(2) ==
                          selectedValue.value.toStringAsFixed(2);

                      return Center(
                        child: Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: isSelected ? 20 : 16,
                            color: isSelected ? AppColors.primary : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  label: "Done",
                  ontap: () async {
                    final controller = Get.find<TodayDataController>();
                    
                    double finalWeight = selectedValue.value;
                    if (selectedUnit.value == "Lb") {
                      finalWeight = selectedValue.value / 2.20462;
                    }
                    
                    controller.weight.value = finalWeight;
                    controller.weightUnit.value = selectedUnit.value;
                    try {
                      await controller.saveTodayData();
                    } catch (e) {
                      print("Weight save error: $e");
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Selected: ${selectedValue.value.toStringAsFixed(2)} ${selectedUnit.value}",
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }),
      ),
    );
  }

  Widget _unitToggle(String unit) {
    return Obx(() {
      bool isSelected = selectedUnit.value == unit;

      return GestureDetector(
        onTap: () {
          if (selectedUnit.value != unit) {
            double currentVal = selectedValue.value;
            selectedUnit.value = unit;
            List<double> newValues = unit == "Kg" ? kgValues : lbValues;

            int newIndex = 0;
            double minDiff = double.maxFinite;
            for (int i = 0; i < newValues.length; i++) {
              double diff = (newValues[i] - currentVal).abs();
              if (diff < minDiff) {
                minDiff = diff;
                newIndex = i;
              }
            }
            scrollController.jumpToItem(newIndex);
            selectedValue.value = newValues[newIndex];
          }
        },
        child: Container(
          height: 44,
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Text(
            unit,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
