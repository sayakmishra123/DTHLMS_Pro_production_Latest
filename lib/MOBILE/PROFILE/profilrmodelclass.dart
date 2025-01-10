// class DeviceLoginHistoryDetails {
//   final int userDevicesId;
//   final String userId;
//   final String deviceType;
//   final int franchiseId;
//   final String defaultAppVersion;
//   final DateTime allotedOn;
//   final bool isActive;
//   final bool isBlock;
//   final String deviceId1;
//   final String configuration;
//   final String osVersion;
//   final bool isLaptop;
//   final bool isTabletIpad;
//   final bool isDeleted;
//   final int activationKeyId;
//   final bool isLoggedIn;
//   final DateTime logoutTime;
//   final String deviceName;

//   DeviceLoginHistoryDetails({
//     required this.userDevicesId,
//     required this.userId,
//     required this.deviceType,
//     required this.franchiseId,
//     required this.defaultAppVersion,
//     required this.allotedOn,
//     required this.isActive,
//     required this.isBlock,
//     required this.deviceId1,
//     required this.configuration,
//     required this.osVersion,
//     required this.isLaptop,
//     required this.isTabletIpad,
//     required this.isDeleted,
//     required this.activationKeyId,
//     required this.isLoggedIn,
//     required this.logoutTime,
//     required this.deviceName,
//   });

//   // Factory method to create a DeviceLoginHistory from JSON
//   factory DeviceLoginHistoryDetails.fromJson(Map<String, dynamic> json) {
//     return DeviceLoginHistoryDetails(
//       userDevicesId: json['UserDevicesID'],
//       userId: json['UserId'],
//       deviceType: json['DeviceType'],
//       franchiseId: json['FranchiseId'],
//       defaultAppVersion: json['DefaultAppVersion'],
//       allotedOn: DateTime.parse(json['AllotedOn']),
//       isActive: json['IsActive'],
//       isBlock: json['IsBlock'],
//       deviceId1: json['DeviceId1'],
//       configuration: json['Configuration'],
//       osVersion: json['OSVersion'],
//       isLaptop: json['IsLaptop'],
//       isTabletIpad: json['IsTabletIpad'],
//       isDeleted: json['IsDeleted'],
//       activationKeyId: json['ActivationKeyId'],
//       isLoggedIn: json['IsLoggedIn'],
//       logoutTime: DateTime.parse(json['LogoutTime']),
//       deviceName: json['DeviceName'],
//     );
//   }
// }
