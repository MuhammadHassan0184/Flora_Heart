import 'package:flutter/material.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';

class BasalTemperatureBottomSheet extends StatefulWidget {
  const BasalTemperatureBottomSheet({super.key});

  @override
  State<BasalTemperatureBottomSheet> createState() =>
      _BasalTemperatureBottomSheetState();
}

class _BasalTemperatureBottomSheetState
    extends State<BasalTemperatureBottomSheet> {
  String selectedUnit = "°C";
  double selectedValue = 36.00;

  late List<double> celsiusTemps;
  late List<double> fahrenheitTemps;

  @override
  void initState() {
    super.initState();

    // 36.00°C to 42.00°C (step 0.01)
    celsiusTemps = List.generate(601, (index) => 36.00 + index * 0.01);

    fahrenheitTemps = celsiusTemps.map((c) => (c * 9 / 5) + 32).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<double> temps = selectedUnit == "°C" ? celsiusTemps : fahrenheitTemps;

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
                  "${selectedValue.toStringAsFixed(2)} $selectedUnit",
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
              height: 150,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedValue = temps[index];
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: temps.length,
                  builder: (context, index) {
                    double temp = temps[index];

                    bool isSelected =
                        temp.toStringAsFixed(2) ==
                        selectedValue.toStringAsFixed(2);

                    return Center(
                      child: Text(
                        temp.toStringAsFixed(2),
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
                      duration: const Duration(seconds: 2),
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
          selectedValue = unit == "°C" ? 36.00 : 96.80; // 36°C in °F
        });
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
