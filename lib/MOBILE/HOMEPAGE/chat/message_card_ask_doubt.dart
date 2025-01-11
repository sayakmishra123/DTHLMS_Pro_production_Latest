import 'package:dthlms/MOBILE/HOMEPAGE/chat/AskDoubtModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messagecard extends StatefulWidget {
  late AskDoubtMsg msg;
  String userid;
  String username;
  String hostname;
  Messagecard(this.msg, this.userid, this.username, this.hostname, {super.key});

  @override
  State<Messagecard> createState() => _MessagecardState();
}

class _MessagecardState extends State<Messagecard> {
  TextStyle rightBarTopTextStyle = const TextStyle(
      fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);
  // RxInt rightBarIndex = 0.obs;
  // RxBool chatMood = true.obs;
  // RxBool topicChecValue = true.obs;

  @override
  Widget build(BuildContext context) {
    return widget.userid == widget.msg.fromId ? _greenmsg() : _blueMsg();
  }

//sender or another msg
  Widget _blueMsg() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // const CircleAvatar(
        //     backgroundImage:
        //         AssetImage('assets/blank-profile-picture-973460_1920.png'), // Assuming dp is a path to the image asset
        //     radius: 20,
        //   ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      widget.hostname,
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
                      formatedTime(widget.msg
                          .sent), // Display the formatted date and time or default message
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // This ensures the width is constrained to the text content size
                      width: widget.msg.msg.length < 20 ? null : 200,
                      child: Text(
                        widget.msg.msg,
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
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

//our or user msg me
  Widget _greenmsg() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const CircleAvatar(
        //     backgroundImage:
        //         AssetImage('assets/blank-profile-picture-973460_1920.png'), // Assuming dp is a path to the image asset
        //     radius: 20,
        //   ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      widget.username,
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
                      formatedTime(widget.msg
                          .sent), // Display the formatted date and time or default message
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.green[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // This ensures the width is constrained to the text content size
                      width: widget.msg.msg.length < 20 ? null : 200,
                      child: Text(
                        widget.msg.msg,
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
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  String formatedTime(dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    print(formattedTime);
    return formattedTime; // Output: 5.00 PM
  }
}
