
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dthlms/Live/models/message.dart';
import 'package:dthlms/Live/models/modelClass.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/chat/AskDoubtModel.dart';
import 'package:dthlms/MODEL_CLASS/login_model.dart';

class AskDoubtServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot<Map<String, dynamic>>?> getLastMessage(
     String userId) {
    return FirebaseFirestore.instance
        .collection('meetings')
        .doc(userId)
        .collection('messages')
        .where('userId', isEqualTo: userId)
        .where('')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .first; // This is a QueryDocumentSnapshot which can be treated as a DocumentSnapshot
      } else {
        return null; // Return null when no documents are found
      }
    });
  }

  // Method to add user to a meeting
  static Future<void> joinMeeting(String sessionId, String userId,
      String userName) async {
    final ref = firestore.collection("meetings").doc(sessionId);

    await ref.set({
      'users': FieldValue.arrayUnion([
        {'userId': userId, 'userName': userName, 'Type': 'Student'}
      ]),
    }, SetOptions(merge: true));
  }

  // Method to get all users in the meeting
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getMeetingUsers(
      String sessionId) {
    return firestore.collection("meetings").doc(sessionId).snapshots();
  }

  //  static FirebaseAuth auth = FirebaseAuth.instance;
  // static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser(String userid) {
  //   print(userid);

  //   return firestore
  //       .collection("userDetails")
  //       .where('userid', isNotEqualTo: userid)
  //       .snapshots();
  // }

  static String getConversationID(String id, String userid) =>
      userid.hashCode <= id.hashCode ? '${userid}_$id' : '${id}_$userid';

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsg(UserDetails user,
  //     userid) {
  //   print(userid);
  //   return firestore
  //       .collection("chats/${getConversationID(user.userid, userid)}/message/")
  //       .snapshots();
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsg(
      DthloginUserDetails user, String userid,) {
    print("Retrieving messages for userId: $userid");
    return firestore
        .collection("askdoubt/${getConversationID(user.nameId, userid)}/message/")
        // .where('fromId', isEqualTo: userid) // Check for userid
        .where('fromId', isEqualTo: userid) // Check for sessionId
        .snapshots();
  }

  static sendMsg(DthloginUserDetails user, String msg, String userid) async {
    final time = DateTime.now().toString();

    // Create the UserMsg instance with sessionId included
     AskDoubtMsg message = AskDoubtMsg( 
      msg: msg,
      read: '',
      told: user.nameId, 
      type: MsgType.text, 
      fromId: userid,
      sent: time,
      // sessionid: sessionId,
      // Include sessionId in the message structure
    );

    // Reference to the Firestore collection
    final ref = firestore
        .collection("askdoubt/${getConversationID(user.nameId, userid)}/message/");

    // Save the message to Firestore with the sessionId
    await ref.doc(time).set(message.toJson());
  }
}