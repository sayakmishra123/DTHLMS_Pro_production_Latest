class MeetingDeatils {
  final String packageName;
  final String packageId;
  final String videoId;
  final String videoName;
  final int videoDuration;
  final String videoDescription;
  final bool isActive;
  final DateTime scheduledOn;
  final String topicName;
  final String videoCategory;
  final String programStatus;
  final String? sessionId;
  final String? hostUid;
  final String? projectId;
  final String? meetingId;
  final String? liveUrl;
  final String? groupChat;
  final String? personalChat;
  final String? poolURL;
  final String? topicURL;

  MeetingDeatils(
      {required this.packageName,
      required this.packageId,
      required this.videoId,
      required this.videoName,
      required this.videoDuration,
      required this.videoDescription,
      required this.isActive,
      required this.scheduledOn,
      required this.topicName,
      required this.videoCategory,
      required this.programStatus,
      this.groupChat,
      this.sessionId,
      this.hostUid,
      this.projectId,
      this.meetingId,
      this.personalChat,
      this.liveUrl,
      this.poolURL,
      this.topicURL});

  factory MeetingDeatils.fromJson(Map<String, dynamic> json) {
    return MeetingDeatils(
      packageName: json['PackageNames'] ?? '',
      packageId: json['PackageIds'] ?? '',
      videoId: json['VideoIds'] ?? '',
      videoName: json['VideoName'] ?? '',
      videoDuration: json['VideoDuration'] ?? 0,
      videoDescription: json['VideoDescription'] ?? '',
      isActive: json['IsActive'] ?? false,
      scheduledOn: json['ScheduledOn'] != null
          ? DateTime.parse(json['ScheduledOn'])
          : DateTime.now(), // Default to current time if null
      topicName: json['TopicName'] ?? '',
      videoCategory: json['VideoCategory'] ?? '',
      programStatus: json['ProgramStatus'] ?? '',
      sessionId: json['SessionId'], // Nullable, no need for default
      hostUid: json['HostUid'], // Nullable, no need for default
      projectId: json['ProjectId'], // Nullable, no need for default
      meetingId: json['MeetingId'], // Nullable, no need for default
      liveUrl: json['LiveURL'],
      groupChat: json['ChatURL'] ?? "",
      personalChat: json['ChatURL'] ?? "", // Nullable, no need for default,
      poolURL: json['PoolURL'] ?? "",
      topicURL: json['TopicURL'] ?? "",
    );
  }
}
