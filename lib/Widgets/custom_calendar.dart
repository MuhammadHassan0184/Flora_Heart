// ignore_for_file: deprecated_member_use

import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? ovulationDate;
  final List<DateTime>? manualOvulationDates; // NEW
  final DateTime? nextPeriodDate;
  final List<DateTime>? fertilityWindow;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool enabled;
  final void Function(DateTime start, DateTime end)? onRangeSelected;
  final void Function(DateTime date)? onDateTap; // NEW
  final DateTime? selectedDate; // NEW
  final List<DateTime>? predictedPeriodDates; // NEW
  final List<DateTime>? predictedFertilityDates; // NEW
  final List<DateTime>? predictedOvulationDates; // NEW
  final bool showPredictedColors; // NEW

  const CustomCalendar({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onRangeSelected,
    this.onDateTap,
    this.selectedDate,
    this.ovulationDate,
    this.manualOvulationDates,
    this.nextPeriodDate,
    this.fertilityWindow,
    this.predictedPeriodDates,
    this.predictedFertilityDates,
    this.predictedOvulationDates,
    this.enabled = true,
    this.showPredictedColors = false, // default false
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime currentMonth = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  Set<DateTime> selectedDates = {};

  String fertilityChance = "Low"; // default value

  // static const int maxRangeDays = 5;
  final List<String> weekDays = ["mo", "tu", "we", "th", "fr", "sa", "su"];

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    _syncSelectedDatesFromRange();
    if (startDate != null) {
      currentMonth = DateTime(startDate!.year, startDate!.month);
    }
  }

  void _syncSelectedDatesFromRange() {
    selectedDates.clear();
    if (startDate != null) {
      DateTime start = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
      );
      DateTime end = endDate != null
          ? DateTime(endDate!.year, endDate!.month, endDate!.day)
          : start.add(const Duration(days: 5)); // Default to 6 days

      DateTime current = start;
      while (!current.isAfter(end)) {
        selectedDates.add(current);
        current = current.add(const Duration(days: 1));
      }
    }
  }

  @override
  void didUpdateWidget(covariant CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStartDate != oldWidget.initialStartDate ||
        widget.initialEndDate != oldWidget.initialEndDate) {
      startDate = widget.initialStartDate;
      endDate = widget.initialEndDate;
      _syncSelectedDatesFromRange();
      if (startDate != null) {
        setState(() {
          currentMonth = DateTime(startDate!.year, startDate!.month);
        });
      }
    }
  }

  void _updateRangeFromSelectedDates() {
    if (selectedDates.isEmpty) {
      startDate = null;
      endDate = null;
    } else {
      final sorted = selectedDates.toList()..sort();
      startDate = sorted.first;
      endDate = sorted.last;
    }
  }

  void _handleCellTap(DateTime cellDate) {
    final normalizedDate = DateTime(
      cellDate.year,
      cellDate.month,
      cellDate.day,
    );

    if (!widget.enabled) {
      widget.onDateTap?.call(normalizedDate);
      return;
    }

    setState(() {
      if (selectedDates.contains(normalizedDate)) {
        // One-by-one deselection
        selectedDates.remove(normalizedDate);
      } else {
        if (selectedDates.isEmpty) {
          // Select 6 days (tapped date + 5 more)
          for (int i = 0; i < 6; i++) {
            selectedDates.add(normalizedDate.add(Duration(days: i)));
          }
        } else {
          // Manual addition
          selectedDates.add(normalizedDate);
        }
      }

      _updateRangeFromSelectedDates();
      widget.onDateTap?.call(normalizedDate);
    });

    if (startDate != null && endDate != null) {
      widget.onRangeSelected?.call(startDate!, endDate!);
    } else if (startDate != null) {
      widget.onRangeSelected?.call(startDate!, startDate!);
    }
  }

  String? _getFertilityChance(DateTime date) {
    // Only show for predicted colors
    if (!widget.showPredictedColors) return null;

    // Low: start/end of fertility window
    if (widget.predictedFertilityDates != null) {
      final index = widget.predictedFertilityDates!.indexWhere(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      if (index != -1) {
        if (index == 0 || index == widget.predictedFertilityDates!.length - 1) {
          return "Low";
        } else if (index == 1 ||
            index == widget.predictedFertilityDates!.length - 2) {
          return "Medium";
        } else {
          return "High";
        }
      }
    }

    // Ovulation date
    if (widget.ovulationDate != null &&
        date.year == widget.ovulationDate!.year &&
        date.month == widget.ovulationDate!.month &&
        date.day == widget.ovulationDate!.day) {
      return "High";
    }

    // Manual ovulation dates
    if (widget.manualOvulationDates != null) {
      for (var d in widget.manualOvulationDates!) {
        if (d.year == date.year && d.month == date.month && d.day == date.day) {
          return "High";
        }
      }
    }

    return null; // No chance for non-predicted dates
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
              children: const [
                Text("mo", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("tu", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("we", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("th", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("fr", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("sa", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                Text("su", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),

            const SizedBox(height: 15),
            
            /// Dates Grid
            Builder(
              builder: (context) {
                // --- OPTIMIZED COLOR LOOKUP MAP ---
                final Map<int, Color> calendarMap = {};
                int toKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

                // 1. Predictions (Lower Priority)
                if (widget.showPredictedColors) {
                  widget.fertilityWindow?.forEach((d) => calendarMap[toKey(d)] = const Color(0xFFFDD7DD));
                  widget.predictedFertilityDates?.forEach((d) => calendarMap[toKey(d)] = const Color(0xFFFDD7DD));
                  widget.predictedPeriodDates?.forEach((d) => calendarMap[toKey(d)] = AppColors.primary.withOpacity(0.7));
                  widget.predictedOvulationDates?.forEach((d) => calendarMap[toKey(d)] = const Color(0xFFA6E63F));
                  
                  if (widget.ovulationDate != null) calendarMap[toKey(widget.ovulationDate!)] = const Color(0xFFA6E63F);
                  if (widget.nextPeriodDate != null) calendarMap[toKey(widget.nextPeriodDate!)] = const Color(0xFFE57373);
                  widget.manualOvulationDates?.forEach((d) => calendarMap[toKey(d)] = const Color(0xFFA6E63F));
                }

                final firstDayOfMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month,
                  1,
                );

                // Correctly align with the "mo-su" header (Mon is 0, Sun is 6)
                int startWeekday = (firstDayOfMonth.weekday - 1);

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

                final totalItemsNeeded = startWeekday + daysInMonth;
                final itemCount = (totalItemsNeeded / 7).ceil() * 7;
 
                return RepaintBoundary(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      int dayNumber = index - startWeekday + 1;
                      DateTime cellDate;
                      bool isCurrentMonth = true;

                      if (dayNumber < 1) {
                        cellDate = DateTime(currentMonth.year, currentMonth.month - 1, daysInPrevMonth + dayNumber);
                        isCurrentMonth = false;
                      } else if (dayNumber > daysInMonth) {
                        cellDate = DateTime(currentMonth.year, currentMonth.month + 1, dayNumber - daysInMonth);
                        isCurrentMonth = false;
                      } else {
                        cellDate = DateTime(currentMonth.year, currentMonth.month, dayNumber);
                      }

                      final normalizedCellDate = DateTime(cellDate.year, cellDate.month, cellDate.day);
                      bool isSelected = selectedDates.contains(normalizedCellDate);

                      if (!isSelected && startDate != null && endDate == null) {
                        DateTime start = DateTime(startDate!.year, startDate!.month, startDate!.day);
                        DateTime end = start.add(const Duration(days: 5));
                        if (!normalizedCellDate.isBefore(start) && !normalizedCellDate.isAfter(end)) {
                          isSelected = true;
                        }
                      }

                      bool isTappedSelection = widget.selectedDate != null &&
                          normalizedCellDate.year == widget.selectedDate!.year &&
                          normalizedCellDate.month == widget.selectedDate!.month &&
                          normalizedCellDate.day == widget.selectedDate!.day;

                      final int cellKey = toKey(normalizedCellDate);
                      final Color? predictedColor = calendarMap[cellKey];

                      return GestureDetector(
                        onTap: isCurrentMonth
                            ? () {
                                _handleCellTap(cellDate);
                                final chance = _getFertilityChance(cellDate);
                                setState(() {
                                  fertilityChance = chance ?? "Low";
                                });
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (predictedColor == const Color(0xFFA6E63F)
                                    ? const Color(0xFFA6E63F)
                                    : AppColors.primary)
                                : isTappedSelection
                                ? AppColors.primary.withOpacity(0.5)
                                : predictedColor ?? Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isTappedSelection
                                ? Border.all(color: Colors.blue, width: 1.5)
                                : null,
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
