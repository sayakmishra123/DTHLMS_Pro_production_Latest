import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/Live/mobile_vcScreen.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/package_contents.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LivePage extends StatefulWidget {
  final List todayLiveClassList;
  const LivePage({super.key, required this.todayLiveClassList});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Widget _buildGridView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.todayLiveClassList.length,
      itemBuilder: (context, index) {
        MeetingDeatils meeting = widget.todayLiveClassList[index];
        return TutorCard(
          meeting: meeting,
          imageUrl: meeting.videoCategory == 'YouTube'
              ? 'assets/youtube.png'
              : logopath, // Replace with your image URL
          name: meeting.videoName,
          topicname: meeting.topicName,
          time: meeting.videoDuration.toString(),
          description: meeting.packageName,
          languages: meeting.scheduledOn.toString(),
          liveUrl: meeting.liveUrl.toString(),
          projectId: meeting.projectId.toString(),
          sessionId: meeting.sessionId.toString(),
          videoCategory: meeting.videoCategory,
        );
      },
    );
  }

  Widget _buildMeetingList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() =>
          getx.todaymeeting.isEmpty && widget.todayLiveClassList.isEmpty
              ? Container()
              : _buildGridView()),
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
      getMeetingList(context).then((_) {
        filterMeetingListByPackage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPage.blue,
        title: Text(
          'Live',
          style: FontFamily.styleb,
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderRow(),
           getx.todaymeeting.isEmpty ? Column(children: [
            Text('No Data to reflect')
           ],) : _buildMeetingList()
          ],
        ),
      ),
    );
  }
}

class TutorCard extends StatelessWidget {
  final MeetingDeatils meeting;
  final String imageUrl;
  final String name;
  final String topicname;
  final String time;
  final String description;
  final String languages;
  final String projectId;
  final String sessionId;
  final String liveUrl;
  final String videoCategory;

  const TutorCard(
      {required this.imageUrl,
      required this.name,
      required this.topicname,
      required this.time,
      required this.description,
      required this.languages,
      required this.projectId,
      required this.sessionId,
      required this.liveUrl,
      required this.videoCategory,
      required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFF1D5),
              const Color(0xFFFFE0AF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(imageUrl),
                  radius: 30,
                ),
                SizedBox(width: 12),
                // Name and Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        topicname,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),

                Lottie.asset('assets/liveanimation.json',
                    width: 70, height: 70),
                // Rating
                // Row(
                //   children: [
                //     Icon(Icons.alarm, color: Colors.amber, size: 20),
                //     SizedBox(width: 4),
                //     Text(
                //       '$time min',
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
              ],
            ),
            SizedBox(height: 8),
            // Description
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            // Languages
            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 4.0,
            //   children: languages
            //       .map(
            //         (lang) => Chip(
            //           label: Text(
            //             lang,
            //             style: TextStyle(color: Colors.white, fontSize: 12),
            //           ),
            //           backgroundColor: ColorPage.blue,
            //         ),
            //       )
            //       .toList(),
            // ),
            SizedBox(height: 12),
            // Buttons
            Row(
              children: [
                // Text(
                //   languages,
                //   style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.grey[700],
                //       fontWeight: FontWeight.bold),
                // ),
                Icon(Icons.alarm, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  '$time min',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(
                        transition: Transition.cupertino,
                        () => MobileMeetingPage(
                              meeting: meeting,
                              projectId.toString(),
                              sessionId.toString(),
                              getx.loginuserdata[0].nameId,
                              "${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}",
                              topicname,
                              liveUrl,
                              videoCategory: videoCategory,
                            ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPage.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 