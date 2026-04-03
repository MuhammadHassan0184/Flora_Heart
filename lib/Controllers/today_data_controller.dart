// ignore_for_file: avoid_print

import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/utils/tips_manager.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TodayDataController extends GetxController {
  final flow = (-1).obs;
  final period = "".obs;
  final moods = <String>[].obs;
  final symptoms = <String, Set<String>>{}.obs;
  final discharge = <String>[].obs;
  final sexualActivity = "".obs;
  final temperature = 0.0.obs;
  final weight = 0.0.obs; // New: stores user weight
  final ovulationTest = "".obs; // Restore: stores ovulation test result
  final pregnancyTest = "".obs; // New: stores pregnancy test result
  final drinkWater = 0.obs; // 🔥 NEW: stores water intake in ml
  final medicine = "".obs; // 🔥 NEW: stores selected medicine
  final note = "".obs; // 🔥 NEW: stores user note
  final selectedDate = "".obs; // 🔥 THE CURRENTLY SELECTED DATE

  String get uid => FirebaseAuth.instance.currentUser!.uid;
  String get todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

  String getDailyTip(
    PeriodController periodCtrl, [
    DateTime? date,
    int seedModifier = 0,
  ]) {
    final targetDate = date ?? DateTime.now();

    /// 1. PERIOD RUNNING
    if (periodCtrl.isPeriodRunning) {
      return TipsManager.getDailyStableTip(
        TipsManager.periodTips,
        targetDate,
        seedModifier,
      );
    }

    /// 2. OVULATION DAY
    if (periodCtrl.ovulationDate != null) {
      final ov = periodCtrl.ovulationDate!;

      if (targetDate.year == ov.year &&
          targetDate.month == ov.month &&
          targetDate.day == ov.day) {
        return TipsManager.getDailyStableTip(
          TipsManager.ovulationTips,
          targetDate,
          seedModifier,
        );
      }
    }

    /// 3. SYMPTOMS EXIST
    if (symptoms.isNotEmpty) {
      return TipsManager.getDailyStableTip(
        TipsManager.symptomTips,
        targetDate,
        seedModifier,
      );
    }

    /// 4. HEAVY FLOW SPECIAL
    if (flow.value == 2 || flow.value == 3) {
      return "Heavy flow detected, stay hydrated, take rest, and consider iron-rich foods for recovery.";
    }

    /// 5. MOOD BASED
    if (moods.contains("Sad") || moods.contains("Stressed")) {
      return "Take time for yourself, relax your mind, and do activities that bring you peace.";
    }

    /// 6. DEFAULT
    return TipsManager.getDailyStableTip(
      TipsManager.normalTips,
      targetDate,
      seedModifier,
    );
  }

  /// SAVE DATA
  Future<void> saveTodayData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final uid = user.uid;

      final targetDate = selectedDate.value.isEmpty
          ? todayDate
          : selectedDate.value;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("logs")
          .doc(targetDate)
          .set({
            "flow": flow.value,
            "period": period.value,
            "moods": moods.toList(),
            "discharge": discharge.toList(),
            "sexualActivity": sexualActivity.value,
            "temperature": temperature.value,
            "weight": weight.value, // 🔥 add weight
            "ovulationTest": ovulationTest.value, // 🔥 add test results
            "pregnancyTest": pregnancyTest.value,
            "drinkWater": drinkWater.value, // 🔥 add water intake
            "medicine": medicine.value, // 🔥 add medicine
            "note": note.value, // 🔥 add note
            "symptoms": symptoms.map(
              (key, value) => MapEntry(key, value.toList()),
            ),
            "date": targetDate,
          });
    } catch (e) {
      print("FIRESTORE SAVE ERROR: $e");
      rethrow;
    }
  }

  /// LOAD DATA
  Future<void> loadTodayData([String? date]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final targetDate = date ?? todayDate;
    selectedDate.value = targetDate; // 🔥 Sync controller's date

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("logs")
        .doc(targetDate)
        .get();

    if (!doc.exists) {
      // Clear data if not found for the specific date
      flow.value = -1;
      period.value = "";
      moods.clear();
      discharge.clear();
      sexualActivity.value = "";
      temperature.value = 0.0;
      weight.value = 0.0;
      ovulationTest.value = "";
      pregnancyTest.value = "";
      drinkWater.value = 0; // 🔥 clear water intake
      medicine.value = ""; // 🔥 clear medicine
      note.value = ""; // 🔥 clear note
      symptoms.clear();
      return;
    }

    final data = doc.data()!;

    flow.value = data["flow"] ?? -1;
    period.value = data["period"] ?? "";
    moods.assignAll(List<String>.from(data["moods"] ?? []));
    discharge.assignAll(List<String>.from(data["discharge"] ?? []));
    sexualActivity.value = data["sexualActivity"] ?? "";
    temperature.value = (data["temperature"] ?? 0).toDouble();
    weight.value = (data["weight"] ?? 0).toDouble(); // 🔥 load weight
    ovulationTest.value = data["ovulationTest"] ?? "";
    pregnancyTest.value = data["pregnancyTest"] ?? "";
    drinkWater.value = data["drinkWater"] ?? 0; // 🔥 load water intake
    medicine.value = data["medicine"] ?? ""; // 🔥 load medicine
    note.value = data["note"] ?? ""; // 🔥 load note

    Map<String, dynamic> rawSymptoms = data["symptoms"] ?? {};
    symptoms.value = rawSymptoms.map(
      (k, v) => MapEntry(k, Set<String>.from(v)),
    );
  }
}
