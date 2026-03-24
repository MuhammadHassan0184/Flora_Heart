// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:floraheart/Widgets/custom_button.dart';
import 'package:floraheart/Widgets/custom_calendar.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomEditButton extends StatelessWidget {
  const CustomEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (context) {
            final ctrl = Get.find<PeriodController>();
            DateTime? tempStart = ctrl.periodStart.value;
            DateTime? tempEnd = ctrl.periodEnd.value;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag Indicator
                        Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        SizedBox(height: 16),
                        Text(
                          "Edit Period",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 16),

                        CustomCalendar(
                          initialStartDate: tempStart,
                          initialEndDate: tempEnd,
                          onRangeSelected: (s, e) {
                            setModalState(() {
                              tempStart = s;
                              tempEnd = e;
                              ctrl.setRange(
                                s,
                                e,
                              ); // Update controller in real-time
                            });
                          },
                        ),

                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            label: "Done",
                            ontap: () async {
                              if (tempStart != null && tempEnd != null) {
                                ctrl.setRange(tempStart!, tempEnd!);
                                await ctrl.savePeriod();
                              }
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Period updated successfully!"),
                                  backgroundColor: AppColors.primary,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        width: 71,
        height: 29,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset("assets/PinkDrops.svg", width: 21, height: 21),
            Text("Edit", style: TextStyle(color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}
