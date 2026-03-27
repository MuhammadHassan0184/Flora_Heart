// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   /// INIT
//   static Future<void> init() async {
//     initializeTimeZones(); // ✅ FIXED

//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android);

//     await _notifications.initialize(settings);
//   }

//   /// DAILY NOTIFICATION
//   static Future<void> showDailyTip(String tip) async {
//     await _notifications.zonedSchedule(
//       0,
//       "Daily Health Tip 🌸",
//       tip,
//       _nextTime(),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_tips_channel',
//           'Daily Tips',
//           channelDescription: 'Daily health tips',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),

//       /// 🔥 ADD THIS LINE (THIS IS YOUR ERROR FIX)
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,

//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static Future<void> showDailyTipAtTime(String tip, DateTime time) async {
//     await _notifications.zonedSchedule(
//       0,
//       "Daily Health Tip 🌸",
//       tip,
//       tz.TZDateTime.from(time, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_tips_channel',
//           'Daily Tips',
//           channelDescription: 'Daily health tips',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),

//       // 🔥 REQUIRED
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,

//       // Optional: for one-time test, remove recurrence
//       // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     );
//   }

//   static tz.TZDateTime _nextTime() {
//     final now = tz.TZDateTime.now(tz.local);

//     final scheduled = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       9,
//       0,
//     );

//     return scheduled.isBefore(now)
//         ? scheduled.add(const Duration(days: 1))
//         : scheduled;
//   }
// }
