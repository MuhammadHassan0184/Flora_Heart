// // ignore_for_file: avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class PeriodController extends GetxController {
//   /// PERIOD RANGE
//   final Rxn<DateTime> periodStart = Rxn<DateTime>();
//   final Rxn<DateTime> periodEnd = Rxn<DateTime>();

//   /// DATA LOAD FLAG
//   final RxBool isLoaded = false.obs;

//   /// USER ID
//   String get uid => FirebaseAuth.instance.currentUser!.uid;

//   /// CHECK IF PERIOD IS RUNNING
//   bool get isPeriodRunning =>
//       periodStart.value != null && periodEnd.value == null;

//   /// LOAD PERIOD FROM FIREBASE
//   Future<void> loadPeriod() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (!doc.exists) {
//         isLoaded.value = true;
//         return;
//       }

//       final data = doc.data()!;

//       if (data['periodStart'] != null) {
//         periodStart.value = DateTime.parse(data['periodStart']);
//       }

//       if (data['periodEnd'] != null) {
//         periodEnd.value = DateTime.parse(data['periodEnd']);
//       }

//       isLoaded.value = true;
//       print("Period loaded successfully");
//     } catch (e) {
//       print("LOAD PERIOD ERROR $e");
//       isLoaded.value = true;
//     }
//   }

//   /// START PERIOD (TodayScreen / Calendar)
//   Future<void> startPeriod(DateTime start) async {
//     periodStart.value = start;
//     periodEnd.value = null;

//     try {
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         "periodStart": start.toIso8601String(),
//         "periodEnd": null,
//       }, SetOptions(merge: true));

//       print("Period started: $start");
//     } catch (e) {
//       print("START PERIOD ERROR $e");
//     }
//     print("PERIOD START SAVED: $start");

//     update();
//   }

//   /// END PERIOD (TodayScreen / Calendar)
//   Future<void> endPeriod(DateTime end) async {
//     periodEnd.value = end;

//     try {
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         "periodEnd": end.toIso8601String(),
//       }, SetOptions(merge: true));

//       print("Period ended: $end");
//     } catch (e) {
//       print("END PERIOD ERROR $e");
//     }
//     print("PERIOD END SAVED: $end");

//     update();
//   }

//   /// SET RANGE (USED IN EDIT CALENDAR)
//   void setRange(DateTime start, DateTime end) {
//     periodStart.value = start;
//     periodEnd.value = end;
//     update();
//   }

//   /// SAVE PERIOD (USED BY EDIT + ONBOARDING)
//   Future<void> savePeriod() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         if (periodStart.value != null)
//           "periodStart": periodStart.value!.toIso8601String(),
//         if (periodEnd.value != null)
//           "periodEnd": periodEnd.value!.toIso8601String(),
//       }, SetOptions(merge: true));

//       print("Period saved successfully");
//     } catch (e) {
//       print("SAVE PERIOD ERROR $e");
//     }
//   }

//   /// OVULATION DATE
//   DateTime? get ovulationDate {
//     if (periodStart.value == null) return null;
//     return periodStart.value!.add(const Duration(days: 14));
//   }

//   /// NEXT PERIOD DATE
//   DateTime? get nextPeriodDate {
//     if (periodStart.value == null) return null;
//     return periodStart.value!.add(const Duration(days: 28));
//   }

//   /// FERTILITY WINDOW
//   List<DateTime> get fertilityWindow {
//     if (ovulationDate == null) return [];

//     return List.generate(
//       6,
//       (index) => ovulationDate!
//           .subtract(const Duration(days: 3))
//           .add(Duration(days: index)),
//     );
//   }

//   /// PREDICTED PERIOD RANGE (5 days after period end)
//   List<DateTime> get predictedPeriodRange {
//     if (periodEnd == null) return [];
//     return List.generate(
//       5,
//       (index) => periodEnd.value!.add(Duration(days: index + 1)),
//     );
//   }

//   /// CHECK IF DATE IS WITHIN PERIOD
//   bool isInPeriod(DateTime date) {
//     if (periodStart.value == null) return false;
//     final start = periodStart.value!;
//     final end = periodEnd.value ?? start;
//     return !date.isBefore(start) && !date.isAfter(end);
//   }

//   /// CHECK IF DATE IS IN PREDICTED FERTILITY WINDOW
//   bool isInFertility(DateTime date) {
//     return fertilityWindow.any(
//       (d) => d.year == date.year && d.month == date.month && d.day == date.day,
//     );
//   }

//   /// CHECK IF DATE IS OVULATION DAY
//   bool isOvulationDay(DateTime date) {
//     final ov = ovulationDate;
//     if (ov == null) return false;
//     return ov.year == date.year && ov.month == date.month && ov.day == date.day;
//   }

//   /// CHECK IF DATE IS IN PREDICTED PERIOD RANGE
//   bool isInPredictedPeriod(DateTime date) {
//     return predictedPeriodRange.any(
//       (d) => d.year == date.year && d.month == date.month && d.day == date.day,
//     );
//   }
// }
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PeriodController extends GetxController {
  /// PERIOD RANGE
  final Rxn<DateTime> periodStart = Rxn<DateTime>();
  final Rxn<DateTime> periodEnd = Rxn<DateTime>();

  /// DATA LOAD FLAG
  final RxBool isLoaded = false.obs;

  /// PERIOD HISTORY (for smarter predictions)
  final RxList<DateTime> periodHistory = <DateTime>[].obs;

  /// DEFAULT VALUES
  final int defaultCycleLength = 28;
  final int defaultPeriodLength = 5;

  /// USER ID
  String get uid => FirebaseAuth.instance.currentUser!.uid;

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

      /// Save start date in history
      if (periodStart.value != null) {
        periodHistory.add(periodStart.value!);
      }

      isLoaded.value = true;
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

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "periodStart": start.toIso8601String(),
        "periodEnd": null,
      }, SetOptions(merge: true));

      /// Save to history
      periodHistory.add(start);

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

  /// AVERAGE CYCLE LENGTH
  int get averageCycleLength {
    if (periodHistory.length < 2) return defaultCycleLength;

    List<int> cycles = [];
    for (int i = 1; i < periodHistory.length; i++) {
      final prev = periodHistory[i - 1];
      final current = periodHistory[i];
      cycles.add(current.difference(prev).inDays);
    }

    return (cycles.reduce((a, b) => a + b) / cycles.length).round();
  }

  /// AVERAGE PERIOD LENGTH
  int get averagePeriodLength {
    if (periodStart.value == null || periodEnd.value == null) {
      return defaultPeriodLength;
    }
    return periodEnd.value!.difference(periodStart.value!).inDays + 1;
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

  /// SMART OVULATION (based on average cycle)
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

  /// SMART FERTILITY WINDOW
  List<DateTime> get smartFertilityWindow {
    final ovulation = smartOvulationDate;
    if (ovulation == null) return [];
    return List.generate(
      6,
      (i) => ovulation.subtract(const Duration(days: 4)).add(Duration(days: i)),
    );
  }

  /// PREDICTED PERIOD RANGE (5 days after period end)
  List<DateTime> get predictedPeriodRange {
    if (periodEnd.value == null) return [];
    return List.generate(
      averagePeriodLength,
      (index) => nextPeriodDate!.add(Duration(days: index)),
    );
  }

  /// CHECK IF DATE IS WITHIN PERIOD
  bool isInPeriod(DateTime date) {
    if (periodStart.value == null) return false;
    final start = periodStart.value!;
    final end = periodEnd.value ?? start;
    return !date.isBefore(start) && !date.isAfter(end);
  }

  /// CHECK IF DATE IS IN PREDICTED FERTILITY WINDOW
  bool isInFertility(DateTime date) {
    return fertilityWindow.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// CHECK IF DATE IS OVULATION DAY
  bool isOvulationDay(DateTime date) {
    final ov = ovulationDate;
    if (ov == null) return false;
    return ov.year == date.year && ov.month == date.month && ov.day == date.day;
  }

  /// CHECK IF DATE IS IN PREDICTED PERIOD RANGE
  bool isInPredictedPeriod(DateTime date) {
    return predictedPeriodRange.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }
}
