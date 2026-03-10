import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PeriodController extends GetxController {
  /// inclusive range of most recent period
  final Rxn<DateTime> periodStart = Rxn<DateTime>();
  final Rxn<DateTime> periodEnd = Rxn<DateTime>();

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// load stored period info from user document
  Future<void> loadPeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return;
    final data = doc.data()!;
    if (data['periodStart'] != null) {
      periodStart.value = DateTime.tryParse(data['periodStart']);
    }
    if (data['periodEnd'] != null) {
      periodEnd.value = DateTime.tryParse(data['periodEnd']);
    }
  }

  /// persist the current range to Firestore (merges with existing data)
  Future<void> savePeriod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final map = <String, dynamic>{};
    if (periodStart.value != null) {
      map['periodStart'] = periodStart.value!.toIso8601String();
    }
    if (periodEnd.value != null) {
      map['periodEnd'] = periodEnd.value!.toIso8601String();
      // also update legacy field for onboarding/backwards compatibility;
      // actual string will be written in the following block
    }
    // note: we cannot create a formatted date string easily within the map itself; we'll do it
    if (periodEnd.value != null) {
      final end = periodEnd.value!;
      map['lastPeriodEnd'] = "${end.day}-${end.month}-${end.year}";
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(map, SetOptions(merge: true));
  }

  void setRange(DateTime start, DateTime end) {
    periodStart.value = start;
    periodEnd.value = end;
  }
}
