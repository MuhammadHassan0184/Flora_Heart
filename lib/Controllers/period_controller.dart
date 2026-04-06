// ignore_for_file: avoid_print

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PeriodController extends GetxController {
  /// PERIOD RANGE
  final Rxn<DateTime> periodStart = Rxn<DateTime>();
  final Rxn<DateTime> periodEnd = Rxn<DateTime>();

  /// DATA LOAD FLAG
  final RxBool isLoaded = false.obs;

  /// MANUAL OVULATION DATES
  final RxList<DateTime> manualOvulationDates = <DateTime>[].obs;

  /// PERIOD HISTORY (for smarter predictions)
  final RxList<DateTime> periodHistory = <DateTime>[].obs;

  /// DEFAULT VALUES
  final int defaultCycleLength = 28;
  final int defaultPeriodLength = 5;

  /// --- CACHING FOR PERFORMANCE ---
  Set<int>? _cachedPredictedPeriod;
  Set<int>? _cachedPredictedFertility;
  Set<int>? _cachedPredictedOvulation;

  void _clearPredictionCache() {
    _cachedPredictedPeriod = null;
    _cachedPredictedFertility = null;
    _cachedPredictedOvulation = null;
  }

  int _toKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  /// USER ID
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? "";

  /// CHECK IF PERIOD IS RUNNING
  bool get isPeriodRunning =>
      periodStart.value != null && periodEnd.value == null;

  /// LOAD PERIOD FROM FIREBASE
  Future<void> loadPeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        isLoaded.value = true;
        return;
      }

      final data = doc.data()!;

      if (data['periodStart'] != null) {
        periodStart.value = DateTime.parse(data['periodStart']);
      }

      if (data['periodEnd'] != null) {
        periodEnd.value = DateTime.parse(data['periodEnd']);
      }

      /// Load start date in history
      if (periodStart.value != null) {
        periodHistory.clear();
        periodHistory.add(periodStart.value!);
      }

      isLoaded.value = true;
      _clearPredictionCache();
      print("Period loaded successfully");
    } catch (e) {
      print("LOAD PERIOD ERROR $e");
      isLoaded.value = true;
    }
  }

  /// START PERIOD
  Future<void> startPeriod(DateTime start) async {
    periodStart.value = start;
    periodEnd.value = null;
    _clearPredictionCache();

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "periodStart": start.toIso8601String(),
        "periodEnd": null,
      }, SetOptions(merge: true));

      /// Save to history if not already there
      if (!periodHistory.contains(start)) {
        periodHistory.add(start);
      }

      print("Period started: $start");
    } catch (e) {
      print("START PERIOD ERROR $e");
    }

    print("PERIOD START SAVED: $start");
    update();
  }

  /// END PERIOD
  Future<void> endPeriod(DateTime end) async {
    periodEnd.value = end;
    _clearPredictionCache();

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "periodEnd": end.toIso8601String(),
      }, SetOptions(merge: true));

      print("Period ended: $end");
    } catch (e) {
      print("END PERIOD ERROR $e");
    }

    print("PERIOD END SAVED: $end");
    update();
  }

  /// SET RANGE
  void setRange(DateTime start, DateTime end) {
    periodStart.value = start;
    periodEnd.value = end;
    _clearPredictionCache();
    update();
  }

  /// SAVE PERIOD
  Future<void> savePeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        if (periodStart.value != null)
          "periodStart": periodStart.value!.toIso8601String(),
        if (periodEnd.value != null)
          "periodEnd": periodEnd.value!.toIso8601String(),
      }, SetOptions(merge: true));

      print("Period saved successfully");
    } catch (e) {
      print("SAVE PERIOD ERROR $e");
    }
  }

  /// AVERAGE CYCLE LENGTH (Safe minimum of 20 days)
  int get averageCycleLength {
    if (periodHistory.isEmpty) return defaultCycleLength;
    if (periodHistory.length < 2) return defaultCycleLength;

    List<int> cycles = [];
    for (int i = 1; i < periodHistory.length; i++) {
      final prev = periodHistory[i - 1];
      final current = periodHistory[i];
      int diff = current.difference(prev).inDays;
      if (diff > 15) cycles.add(diff);
    }

    if (cycles.isEmpty) return defaultCycleLength;
    int avg = (cycles.reduce((a, b) => a + b) / cycles.length).round();
    return max(20, min(avg, 45)); // Safety clamp
  }

  /// AVERAGE PERIOD LENGTH
  int get averagePeriodLength {
    if (periodStart.value == null || periodEnd.value == null) {
      return defaultPeriodLength;
    }
    int diff = periodEnd.value!.difference(periodStart.value!).inDays + 1;
    return max(1, min(diff, 10)); // Safety clamp
  }

  /// CURRENT CYCLE DAY
  int get cycleDay {
    if (periodStart.value == null) return 0;
    return DateTime.now().difference(periodStart.value!).inDays + 1;
  }

  /// OVULATION DATE
  DateTime? get ovulationDate {
    if (periodStart.value == null) return null;
    return periodStart.value!.add(const Duration(days: 14));
  }

  /// SMART OVULATION
  DateTime? get smartOvulationDate {
    if (periodStart.value == null) return null;
    final nextPeriod = periodStart.value!.add(
      Duration(days: averageCycleLength),
    );
    return nextPeriod.subtract(const Duration(days: 14));
  }

  /// NEXT PERIOD DATE
  DateTime? get nextPeriodDate {
    if (periodStart.value == null) return null;
    return periodStart.value!.add(Duration(days: averageCycleLength));
  }

  /// FERTILITY WINDOW
  List<DateTime> get fertilityWindow {
    if (ovulationDate == null) return [];
    return List.generate(
      6,
      (index) => ovulationDate!
          .subtract(const Duration(days: 3))
          .add(Duration(days: index)),
    );
  }

  /// PREDICTED PERIOD RANGE (Future-Only Fix)
  List<DateTime> get predictedPeriodRange {
    if (periodStart.value == null) return [];
    
    List<DateTime> allPredictions = [];
    int cycleLen = averageCycleLength;
    int periodLen = averagePeriodLength;
    
    DateTime today = DateTime.now();
    DateTime lastKnownBound = periodEnd.value ?? periodStart.value!.add(const Duration(days: 5));

    for (int i = 1; i <= 6; i++) {
      DateTime nextStart = periodStart.value!.add(Duration(days: cycleLen * i));
      if (nextStart.isBefore(lastKnownBound) || nextStart.isBefore(today.subtract(const Duration(days: 1)))) {
        continue;
      }

      for (int j = 0; j < periodLen; j++) {
        allPredictions.add(nextStart.add(Duration(days: j)));
      }
    }
    
    _cachedPredictedPeriod = allPredictions.map(_toKey).toSet();
    return allPredictions;
  }

  /// PREDICTED FERTILITY WINDOW (Future-Only Fix)
  List<DateTime> get predictedFertilityWindow {
    if (periodStart.value == null) return [];

    List<DateTime> allFertility = [];
    int cycleLen = averageCycleLength;
    DateTime today = DateTime.now();
    DateTime lastKnownBound = periodEnd.value ?? periodStart.value!.add(const Duration(days: 5));

    for (int i = 1; i <= 6; i++) {
      DateTime nextStart = periodStart.value!.add(Duration(days: cycleLen * i));
      DateTime ovulation = nextStart.subtract(const Duration(days: 14));
      
      if (ovulation.isBefore(lastKnownBound) || ovulation.isBefore(today.subtract(const Duration(days: 5)))) {
        continue;
      }

      for (int j = -3; j <= 2; j++) {
        allFertility.add(ovulation.add(Duration(days: j)));
      }
    }

    _cachedPredictedFertility = allFertility.map(_toKey).toSet();
    return allFertility;
  }

  /// PREDICTED OVULATION DATES (Future-Only Fix)
  List<DateTime> get predictedOvulationDates {
    if (periodStart.value == null) return [];

    List<DateTime> allOvulation = [];
    int cycleLen = averageCycleLength;
    DateTime today = DateTime.now();
    DateTime lastKnownBound = periodEnd.value ?? periodStart.value!.add(const Duration(days: 5));

    for (int i = 1; i <= 6; i++) {
      DateTime nextStart = periodStart.value!.add(Duration(days: cycleLen * i));
      DateTime ovulation = nextStart.subtract(const Duration(days: 14));

      if (ovulation.isBefore(lastKnownBound) || ovulation.isBefore(today.subtract(const Duration(days: 1)))) {
        continue;
      }

      allOvulation.add(ovulation);
    }

    _cachedPredictedOvulation = allOvulation.map(_toKey).toSet();
    return allOvulation;
  }

  /// CHECK IF DATE IS WITHIN PERIOD
  bool isInPeriod(DateTime date) {
    if (periodStart.value == null) return false;
    final start = DateTime(
      periodStart.value!.year,
      periodStart.value!.month,
      periodStart.value!.day,
    );
    final end = periodEnd.value != null
        ? DateTime(
            periodEnd.value!.year,
            periodEnd.value!.month,
            periodEnd.value!.day,
          )
        : start.add(const Duration(days: 5)); // Highlight 6 days (start + 5)

    final check = DateTime(date.year, date.month, date.day);
    return !check.isBefore(start) && !check.isAfter(end);
  }

  /// REFRESH MANUAL OVULATION DATES
  Future<void> refreshManualOvulationDates() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("logs")
          .where("ovulationTest", isEqualTo: "Positive")
          .get();

      final dates = snapshot.docs.map((doc) => DateTime.parse(doc.id)).toList();
      manualOvulationDates.assignAll(dates);
      print("Manual ovulation dates refreshed: ${dates.length}");
    } catch (e) {
      print("REFRESH MANUAL OVULATION ERROR $e");
    }
  }

  /// CHECK IF DATE IS IN PREDICTED FERTILITY WINDOW
  bool isInFertility(DateTime date) {
    if (_cachedPredictedFertility == null) {
      predictedFertilityWindow; // triggers cache
    }
    return _cachedPredictedFertility?.contains(_toKey(date)) ?? false;
  }

  /// CHECK IF DATE IS OVULATION DAY
  bool isOvulationDay(DateTime date) {
    if (_cachedPredictedOvulation == null) {
      predictedOvulationDates; // triggers cache
    }
    return _cachedPredictedOvulation?.contains(_toKey(date)) ?? false;
  }

  /// CHECK IF DATE IS IN PREDICTED PERIOD RANGE
  bool isInPredictedPeriod(DateTime date) {
    if (_cachedPredictedPeriod == null) {
      predictedPeriodRange; // triggers cache
    }
    return _cachedPredictedPeriod?.contains(_toKey(date)) ?? false;
  }
}
