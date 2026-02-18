import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CycleRegularityScreen extends StatefulWidget {
  final VoidCallback onNext;

  const CycleRegularityScreen({super.key, required this.onNext});

  @override
  State<CycleRegularityScreen> createState() => _CycleRegularityScreenState();
}

class _CycleRegularityScreenState extends State<CycleRegularityScreen> {
  bool isRegular = true;

  int selectedRegular = 28;
  int selectedMin = 28;
  int selectedMax = 32;

  final List<int> days = List.generate(15, (index) => 21 + index); // 21–35

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Section (Title + Toggle)
            Text(
              "How long does your\ncycle last?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toggle("Regular", isRegular),
                SizedBox(width: 12),
                toggle("Irregular", !isRegular),
              ],
            ),

            SizedBox(height: 20),
            Divider(),

            /// 🔥 THIS MAKES PICKER CENTERED
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 250, // important for proper centering
                  child: isRegular ? buildSinglePicker() : buildDoublePicker(),
                ),
              ),
            ),

            /// Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(label: "Continue", ontap: widget.onNext),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// SINGLE PICKER (REGULAR)
  /// ------------------------------
  Widget buildSinglePicker() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 50,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedRegular = days[index];
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedRegular;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 40,
                    height: 1.5,
                    color: AppColors.lightgrey,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ------------------------------
  /// DOUBLE PICKER (IRREGULAR)
  /// ------------------------------
  Widget buildDoublePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: buildMinPicker()),
        Expanded(child: buildMaxPicker()),
      ],
    );
  }

  Widget buildMinPicker() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 50,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedMin = days[index];
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedMin;

          return buildPickerItem(day, isSelected);
        },
      ),
    );
  }

  Widget buildMaxPicker() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 50,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedMax = days[index];
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedMax;

          return buildPickerItem(day, isSelected);
        },
      ),
    );
  }

  Widget buildPickerItem(int day, bool isSelected) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 40,
              height: 2,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    );
  }

  /// ------------------------------
  /// TOGGLE BUTTON
  /// ------------------------------
  Widget toggle(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRegular = text == "Regular";
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 44,
        width: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
