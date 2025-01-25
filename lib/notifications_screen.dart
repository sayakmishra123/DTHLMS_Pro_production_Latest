import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/notificationsave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_model.dart';
// import 'notification_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Getx getx = Get.put(Getx());

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    List<NotificationModel> storedNotifications =
        await NotificationService.getNotifications();

    getx.notifications.value = storedNotifications;
  }

  Future<void> clearAllNotifications() async {
    await NotificationService.clearNotifications();

    getx.notifications.value = [];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: clearAllNotifications,
              ),
            ],
          ),
          body: getx.notifications.isEmpty
              ? Center(child: Text("No Notification Found"))
              : ListView.builder(
                  itemCount: getx.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = getx.notifications[index];
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
                )),
    );
  }
}
