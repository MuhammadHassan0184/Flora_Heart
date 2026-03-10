// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  /// Optional initial date range to be displayed/highlighted when the calendar
  /// appears. Parents can update these values and the widget will adjust
  /// accordingly via `didUpdateWidget`.
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  /// When true (default) the user can tap to select a range. When false the
  /// calendar is read-only and taps are ignored.
  final bool enabled;

  /// Called once the user has selected both a start and an end date that fit
  /// within the allowed range. The callback may be used by parents to persist
  /// or react to the selection.
  final void Function(DateTime start, DateTime end)? onRangeSelected;

  const CustomCalendar({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onRangeSelected,
    this.enabled = true,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime currentMonth = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  static const int maxRangeDays = 5;
  final List<String> weekDays = ["mo", "tu", "we", "th", "fr", "sa", "su"];

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    if (startDate != null) {
      currentMonth = DateTime(startDate!.year, startDate!.month);
    }
  }

  @override
  void didUpdateWidget(covariant CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStartDate != oldWidget.initialStartDate ||
        widget.initialEndDate != oldWidget.initialEndDate) {
      startDate = widget.initialStartDate;
      endDate = widget.initialEndDate;
      if (startDate != null) {
        setState(() {
          currentMonth = DateTime(startDate!.year, startDate!.month);
        });
      }
    }
  }

  void _handleCellTap(DateTime cellDate) {
    if (!widget.enabled) return;

    setState(() {
      if (startDate == null || (startDate != null && endDate != null)) {
        // begin new range
        startDate = cellDate;
        endDate = null;
      } else {
        // choosing the end date
        DateTime newStart = startDate!;
        DateTime newEnd = cellDate;
        if (newEnd.isBefore(newStart)) {
          final tmp = newStart;
          newStart = newEnd;
          newEnd = tmp;
        }
        final days = newEnd.difference(newStart).inDays + 1;
        if (days > maxRangeDays) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Period cannot exceed $maxRangeDays days."),
              backgroundColor: AppColors.primary,
            ),
          );
          return;
        }
        startDate = newStart;
        endDate = newEnd;
        widget.onRangeSelected?.call(startDate!, endDate!);
      }
    });
  }

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
                  onTap: isCurrentMonth ? () => _handleCellTap(cellDate) : null,
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
