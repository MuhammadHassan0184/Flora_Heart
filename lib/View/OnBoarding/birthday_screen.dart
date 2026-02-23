import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class BirthdayScreen extends StatefulWidget {
  final VoidCallback onNext;

  const BirthdayScreen({super.key, required this.onNext});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  int selectedDay = 0;
  int selectedMonth = 2;
  int selectedYear = 33; // 1998 if start 1965

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    dayController = FixedExtentScrollController(initialItem: selectedDay);
    monthController = FixedExtentScrollController(initialItem: selectedMonth);
    yearController = FixedExtentScrollController(initialItem: selectedYear);
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(height: 20),
            Text(
              "What's your birthday?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 50),

            // 🔴 Date Field Like Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(selectedDay + 1).toString().padLeft(2, '0')}."
                      "${(selectedMonth + 1).toString().padLeft(2, '0')}."
                      "${1965 + selectedYear}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_month, size: 18),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: AppColors.lightgrey),
            ),
            SizedBox(height: 15),

            pickerRow(),

            Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(label: "Continue", ontap: widget.onNext,),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget pickerRow() {
    return SizedBox(
      height: 230,
      child: Row(
        children: [
          buildWheel(
            controller: dayController,
            itemCount: 31,
            onChanged: (index) {
              setState(() => selectedDay = index);
            },
            builder: (index) => (index + 1).toString().padLeft(2, '0'),
          ),
          buildWheel(
            controller: monthController,
            itemCount: 12,
            onChanged: (index) {
              setState(() => selectedMonth = index);
            },
            builder: (index) => months[index],
          ),
          buildWheel(
            controller: yearController,
            itemCount: 60,
            onChanged: (index) {
              setState(() => selectedYear = index);
            },
            builder: (index) => (1965 + index).toString(),
          ),
        ],
      ),
    );
  }

  Widget buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Function(int) onChanged,
    required String Function(int) builder,
  }) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 45,
            diameterRatio: 1.4,
            perspective: 0.003,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final isSelected = controller.selectedItem == index;

                return Center(
                  child: Text(
                    builder(index),
                    style: TextStyle(
                      fontSize: isSelected ? 20 : 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          
          Positioned(
            bottom: 92,
            left: 20,
            right: 20,
            child: Divider(thickness: 1, color: AppColors.lightgrey),
          ),
        ],
      ),
    );
  }
}
