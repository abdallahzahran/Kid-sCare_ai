// lib/models/notification_model.dart
class NotificationModel {
  final String title;
  final String time;
  final String? imageUrl;

  NotificationModel({
    required this.title,
    required this.time,
    this.imageUrl,
  });
}