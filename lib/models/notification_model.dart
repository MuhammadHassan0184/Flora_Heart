import 'dart:convert';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  // Create from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'] ?? false,
      );

  // Helper to convert list to JSON string
  static String encodeList(List<AppNotification> notifications) =>
      json.encode(notifications.map((n) => n.toJson()).toList());

  // Helper to decode list from JSON string
  static List<AppNotification> decodeList(String data) {
    if (data.isEmpty) return [];
    List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => AppNotification.fromJson(j)).toList();
  }
}
