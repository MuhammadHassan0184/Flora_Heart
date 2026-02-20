// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime currentMonth = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  final List<String> weekDays = ["mo", "tu", "we", "th", "fr", "sa", "su"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            /// Month Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _arrowButton(Icons.chevron_left, () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                    );
                  });
                }),
                Text(
                  "${_monthName(currentMonth.month)} ${currentMonth.year}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _arrowButton(Icons.chevron_right, () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                    );
                  });
                }),
              ],
            ),

            const SizedBox(height: 20),

            /// Week Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays
                  .map(
                    (e) => Text(
                      e,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 15),

            /// Dates Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 42,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final firstDayOfMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month,
                  1,
                );

                int startWeekday =
                    firstDayOfMonth.weekday % 7; // make Monday first

                final daysInMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month + 1,
                  0,
                ).day;

                final daysInPrevMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month,
                  0,
                ).day;

                int dayNumber = index - startWeekday + 1;

                DateTime cellDate;

                bool isCurrentMonth = true;

                if (dayNumber < 1) {
                  cellDate = DateTime(
                    currentMonth.year,
                    currentMonth.month - 1,
                    daysInPrevMonth + dayNumber,
                  );
                  isCurrentMonth = false;
                } else if (dayNumber > daysInMonth) {
                  cellDate = DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                    dayNumber - daysInMonth,
                  );
                  isCurrentMonth = false;
                } else {
                  cellDate = DateTime(
                    currentMonth.year,
                    currentMonth.month,
                    dayNumber,
                  );
                }

                bool isSelected = false;

                if (startDate != null && endDate != null) {
                  isSelected =
                      cellDate.isAfter(
                        startDate!.subtract(const Duration(days: 1)),
                      ) &&
                      cellDate.isBefore(endDate!.add(const Duration(days: 1)));
                }

                return GestureDetector(
                  onTap: isCurrentMonth
                      ? () {
                          setState(() {
                            if (startDate == null ||
                                (startDate != null && endDate != null)) {
                              startDate = cellDate;
                              endDate = null;
                            } else {
                              if (cellDate.isBefore(startDate!)) {
                                endDate = startDate;
                                startDate = cellDate;
                              } else {
                                endDate = cellDate;
                              }
                            }
                          });
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${cellDate.day}",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isCurrentMonth
                            ? Colors.black
                            : Colors.grey.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _arrowButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20),
    ),
  );
}

String _monthName(int month) {
  const months = [
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
  return months[month - 1];
}
