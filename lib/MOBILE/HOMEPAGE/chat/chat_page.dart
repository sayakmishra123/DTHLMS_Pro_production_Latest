// import 'package:dthlms/Live/groupchat.dart';
// import 'package:dthlms/Live/personchat.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/chat/personal_chat.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
    // final String? sessionId;
  String userid;
  String username;
   ChatPage(
    // this.sessionId,
   this.userid,this.username,{super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Widget> chattype = [];
  // int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // chattype = [
    //   // GroupChatScreen(  
    //   //   sessionId: widget.sessionId.toString(),
    //   //   userId: widget.userid,
    //   //   userName: widget.username,
    //   // ),
    //   PersonChatHomePage(  
    //     // sessionId: '',
    //     userid: widget.userid,
    //     username: widget.username,
    //   )
    // ];
  }

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  // Color chatBoxColor = const Color(0XffC9E1FF);

  // var rightBorderRadious = const Radius.circular(20);
  // RxInt rightBarIndex = 0.obs;
  // RxBool chatMood = true.obs;
  // RxBool topicChecValue = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Help Chat'),
        centerTitle: true,
      ),
      body: 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
               Expanded(
                 child: PersonChatHomePage(  
                         // sessionId: '',
                         userid: widget.userid,
                         username: widget.username,
                       ),
               )
              ],
            ),
          ),
      
    
    );
  }
}
