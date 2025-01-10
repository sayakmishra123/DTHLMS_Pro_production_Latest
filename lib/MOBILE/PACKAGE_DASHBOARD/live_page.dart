import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/Live/mobile_vcScreen.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';

import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Widget _buildGridView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: getx.todaymeeting.length,
      itemBuilder: (context, index) {
        MeetingDeatils meeting = getx.todaymeeting[index];
        return _buildCard(index, meeting);
      },
    );
  }

  Widget _buildCard(int index, MeetingDeatils meeting) {
    return Card(
      elevation: 4,
      color: Colors.transparent,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      meeting.videoName.toUpperCase(),
                      style: FontFamily.styleb.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package: ${meeting.packageName}',
                          style: FontFamily.styleb.copyWith(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          'TopicName: ${meeting.topicName}',
                          style: FontFamily.styleb.copyWith(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          'Duration: ${meeting.videoDuration}',
                          style: FontFamily.styleb.copyWith(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          hoverColor: Colors.white10,
                          focusColor: Colors.red,
                          highlightColor: Colors.blue[200],
                          color: Colors.red,
                          onPressed: () {
                            // Navigate to MobileMeetingPage with the relevant information
                            Get.to(
                                transition: Transition.cupertino,
                                () => MobileMeetingPage(
                                      meeting.projectId.toString(),
                                      meeting.sessionId.toString(),
                                      getx.loginuserdata[0].nameId,
                                      "${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}",
                                      meeting.topicName,
                                      meeting.liveUrl,
                                      videoCategory: meeting.videoCategory,
                                    ));
                          },
                          child: Text(
                            'Join',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Obx(() => getx.todaymeeting.isEmpty ? Container() : _buildGridView()),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            pageTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String pageTitle = 'Today Meetings';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMeetingList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPage.blue,
        title: Text(
          'Live',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderRow(),
            _buildMeetingList(),
          ],
        ),
      ),
    );
  }
}
