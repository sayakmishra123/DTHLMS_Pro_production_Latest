class MeetingDetails {
  final String meetingName;
  final String meetingId;
  final String hostUid;

  MeetingDetails({
    required this.meetingName,
    required this.meetingId,
    required this.hostUid,
  });

  factory MeetingDetails.fromJson(Map<String, dynamic> json) {
    return MeetingDetails(
      meetingName: json['meetingName'],
      meetingId: json['meetingId'],
      hostUid: json['hostUid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meetingName': meetingName,
      'meetingId': meetingId,
      'hostUid': hostUid,
    };
  }
}
