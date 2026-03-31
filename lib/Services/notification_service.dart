import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    // 1. Initialize Timezones
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);

    // 2. Request Notification Permission (Android 13+)
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// SHOW INSTANT (for testing)
  static Future<void> showNow(String title, String body) async {
    await _notifications.show(
      DateTime.now().millisecond, // Unique ID for testing many
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_tips',
          'Daily Tips',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
    );
  }

  /// SCHEDULE MULTIPLE SLOTS (🔥 UPGRADED)
  static Future<void> scheduleMultipleSlots({
    required List<String> morningTips,
    required List<String> eveningTips,
  }) async {
    // 1. Clear old tips (Morning: 101-115, Evening: 201-215)
    for (int i = 0; i < 15; i++) {
      await _notifications.cancel(101 + i);
      await _notifications.cancel(201 + i);
    }

    // 2. Schedule Morning Tips (9:00 AM)
    final tz.TZDateTime nextMorning = _nextInstanceOfTime(9);
    for (int i = 0; i < morningTips.length; i++) {
        if (i >= 14) break;
        final scheduledDate = nextMorning.add(Duration(days: i));
        await _notifications.zonedSchedule(
            101 + i,
            "Morning Health Tip 🌸",
            morningTips[i],
            scheduledDate,
            _notificationDetails('morning_tips', 'Morning Tips'),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
    }

    // 3. Schedule Evening Tips (6:00 PM)
    final tz.TZDateTime nextEvening = _nextInstanceOfTime(18); // 6 PM
    for (int i = 0; i < eveningTips.length; i++) {
        if (i >= 14) break;
        final scheduledDate = nextEvening.add(Duration(days: i));
        await _notifications.zonedSchedule(
            201 + i,
            "Evening Reflection ✨",
            eveningTips[i],
            scheduledDate,
            _notificationDetails('evening_tips', 'Evening Tips'),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
    }
    
    print("Scheduled 14 days of Morning & Evening notifications.");
  }

  static NotificationDetails _notificationDetails(String channelId, String channelName) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.high,
            priority: Priority.high,
        ),
    );
  }

  /// CANCEL ALL TIPS
  static Future<void> cancelAllTips() async {
    for (int i = 0; i < 20; i++) {
      await _notifications.cancel(101 + i);
      await _notifications.cancel(201 + i);
    }
  }

  /// NEXT TIME CALCULATOR
  static tz.TZDateTime _nextInstanceOfTime(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
