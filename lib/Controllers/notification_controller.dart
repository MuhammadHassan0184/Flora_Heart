// ignore_for_file: avoid_print

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

  // Add a scheduled notification (Pre-save for history)
  void addScheduledNotification({
    required String id,
    required String title,
    required String body,
    required DateTime timestamp,
  }) {
    // Check if this specific scheduled notification already exists
    if (notifications.any((n) => n.id == id)) return;

    final newNotif = AppNotification(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
    );
    notifications.add(newNotif);
    // Sort to keep newest on top when displayed
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
    final now = DateTime.now();
    for (var n in notifications) {
      if (n.timestamp.isBefore(now)) {
        n.isRead = true;
      }
    }
    notifications.refresh();
    saveNotifications();
  }

  // Clear all notifications
  void clearAll() {
    notifications.clear();
    saveNotifications();
  }

  // Count unread notifications (only those already fired)
  int get unreadCount {
    final now = DateTime.now();
    return notifications.where((n) => !n.isRead && n.timestamp.isBefore(now)).length;
  }
}
