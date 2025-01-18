import 'package:dthlms/notificationsave.dart';
import 'package:flutter/material.dart';
import 'notification_model.dart';
// import 'notification_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    List<NotificationModel> storedNotifications =
        await NotificationService.getNotifications();
    setState(() {
      notifications = storedNotifications;
    });
  }

  Future<void> clearAllNotifications() async {
    await NotificationService.clearNotifications();
    setState(() {
      notifications = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: clearAllNotifications,
            ),
          ],
        ),
        body: notifications.isEmpty
            ? Center(
                child: Text("No Notification Found")
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.body),
                    trailing: Text(notification.receivedAt),
                    leading: notification.img != 'No image'
                        ? Image.network(
                            notification.img,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.notifications),
                  );
                },
              ));
  }
}
