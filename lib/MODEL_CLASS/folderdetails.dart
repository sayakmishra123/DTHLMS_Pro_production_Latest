class FolderDetails {
  final int sectionChapterId;
  final String sectionChapterName;
  final int parentSectionChapterId;
  final int packageId;
  final int startParentId;

  FolderDetails({
    required this.sectionChapterId,
    required this.sectionChapterName,
    required this.parentSectionChapterId,
    required this.packageId,
    required this.startParentId,
  });

  // Factory method to create a SectionChapter from JSON
  factory FolderDetails.fromJson(Map<String, dynamic> json) {
    return FolderDetails(
      sectionChapterId: json['SectionChapterId'],
      sectionChapterName: json['SectionChapterName'],
      parentSectionChapterId: json['ParentSectionChapterId'],
      packageId: json['PackageId'],
      startParentId: json['StartParentId'],
    );
  }

  // Method to convert a SectionChapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'SectionChapterId': sectionChapterId,
      'SectionChapterName': sectionChapterName,
      'ParentSectionChapterId': parentSectionChapterId,
      'PackageId': packageId,
      'StartParentId': startParentId,
    };
  }
}
