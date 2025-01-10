import 'package:dthlms/Live/details.dart';

class SessionDeatils {
  final String id;
  final String projectId;
  final String sessionName;
  final MeetingDetails meetingDetails;
  final int entryTime;
  final int expirationTime;
  final int createdAt;

  SessionDeatils({
    required this.id,
    required this.projectId,
    required this.sessionName,
    required this.meetingDetails,
    required this.entryTime,
    required this.expirationTime,
    required this.createdAt,
  });

  factory SessionDeatils.fromJson(Map<String, dynamic> json) {
    print(json);
    return SessionDeatils(
      id: json['_id'],
      projectId: json['projectId'],
      sessionName: json['sessionName'],
      meetingDetails: MeetingDetails.fromJson(json['meetingDetails']),
      entryTime: json['entryTime'],
      expirationTime: json['expirationTime'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'projectId': projectId,
      'sessionName': sessionName,
      'meetingDetails': meetingDetails.toJson(),
      'entryTime': entryTime,
      'expirationTime': expirationTime,
      'createdAt': createdAt,
    };
  }
}
