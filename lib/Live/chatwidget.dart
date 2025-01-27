// import 'package:abc/personchat.dart';
// import 'package:abc/widget/groupchat.dart';
// import 'package:abc/widget/personchat.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'groupchat.dart';
import 'personchat.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChatUi extends StatefulWidget {
  final String? sessionId;
  String userid;
  String username;
  final MeetingDeatils? meeting;

  ChatUi(this.sessionId, this.userid, this.username, {super.key, this.meeting});

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  List<Widget> chattype = [];
  int _currentIndex = 0;

  @override
  void initState() {
    initializeWebView().then((v){
      setState(() {
        
      });
    });
    chattype = [
      GroupChatScreen(
        sessionId: widget.sessionId.toString(),
        userId: widget.userid,
        userName: widget.username,
      ),
      PersonChat(
        sessionId: widget.sessionId ?? '',
        userid: widget.userid,
        username: widget.username,
      )
    ];
    super.initState();
    
  }
  Getx getx = Get.put(Getx());


  final WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.google.co.in/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri?.parse('https://www.google.co.in/'));

Future<void> initializeWebView() async {
  try {
 
    controller.loadRequest(Uri.parse(widget.meeting!.groupChat!)); // Assuming widget.personchat is a URL
    getx.isloadChatUrl.value = true;
  } catch (e) {
    debugPrint('Error initializing WebView: $e');
  }
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
        title: Text('Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 300),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: chatConColor.withOpacity(0.3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      elevation: 50,
                      shadowColor: Colors.black,
                      backgroundColor:
                          _currentIndex == 0 ? greencolor : Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Center(
                        child: Text(
                          'Group',
                          style: TextStyle(
                              fontSize: 16,
                              color: _currentIndex == 0
                                  ? chatSelectedColor
                                  : chatUnSelectedColor,
                              fontFamily: 'ocenwide'),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _currentIndex == 1 ? greencolor : Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Center(
                        child: Text(
                          'Personal',
                          style: TextStyle(
                              fontSize: 16,
                              color: _currentIndex == 1
                                  ? chatSelectedColor
                                  : chatUnSelectedColor,
                              fontFamily: 'ocenwide'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(child: chattype[_currentIndex]),
            // Expanded(child: )
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: WebViewWidget(controller: controller))
          ],
        ),
      ),
    );
  }
}
