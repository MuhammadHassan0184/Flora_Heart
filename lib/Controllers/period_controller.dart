// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class PeriodController extends GetxController {
//   /// inclusive range of most recent period
//   final Rxn<DateTime> periodStart = Rxn<DateTime>();
//   final Rxn<DateTime> periodEnd = Rxn<DateTime>();

//   String get uid => FirebaseAuth.instance.currentUser!.uid;

//   /// load stored period info from user document
//   Future<void> loadPeriod() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();
//     if (!doc.exists) return;
//     final data = doc.data()!;
//     if (data['periodStart'] != null) {
//       periodStart.value = DateTime.tryParse(data['periodStart']);
//     }
//     if (data['periodEnd'] != null) {
//       periodEnd.value = DateTime.tryParse(data['periodEnd']);
//     }
//   }

//   /// persist the current range to Firestore (merges with existing data)
//   Future<void> savePeriod() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     final map = <String, dynamic>{};
//     if (periodStart.value != null) {
//       map['periodStart'] = periodStart.value!.toIso8601String();
//     }
//     if (periodEnd.value != null) {
//       map['periodEnd'] = periodEnd.value!.toIso8601String();
//       // also update legacy field for onboarding/backwards compatibility;
//       // actual string will be written in the following block
//     }
//     // note: we cannot create a formatted date string easily within the map itself; we'll do it
//     if (periodEnd.value != null) {
//       final end = periodEnd.value!;
//       map['lastPeriodEnd'] = "${end.day}-${end.month}-${end.year}";
//     }
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .set(map, SetOptions(merge: true));
//   }

//   void setRange(DateTime start, DateTime end) {
//     periodStart.value = start;
//     periodEnd.value = end;
//   }

//   DateTime? get ovulationDate {
//     if (periodStart.value == null) return null;

//     // Ovulation ~14 days after period start
//     return periodStart.value!.add(const Duration(days: 14));
//   }

//   DateTime? get nextPeriodDate {
//     if (periodStart.value == null) return null;

//     // Average cycle = 28 days
//     return periodStart.value!.add(const Duration(days: 28));
//   }

//   List<DateTime> get fertilityWindow {
//     if (ovulationDate == null) return [];

//     // 3 days before + 2 days after ovulation
//     return List.generate(
//       6,
//       (index) => ovulationDate!
//           .subtract(const Duration(days: 3))
//           .add(Duration(days: index)),
//     );
//   }
// }
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PeriodController extends GetxController {
  /// Inclusive range of most recent period
  final Rxn<DateTime> periodStart = Rxn<DateTime>();
  final Rxn<DateTime> periodEnd = Rxn<DateTime>();

  /// Flag to indicate data has been loaded from Firestore
  final RxBool isLoaded = false.obs;

  /// Current user ID
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// Load stored period info from user document
  Future<void> loadPeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in!");
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        print("User document does not exist");
        isLoaded.value = true; // mark loaded even if empty
        return;
      }

      final data = doc.data()!;
      if (data['periodStart'] != null) {
        periodStart.value = DateTime.tryParse(data['periodStart']);
      }
      if (data['periodEnd'] != null) {
        periodEnd.value = DateTime.tryParse(data['periodEnd']);
      }

      isLoaded.value = true; // mark data as loaded
      print("Period data loaded successfully");
    } catch (e) {
      print("Error loading period data: $e");
      isLoaded.value = true; // still allow UI to proceed
    }
  }

  /// Persist the current range to Firestore
  Future<void> savePeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final map = <String, dynamic>{};
    if (periodStart.value != null) {
      map['periodStart'] = periodStart.value!.toIso8601String();
    }
    if (periodEnd.value != null) {
      map['periodEnd'] = periodEnd.value!.toIso8601String();
      map['lastPeriodEnd'] =
          "${periodEnd.value!.day}-${periodEnd.value!.month}-${periodEnd.value!.year}";
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(map, SetOptions(merge: true));
      print("Period data saved successfully");
    } catch (e) {
      print("Error saving period data: $e");
    }
  }

  /// Set period start and end manually
  void setRange(DateTime start, DateTime end) {
    periodStart.value = start;
    periodEnd.value = end;
  }

  /// Compute ovulation date (~14 days after period start)
  DateTime? get ovulationDate {
    if (periodStart.value == null) return null;
    return periodStart.value!.add(const Duration(days: 14));
  }

  /// Compute next period date (~28 days after period start)
  DateTime? get nextPeriodDate {
    if (periodStart.value == null) return null;
    return periodStart.value!.add(const Duration(days: 28));
  }

  /// Fertility window: 3 days before and 2 days after ovulation
  List<DateTime> get fertilityWindow {
    if (ovulationDate == null) return [];
    return List.generate(
      6,
      (index) => ovulationDate!
          .subtract(const Duration(days: 3))
          .add(Duration(days: index)),
    );
  }
}
