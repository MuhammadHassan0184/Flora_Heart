// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:floraheart/Services/notification_service.dart';
import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Controllers/period_controller.dart';

class TodayController extends GetxController {
  // Use existing controllers
  final PeriodController periodCtrl = Get.find<PeriodController>();
  final TodayDataController dataCtrl = Get.find<TodayDataController>();

  // Safety flag to prevent multiple scheduling on rebuilds
  bool _isNotificationScheduled = false;

  @override
  void onInit() {
    super.onInit();
    // Schedule tip notification on controller init
    scheduleDailyTipNotification();
  }

  void scheduleDailyTipNotification() {
    if (_isNotificationScheduled) return;

    try {
      List<String> morningTips = [];
      List<String> eveningTips = [];
      DateTime now = DateTime.now();

      // Generate 14 days of Morning (9AM) and Evening (6PM) tips
      for (int i = 0; i < 14; i++) {
        DateTime targetDate = now.add(Duration(days: i));
        
        // Morning Tip (default)
        morningTips.add(dataCtrl.getDailyTip(periodCtrl, targetDate));
        
        // Evening Tip (seedModifier so it's different from morning)
        eveningTips.add(dataCtrl.getDailyTip(periodCtrl, targetDate, 100));
      }
      
      // Schedule both slots
      NotificationService.scheduleMultipleSlots(
        morningTips: morningTips,
        eveningTips: eveningTips,
      );
      
      _isNotificationScheduled = true;
      print("14 days of Morning & Evening notifications scheduled.");
    } catch (e) {
      print("Failed to schedule multi-slot notifications: $e");
    }
  }
}
