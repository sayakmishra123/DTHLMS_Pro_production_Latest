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
      required this.isDirectPlay});

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
      isDirectPlay: json['IsDirectPlay'] ?? false
    );
  }
}
