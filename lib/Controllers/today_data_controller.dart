// ignore_for_file: avoid_print

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

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  String get today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// SAVE DATA
  /// SAVE DATA
  Future<void> saveTodayData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final uid = user.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("logs")
          .doc(today)
          .set({
            "flow": flow.value,
            "period": period.value,
            "moods": moods.toList(),
            "discharge": discharge.toList(),
            "sexualActivity": sexualActivity.value,
            "temperature": temperature.value,
            "weight": weight.value, // 🔥 add weight
            "symptoms": symptoms.map(
              (key, value) => MapEntry(key, value.toList()),
            ),
            "date": today,
          });
    } catch (e) {
      print("FIRESTORE SAVE ERROR: $e");
      rethrow;
    }
  }

  /// LOAD DATA
  Future<void> loadTodayData() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("logs")
        .doc(today)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    flow.value = data["flow"] ?? -1;
    period.value = data["period"] ?? "";
    moods.assignAll(List<String>.from(data["moods"] ?? []));
    discharge.assignAll(List<String>.from(data["discharge"] ?? []));
    sexualActivity.value = data["sexualActivity"] ?? "";
    temperature.value = (data["temperature"] ?? 0).toDouble();
    weight.value = (data["weight"] ?? 0).toDouble(); // 🔥 load weight

    Map<String, dynamic> rawSymptoms = data["symptoms"] ?? {};
    symptoms.value = rawSymptoms.map(
      (k, v) => MapEntry(k, Set<String>.from(v)),
    );
  }
}
