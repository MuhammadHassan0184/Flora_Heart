import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';

class WeightBottomSheet extends StatefulWidget {
  const WeightBottomSheet({super.key});

  @override
  State<WeightBottomSheet> createState() => _WeightBottomSheetState();
}

class _WeightBottomSheetState extends State<WeightBottomSheet> {
  String selectedUnit = "Kg";
  double selectedValue = 40.00;

  late List<double> kgValues;
  late List<double> lbValues;

  @override
  void initState() {
    super.initState();

    // Generate weight list (40kg – 150kg)
    kgValues = List.generate(111, (index) => 40 + index.toDouble());

    lbValues = kgValues.map((kg) => kg * 2.20462).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<double> values = selectedUnit == "Kg" ? kgValues : lbValues;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            const Text(
              "Weight",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Unit Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitToggle("Kg"),
                const SizedBox(width: 12),
                _unitToggle("Lb"),
              ],
            ),
            const SizedBox(height: 16),

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
                  selectedValue.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Picker
            SizedBox(
              height: 150,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedValue = values[index];
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: values.length,
                  builder: (context, index) {
                    double value = values[index];
                    bool isSelected =
                        value.toStringAsFixed(2) ==
                        selectedValue.toStringAsFixed(2);

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

            /// Done Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Done",
                ontap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Selected: ${selectedValue.toStringAsFixed(2)} $selectedUnit",
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _unitToggle(String unit) {
    bool isSelected = selectedUnit == unit;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnit = unit;
          selectedValue = unit == "Kg" ? 40.00 : 88.18;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
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
