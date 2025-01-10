import 'dart:convert';

class PremiumPackage {
  int sortingOrder;
  String documentUrl;
  int packageId;
  String packageName;
  String packageBannerPathUrl;
  double minPackagePrice;

  PremiumPackage({
    required this.sortingOrder,
    required this.documentUrl,
    required this.packageId,
    required this.packageName,
    required this.packageBannerPathUrl,
    required this.minPackagePrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'sortingOrder': sortingOrder,
      'documentUrl': documentUrl,
      'packageId': packageId,
      'packageName': packageName,
      'packageBannerPathUrl': packageBannerPathUrl,
      'minPackagePrice': minPackagePrice,
    };
  }

  factory PremiumPackage.fromJson(Map<String, dynamic> json) {
    const validImageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp'
    ];
    String bannerPathUrl = json['PackageBannerPathUrl'] ?? '';
    bool isImageUrl = validImageExtensions
        .any((ext) => bannerPathUrl.toLowerCase().endsWith(ext));

    return PremiumPackage(
      sortingOrder: json['SortingOrder'] ?? 0,
      documentUrl: json['DocumentUrl'] ?? '',
      packageId: json['PackageId'] ?? 0,
      packageName: json['PackageName'] ?? '',
      packageBannerPathUrl: isImageUrl ? bannerPathUrl : '',
      minPackagePrice: (json['MinPackagePrice'] ?? 0.0).toDouble(),
    );
  }
}

class PackageInfo {
  final int appStoreId;
  final int categoryOrder;
  final String imageType;
  final String heading;
  final List<PremiumPackage> premiumPackageListInfo;

  PackageInfo({
    required this.appStoreId,
    required this.categoryOrder,
    required this.imageType,
    required this.heading,
    required this.premiumPackageListInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'appStoreId': appStoreId,
      'categoryOrder': categoryOrder,
      'imageType': imageType,
      'heading': heading,
      'premiumPackageListInfo':
          premiumPackageListInfo.map((e) => e.toJson()).toList(),
    };
  }

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    var list = json['PremiumPackageListInfo'] as List? ?? [];
    List<PremiumPackage> premiumPackages =
        list.map((i) => PremiumPackage.fromJson(i)).toList();

    return PackageInfo(
      appStoreId: json['AppStoreId'] ?? 0,
      categoryOrder: json['CategoryOrder'] ?? 0,
      imageType: json['ImageType'] ?? '',
      heading: json['AppSectionHeading'] ?? '',
      premiumPackageListInfo: premiumPackages,
    );
  }
}

class ApiResponse {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessages;
  final List<PackageInfo> result;

  ApiResponse({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessages,
    required this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    List resultList = json['result'] != null ? jsonDecode(json['result']) : [];

    List<PackageInfo> parsedResult = resultList.isNotEmpty
        ? resultList.map((data) => PackageInfo.fromJson(data)).toList()
        : [];

    return ApiResponse(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessages: json['errorMessages'] != null
          ? List<String>.from(json['errorMessages'])
          : [],
      result: parsedResult,
    );
  }
}

class PackageAttribute {
  int packageDetailsId;
  int packageId;
  int franchiseId;
  int nodeId;
  String category;
  String description;
  int documentId;
  String? documentPath;
  int nodeOptionId;
  String createdBy;
  String? modifiedBy;
  DateTime createdOn;
  DateTime? modifiedOn;
  String createdIp;
  String? modifiedIp;
  bool isActive;
  bool isDeleted;

  PackageAttribute({
    required this.packageDetailsId,
    required this.packageId,
    required this.franchiseId,
    required this.nodeId,
    required this.category,
    required this.description,
    required this.documentId,
    this.documentPath,
    required this.nodeOptionId,
    required this.createdBy,
    this.modifiedBy,
    required this.createdOn,
    this.modifiedOn,
    required this.createdIp,
    this.modifiedIp,
    required this.isActive,
    required this.isDeleted,
  });

  factory PackageAttribute.fromJson(Map<String, dynamic> json) {
    return PackageAttribute(
      packageDetailsId: json['PackageDetailsId'] ?? 0,
      packageId: json['PackageId'] ?? 0,
      franchiseId: json['FranchiseId'] ?? 0,
      nodeId: json['NodeId'] ?? 0,
      category: json['Category'] ?? '',
      description: json['Description'] ?? '',
      documentId: json['DocumentId'] ?? 0,
      documentPath: json['DocumentPath'],
      nodeOptionId: json['NodeOptionId'] ?? 0,
      createdBy: json['CreatedBy'] ?? '',
      modifiedBy: json['ModifiedBy'],
      createdOn: json['CreatedOn'] != null
          ? DateTime.parse(json['CreatedOn'])
          : DateTime.now(),
      modifiedOn: json['ModifiedOn'] != null
          ? DateTime.parse(json['ModifiedOn'])
          : null,
      createdIp: json['CreatedIp'] ?? '',
      modifiedIp: json['ModifiedIp'],
      isActive: json['IsActive'] ?? false,
      isDeleted: json['IsDeleted'] ?? false,
    );
  }
}

class PackagInfoData {
  List<PackageAttribute> attributes;

  PackagInfoData({
    required this.attributes,
  });

  factory PackagInfoData.fromJson(Map<String, dynamic> json) {
    var attributesList = <dynamic>[];

    // Check if 'result' is a String and parse it
    if (json['result'] is String) {
      try {
        attributesList = List<dynamic>.from(jsonDecode(json['result']));
      } catch (e) {
        attributesList = [];
      }
    } else if (json['result'] is List) {
      attributesList = List<dynamic>.from(json['result']);
    }

    return PackagInfoData(
      attributes:
          attributesList.map((e) => PackageAttribute.fromJson(e)).toList(),
    );
  }
}

// void main() {
//   // Sample JSON response
//   var jsonData = {
//     "statusCode": 200,
//     "isSuccess": true,
//     "errorMessages": [],
//     "result": [
//       {
//         "PackageDetailsId": 32,
//         "PackageId": 139,
//         "FranchiseId": 9,
//         "NodeId": 306,
//         "Category": "Attribute",
//         "Description": "ATTRIBUTE IS BEST ",
//         "CreatedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "ModifiedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "CreatedOn": "2024-11-05T12:11:34.027",
//         "ModifiedOn": "2024-11-05T12:16:58.047",
//         "CreatedIp": "203.163.224.162",
//         "ModifiedIp": "203.163.224.162",
//         "IsActive": true,
//         "IsDeleted": false,
//         "NodeOptionId": 961
//       },
//       {
//         "PackageDetailsId": 33,
//         "PackageId": 139,
//         "FranchiseId": 9,
//         "NodeId": 307,
//         "Category": "Attribute",
//         "Description": "ATTRIBUTE IS BEST 163  ROW ",
//         "CreatedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "ModifiedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "CreatedOn": "2024-11-05T12:11:34.783",
//         "ModifiedOn": "2024-11-05T12:17:03.727",
//         "CreatedIp": "203.163.224.162",
//         "ModifiedIp": "203.163.224.162",
//         "IsActive": true,
//         "IsDeleted": false,
//         "NodeOptionId": 964
//       },
//       {
//         "PackageDetailsId": 34,
//         "PackageId": 139,
//         "FranchiseId": 9,
//         "NodeId": 309,
//         "Category": "Details",
//         "DocumentId": 15906,
//         "Description": "EVERY DETAILS IS COMMING HERE ",
//         "CreatedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "ModifiedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "CreatedOn": "2024-11-05T12:11:58.597",
//         "ModifiedOn": "2024-11-05T12:17:58.997",
//         "CreatedIp": "203.163.224.162",
//         "ModifiedIp": "203.163.224.162",
//         "IsActive": true,
//         "IsDeleted": false
//       },
//       {
//         "PackageDetailsId": 41,
//         "PackageId": 139,
//         "FranchiseId": 9,
//         "NodeId": 310,
//         "Category": "Details",
//         "DocumentId": 16155,
//         "CreatedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "CreatedOn": "2024-11-07T15:12:13.123",
//         "CreatedIp": "203.163.224.162",
//         "IsActive": true,
//         "IsDeleted": false
//       },
//       {
//         "PackageDetailsId": 42,
//         "PackageId": 139,
//         "FranchiseId": 9,
//         "NodeId": 311,
//         "Category": "Details",
//         "DocumentId": 16162,
//         "CreatedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "ModifiedBy": "2bde3a95-65ad-4008-a94e-1b4ca3cbbd23",
//         "CreatedOn": "2024-11-07T15:16:27.903",
//         "ModifiedOn": "2024-11-07T15:19:47.283",
//         "CreatedIp": "203.163.224.162",
//         "ModifiedIp": "203.163.224.162",
//         "IsActive": true,
//         "IsDeleted": false
//       }
//     ]
//   };

//   // Creating PackageData object from JSON
//   var packageData = PackageData.fromJson(jsonData);

//   // Print data for verification
//   print("Attributes:");
//   packageData.attributes.forEach((attribute) => print("Description: ${attribute.description}, Created By: ${attribute.createdBy}"));
// }
