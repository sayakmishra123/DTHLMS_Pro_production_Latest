import 'dart:developer';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../THEME_DATA/color/color.dart';

class ClsDeviceInfo {
  static Future<Map<String, dynamic>> windowsInfo(BuildContext context) async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      bool isLaptop = await getBatteryInfo();

      return {
        'DeviceId1': windowsInfo.deviceId +
            windowsInfo.data[0].hashCode.toString() +
            windowsInfo.buildNumber.toString() +
            windowsInfo.csdVersion,
        'DeviceId2': windowsInfo.deviceId.toString() +
            windowsInfo.buildNumber.toString(),
        'DeviceType': "windows",
        'OsVersion': windowsInfo.productName,
        'DeviceName': windowsInfo.computerName.toString(),
        'IsLaptop': isLaptop ? "1" : "0",
        'AppVersion': "1.0.1",
        'AppType': 'Player',
        "DeviceConfiguration": "0",
      };
    } catch (e) {
      writeToFile(e, 'windowsInfo');
      return {};
    }
  }

  static Future<bool> getBatteryInfo() async {
    final battery = Battery();
    try {
      await battery.batteryLevel;
      await battery.onBatteryStateChanged.first;
      return true;
    } catch (e) {
      writeToFile(e, 'getBatteryInfo');
      return false;
    }
  }

  static Future<Map<String, dynamic>> androidInfo(BuildContext context) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String? advertisingId = await AdvertisingId.id(true);
      bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
      return {
        'DeviceId1': advertisingId,
        'DeviceId2': androidInfo.id,
        'DeviceType': "android",
        'OsVersion': androidInfo.version.release,
        'DeviceName': androidInfo.manufacturer,
        'IsLaptop': "0",
        'AppVersion': "1.0.1",
        'AppType': 'Player',
        "DeviceConfiguration": "0",
      };
    } catch (e) {
      writeToFile(e, 'androidInfo');
      return {};
    }
  }

  static Future<Map<String, dynamic>> macOsInfo() async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
      return {
        'DeviceId1': macInfo.systemGUID,
        'DeviceId2': macInfo.model,
        'DeviceType': "macos",
        'OsVersion': macInfo.osRelease,
'DeviceName': macInfo.computerName
    .replaceAll(RegExp(r"'s"), '')
    .replaceAll(RegExp(r"’s"), ''),
        'IsLaptop': "1",
        'AppVersion': "1.0.1",
        'AppType': 'Player',
        "DeviceConfiguration": "0",
      };
    } catch (e) {
      writeToFile(e, 'macOsInfo');
      return {};
    }
  }

  static Future<Map<String, dynamic>> iosInfo() async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return {
        'DeviceId1': iosInfo.identifierForVendor,
        'DeviceId2': iosInfo.name,
        'DeviceType': "ios",
        'OsVersion': iosInfo.systemVersion,
        'DeviceName': iosInfo.utsname.machine,
        'IsLaptop': "0",
        'AppVersion': "1.0.1",
        'AppType': 'Player',
        "DeviceConfiguration": "0",
      };
    } catch (e) {
      writeToFile(e, 'iosInfo');
      return {};
    }
  }

  static onDeviceError(context, String title) {
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Device Information",
      desc: title,
      buttons: [
        DialogButton(
          child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.blue,
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromARGB(255, 207, 43, 43),
        ),
      ],
    ).show();
  }
}
