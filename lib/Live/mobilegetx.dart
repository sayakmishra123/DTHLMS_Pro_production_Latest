import 'dart:convert';

// import 'package:abc/model/meetingdetails.dart';
// import 'package:abc/url.dart';
// import 'package:abc/widget/models/message.dart';
// import 'package:abc/widget/models/modelClass.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/log.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'models/message.dart';
import 'models/modelClass.dart';
import 'url.dart';

class GetxLive extends GetxController {
  // RxList<AllPackages> packages = <AllPackages>[].obs;
  RxSet<int> selectedPackages = <int>{}.obs;
  // late SharedPreferences prefs;
  RxList<MeetingDeatils> pastmeeting = RxList<MeetingDeatils>();
  RxList<MeetingDeatils> todaymeeting = RxList<MeetingDeatils>();
  RxList<MeetingDeatils> upcomingmeeting = RxList<MeetingDeatils>();
  RxList allmeeting = RxList();
  static String token = "dgfdghsfsfrwerrt";
  RxBool topichas = false.obs;
  RxBool pollhas = false.obs;
  RxBool isloadChatUrl = false.obs;
  RxList<UserDetails> userDetails = <UserDetails>[].obs;

  initiallizeSharePreferrance(token) async {
    // prefs = await SharedPreferences.getInstance();
    // prefs.setString('token', token);
  }

  gettoken() async {
    // prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token') ?? 'kjbsfbdsfbjhksbfjdshbfds';
  }

  // Future<void> getAllPackages(BuildContext context) async {
  //   token = await gettoken();
  //   var data = {
  //     "tblPackage": {"PackageId": "0"}
  //   };

  //   try {
  //     var res = await http.post(
  //       Uri.https(LinkUrl.mainpoint, LinkUrl.getallpackages),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json'
  //       },
  //       body: jsonEncode(data),
  //     );

  //     if (res.statusCode == 200) {
  //       var responseData = jsonDecode(res.body);
  //       var resultString = responseData['result'];
  //       print(resultString);
  //       // Convert the result string to a list of maps
  //       List<dynamic> resultList = jsonDecode(resultString);

  //       // // Convert the list of maps to a list of Package objects
  //       packages.value =
  //           resultList.map((e) => AllPackages.fromJson(e)).toList();
  //     } else {
  //       print('Failed to load packages');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     // Get.back();
  //   }
  // }

  // Future<void> createMeeting(
  //     BuildContext context,
  //     TextEditingController videoname,
  //     TextEditingController selectpackage,
  //     TextEditingController topicname,
  //     TextEditingController date,
  //     TextEditingController duration,
  //     TextEditingController description,
  //     String videoCategory,
  //     RxSet<int> selectedPackages) async {
  //   token = await gettoken();
  //   String selectedPackagesString =
  //       selectedPackages.map((e) => e.toString()).join(',');
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   print(selectedPackagesString.toString());
  //   var data = {
  //     "tblEncryptionHistory": {
  //       "VideoCategory": videoCategory.toString(),
  //       "VideoName": videoname.text.toString(),
  //       "VideoDuration": duration.text.toString(),
  //       "VideoDescription": description.text.toString(),
  //       "TopicName": topicname.text.toString(),
  //       "ScheduledOn": date.text.toString(),
  //       // "IsActive": true,
  //       // "IsDeleted": false,
  //       "PackageIds": selectedPackagesString.toString(),
  //       // "ZoomUserId": "user123",
  //       // "ZoomPassword": "pass123",
  //       // "SessionId": "session123",
  //       // "MeetingId": "meeting123",
  //       // "HostUid": "host1235455656465",
  //       // "ProjectId": "project123"
  //     }
  //   };
  //   print(data);

  //   try {
  //     var res = await http.post(
  //       Uri.https(LinkUrl.mainpoint, LinkUrl.insertcreatesessiondata),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json'
  //       },
  //       body: jsonEncode(data),
  //     );

  //     print(res.body);
  //     Get.back();

  //     // if (res.statusCode == 200) {
  //     //   var responseData = jsonDecode(res.body);
  //     //   var resultString = responseData['result'] as String;
  //     //   print(resultString);
  //     //   // Convert the result string to a list of maps
  //     //   List<dynamic> resultList = jsonDecode(resultString);

  //     //   // Convert the list of maps to a list of Package objects
  //     //   packages.value =
  //     //       resultList.map((e) => AllPackages.fromJson(e)).toList();
  //     // } else {
  //     //   print('Failed to load packages');
  //     // }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     // Get.back();
  //   }
  // }

  void togglePackageSelection(int packageId) {
    if (selectedPackages.contains(packageId)) {
      selectedPackages.remove(packageId);
    } else {
      selectedPackages.add(packageId);
    }
  }

  Future<void> getMeetingList() async {
    token = await gettoken();
    Map<String, dynamic> data = {};

    try {
      // Sending the POST request
      var res = await http.post(
        Uri.https(LinkUrl.mainpoint, LinkUrl.meetinglist),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print(res.body);
      // Checking if the request was successful
      if (res.statusCode == 200) {
        print('Response Status Code: ${res.statusCode}');

        // Parsing the response body
        Map<String, dynamic> parsedResponse = jsonDecode(res.body);

        // Checking if the response indicates success
        if (parsedResponse['isSuccess']) {
          // Parsing the result field, which is a stringified JSON array
          List<dynamic> resultList = jsonDecode(parsedResponse['result']);

          // Separating the meetings into Past, Today, and Upcoming
          for (var meetingJson in resultList) {
            MeetingDeatils meeting = MeetingDeatils.fromJson(meetingJson);
            String programStatus = meeting.programStatus;

            if (programStatus == 'Past') {
              pastmeeting.add(meeting);
            } else if (programStatus == 'Today') {
              todaymeeting.add(meeting);
            } else if (programStatus == 'Upcoming') {
              upcomingmeeting.add(meeting);
            }
          }

          // Combine all lists into a single list if needed

          // Printing the categorized meetings
          print('Past Meetings: ${pastmeeting.length}');
          print('Today Meetings: ${todaymeeting.length}');
          print('Upcoming Meetings: ${upcomingmeeting.length}');
        } else {
          print(
              'Request was not successful. Error Messages: ${parsedResponse['errorMessages']}');
        }
      } else {
        print('Request failed with status: ${res.statusCode}');
      }
    } catch (e) {
      writeToFile(e, "getMeetingList");
      print('An error occurred: $e');
    }
  }
}

// class MeetingService {
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   static Stream<DocumentSnapshot<Map<String, dynamic>>?> getLastMessage(
//       String sessionId, String userId) {
//     return FirebaseFirestore.instance
//         .collection('meetings')
//         .doc(sessionId)
//         .collection('messages')
//         .where('userId', isEqualTo: userId)
//         .where('')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .map((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs
//             .first; // This is a QueryDocumentSnapshot which can be treated as a DocumentSnapshot
//       } else {
//         return null; // Return null when no documents are found
//       }
//     });
//   }

//   // Method to add user to a meeting
//   static Future<void> joinMeeting(String sessionId, String userId,
//       String userName) async {
//     final ref = firestore.collection("meetings").doc(sessionId);

//     await ref.set({
//       'users': FieldValue.arrayUnion([
//         {'userId': userId, 'userName': userName, 'Type': 'Student'}
//       ]),
//     }, SetOptions(merge: true));
//   }

//   // Method to get all users in the meeting
//   static Stream<DocumentSnapshot<Map<String, dynamic>>> getMeetingUsers(
//       String sessionId) {
//     return firestore.collection("meetings").doc(sessionId).snapshots();
//   }

//   //  static FirebaseAuth auth = FirebaseAuth.instance;
//   // static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser(String userid) {
//     print(userid);

//     return firestore
//         .collection("userDetails")
//         .where('userid', isNotEqualTo: userid)
//         .snapshots();
//   }

//   static String getConversationID(String id, String userid) =>
//       userid.hashCode <= id.hashCode ? '${userid}_$id' : '${id}_$userid';

//   // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsg(UserDetails user,
//   //     userid) {
//   //   print(userid);
//   //   return firestore
//   //       .collection("chats/${getConversationID(user.userid, userid)}/message/")
//   //       .snapshots();
//   // }

//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsg(
//       UserDetails user, String userid, String sessionId) {
//     print("Retrieving messages for userId: $userid with sessionId: $sessionId");
//     return firestore
//         .collection("chats/${getConversationID(user.userid, userid)}/message/")
//         // .where('fromId', isEqualTo: userid) // Check for userid
//         .where('sessionId', isEqualTo: sessionId) // Check for sessionId
//         .snapshots();
//   }

//   static sendMsg(UserDetails user, String msg, String userid,
//       String sessionId) async {
//     final time = DateTime.now().toString();

//     // Create the UserMsg instance with sessionId included
//     final UserMsg message = UserMsg(
//       msg: msg,
//       read: '',
//       told: user.userid,
//       type: Type.text,
//       fromId: userid,
//       sent: time,
//       sessionid: sessionId,
//       // Include sessionId in the message structure
//     );

//     // Reference to the Firestore collection
//     final ref = firestore
//         .collection("chats/${getConversationID(user.userid, userid)}/message/");

//     // Save the message to Firestore with the sessionId
//     await ref.doc(time).set(message.toJson());
//   }
// }
