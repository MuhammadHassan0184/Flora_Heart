import 'package:floraheart/Controllers/onboarding_controller.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CycleRegularityScreen extends StatefulWidget {
  final VoidCallback onNext;

  const CycleRegularityScreen({super.key, required this.onNext});

  @override
  State<CycleRegularityScreen> createState() => _CycleRegularityScreenState();
}

class _CycleRegularityScreenState extends State<CycleRegularityScreen> {
  final RxBool isRegular = true.obs;

  final RxInt selectedRegular = 28.obs;
  final RxInt selectedMin = 28.obs;
  final RxInt selectedMax = 32.obs;

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

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toggle("Regular", isRegular.value),
                const SizedBox(width: 12),
                toggle("Irregular", !isRegular.value),
              ],
            )),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),

            /// 🔥 THIS MAKES PICKER CENTERED
            Center(
              child: SizedBox(
                height: 250,
                child: Obx(() => isRegular.value ? buildSinglePicker() : buildDoublePicker()),
              ),
            ),

            Spacer(),

            /// Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Continue",
                ontap: () {
                  final onboarding = Get.find<OnboardingController>();
                  if (isRegular.value && selectedRegular.value <= 0) {
                    Get.snackbar(
                      "Error",
                      "Please select your cycle length",
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  if (!isRegular.value && (selectedMin.value <= 0 || selectedMax.value <= 0)) {
                    Get.snackbar(
                      "Error",
                      "Please select your cycle range",
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  onboarding.cycleLength = isRegular.value
                      ? selectedRegular.value
                      : selectedMax.value;
                  widget.onNext();
                },
              ),
              // CustomButton(
              //   label: "Continue",
              //   // ontap: widget.onNext,
              //   ontap: () {
              //     final onboarding = Get.find<OnboardingController>();

              //     onboarding.cycleLength = isRegular
              //         ? selectedRegular
              //         : selectedMax;

              //     widget.onNext();
              //   },
              // ),
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
        selectedRegular.value = days[index];
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          return Obx(() {
            final isSelected = day == selectedRegular.value;

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
                      color: AppColors.lightgrey,
                    ),
                ],
              ),
            );
          });
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
        selectedMin.value = days[index];
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          return Obx(() {
            final isSelected = day == selectedMin.value;
            return buildPickerItem(day, isSelected);
          });
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
        selectedMax.value = days[index];
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: days.length,
        builder: (context, index) {
          final day = days[index];
          return Obx(() {
            final isSelected = day == selectedMax.value;
            return buildPickerItem(day, isSelected);
          });
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
        isRegular.value = text == "Regular";
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
