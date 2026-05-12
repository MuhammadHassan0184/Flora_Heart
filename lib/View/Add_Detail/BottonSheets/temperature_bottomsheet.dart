// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BasalTemperatureBottomSheet extends StatefulWidget {
  const BasalTemperatureBottomSheet({super.key});

  @override
  State<BasalTemperatureBottomSheet> createState() =>
      _BasalTemperatureBottomSheetState();
}

class _BasalTemperatureBottomSheetState
    extends State<BasalTemperatureBottomSheet> {
  final RxString selectedUnit = "°C".obs;
  final RxInt wholePart = 36.obs;
  final RxInt decimalPart = 0.obs;

  late FixedExtentScrollController wholeController;
  late FixedExtentScrollController decimalController;

  late List<int> wholeValues;
  late List<int> decimalValues;

  void _updateValues() {
    if (selectedUnit.value == "°C") {
      wholeValues = List.generate(15, (index) => 30 + index); // 30 to 44
    } else {
      wholeValues = List.generate(35, (index) => 86 + index); // 86 to 120
    }
    decimalValues = List.generate(100, (index) => index);
  }

  @override
  void initState() {
    super.initState();
    final controller = Get.find<TodayDataController>();
    double currentTemp = controller.temperature.value;

    if (currentTemp <= 0) currentTemp = 36.0;

    selectedUnit.value = controller.temperatureUnit.value;
    
    double displayTemp = currentTemp;
    if (selectedUnit.value == "°F") {
        displayTemp = (currentTemp * 9 / 5) + 32;
    }

    wholePart.value = displayTemp.floor();
    decimalPart.value = ((displayTemp - wholePart.value) * 100).round();

    if (decimalPart.value >= 100) {
      wholePart.value += 1;
      decimalPart.value = 0;
    }

    _updateValues();

    int wholeIndex = wholeValues.indexOf(wholePart.value);
    if (wholeIndex == -1) wholeIndex = 0;

    wholeController = FixedExtentScrollController(initialItem: wholeIndex);
    decimalController = FixedExtentScrollController(initialItem: decimalPart.value);
  }

  @override
  void dispose() {
    wholeController.dispose();
    decimalController.dispose();
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
          _updateValues(); // Ensure values are correct for current unit
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
                "Basal Body Temperature",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitToggle("°C"),
                  const SizedBox(width: 12),
                  _unitToggle("°F"),
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
                    "${wholePart.value}.${decimalPart.value.toString().padLeft(2, '0')} ${selectedUnit.value}",
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
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            controller: wholeController,
                            itemExtent: 45,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              wholePart.value = wholeValues[index];
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: wholeValues.length,
                              builder: (context, index) {
                                int value = wholeValues[index];
                                bool isSelected = value == wholePart.value;
                                return Center(
                                  child: Text(
                                    "$value",
                                    style: TextStyle(
                                      fontSize: isSelected ? 24 : 18,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade400,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            ".",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            controller: decimalController,
                            itemExtent: 45,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              decimalPart.value = decimalValues[index];
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: decimalValues.length,
                              builder: (context, index) {
                                int value = decimalValues[index];
                                bool isSelected = value == decimalPart.value;
                                return Center(
                                  child: Text(
                                    value.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: isSelected ? 24 : 18,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade400,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  label: "Done",
                  ontap: () async {
                    final controller = Get.find<TodayDataController>();

                    double finalTemp = wholePart.value + (decimalPart.value / 100.0);

                    if (selectedUnit.value == "°F") {
                      finalTemp = (finalTemp - 32) * 5 / 9;
                    }

                    controller.temperature.value = finalTemp;
                    controller.temperatureUnit.value = selectedUnit.value;

                    try {
                      await controller.saveTodayData();
                    } catch (e) {
                      print("Temperature save error: $e");
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Selected: ${wholePart.value}.${decimalPart.value.toString().padLeft(2, '0')} ${selectedUnit.value}",
                        ),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 2),
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
            double currentC = wholePart.value + (decimalPart.value / 100.0);
            if (selectedUnit.value == "°F") {
              currentC = (currentC - 32) * 5 / 9;
            }

            selectedUnit.value = unit;
            double convertedValue;
            if (unit == "°C") {
              convertedValue = currentC;
            } else {
              convertedValue = (currentC * 9 / 5) + 32;
            }

            wholePart.value = convertedValue.floor();
            decimalPart.value = ((convertedValue - wholePart.value) * 100).round();
            if (decimalPart.value >= 100) {
              wholePart.value += 1;
              decimalPart.value = 0;
            }

            _updateValues();

            int wholeIndex = wholeValues.indexOf(wholePart.value);
            if (wholeIndex == -1) wholeIndex = 0;

            wholeController.jumpToItem(wholeIndex);
            decimalController.jumpToItem(decimalPart.value);
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
