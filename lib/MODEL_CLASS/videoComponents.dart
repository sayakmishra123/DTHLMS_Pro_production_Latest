class VideoComponents {
  final String componentId;
  final int packageId;
  final int videoId;
  final String names;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String videoTime;
  final String answer;
  final String category;
  final String tagName;
  final int documentId;
  final String documentURL;
  final bool isVideoCompulsory;
  final bool isChapterCompulsory;
  final int previousVideoId;
  final int minimumVideoDuration;
  final int previousChapterId;
  final String sessionId;
  final int franchiseId;
  final String isEncrypted;

  VideoComponents(  {
    required this.componentId,
    required this.packageId,
    required this.videoId,
    required this.names,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.videoTime,
    required this.answer,
    required this.category,
    required this.tagName,
    required this.documentId,
   required this. documentURL,
    required this.isVideoCompulsory,
    required this.isChapterCompulsory,
    required this.previousVideoId,
    required this.minimumVideoDuration,
    required this.previousChapterId,
    required this.sessionId,
    required this.franchiseId,
    required this.isEncrypted,

  });

  factory VideoComponents.fromJson(Map<String, dynamic> json) {
    return VideoComponents(
     componentId :json['VideoDetailsId'].toString(),

      packageId: json['PackageId'],
      videoId: json['VideoId'],
      names: json['Names'],
      option1: json['Option1'],
      option2: json['Option2'],
      option3: json['Option3'],
      option4: json['Option4'],
      videoTime: json['VideoTime'],
      answer: json['Answer'],
      category: json['Category'],
      tagName: json['TagName'],
      documentId: json['DocumentId'],
      documentURL: json['DocumentURL'],
      isVideoCompulsory: json['IsVideoCompulsory'],
      isChapterCompulsory: json['IsChapterCompulsory'],
      previousVideoId: json['PreviousVideoId'],
      minimumVideoDuration: json['MinimumVideoDuration'],
      previousChapterId: json['PreviousChapterId'],
      sessionId: json['SessionId'],
      franchiseId: json['FranchiseId'],
      isEncrypted: json['IsEncrypted'].toString(),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PackageId': packageId,
      'VideoId': videoId,
      'Names': names,
      'Option1': option1,
      'Option2': option2,
      'Option3': option3,
      'Option4': option4,
      'VideoTime': videoTime,
      'Answer': answer,
      'Category': category,
      'TagName': tagName,
      'DocumentId': documentId,
      'DocumentURL':documentURL,
      'IsVideoCompulsory': isVideoCompulsory,
      'IsChapterCompulsory': isChapterCompulsory,
      'PreviousVideoId': previousVideoId,
      'MinimumVideoDuration': minimumVideoDuration,
      'PreviousChapterId': previousChapterId,
      'SessionId': sessionId,
      'FranchiseId': franchiseId,
      'IsEncrypted':isEncrypted,
    };
  }
}
