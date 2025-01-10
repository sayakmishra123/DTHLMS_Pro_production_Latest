// import 'package:dthlms/THEME_DATA/color/color.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:hive_flutter/hive_flutter.dart';

// import '../notification_model.dart';

// class NotificationHistoryScreen extends StatefulWidget {
//   @override
//   State<NotificationHistoryScreen> createState() =>
//       _NotificationHistoryScreenState();
// }

// class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
//   late Box<NotificationModel> notificationBox;

//   @override
//   void initState() {
//     super.initState();
//     notificationBox = Hive.box<NotificationModel>('notifications');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorPage.colorbutton,
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "Notifications",
//           style: FontFamily.styleb.copyWith(color: Colors.white)
//         ),
//       ),
//       body: ValueListenableBuilder(
//           valueListenable: notificationBox.listenable(),
//           builder: (context, Box<NotificationModel> box, _) {
//             if (box.values.isEmpty)
//               return Center(
//                 child: Text('No notifications received'),
//               );
//             return ListView.builder(
//                 itemCount: box.length,
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                 itemBuilder: (BuildContext context, int index) {
//                   NotificationModel? notification = box.getAt(index);
//                   return _buildNotificationItem(
//                     notification!.title.toString(),
//                     notification.body.toString(),
//                     notification.receivedAt.toString(),
//                     notification.img == null
//                         ? 'No image'
//                         : notification.img.toString(),
//                   );
//                 });
//           }),
//     );
//   }

//   Widget _buildNotificationItem(
//       String title, String subtitle, String date, String img) {
//     print(img + "sayak");
//     return Container(
//       child: Card(
//         elevation: 0,
//         color: Colors.white,
//         child: ListTile(
//           trailing: Icon(
//             Icons.circle,
//             size: 10,
//             color: Colors.green,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//           minVerticalPadding: 0,
//           leading: img != "No image"
//               ? CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                     scale: 2,
//                     img,
//                     // width: 50,
//                     // height: 100,
//                   ),
//                 )
//               : CircleAvatar(
//                   backgroundColor: Colors.grey[200],
//                   child: Icon(Icons.notifications, color: Colors.blue),
//                 ),
//           title: Container(
//             child: Text.rich(
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//               TextSpan(children: [
//                 TextSpan(
//                     text: date,
//                     style: GoogleFonts.inter(
//                         textStyle:
//                             TextStyle(fontSize: 10, color: ColorPage.grey)))
//               ], text: '$title    '),
//             ),
//           ),
//           subtitle: Text(subtitle,
//               style: TextStyle(color: Colors.grey, fontSize: 10)),
//           // trailing: ,
//         ),
//       ),
//     );
//   }
// }
