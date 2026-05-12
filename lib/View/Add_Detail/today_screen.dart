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
  final Rx<DateTime> _currentMonth = DateTime.now().obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxInt selectedIndex = 0.obs; // 0 = Start, 1 = End

  final ScrollController _scrollController = ScrollController();
  late TodayDataController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TodayDataController(), permanent: true);
    final periodCtrl = Get.find<PeriodController>();

    controller.loadTodayData();
    periodCtrl.refreshManualOvulationDates();

    if (periodCtrl.periodStart.value != null &&
        periodCtrl.periodEnd.value == null) {
      _selectedDate.value = periodCtrl.periodStart.value!;
      _currentMonth.value = DateTime(_selectedDate.value.year, _selectedDate.value.month);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    int dayIndex = _selectedDate.value.day - 1;
    double position = dayIndex * 60.0;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _changeMonth(int value) {
    _currentMonth.value = DateTime(_currentMonth.value.year, _currentMonth.value.month + value);
    _selectedDate.value = DateTime(_currentMonth.value.year, _currentMonth.value.month, 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final periodCtrl = Get.find<PeriodController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Today"),
      body: SingleChildScrollView(
        child: Obx(() {
          int totalDays = _daysInMonth(_currentMonth.value);
          
          return Column(
            children: [
              /// ===== Calendar Container =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    /// Month Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _changeMonth(-1),
                            child: _arrowButton(Icons.chevron_left),
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(_currentMonth.value),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _changeMonth(1),
                            child: _arrowButton(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

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
                              _currentMonth.value.year,
                              _currentMonth.value.month,
                              index + 1,
                            );

                            bool isSelected =
                                _selectedDate.value.year == date.year &&
                                _selectedDate.value.month == date.month &&
                                _selectedDate.value.day == date.day;

                            bool isInPeriod = periodCtrl.isInPeriod(date);
                            bool isOvulationPos = periodCtrl.manualOvulationDates.any(
                                  (d) =>
                                      d.year == date.year &&
                                      d.month == date.month &&
                                      d.day == date.day,
                                );

                            return GestureDetector(
                              onTap: () async {
                                try {
                                  await controller.saveTodayData();
                                  if (controller.ovulationTest.value == "Positive") {
                                    await periodCtrl.refreshManualOvulationDates();
                                  }
                                  _selectedDate.value = date;
                                  await controller.loadTodayData(
                                    DateFormat('yyyy-MM-dd').format(date),
                                  );
                                } catch (e) {
                                  print("SWITCH DATE ERROR: $e");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: isSelected
                                    ? _selectedItem(date, isInPeriod, isOvulationPos)
                                    : _normalItem(date, isInPeriod, isOvulationPos),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              
              () {
                bool isRunning = periodCtrl.periodStart.value != null &&
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
                      const Text(
                        "Period",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// START BUTTON
                          Expanded(
                            child: () {
                              bool isStartDate = false;
                              if (periodCtrl.periodStart.value != null) {
                                final ps = periodCtrl.periodStart.value!;
                                isStartDate =
                                    _selectedDate.value.year == ps.year &&
                                    _selectedDate.value.month == ps.month &&
                                    _selectedDate.value.day == ps.day;
                              }

                              bool isStartButtonEnabled = !isRunning || (isRunning && isStartDate);

                              return GestureDetector(
                                onTap: !isStartButtonEnabled
                                    ? null
                                    : () async {
                                        selectedIndex.value = 0;
                                        await periodCtrl.startPeriod(_selectedDate.value);
                                      },
                                child: Opacity(
                                  opacity: isStartButtonEnabled ? 1.0 : 0.4,
                                  child: Container(
                                    height: 37,
                                    decoration: BoxDecoration(
                                      color: selectedIndex.value == 0
                                          ? AppColors.primary
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
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
                              );
                            }(),
                          ),

                          const SizedBox(width: 20),

                          /// END BUTTON
                          Expanded(
                            child: GestureDetector(
                              onTap: !isRunning
                                  ? null
                                  : () async {
                                      selectedIndex.value = 1;
                                      await periodCtrl.endPeriod(DateTime.now());
                                    },
                              child: Opacity(
                                opacity: !isRunning ? 0.4 : 1.0,
                                child: Container(
                                  height: 37,
                                  decoration: BoxDecoration(
                                    color: selectedIndex.value == 1
                                        ? AppColors.primary
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }(),
              
              const SizedBox(height: 10),
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
                  children: const [
                    Text(
                      "Flow",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    FlowSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const MoodSection(),
              const SizedBox(height: 10),
              const SymptomsSection(),
              const SizedBox(height: 10),
              const DischargeSection(),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Basal Body Temperature",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (context) => const BasalTemperatureBottomSheet(),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Weight",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (context) => const WeightBottomSheet(),
                  );
                },
              ),
              const SizedBox(height: 10),
              const SexualActivitySection(),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Tests",
                onTap: () {
                  TestsBottomSheet.show(context);
                },
              ),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Drink Water",
                onTap: () {
                  DrinkWaterBottomSheet.show(context);
                },
              ),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Medicine",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MedicineBottomSheetExample(),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomCardButton(
                label: "Note",
                onTap: () {
                  NoteBottomsheet.show(context);
                },
              ),
              const SizedBox(height: 10),
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

                      if (controller.ovulationTest.value == "Positive") {
                        await periodCtrl.refreshManualOvulationDates();
                      }

                      dashboardController.updateIndex(1);
                      Get.back();
                    } catch (e) {
                      print("SAVE ERROR FULL: $e");
                      Get.snackbar("Error", e.toString());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
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
        const SizedBox(height: 4),
        Text(
          DateFormat('E').format(date),
          style: const TextStyle(
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
        border: isInPeriod ? Border.all(color: AppColors.primary, width: 1) : null,
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
              const SizedBox(height: 4),
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



