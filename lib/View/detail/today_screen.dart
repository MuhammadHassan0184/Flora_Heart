// ignore_for_file: deprecated_member_use

import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_card_button.dart';
import 'package:floraheart/View/detail/BottonSheets/medicine_bottomsheet.dart';
import 'package:floraheart/View/detail/cards/flow_select.dart';
import 'package:floraheart/View/detail/cards/mood_section.dart';
import 'package:floraheart/View/detail/cards/sexual_activity.dart';
import 'package:floraheart/View/detail/cards/symptoms_section.dart';
import 'package:floraheart/View/detail/cards/vaginal_discharge.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    int dayIndex = _selectedDate.day - 1;
    double position = dayIndex * 60.0;
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _changeMonth(int value) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + value);

      _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, 1);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    int totalDays = _daysInMonth(_currentMonth);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Today",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ===== Calendar Container =====
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  /// Month Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Left Arrow
                        GestureDetector(
                          onTap: () => _changeMonth(-1),
                          child: _arrowButton(Icons.chevron_left),
                        ),

                        /// Month Name
                        Text(
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),

                        /// Right Arrow
                        GestureDetector(
                          onTap: () => _changeMonth(1),
                          child: _arrowButton(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  /// Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: SizedBox(
                      height: 70,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: totalDays,
                        itemBuilder: (context, index) {
                          DateTime date = DateTime(
                            _currentMonth.year,
                            _currentMonth.month,
                            index + 1,
                          );

                          bool isSelected =
                              _selectedDate.year == date.year &&
                              _selectedDate.month == date.month &&
                              _selectedDate.day == date.day;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: isSelected
                                  ? _selectedItem(date)
                                  : _normalItem(date),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              // height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Period",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// START BUTTON
                      Expanded(
                        child: Container(
                          height: 37,
                          decoration: BoxDecoration(
                            color: AppColors.primary, // red color
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                "Start",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      /// END BUTTON
                      Expanded(
                        child: Container(
                          height: 37,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stop, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "End",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flow",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  FlowSelector(),
                ],
              ),
            ),
            SizedBox(height: 10),
            MoodSection(),
            SizedBox(height: 10),
            SymptomsSection(),
            SizedBox(height: 10),
            DischargeSection(),
            SizedBox(height: 10),
            CustomCardButton(
              label: "Basal Body Temperature",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    String selectedUnit = "°C";
                    double selectedValue = 40.00;

                    // Create full list of temperatures
                    List<double> celsiusTemps = List.generate(
                      601,
                      (index) => 36.00 + index * 0.01,
                    ); // 36.00 to 42.00
                    List<double> fahrenheitTemps = celsiusTemps
                        .map((c) => c * 9 / 5 + 32)
                        .toList();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        List<double> temps = selectedUnit == "°C"
                            ? celsiusTemps
                            : fahrenheitTemps;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Text(
                                  "Temperature",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // °C / °F Toggle
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _unitToggle("°C", selectedUnit, () {
                                      setState(() {
                                        selectedUnit = "°C";
                                        selectedValue = 40.00;
                                      });
                                    }),
                                    SizedBox(width: 12),
                                    _unitToggle("°F", selectedUnit, () {
                                      setState(() {
                                        selectedUnit = "°F";
                                        selectedValue = 104.0; // 40°C in °F
                                      });
                                    }),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Display selected temperature
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: double.infinity,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
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
                                SizedBox(height: 16),

                                // Picker
                                SizedBox(
                                  height: 150,
                                  child: ListWheelScrollView.useDelegate(
                                    itemExtent: 40,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        selectedValue = temps[index];
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: temps.length,
                                          builder: (context, index) {
                                            double temp = temps[index];
                                            bool isSelected =
                                                temp.toStringAsFixed(2) ==
                                                selectedValue.toStringAsFixed(
                                                  2,
                                                );
                                            return Center(
                                              child: Text(
                                                temp.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: isSelected
                                                      ? 20
                                                      : 16,
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Done button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: CustomButton(
                                    label: "Done",
                                    ontap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Selected: ${selectedValue.toStringAsFixed(2)} $selectedUnit",
                                          ),
                                          backgroundColor: AppColors.primary,
                                          duration: Duration(seconds: 2),
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
                      },
                    );
                  },
                );
              },
            ),

            SizedBox(height: 10),
            CustomCardButton(
              label: "Weight",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    String selectedUnit = "Kg";
                    double selectedValue = 40.00;

                    // Create full list of temperatures
                    List<double> celsiusTemps = List.generate(
                      601,
                      (index) => 36.00 + index * 0.01,
                    ); // 36.00 to 42.00
                    List<double> fahrenheitTemps = celsiusTemps
                        .map((c) => c * 9 / 5 + 32)
                        .toList();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        List<double> temps = selectedUnit == "Lb"
                            ? celsiusTemps
                            : fahrenheitTemps;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // °C / °F Toggle
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _unitToggle("Kg", selectedUnit, () {
                                      setState(() {
                                        selectedUnit = "Lb";
                                        selectedValue = 40.00;
                                      });
                                    }),
                                    SizedBox(width: 12),
                                    _unitToggle("Lb", selectedUnit, () {
                                      setState(() {
                                        selectedUnit = "Lb";
                                        selectedValue = 88.0; // 40kg in lbs
                                      });
                                    }),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Display selected temperature
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: double.infinity,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
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
                                SizedBox(height: 16),

                                // Picker
                                SizedBox(
                                  height: 150,
                                  child: ListWheelScrollView.useDelegate(
                                    itemExtent: 40,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        selectedValue = temps[index];
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: temps.length,
                                          builder: (context, index) {
                                            double temp = temps[index];
                                            bool isSelected =
                                                temp.toStringAsFixed(2) ==
                                                selectedValue.toStringAsFixed(
                                                  2,
                                                );
                                            return Center(
                                              child: Text(
                                                temp.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: isSelected
                                                      ? 20
                                                      : 16,
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Done button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: CustomButton(
                                    label: "Done",
                                    ontap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Selected: ${selectedValue.toStringAsFixed(2)} $selectedUnit",
                                          ),
                                          backgroundColor: AppColors.primary,
                                          duration: Duration(seconds: 2),
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
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
            SexualActivitySection(),
            SizedBox(height: 10),
            CustomCardButton(
              label: "Medicine",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => MedicineBottomSheetExample(),
                );
              },
            ),
            SizedBox(height: 10),
            CustomCardButton(label: "Drink Water"),
            SizedBox(height: 10),
            CustomCardButton(label: "Tests"),
            SizedBox(height: 10),
            CustomCardButton(label: "Note"),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Done",
                ontap: () {
                  Get.toNamed(AppRoutesName.mainScreen);
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _arrowButton(IconData icon) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _normalItem(DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date.day.toString(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text(
          DateFormat('E').format(date),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _selectedItem(DateTime date) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF8D7DA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            DateFormat('E').format(date),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for toggle buttons
Widget _unitToggle(String unit, String selectedUnit, VoidCallback onTap) {
  bool isSelected = unit == selectedUnit;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        unit,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
