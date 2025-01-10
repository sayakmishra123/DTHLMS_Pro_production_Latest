class DeviceLoginHistoryDetails {
  final int userDevicesId;
  final String userId;
  final String deviceType;
  final int franchiseId;
  final String defaultAppVersion;
  final DateTime allotedOn; // Note: Changed from nullable to non-nullable
  final bool isActive;
  final bool isBlock;
  final String deviceId1;
  final String configuration;
  final String osVersion;
  final bool isLaptop;
  final bool isTabletIpad;
  final bool isDeleted;
  final int activationKeyId;
  final bool isLoggedIn;
  final DateTime logoutTime; // Note: Changed from nullable to non-nullable
  final String deviceName;

  DeviceLoginHistoryDetails({
    required this.userDevicesId,
    required this.userId,
    required this.deviceType,
    required this.franchiseId,
    required this.defaultAppVersion,
    required this.allotedOn,
    required this.isActive,
    required this.isBlock,
    required this.deviceId1,
    required this.configuration,
    required this.osVersion,
    required this.isLaptop,
    required this.isTabletIpad,
    required this.isDeleted,
    required this.activationKeyId,
    required this.isLoggedIn,
    required this.logoutTime,
    required this.deviceName,
  });

  // Factory method to create a DeviceLoginHistoryDetails from JSON
  factory DeviceLoginHistoryDetails.fromJson(Map<String, dynamic> json) {
    return DeviceLoginHistoryDetails(
      userDevicesId: json['UserDevicesID'] ?? 0,
      userId: json['UserId'] ?? '',
      deviceType: json['DeviceType'] ?? '',
      franchiseId: json['FranchiseId'] ?? 0,
      defaultAppVersion: json['DefaultAppVersion'] ?? '',
      allotedOn: json['AllotedOn'] != null
          ? DateTime.parse(json['AllotedOn'])
          : DateTime(0000, 00, 00), // Fake date when null
      isActive: json['IsActive'] ?? false,
      isBlock: json['IsBlock'] ?? false,
      deviceId1: json['DeviceId1'] ?? '',
      configuration: json['Configuration'] ?? '',
      osVersion: json['OSVersion'] ?? '',
      isLaptop: json['IsLaptop'] ?? false,
      isTabletIpad: json['IsTabletIpad'] ?? false,
      isDeleted: json['IsDeleted'] ?? false,
      activationKeyId: json['ActivationKeyId'] ?? 0,
      isLoggedIn: json['IsLoggedIn'] ?? false,
      logoutTime: json['LogoutTime'] != null
          ? DateTime.parse(json['LogoutTime'])
          : DateTime(0000, 00, 00), // Fake date when null
      deviceName: json['DeviceName'] == null || json['DeviceName'].isEmpty
          ? 'Unknown Device'
          : json['DeviceName'],
    );
  }
}
