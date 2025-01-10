// // import 'package:abc/getx.dart';
// // import 'package:abc/messageui.dart';
// // import 'package:abc/widget/models/modelClass.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:get/get.dart';
//
// // import '../../../GETXCONTROLLER/getxController.dart';
// // import '../getx.dart';
// import '../messageui.dart';
// import '../mobilegetx.dart';
// import '../models/modelClass.dart';
//
// class PersonChat extends StatefulWidget {
//   final String sessionId;
//   final String userid;
//   final String username;
//   PersonChat(
//       {super.key,
//         required this.sessionId,
//         required this.userid,
//         required this.username}) {
//     print(sessionId);
//   }
//
//   @override
//   State<PersonChat> createState() => _PersonChatState();
// }
//
// class _PersonChatState extends State<PersonChat> {
//   UserDetails? selectedUser; // Variable to store the selected user
//   GetxLive getx = Get.put(GetxLive());
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle rightBarTopTextStyle = const TextStyle(
//         fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);
//
//     return SizedBox(
//       height: 500,
//       child: Column(
//         children: [
//           selectedUser != null
//               ? Row(
//             children: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedUser = null; // Set the selected user
//                     });
//                   },
//                   icon: Icon(
//                     Icons.arrow_back,
//                     size: 20,
//                     color: Colors.white,
//                   )),
//             ],
//           )
//               : SizedBox(),
//           SizedBox(
//             height: 20,
//           ),
//           selectedUser == null
//               ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                   stream: MeetingService.getMeetingUsers(widget.sessionId),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (snapshot.hasError) {
//                       return const Center(child: Text('Error loading users'));
//                     }
//
//                     if (!snapshot.hasData || !snapshot.data!.exists) {
//                       return const Center(
//                           child: Text('No users in this meeting'));
//                     }
//
//                     // Extract and filter the users list
//                     RxList<dynamic> users =
//                         (snapshot.data?.data()?['users'] as List<dynamic>? ??
//                                 <dynamic>[])
//                             .obs;
//
//                     // Convert and filter the users list to get only those with the role of 'teacher'
//                     List<UserDetails> filteredUsers = users
//                         .map((user) =>
//                             UserDetails.fromJson(user as Map<String, dynamic>))
//                         .where((userDetails) => userDetails.role == 'Teacher')
//                         .toList();
//
//                     // Assign the filtered list to the GetX variable
//                     getx.userDetails.assignAll(filteredUsers);
//
//                     return Expanded(
//                       child: ListView.builder(
//                         itemCount: getx.userDetails.length,
//                         itemBuilder: (context, index) {
//                           final user = getx.userDetails[index];
//
//                           // Fetch the last message for each user
//                           return StreamBuilder<
//                               DocumentSnapshot<Map<String, dynamic>>?>(
//                             stream: MeetingService.getLastMessage(
//                                 widget.sessionId, widget.userid),
//                             builder: (context, messageSnapshot) {
//                               String lastMessage =
//                                   'No messages yet'; // Default message when no message is available
//                               if (messageSnapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                     child: CircularProgressIndicator());
//                               }
//
//                               if (messageSnapshot.hasData &&
//                                   messageSnapshot.data != null &&
//                                   messageSnapshot.data!.exists) {
//                                 lastMessage = messageSnapshot.data!
//                                         .data()?['lastMessage'] ??
//                                     'No messages yet';
//                               }
//
//                               return Container(
//                                 decoration: BoxDecoration(
//                                     color: Color.fromARGB(255, 8, 11, 31),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 margin: EdgeInsets.symmetric(vertical: 4),
//                                 child: ListTile(
//                                   leading: const CircleAvatar(
//                                     backgroundImage: AssetImage(
//                                       'assets/blank-profile-picture-973460_1920.png',
//                                     ),
//                                     radius: 15,
//                                   ),
//                                   onTap: () {
//                                     setState(() {
//                                       selectedUser =
//                                           user; // Set the selected user
//                                     });
//                                   },
//                                   title: Text(
//                                     user.name,
//                                     style: rightBarTopTextStyle,
//                                   ),
//                                   subtitle: Text(
//                                     lastMessage, // Display last message here
//                                     style: TextStyle(
//                                         color: Colors.white70, fontSize: 14),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 )
//               : Expanded(
//                   child: MessageUi(selectedUser!,
//                       widget.userid, ), // Display MessageUi if a user is selected
//                 ),
//           // You can add a chat input here or other widgets below the user list
//         ],
//       ),
//     );
//   }
// }
