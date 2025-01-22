// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' as foundation;

// class GroupChatScreen extends StatefulWidget {
//   final String sessionId;
//   final String userId;
//   final String userName;

//   GroupChatScreen({
//     required this.sessionId,
//     required this.userId,
//     required this.userName,
//   });

//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   void _sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       ChatService.sendMessage(
//         widget.sessionId,
//         widget.userId,
//         widget.userName,
//         _messageController.text,
//       );
//       _messageController.clear();
//     }
//   }

//   final _controller = TextEditingController();
//   final _scrollController = ScrollController();
//   bool _emojiShowing = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Map<String, dynamic>>>(
//               stream: ChatService.getChatMessages(widget.sessionId),
//               builder: (ctx, chatSnapshot) {
//                 if (chatSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final chatDocs = chatSnapshot.data ?? [];
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: chatDocs.length,
//                   itemBuilder: (ctx, index) => MessageBubble(
//                     chatDocs[index]['message'],
//                     chatDocs[index]['userName'],
//                     chatDocs[index]['userId'] == widget.userId,
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       autofocus: true,
//                       onFieldSubmitted: (_) {
//                         _sendMessage();
//                         _messageController.value = TextEditingValue.empty;
//                         // setState(() {});
//                       },
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                           labelText: 'Send a message...',
//                           prefixIcon: EmojiPicker(
//                             textEditingController: _messageController,
//                             onEmojiSelected: (category, emoji) {
//                               _messageController.text = emoji.emoji;
//                               setState(() {});
//                             },

//                             onBackspacePressed: () {
//                               // Do something when the user taps the backspace button (optional)
//                               // Set it to null to hide the Backspace-Button
//                             },
//                             // textEditingController: textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
//                             config: Config(
//                               height: 256,
//                               // : const Color(0xFFF2F2F2),
//                               checkPlatformCompatibility: true,
//                               emojiViewConfig: EmojiViewConfig(
//                                 // Issue: https://github.com/flutter/flutter/issues/28894
//                                 emojiSizeMax: 28 *
//                                     (foundation.defaultTargetPlatform ==
//                                             TargetPlatform.iOS
//                                         ? 1.20
//                                         : 1.0),
//                               ),
//                               swapCategoryAndBottomBar: false,
//                               skinToneConfig: const SkinToneConfig(),
//                               categoryViewConfig: const CategoryViewConfig(),
//                               bottomActionBarConfig:
//                                   const BottomActionBarConfig(),
//                               searchViewConfig: const SearchViewConfig(),
//                             ),
//                           )),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String message;
//   final String userName;
//   final bool isMe;

//   MessageBubble(this.message, this.userName, this.isMe);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         if (!isMe)
//           CircleAvatar(
//             child: Text(userName[0]),
//           ),
//         Container(
//           decoration: BoxDecoration(
//             color: isMe ? Colors.blue : Colors.grey[300],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           width: 200,
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           child: Column(
//             crossAxisAlignment:
//                 isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               if (!isMe)
//                 Text(
//                   userName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isMe ? Colors.white : Colors.black,
//                   ),
//                 ),
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: isMe ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (isMe)
//           CircleAvatar(
//             child: Text(userName[0]),
//           ),
//       ],
//     );
//   }
// }

// class ChatService {
//   static Future<void> sendMessage(
//       String sessionId, String userId, String userName, String message) async {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats");

//     await ref.add({
//       'userId': userId,
//       'userName': userName,
//       'message': message,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Stream<List<Map<String, dynamic>>> getChatMessages(String sessionId) {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats")
//         .orderBy('timestamp', descending: true);

//     return ref.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           'userId': doc['userId'],
//           'userName': doc['userName'],
//           'message': doc['message'],
//           'timestamp': doc['timestamp'],
//         };
//       }).toList();
//     });
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  final String sessionId;
  final String userId;
  final String userName;

  GroupChatScreen({
    required this.sessionId,
    required this.userId,
    required this.userName,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    // if (_messageController.text.isNotEmpty) {
    //   ChatService.sendMessage(
    //     widget.sessionId,
    //     widget.userId,
    //     widget.userName,
    //     _messageController.text,
    //   );
    //   _messageController.clear();
    // }
  }

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   child: StreamBuilder<List<Map<String, dynamic>>>(
        //     stream: ChatService.getChatMessages(widget.sessionId),
        //     builder: (ctx, chatSnapshot) {
        //       if (chatSnapshot.data == null || chatSnapshot.data!.isEmpty) {
        //         return const Center(
        //           child: Text(
        //             'Chat is empty',
        //             textScaler: TextScaler.linear(1.4),
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         );
        //       }
        //       if (chatSnapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(child: CircularProgressIndicator());
        //       }
        //       final chatDocs = chatSnapshot.data ?? [];
        //       return ListView.builder(
        //         reverse: true,
        //         itemCount: chatDocs.length,
        //         itemBuilder: (ctx, index) => MessageBubble(
        //             chatDocs[index]['message'],
        //             chatDocs[index]['userName'],
        //             chatDocs[index]['userId'] == widget.userId,
        //             chatDocs[index]['timestamp']),
        //       );
        //     },
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  cursorWidth: 3,
                  cursorColor: greencolor,
                  onSubmitted: (value) {
                    _sendMessage();
                  },
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Type your message',
                    hintStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'ocenwide',
                        fontSize: 15),
                    filled: true,
                    fillColor: chatConColor.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: chatConColor.withOpacity(0.3),
                onPressed: () {
                  _sendMessage();
                },
                child: Image.asset(
                  'assets/send.png',
                  height: 30,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isMe;
  // final Timestamp? time; // Change to nullable Timestamp
  MessageBubble(
    this.message,
    this.userName,
    this.isMe,
  );

  Color chatBoxColor = const Color(0XffC9E1FF);
  TextStyle rightBarTopTextStyle = const TextStyle(
      fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${_monthToString(dateTime.month)}-${dateTime.year} "
        "${_formatHour(dateTime.hour)}:${_formatMinute(dateTime.minute)} "
        "${_getAmPm(dateTime.hour)}";
  }

  String formatTime(DateTime dateTime) {
    return "${_formatHour(dateTime.hour)}:${_formatMinute(dateTime.minute)} ${_getAmPm(dateTime.hour)}";
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}-${_monthToString(dateTime.month)}-${dateTime.year}";
  }

  String _monthToString(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _formatHour(int hour) {
    return hour > 12 ? (hour - 12).toString() : hour.toString();
  }

  String _formatMinute(int minute) {
    return minute < 10 ? '0$minute' : minute.toString();
  }

  String _getAmPm(int hour) {
    return hour >= 12 ? 'PM' : 'AM';
  }

  @override
  Widget build(BuildContext context) {
    // Handle null timestamp by providing a default DateTime or message
    DateTime? dateTime;
    String formattedTime = "Unknown Time"; // Default value if timestamp is null
    String formattedDate = "Unknown Date";

    // if (time != null) {
    //   dateTime = time!.toDate();
    //   formattedTime = formatTime(dateTime);
    //   formattedDate = formatDate(dateTime);
    // }
    return Row(
      mainAxisSize:
          MainAxisSize.min, // Ensures Row takes only as much space as needed
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          // const CircleAvatar(
          //   backgroundImage:
          //       AssetImage('assets/blank-profile-picture-973460_1920.png'), // Assuming dp is a path to the image asset
          //   radius: 20,
          // ),
          const SizedBox(width: 10),
        ],
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      userName,
                      style: rightBarTopTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 4,
                        width: 4,
                      ),
                    ),
                    Text(
                      formattedTime, // Display the formatted date and time or default message
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: chatBoxColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 20 : 0),
                    topRight: Radius.circular(isMe ? 0 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // This ensures the width is constrained to the text content size
                      width: message.length < 20 ? null : 200,
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontFamily: 'ocenwide',
                          fontSize: 14,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              //  Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: Row(
              //       children: [

              //           Text(
              //           formattedDate, // Display the formatted date and time or default message
              //           style: TextStyle(color: Colors.grey[400]),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 10),
        ],
      ],
    );
  }
}

// class ChatService {
//   static Future<void> sendMessage(
//       String sessionId, String userId, String userName, String message) async {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats");

//     await ref.add({
//       'userId': userId,
//       'userName': userName,
//       'message': message,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Stream<List<Map<String, dynamic>>> getChatMessages(String sessionId) {
//     final ref = FirebaseFirestore.instance
//         .collection("meetings")
//         .doc(sessionId)
//         .collection("chats")
//         .orderBy('timestamp', descending: true);

//     return ref.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           'userId': doc['userId'],
//           'userName': doc['userName'],
//           'message': doc['message'],
//           'timestamp': doc['timestamp'],
//         };
//       }).toList();
//     });
//   }
// }



// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return 
//  Expanded(
//                                               child: ListView.builder(
//                                                 itemCount: _messages.length,
//                                                 itemBuilder: (context, index) {
//                                                   final message =
//                                                       _messages[index];
//                                                   bool isSender =
//                                                       message['sender'] ==
//                                                           'Alice';

//                                                   DateTime timestamp =
//                                                       DateTime.parse(
//                                                           message['timestamp']);
//                                                   String formattedTime =
//                                                       DateFormat('hh:mm a')
//                                                           .format(timestamp);

//                                                   return Row(
//                                                     mainAxisAlignment: isSender
//                                                         ? MainAxisAlignment.end
//                                                         : MainAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       if (!isSender) ...[
//                                                         CircleAvatar(
//                                                           backgroundImage:
//                                                               AssetImage(message[
//                                                                   'dp']), // Assuming dp is a path to the image asset
//                                                           radius: 20,
//                                                         ),
//                                                         const SizedBox(
//                                                             width: 10),
//                                                       ],
//                                                       Column(
//                                                         crossAxisAlignment: isSender
//                                                             ? CrossAxisAlignment
//                                                                 .end
//                                                             : CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         10.0),
//                                                             child: Row(
//                                                               children: [
//                                                                 Text(
//                                                                   '${message['sender']}',
//                                                                   style:
//                                                                       rightBarTopTextStyle,
//                                                                 ),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           10),
//                                                                   child:
//                                                                       Container(
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                     ),
//                                                                     height: 4,
//                                                                     width: 4,
//                                                                   ),
//                                                                 ),
//                                                                 Text(
//                                                                   formattedTime,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                               .grey[
//                                                                           400]),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Container(
//                                                             margin:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     vertical: 5,
//                                                                     horizontal:
//                                                                         10),
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(10),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color:
//                                                                   chatBoxColor,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .only(
//                                                                 topLeft: Radius
//                                                                     .circular(
//                                                                         isSender
//                                                                             ? 20
//                                                                             : 0),
//                                                                 topRight: Radius
//                                                                     .circular(
//                                                                         isSender
//                                                                             ? 0
//                                                                             : 20),
//                                                                 bottomLeft:
//                                                                     const Radius
//                                                                         .circular(
//                                                                         20),
//                                                                 bottomRight:
//                                                                     const Radius
//                                                                         .circular(
//                                                                         20),
//                                                               ),
//                                                             ),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 SizedBox(
//                                                                   width: 200,
//                                                                   child: Text(
//                                                                     message[
//                                                                         'content'],
//                                                                     style:
//                                                                         const TextStyle(
//                                                                       fontFamily:
//                                                                           'ocenwide',
//                                                                       fontSize:
//                                                                           14,
//                                                                     ),
//                                                                     // By not setting maxLines, the text will wrap naturally to multiple lines
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                     height: 5),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       if (isSender) ...[
//                                                         const SizedBox(
//                                                             width: 10),
//                                                         CircleAvatar(
//                                                           backgroundImage:
//                                                               AssetImage(message[
//                                                                   'dp']), // Assuming dp is a path to the image asset
//                                                           radius: 20,
//                                                         ),
//                                                       ],
//                                                     ],
//                                                   );
//                                                 },
//                                               ),
//                                             );
//   }
// }
