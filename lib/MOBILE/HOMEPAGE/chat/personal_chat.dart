import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/Live/messageui.dart';
import 'package:dthlms/Live/mobilegetx.dart';
import 'package:dthlms/Live/models/modelClass.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/chat/ask_doubt_services.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/chat/msg_ui_askdoubt.dart';
// import 'package:dthlms/MOBILE/live/getx.dart';
// import 'package:dthlms/MOBILE/live/messageui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonChatHomePage extends StatefulWidget {
  // final String sessionId;
  final String userid;
  final String username;
  PersonChatHomePage(
      {super.key,
      // required this.sessionId,
      required this.userid,
      required this.username}) {
    // print(sessionId);
  }
  @override
  State<PersonChatHomePage> createState() => _PersonChatHomePageState();
}

class _PersonChatHomePageState extends State<PersonChatHomePage> {
  UserDetails? selectedUser; // Variable to store the selected user
  GetxLive getxLive = Get.put(GetxLive());
  Getx getx = Get.put(Getx());


  @override
  Widget build(BuildContext context) {
    TextStyle rightBarTopTextStyle = const TextStyle(
        fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

    return Column(
      children: [
        // SizedBox(
        //   height: 20,
        // ),
        //  Expanded(
        //             child: ListView.builder(
        //               itemCount: getxLive.userDetails.length,
        //               itemBuilder: (context, index) {
        //                 final user = getxLive.userDetails[index];
    
        //                 // Fetch the last message for each user
        //                 return StreamBuilder<
        //                     DocumentSnapshot<Map<String, dynamic>>?>(
        //                   stream: AskDoubtServices.getLastMessage( widget.userid),
        //                   builder: (context, messageSnapshot) {
        //                     String lastMessage =
        //                         ''; // Default message when no message is available
        //                     if (messageSnapshot.connectionState ==
        //                         ConnectionState.waiting) {
        //                       return Center(
        //                           child: CircularProgressIndicator());
        //                     }
    
        //                     if (messageSnapshot.hasData &&
        //                         messageSnapshot.data != null &&
        //                         messageSnapshot.data!.exists) {
        //                       lastMessage = messageSnapshot.data!
        //                               .data()?['lastMessage'] ??
        //                           '';
        //                     }
    
        //                     return Container(
        //                       decoration: BoxDecoration(
        //                           color: Color.fromARGB(255, 8, 11, 31),
        //                           borderRadius: BorderRadius.circular(10)),
        //                       margin: EdgeInsets.symmetric(vertical: 4),
        //                       child: ListTile(
        //                         leading: const CircleAvatar(
        //                           backgroundImage: AssetImage(
        //                             'assets/blank-profile-picture-973460_1920.png',
        //                           ),
        //                           radius: 15,
        //                         ),
        //                         onTap: () {
        //                           setState(() {
        //                             selectedUser =
        //                                 user; // Set the selected user
        //                           });
        //                         },
        //                         title: Text(
        //                           user.name,
        //                           style: rightBarTopTextStyle,
        //                         ),
        //                         // subtitle: Text(
        //                         //   lastMessage, // Display last message here
        //                         //   style: TextStyle(
        //                         //       color: Colors.white70, fontSize: 14),
        //                         // ),
        //                       ),
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //           ),
            
       Expanded( 
                child: MessageUiAskDoubt(  
                   getx.loginuserdata[0],
                    widget.userid,
                    widget.username,
                    "${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}",
                        ), // Display MessageUi if a user is selected
              ),
            
        // You can add a chat input here or other widgets below the user list
      ],
    );
  }
}
