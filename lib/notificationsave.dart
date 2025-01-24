import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_model.dart'; // Ensure you have this import
import 'package:intl/intl.dart'; // For formatting the date
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static const String notificationsKey = 'notifications';

  // Save a single notification
  static Future<void> saveNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    // Get existing notifications
    List<String> notifications = prefs.getStringList(notificationsKey) ?? [];
    // Add new notification as JSON string
    notifications.add(notification.toJson());
    // Save back to SharedPreferences
    await prefs.setStringList(notificationsKey, notifications);
  }

  // Retrieve all notifications
  static Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(notificationsKey) ?? [];

    // log(notifications.toString());
    return notifications
        .map((jsonStr) => NotificationModel.fromJson(jsonStr))
        .toList();
  }

  // Optional: Clear all notifications
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(notificationsKey);
  }
}
