import 'package:floraheart/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  var notifications = <AppNotification>[].obs;
  static const String _storageKey = 'app_notifications';

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // Load notifications from SharedPreferences
  Future<void> loadNotifications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_storageKey);
      if (data != null && data.isNotEmpty) {
        notifications.assignAll(AppNotification.decodeList(data));
        // Sort by timestamp descending (newest first)
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error loading notifications: $e");
    }
  }

  // Save notifications to SharedPreferences
  Future<void> saveNotifications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String data = AppNotification.encodeList(notifications);
      await prefs.setString(_storageKey, data);
    } catch (e) {
      print("Error saving notifications: $e");
    }
  }

  // Add a new notification
  void addNotification({
    required String title,
    required String body,
  }) {
    final newNotif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    notifications.insert(0, newNotif); // Add to the beginning
    saveNotifications();
  }

  // Mark a notification as read
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      saveNotifications();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    saveNotifications();
  }

  // Clear all notifications
  void clearAll() {
    notifications.clear();
    saveNotifications();
  }

  // Count unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
