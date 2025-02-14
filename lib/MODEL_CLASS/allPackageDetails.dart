import 'dart:convert';

class AllPackageDetails {
  final int packageId;
  final String packageName;
  final String fileIdType;
  final int fileId;
  final String fileIdName;
  final int chapterId;
  final int allowDuration;
  final int consumeDuration;
  final int allowNo;
  final int consumeNos;
  final String documentPath;
  final String scheduleOn;
  final String sessionId;
  final int videoDuration;
  final String DownloadedPath;
  final String isEncrypted;
  final int sortedOrder;
  final String viewCount;
  final String durationLimitation;
  final String description;
  final String displayName;

  AllPackageDetails(
      {required this.packageId,
      required this.packageName,
      required this.fileIdType,
      required this.fileId,
      required this.fileIdName,
      required this.chapterId,
      required this.allowDuration,
      required this.consumeDuration,
      required this.allowNo,
      required this.consumeNos,
      required this.documentPath,
      required this.scheduleOn,
      required this.sessionId,
      required this.videoDuration,
      required this.DownloadedPath,
      required this.isEncrypted,
      
      required this.sortedOrder,required this.durationLimitation,required this.viewCount,required this.description,required this.displayName,});

  // Factory method to create a FileInfo instance from JSON
  factory AllPackageDetails.fromJson(Map<String, dynamic> json) {
    return AllPackageDetails(
      packageId: json['PackageId'] ?? 0,
      packageName: json['PackageName'] ?? '',
      fileIdType: json['FileIdType'] ?? '',
      fileId: json['FileId'] ?? 0,
      fileIdName: json['FileIdName'] ?? '',
      chapterId: json['ChapterId'] ?? 0,
      allowDuration: json['AllowDuration'] ?? 0,
      consumeDuration: json['ConsumeDuration'] ?? 0,
      allowNo: json['AllowNo'] ?? 0,
      consumeNos: json['ConsumeNos'] ?? 0,
      documentPath: json['DocumentPath'] ?? '0',
      scheduleOn: json['ScheduledOn'].toString(),
      sessionId: json['SessionId'] ?? '0',
      videoDuration: json['VideoDuration'] ?? '0',
      DownloadedPath: json['DownloadedPath'] ?? '0',
      isEncrypted: json['isEncrypted'].toString(),
      sortedOrder: json['SortedOrder'] ?? 0,
      durationLimitation: json['DurationLimitation'] ?? '0',
      viewCount: json['ViewCount'] ?? '0',
      description: json['Description'] ?? '',
      displayName: json['DisplayName'] ?? '',
    );
  }

  // Method to convert a FileInfo instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'PackageId': packageId,
      'PackageName': packageName,
      'FileIdType': fileIdType,
      'FileId': fileId,
      'FileIdName': fileIdName,
      'ChapterId': chapterId,
      'AllowDuration': allowDuration,
      'ConsumeDuration': consumeDuration,
      'AllowNo': allowNo,
      'ConsumeNos': consumeNos,
      'DocumentPath': documentPath,
      'ScheduleOn': scheduleOn.toString(),
      'SessionId': sessionId,
      'VideoDuration': videoDuration,
      'DownloadedPath': DownloadedPath,
      'isEncrypted': isEncrypted,
      'SortedOrder': sortedOrder,
      'DurationLimitation':durationLimitation,
      'ViewCount':viewCount,
      'Description':description,
      'DisplayName':displayName,
    };
  }

  // Static method to convert a JSON array to a list of FileInfo instances
  static List<AllPackageDetails> fromJsonList(String jsonString) {
    final Iterable jsonList = json.decode(jsonString);
    return jsonList.map((json) => AllPackageDetails.fromJson(json)).toList();
  }
}
