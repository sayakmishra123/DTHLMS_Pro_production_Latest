// ignore_for_file: avoid_print

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';


class ClsSimInfo {
  Future printSimCardsData(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator.adaptive());
          });
      Getx get = Get.put(Getx());
      get.simCardinfo.clear();
      var status = await Permission.phone.status;
      if (!status.isGranted) {
        status = await Permission.phone.request();
      }
      SimNumber.listenPhonePermission((isPermissionGranted) async {
        if (kDebugMode) {
          print("isPermissionGranted : $isPermissionGranted");
        }
        if (isPermissionGranted) {
          SimInfo simInfo = await SimNumber.getSimData();

          for (var s in simInfo.cards) {
            get.simCardinfo.add(s);
            print(get.simCardinfo);
            print('Serial number: ${s.slotIndex} ${s.phoneNumber}');
          }
          Get.back();
          return simInfo.cards;
        } else {
          Get.back();
          return [];
        }
      });
    } on Exception catch (e) {
      Get.back();
      print("error! code: $e - message: $e");
      return e;
    }
  }
}
