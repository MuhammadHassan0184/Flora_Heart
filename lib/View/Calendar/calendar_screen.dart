// ignore_for_file: deprecated_member_use

import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/Widgets/custom_calendar.dart';
import 'package:floraheart/Widgets/custom_edit_button.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late TodayDataController controller;
  late PeriodController periodCtrl;

  // @override
  // void initState() {
  //   super.initState();
  //   // ✅ Ensure controller exists
  //   controller = Get.put(TodayDataController(), permanent: true);
  // }
  @override
  void initState() {
    super.initState();
    controller = Get.put(TodayDataController(), permanent: true);
    periodCtrl = Get.put(PeriodController(), permanent: true);
    // load persisted info
    controller.loadTodayData();
    periodCtrl.loadPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Calendar", showBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // show range from controller
            Obx(
              () => CustomCalendar(
                initialStartDate: periodCtrl.periodStart.value,
                initialEndDate: periodCtrl.periodEnd.value,
                ovulationDate: periodCtrl.ovulationDate,
                nextPeriodDate: periodCtrl.nextPeriodDate,
                fertilityWindow: periodCtrl.fertilityWindow,
                enabled: false,
                showPredictedColors: periodCtrl.periodEnd.value != null,
                onRangeSelected: (start, end) async {
                  await periodCtrl.startPeriod(start);
                },
              ),
            ),
            SizedBox(height: 1),
            // current date--
            
            Obx(() {
              String subtitle = "Cycle Day 3"; // Default or fallback
              
              if (periodCtrl.periodStart.value != null) {
                final start = periodCtrl.periodStart.value!;
                final today = DateTime.now();
                final diff = today.difference(start).inDays + 1;
                
                if (periodCtrl.periodEnd.value == null) {
                  subtitle = "Period Day $diff";
                } else {
                  subtitle = "Cycle Day $diff";
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  title: Text(
                    DateFormat('MMM d').format(DateTime.now()),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: CustomEditButton(),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: AppColors.grey.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 71,
                    height: 29,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Low",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Chance of getting pregnant",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // ✅ Your design wrapped in Obx for reactivity
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Flow -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.flow.value == 0
                              ? "Light"
                              : controller.flow.value == 1
                              ? "Medium"
                              : controller.flow.value == 2
                              ? "Heavy"
                              : controller.flow.value == 3
                              ? "Disaster"
                              : "-",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Mood -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.moods.join(', '),
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Symptoms -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            // controller.symptoms.entries
                            //     .map((e) => e.value.join(', '))
                            //     .join(', '),
                            controller.symptoms.values
                                .expand((e) => e)
                                .join(", "),
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Vaginal Discharge -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.discharge.join(', '),
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Basal Body Temperature -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${controller.temperature.value.toStringAsFixed(2)} °C",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Inside the Obx Column in CalendarScreen (after Vaginal Discharge row)
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Sexual Activity -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.sexualActivity.value.isNotEmpty
                              ? controller.sexualActivity.value
                              : "-",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Weight -",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${controller.weight.value.toStringAsFixed(2)} Kg",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
