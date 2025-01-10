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

      // String motherboardModel = await getMotherboardModel();
      // String Processor = await getProcessorInfo();
      // String harddiskSlNo = await getHardDiskSerialNumber();
      bool isLaptop = await getBatteryInfo();
      // print("$harddiskSlNo");

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
      // onDeviceError(context, e.toString());

      return {};
    }
  }

  static bool? isBattery;

  static Future<bool> getBatteryInfo() async {
    final battery = Battery();

    try {
      final batteryLevel = await battery.batteryLevel;
      final batteryState = await battery.onBatteryStateChanged.first;
      print('Battery Level: $batteryLevel%');
      print('Battery State: $batteryState');
      return true;
    } catch (e) {
      writeToFile(e, 'getBatteryInfo');
      print("Bettery not Exit");
      return false;
    }
  }

  static Future<Map<String, dynamic>> androidInfo(BuildContext context) async {
    try {
      DeviceInfoPlugin android = DeviceInfoPlugin();
      List<dynamic> information = [];
      String? advertisingId;

      String? typeKind;

      try {
        advertisingId = await AdvertisingId.id(true);
      } on PlatformException {
        advertisingId = null;
      }

      var info = await android.androidInfo;
      bool istablet = (MediaQuery.of(context).size.shortestSide >= 600);
      typeKind = istablet ? 'Tablet' : 'Mobile';

      return {
        'DeviceId1': advertisingId,
        'DeviceId2': info.id,
        'DeviceType': Platform.operatingSystem,
        'OsVersion': Platform.operatingSystemVersion,
        'DeviceName': info.manufacturer,
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

  // static Future<String> getMotherboardModel() async {
  //   ProcessResult result = await Process.run(
  //     'wmic',
  //     ['baseboard', 'get', 'product'],
  //   );
  //   return result.stdout.toString().split('\n')[1].trim();
  // }

  // static Future<String> getProcessorInfo() async {
  //   ProcessResult result = await Process.run(
  //     'wmic',
  //     ['cpu', 'get', 'name'],
  //   );
  //   return result.stdout.toString().split('\n')[1].trim();
  // }

  // static Future<String> getHardDiskSerialNumber() async {
  //   ProcessResult result = await Process.run(
  //     'wmic',
  //     ['diskdrive', 'get', 'serialnumber'],
  //   );
  //   return result.stdout.toString().split('\n')[1].trim();
  // }

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
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
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
