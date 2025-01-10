// notification_model.dart
import 'dart:convert';

class NotificationModel {
  final String title;
  final String body;
  final String receivedAt;
  final String img;

  NotificationModel({
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.img,
  });

  // Convert a NotificationModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'receivedAt': receivedAt,
      'img': img,
    };
  }

  // Create a NotificationModel from a Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      receivedAt: map['receivedAt'],
      img: map['img'],
    );
  }

  // Convert NotificationModel to JSON string
  String toJson() => json.encode(toMap());

  // Create NotificationModel from JSON string
  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
