class PackageData {
  final int packageId;
  final String packageName;
  final String packageExpiryDate;
  final int isUpdated;
  final bool isActive;
  final bool isDeleted;
  final bool isBlocked;
  final int isShow;
  final String lastUpdatedOn;
  final String courseId;
  final String courseName;
  final bool isFree;
  final bool isDirectPlay;
  final String isActivateByUser;
  final String isPause;
  final String isViewCounter;
  final String isTotal;
  final String pausedUpto;
  final String pausedays;

  PackageData(
      {required this.packageId,
      required this.packageName,
      required this.packageExpiryDate,
      required this.isUpdated,
      required this.isActive,
      required this.isDeleted,
      required this.isBlocked,
      required this.isShow,
      required this.lastUpdatedOn,
      required this.courseName,
      required this.courseId,
      required this.isFree,
      required this.isDirectPlay,
      required this.isActivateByUser,
      required this.isPause,
      required this.isViewCounter,
      required this.isTotal,
      required this.pausedUpto,
      required this.pausedays});
      
      
     
    

  // Factory method to create an instance from a JSON object
  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
        packageId: json['PackageId'],
        packageName: json['PackageName'],
        packageExpiryDate: json['PackageExpiryDate'] ?? "no date",
        isUpdated: json['IsUpdated'] ?? 0,
        isActive: json['IsActive'] ?? false,
        isBlocked: json['IsBlocked'] ?? false,
        isDeleted: json["IsDeleted"] ?? false,
        isShow: json['IsShow'] ?? 0,
        lastUpdatedOn: json['LastUpdatedOn'] ?? 'no date',
        courseId: json['CourseId'].toString() ?? '0',
        courseName: json['CourseName'] ?? '0',
        isFree: json['IsFree'] ?? false,
        isDirectPlay: json['IsDirectPlay'] ?? false,
        isActivateByUser: json['isActivateByUser'].toString() , //json['isActivateByUser'] ?? '0',
        isPause:json['isPause'].toString(),
      isViewCounter: json['isViewCounter'].toString() ,
      isTotal: json['isTotal'].toString() ,
      pausedUpto: json['pausedUpto'].toString(),
      pausedays: json['pausedays'].toString(),
        );
  }
}
