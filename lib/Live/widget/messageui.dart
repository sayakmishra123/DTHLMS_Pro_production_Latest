// import 'dart:developer';
//
// import 'package:abc/getx.dart';
// import 'package:abc/widget/messagecard.dart';
// import 'package:abc/widget/models/message.dart';
// import 'package:abc/widget/models/modelClass.dart';
//
// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
//
// class MessageUi extends StatefulWidget {
//   final UserDetails userlist;
//   late String userid;
//   MessageUi(this.userlist, this.userid, {super.key});
//
//   @override
//   State<MessageUi> createState() => _MessageUiState();
// }
//
// class _MessageUiState extends State<MessageUi> {
//   final ScrollController _scrollController = ScrollController();
//   final ScrollController _scrollController2 = ScrollController();
//   final ScrollController _scrollController3 = ScrollController();
//   List<UserMsg> msglist = [];
//   // late SharedPreferences sp;
//   TextEditingController msgController = TextEditingController();
//
//   @override
//   Color greencolor = const Color(0Xff15E8D8);
//   void initState() {
//     // getemail().whenComplete(() => null);
//
//     super.initState();
//   }
//
//   // String email = '';
//   // Getx getx = Get.put(Getx());
//
//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
//
//   Color chatConColor = const Color(0XffD9D9D9);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Row(
//         children: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               )),
//         ],
//       ),
//       Expanded(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           child: StreamBuilder(
//               stream: MeetingService.getAllMsg(widget.userlist, widget.userid),
//               builder: (context, snapshot) {
//                 print(snapshot.data);
//                 final data = snapshot.data?.docs;
//                 if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'No messages',
//                       textScaler: TextScaler.linear(1.4),
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToBottom();
//                   });
//                   msglist =
//                       data!.map((e) => UserMsg.fromJson(e.data())).toList() ??
//                           [];
//                   return ListView.builder(
//                       controller: _scrollController,
//                       itemCount: msglist.length,
//                       itemBuilder: (context, index) {
//                         return Messagecard(msglist[index], widget.userid,widget.u);
//                         // print(jsonEncode(snapshot.data!.docs[index].data()));
//                         // return Card(
//                         //   child: ListTile(
//                         //     onTap: () {
//                         //       // Get.to(() => ChatUi(userlist[index]));
//                         //     },
//                         //     title: Text(snapshot.data?.docs[index]['msg']),
//                         //     subtitle: Text(snapshot.data?.docs[index]['read']),
//                         //     trailing: const Icon(
//                         //       Icons.circle,
//                         //       color: Colors.blue,
//                         //     ),
//                         //   ),
//                         // );
//                       });
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(80),
//               color: Colors.transparent),
//           height: 60,
//           width: MediaQuery.sizeOf(context).width - 30,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   autofocus: true,
//                   cursorWidth: 3,
//                   cursorColor: greencolor,
//                   onFieldSubmitted: (value) async {
//                     if (msgController.text.isNotEmpty) {
//                       await MeetingService.sendMsg(
//                         widget.userlist,
//                         msgController.text,
//                         widget.userid,
//                       );
//                       msgController.clear();
//                     }
//                   },
//                   controller: msgController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     // prefixIcon: EmojiSelector(
//                     //   onSelected: (p0) {
//                     //     log(p0.char);
//                     //   },
//                     // ),
//
//                     filled: true,
//                     fillColor: chatConColor.withOpacity(0.3),
//
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.only(left: 20),
//                     hintText: 'Type your message',
//                     hintStyle: const TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'ocenwide',
//                         fontSize: 15),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               FloatingActionButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//                 backgroundColor: chatConColor.withOpacity(0.3),
//                 onPressed: () async {
//                   if (msgController.text.isNotEmpty) {
//                     await MeetingService.sendMsg(
//                         widget.userlist, msgController.text, widget.userid);
//                     msgController.clear();
//                   }
//                 },
//                 child: Image.asset(
//                   'assets/send.png',
//                   height: 30,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ]);
//   }
//
// //   void _scrollToBottom() {
// //   _scrollController.animateTo(
// //     _scrollController.position.maxScrollExtent,
// //     duration: const Duration(milliseconds: 300),
// //     curve: Curves.easeOut,
// //   );
// // }
//
//   void _scrollToBottom2() {
//     _scrollController2.animateTo(
//       _scrollController2.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
//
//   void _scrollToBottom3() {
//     _scrollController3.animateTo(
//       _scrollController3.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
// }
