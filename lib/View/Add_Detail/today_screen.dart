// ignore_for_file: deprecated_member_use, avoid_print

import 'package:floraheart/Controllers/dashboard_controller.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/Widgets/custom_card_button.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/drink_water_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/medicine_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/note_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/temperature_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/tests_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/BottonSheets/weight_bottomsheet.dart';
import 'package:floraheart/View/Add_Detail/cards/flow_select.dart';
import 'package:floraheart/View/Add_Detail/cards/mood_section.dart';
import 'package:floraheart/View/Add_Detail/cards/sexual_activity.dart';
import 'package:floraheart/View/Add_Detail/cards/symptoms_section.dart';
import 'package:floraheart/View/Add_Detail/cards/vaginal_discharge.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  int selectedIndex = 0; // 0 = Start, 1 = End
  late TodayDataController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TodayDataController(), permanent: true);
    final periodCtrl = Get.find<PeriodController>();

    controller.loadTodayData(); // 🔥 LOAD DATA
    periodCtrl.refreshManualOvulationDates(); // 🔥 LOAD OVULATION DATES

    // Set selected date to period start if it's running
    if (periodCtrl.periodStart.value != null &&
        periodCtrl.periodEnd.value == null) {
      _selectedDate = periodCtrl.periodStart.value!;
      _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    }

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
    final periodCtrl =
        Get.find<PeriodController>(); // 🔥 Define once for the whole build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Today"),
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

                          return GestureDetector(
                            onTap: () async {
                              try {
                                // 🔥 Save current date data before switching
                                await controller.saveTodayData();

                                // Refresh manual dates if a positive test was just saved
                                if (controller.ovulationTest.value ==
                                    "Positive") {
                                  await periodCtrl
                                      .refreshManualOvulationDates();
                                }

                                setState(() {
                                  _selectedDate = date;
                                });

                                // 🔥 Reload data for the new selected date
                                await controller.loadTodayData(
                                  DateFormat('yyyy-MM-dd').format(date),
                                );
                              } catch (e) {
                                print("SWITCH DATE ERROR: $e");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Obx(() {
                                // Wrap in Obx to react to manualOvulationDates changes
                                bool isSelected =
                                    _selectedDate.year == date.year &&
                                    _selectedDate.month == date.month &&
                                    _selectedDate.day == date.day;

                                bool isInPeriod = periodCtrl.isInPeriod(date);

                                // Check if this date has a positive ovulation test
                                bool isOvulationPos = periodCtrl
                                    .manualOvulationDates
                                    .any(
                                      (d) =>
                                          d.year == date.year &&
                                          d.month == date.month &&
                                          d.day == date.day,
                                    );

                                return isSelected
                                    ? _selectedItem(
                                        date,
                                        isInPeriod,
                                        isOvulationPos,
                                      )
                                    : _normalItem(
                                        date,
                                        isInPeriod,
                                        isOvulationPos,
                                      );
                              }),
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
            Obx(() {
              bool isRunning =
                  periodCtrl.periodStart.value != null &&
                  periodCtrl.periodEnd.value == null;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// START BUTTON
                        () {
                          bool isStartDate = false;
                          if (periodCtrl.periodStart.value != null) {
                            final ps = periodCtrl.periodStart.value!;
                            isStartDate =
                                _selectedDate.year == ps.year &&
                                _selectedDate.month == ps.month &&
                                _selectedDate.day == ps.day;
                          }

                          // If period is running, only enable "Start" if on the start date
                          // If period is not running, allow starting on any date
                          bool isStartButtonEnabled =
                              !isRunning || (isRunning && isStartDate);

                          return Expanded(
                            child: GestureDetector(
                              onTap: !isStartButtonEnabled
                                  ? null
                                  : () async {
                                      setState(() {
                                        selectedIndex = 0;
                                      });
                                      await periodCtrl.startPeriod(
                                        _selectedDate,
                                      );
                                    },
                              child: Opacity(
                                opacity: isStartButtonEnabled ? 1.0 : 0.4,
                                child: Container(
                                  height: 37,
                                  decoration: BoxDecoration(
                                    color: selectedIndex == 0
                                        ? AppColors.primary
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
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
                            ),
                          );
                        }(),

                        const SizedBox(width: 20),

                        /// END BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: !isRunning
                                ? null
                                : () async {
                                    setState(() {
                                      selectedIndex = 1;
                                    });
                                    await periodCtrl.endPeriod(DateTime.now());
                                  },
                            child: Opacity(
                              opacity: !isRunning ? 0.4 : 1.0,
                              child: Container(
                                height: 37,
                                decoration: BoxDecoration(
                                  color: selectedIndex == 1
                                      ? AppColors.primary
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.stop,
                                      color: Colors.white,
                                      size: 18,
                                    ),
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) => const BasalTemperatureBottomSheet(),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) => const WeightBottomSheet(),
                );
              },
            ),
            SizedBox(height: 10),
            SexualActivitySection(),
            SizedBox(height: 10),
            CustomCardButton(
              label: "Tests",
              onTap: () {
                TestsBottomSheet.show(context);
              },
            ),
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
            CustomCardButton(
              label: "Drink Water",
              onTap: () {
                DrinkWaterBottomSheet.show(context);
              },
            ),
            SizedBox(height: 10),
            CustomCardButton(
              label: "Note",
              onTap: () {
                NoteBottomsheet.show(context);
              },
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                label: "Done",
                ontap: () async {
                  try {
                    final controller = Get.find<TodayDataController>();
                    final periodCtrl = Get.find<PeriodController>();
                    final dashboardController = Get.find<DashboardController>();

                    await controller.saveTodayData();

                    // Refresh manual ovulation dates in case it changed
                    if (controller.ovulationTest.value == "Positive") {
                      await periodCtrl.refreshManualOvulationDates();
                    }

                    // 🔥 Switch to Calendar tab (index 1) and go back
                    dashboardController.updateIndex(1);
                    Get.back();
                  } catch (e) {
                    print("SAVE ERROR FULL: $e");

                    Get.snackbar(
                      "Error",
                      e.toString(), // show real error
                    );
                  }
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

  Widget _normalItem(DateTime date, bool isInPeriod, bool isOvulationPos) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isInPeriod ? const Color(0xffF8D7DA) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isInPeriod ? AppColors.primary : Colors.black,
                ),
              ),
              if (isOvulationPos)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
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

  Widget _selectedItem(DateTime date, bool isInPeriod, bool isOvulationPos) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF8D7DA),
        borderRadius: BorderRadius.circular(12),
        border: isInPeriod
            ? Border.all(color: AppColors.primary, width: 1)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
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
          if (isOvulationPos)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
