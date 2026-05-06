// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class BasalTemperatureBottomSheet extends StatefulWidget {
  const BasalTemperatureBottomSheet({super.key});

  @override
  State<BasalTemperatureBottomSheet> createState() =>
      _BasalTemperatureBottomSheetState();
}

class _BasalTemperatureBottomSheetState
    extends State<BasalTemperatureBottomSheet> {
  String selectedUnit = "°C";
  int wholePart = 36;
  int decimalPart = 0;

  late FixedExtentScrollController wholeController;
  late FixedExtentScrollController decimalController;

  late List<int> wholeValues;
  late List<int> decimalValues;

  void _updateValues() {
    if (selectedUnit == "°C") {
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

    selectedUnit = controller.temperatureUnit.value;
    
    double displayTemp = currentTemp;
    if (selectedUnit == "°F") {
        displayTemp = (currentTemp * 9 / 5) + 32;
    }

    wholePart = displayTemp.floor();
    decimalPart = ((displayTemp - wholePart) * 100).round();

    if (decimalPart >= 100) {
      wholePart += 1;
      decimalPart = 0;
    }

    _updateValues();

    int wholeIndex = wholeValues.indexOf(wholePart);
    if (wholeIndex == -1) wholeIndex = 0;

    wholeController = FixedExtentScrollController(initialItem: wholeIndex);
    decimalController = FixedExtentScrollController(initialItem: decimalPart);
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
        child: Column(
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
            SizedBox(height: 16),

            /// Header
            Text(
              "Basal Body Temperature",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            /// Unit Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitToggle("°C"),
                const SizedBox(width: 12),
                _unitToggle("°F"),
              ],
            ),
            SizedBox(height: 16),

            /// Selected Value Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 47,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Center(
                child: Text(
                  "$wholePart.${decimalPart.toString().padLeft(2, '0')} $selectedUnit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            /// Picker
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Selection Highlight Bar
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
                      // Whole Part Wheel
                      SizedBox(
                        width: 70,
                        child: ListWheelScrollView.useDelegate(
                          controller: wholeController,
                          itemExtent: 45,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              wholePart = wholeValues[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: wholeValues.length,
                            builder: (context, index) {
                              int value = wholeValues[index];
                              bool isSelected = value == wholePart;
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
                      
                      // Decimal Point
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

                      // Decimal Part Wheel
                      SizedBox(
                        width: 70,
                        child: ListWheelScrollView.useDelegate(
                          controller: decimalController,
                          itemExtent: 45,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              decimalPart = decimalValues[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: decimalValues.length,
                            builder: (context, index) {
                              int value = decimalValues[index];
                              bool isSelected = value == decimalPart;
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

            /// Done Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Done",
                ontap: () async {
                  final controller = Get.find<TodayDataController>();

                  double finalTemp = wholePart + (decimalPart / 100.0);

                  // If saved as Fahrenheit, convert back to Celsius for storage if needed,
                  // but here we store as the numeric value shown.
                  // Most apps store Celsius.
                  if (selectedUnit == "°F") {
                    finalTemp = (finalTemp - 32) * 5 / 9;
                  }

                  controller.temperature.value = finalTemp;
                  controller.temperatureUnit.value = selectedUnit;

                  try {
                    // Optional: save to Firebase immediately
                    await controller.saveTodayData();
                  } catch (e) {
                    print("Temperature save error: $e");
                  }

                  // Close BottomSheet
                  Navigator.pop(context);

                  // Optional: show SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Selected: $wholePart.${decimalPart.toString().padLeft(2, '0')} $selectedUnit",
                      ),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _unitToggle(String unit) {
    bool isSelected = selectedUnit == unit;

    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     selectedUnit = unit;
      //     selectedValue = unit == "°C" ? 36.00 : 96.80; // 36°C in °F
      //   });
      // },
      onTap: () {
        if (selectedUnit != unit) {
          setState(() {
            // Convert current value before switching unit
            double currentC = wholePart + (decimalPart / 100.0);
            if (selectedUnit == "°F") {
              currentC = (currentC - 32) * 5 / 9;
            }

            selectedUnit = unit;
            double convertedValue;
            if (unit == "°C") {
              convertedValue = currentC;
            } else {
              convertedValue = (currentC * 9 / 5) + 32;
            }

            wholePart = convertedValue.floor();
            decimalPart = ((convertedValue - wholePart) * 100).round();
            if (decimalPart >= 100) {
              wholePart += 1;
              decimalPart = 0;
            }

            _updateValues();

            int wholeIndex = wholeValues.indexOf(wholePart);
            if (wholeIndex == -1) wholeIndex = 0;

            wholeController.jumpToItem(wholeIndex);
            decimalController.jumpToItem(decimalPart);
          });
        }
      },
      child: Container(
        height: 44,
        width: 120, // important for equal size
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
  }
}
