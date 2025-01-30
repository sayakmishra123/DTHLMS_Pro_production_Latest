import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/ERROR_MASSEGE/errorhandling.dart';
import 'package:dthlms/API/MAP_DATA/apiobject.dart';
import 'package:dthlms/API/url/api_url.dart';
import 'package:dthlms/DEVICE_INFORMATION/device_info.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/GLOBAL_WIDGET/loader.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MODEL_CLASS/login_model.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/project_setup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future loginApi(
  BuildContext context,
  String loginemail,
  String password,
  String otp,
) async {
  var logindata;
  final getObj = Get.put(Getx());
  try {
    loader(context);
    createtblSession();
    var deviceinfo;

    if (Platform.isAndroid) {
      deviceinfo = await ClsDeviceInfo.androidInfo(context);
    } else if (Platform.isWindows) {
      deviceinfo = await ClsDeviceInfo.windowsInfo(context);
    } else if (Platform.isIOS) {
      deviceinfo = await ClsDeviceInfo.iosInfo();
    } else if (Platform.isMacOS) {
      deviceinfo = await ClsDeviceInfo.macOsInfo();
    }

    if (Platform.isIOS) {
      logindata = ClsMap().objLoginApi(loginemail, password, otp);
    } else if (Platform.isMacOS) {
      logindata = ClsMap().objLoginApi(loginemail, password, otp);
    }

    final res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.loginEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'DeviceInfo': jsonEncode(deviceinfo),
        'Origin': origin,
      },
      body: json.encode(logindata),
    );
    var jsondata = json.decode(res.body);
    // print(jsondata);

    if (jsondata['isSuccess'] == true) {
      final jwt = JWT.decode(jsondata['result']['token']);

      Map<String, dynamic> userData =
          await getUserImage(context, jsondata['result']['token']);

      final jwtMap = jwt.payload;
      getObj.loginuserdata.clear();

      ///
      // etObj.token.value = jsondata['result']['token'];g
      log(jsondata['result']['token']);
      final userdata = DthloginUserDetails(
          firstName: jwtMap['FirstName'],
          lastName: jwtMap['LastName'],
          email: jsondata['result']['email'],
          phoneNumber: jsondata['result']['phoneNumber'],
          token: jsondata['result']['token'],
          nameId: jwtMap['nameid'],
          password: password,
          loginTime: jwtMap['iat'].toString(),
          image: userData['ImageUrl'],
          loginId: loginemail,
          imageDocumnetId: userData['ProfileImageDocumentId'].toString(),
          username: userData['UserName'],
          franchiseeId: jwtMap['FranchiseId']);
      getObj.loginuserdata.add(userdata);

      String userdataJson = jsonEncode(userdata.toJson());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogin", true);
      await prefs.setString('userDetails', userdataJson);



      deletetblpackage();
      createtblPackageDetails();

      createMCQAnswer();
      createTheorySet();
      createTheoryPaper();
      createMCQOption();
      createMCQPSection();
      createMCQPaper();
      createMCQSet();
      createMCQQuestion();
      createtblMCQhistory();
      createUserMCQResult();
      createUserResultDetails();

      createTblPackageData();
      createTblVideoComponents();
      creatTablePackageFolderDetails();
      createTblLocalNavigation();
      createDownloadFileData();
      createDownloadFileDataOfVideo();

      getx.calenderEvents.clear();

      deleteAllFolders();
      deleteAllPackage();
      deleteVideoComponents();

      getPackageData(context, jsondata['result']['token']);
      getAllFolders(context, jsondata['result']['token'], "");
      getAllFiles(context, jsondata['result']['token'], "");
      getVideoComponents(context, jsondata['result']['token'], "");
      getMCQExamHistory(context, jsondata['result']['token']);
      getVideowatchHistory(context, jsondata['result']['token']);
      getMCQhistoryResult(context, jsondata['result']['token']);
      getEncryptionKey(jsondata['result']['token'], context);

      deleteSessionDetails();
      insertTblSession(
        loginemail,
        password,
        jsondata['result']['token'],
        jwtMap['iat'].toString(),
        jwtMap['FirstName'] + jwtMap['LastName'],
        jwtMap['email'],
        jwtMap['Mobile'].toString(),
        "studentImage",
        jwtMap['nameid'],
      );

      Get.back();

      // Navigate after all functions are executed
      Platform.isMacOS
          ?
          // ? Get.offAll(() => LastLoadScreen())
          Get.offAllNamed('/Homepage')
          : Get.offAllNamed("/Mobilehompage");
    } else {
      Get.back();
      deleteSessionDetails();
      insertTblSession(
        loginemail,
        password,
        "Null",
        "Null",
        "Null",
        "Null",
        "Null",
        "Null",
        "Null",
      );
      ClsErrorMsg.fnErrorDialog(
          context,
          'Login',
          jsondata['errorMessages']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          res);
    }
  } catch (e) {
    Get.back();
    writeToFile(e, 'loginApi');
    ClsErrorMsg.fnErrorDialog(context, 'Login error',
'Error', e);
  }
}

Future signupApi(
  BuildContext context,
  String signupuser,
  String signupfirstname,
  String signuplastname,
  signupemail,
  signuppassword,
  signupphno,
  signupwaphno,
  key,
  emailotp,
  String phoneNumberCode,
  String activationkey,
  String phonenumbercountryid,
  String whatsappnumbercountryid,
  String whatsappnumbercode,
) async {
  // print(ClsUrlApi.signupEndpoint);
  try {
    loader(context);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var deviceinfo;
    if (Platform.isAndroid) {
      deviceinfo = await ClsDeviceInfo.androidInfo(context);
    } else if (Platform.isWindows) {
      deviceinfo = await ClsDeviceInfo.windowsInfo(context);
    } else if (Platform.isIOS) {
      deviceinfo = ClsDeviceInfo.iosInfo();
    } else if (Platform.isMacOS) {
      deviceinfo = await ClsDeviceInfo.macOsInfo();
    }

    log(deviceinfo.toString());

    var signupdata = ClsMap().objSignupApi(
        signupuser,
        signupfirstname,
        signuplastname,
        signupemail,
        signuppassword,
        signupphno,
        signupwaphno,
        key,
        emailotp,
        phoneNumberCode,
        packageInfo.packageName,
        activationkey,
        phonenumbercountryid,
        whatsappnumbercountryid,
        whatsappnumbercode);

    // log(signupdata.toString());
    final http.Response res = await http.post(
        Uri.https(ClsUrlApi.mainurl, '${ClsUrlApi.signupEndpoint}$key'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'DeviceInfo': jsonEncode(deviceinfo),
          'Origin': origin
        },
        body: jsonEncode(signupdata));
    var jsondata = json.decode(res.body);
    log(res.body.toString());

    if (jsondata['isSuccess'] == true) {
      Get.back();
      await FlutterPlatformAlert.playAlertSound();

      final result = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: 'Login',
        text: 'Registration Sucessfull',
        positiveButtonTitle: "Ok",
      );
      if (result == "Ok") {
        Get.to(transition: Transition.cupertino, () => const DthLmsLogin());
      }

      // ArtDialogResponse response = ArtSweetAlert.show(
      //     context: context,
      //     artDialogArgs: ArtDialogArgs(
      //         type: ArtSweetAlertType.success,
      //         title: "Registration Successful"));
      // Getx getxController = Get.put(Getx());
      // if (response.isTapConfirmButton) {
      //   getxController.show.value = false;
      //   Get.to(transition: Transition.cupertino, () => const DthLmsLogin());
      // } else {
      //   print(res.statusCode);
      // }
      Get.to(transition: Transition.cupertino, () => const DthLmsLogin());
    } else {
      Get.back();
      ClsErrorMsg.fnErrorDialog(
          context,
          "Signup",
          jsondata['errorMessages']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          jsondata['errorMessages']);
    }
  } catch (e) {
    writeToFile(e, 'signupApi');
    Get.back();
    ClsErrorMsg.fnErrorDialog(context, 'Signup error',
        'Error', e);
  }
}

Future signupcodegenerate(
  String signupphnocountryId,
  String signupphno,
  String signupemail,
  String activationKey,
  String whatsAppNumberCountryId,
  String signupwaphno,
  BuildContext context,
) async {
  Getx getObj = Get.put(Getx());
  loader(context);
  try {
    var response = await http.get(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getUserConfirmationTypeEndpoint),
        headers: <String, String>{
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Origin': origin
        });

    var json = jsonDecode(response.body);

    var key = json['result']['key'];
    handleConfirmationResponse(key);
    getObj.signUpMSG.value = handleResponse(key);

    if (json['isSuccess'] == true) {
      var datacode;
      switch (key) {
        case 1:
        case 2:
        case 3:
        case 4:
          datacode = ClsMap().objgenerateSRCode(
              signupphnocountryId, signupphno, signupemail, activationKey);
          break;
        case 5:
        case 6:
        case 7:
          datacode = ClsMap().objgenerateSRCode(whatsAppNumberCountryId,
              signupwaphno, signupemail, activationKey);
          break;
        default:
          throw Exception('Unhandled key type');
      }

      var responsecode = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.generateSRCode),
        headers: <String, String>{
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Origin': origin
        },
        body: jsonEncode(datacode),
      );

      var json = jsonDecode(responsecode.body);
      Get.back(); // Dismiss loader here after the post response

      if (json['isSuccess'] == true) {
        String key = json['result'];
        getObj.otplineshow.value = true;
        return key;
      } else {
        // print(datacode);
        ClsErrorMsg.fnErrorDialog(
            context,
            'Sign up',
            json['errorMessages']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", ""),
            responsecode);
        return 'error';
      }
    } else {
      Get.back(); // Dismiss loader on failed GET response
      ClsErrorMsg.fnErrorDialog(
          context,
          'Sign up',
          json['errorMessages']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          response);
      return 'error';
    }
  } catch (e) {
    writeToFile(e, 'signupcodegenerate');
    Get.back(); // Dismiss loader in case of exceptions
    ClsErrorMsg.fnErrorDialog(context, "", e.toString(), e.toString());
    return 'error';
  }
}

String handleResponse(int responseCode) {
  String message;

  switch (responseCode) {
    case 1:
      message =
          "Yay! Your phone number has been confirmed successfully. 😊\nAn has been sent to your phone number.";
      break;
    case 2:
      message =
          "Great! Your email address has been confirmed. 🎉\nAn OTP has been sent to your email address.";
      break;
    case 3:
      message =
          "Awesome! Both your phone number and email are confirmed. You're all set! 🌟\nAn OTP has been sent to both your phone number and email.";
      break;
    case 4:
      message =
          "Good job! Either your phone number or email has been confirmed. 👍\nAn OTP has been sent to the corresponding device.";
      break;
    case 5:
      message =
          "Fantastic! Your WhatsApp number has been confirmed. Stay connected! 💬\nAn OTP has been sent to your WhatsApp number.";
      break;
    case 6:
      message =
          "Wonderful! Both your WhatsApp number and email are confirmed. You're all set to go! 🚀\nAn OTP has been sent to both your WhatsApp number and email.";
      break;
    case 7:
      message =
          "You're almost there! Either your WhatsApp number or email has been confirmed. Keep it up! 🌈\nAn OTP has been sent to the corresponding device.";
      break;
    default:
      message = "Oops! Something went wrong. Please try again. 🤔";
  }

  // Display the message to the user

  // Optionally return the message for further use
  return message;
}

// Example usage

void handleConfirmationResponse(int response) {
  Getx getObj = Get.put(Getx());

  // Set flags based on the response
  switch (response) {
    case 1: // Phone number confirmed
      getObj.isPhoneOtpRequired.value = true;
      getObj.isWhatsAppOtpRequired.value = false;
      getObj.isEmailOtpRequired.value = false;
      // getObj.isFieldValueOr.value =false;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;

      break;
    case 2: // Email confirmed
      getObj.isEmailOtpRequired.value = true;
      getObj.isPhoneOtpRequired.value = false;
      getObj.isWhatsAppOtpRequired.value = false;
      // getObj.isFieldValueOr.value =false;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;

      break;
    case 3: // Both phone number and email confirmed
      getObj.isPhoneOtpRequired.value = true;
      getObj.isEmailOtpRequired.value = true;

      getObj.isWhatsAppOtpRequired.value = false;

      // getObj.isFieldValueOr.value =false;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;

      break;
    case 4: // Either phone number or email confirmed
      getObj.isPhoneOtpRequired.value = true;
      getObj.isEmailOtpRequired.value = true;
      getObj.isWhatsAppOtpRequired.value = false;
      // getObj.isFieldValueOr.value =true;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = true;
      break;
    case 5: // WhatsApp confirmed
      getObj.isWhatsAppOtpRequired.value = true;
      getObj.isPhoneOtpRequired.value = false;
      getObj.isEmailOtpRequired.value = false;
      // getObj.isFieldValueOr.value =false;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;
      break;
    case 6: // WhatsApp and email confirmed
      getObj.isWhatsAppOtpRequired.value = true;
      getObj.isEmailOtpRequired.value = true;
      getObj.isPhoneOtpRequired.value = false;
      // getObj.isFieldValueOr.value =false;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;
      break;
    case 7: // Either WhatsApp or email confirmed
      getObj.isWhatsAppOtpRequired.value = true;
      getObj.isEmailOtpRequired.value = true;
      getObj.isPhoneOtpRequired.value = false;
      // getObj.isFieldValueOr.value =true;
      getObj.isWhatsAppOrRequired.value = true;
      getObj.isPhoneNumberOrRequired.value = false;

      break;
    default:
      getObj.isWhatsAppOtpRequired.value = false;
      getObj.isEmailOtpRequired.value = false;
      getObj.isPhoneOtpRequired.value = false;
      // getObj.isFieldValueOr.value =true;
      getObj.isWhatsAppOrRequired.value = false;
      getObj.isPhoneNumberOrRequired.value = false;
      break;
  }
}

Future<void> backgroundlistApi(String token) async {
  Map<String, dynamic> data = {
    "tblBlackWhiteList": {"OsType": 'Windows'},
  };

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.backgroundapplicationList),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Origin': origin
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      var responseData = jsonDecode(res.body);

      if (responseData['isSuccess'] == true && responseData['result'] != null) {
        String resultString = responseData['result'];
        List<dynamic> parsedResult = jsonDecode(resultString);

        if (parsedResult.isNotEmpty) {
          final List<dynamic> whiteList = parsedResult[0]['WhiteList'];
          final List<dynamic> blackList = parsedResult[0]['BlackList'];

          await insertWhiteList(
              whiteList.map((app) => app as Map<String, dynamic>).toList());
          await insertBlackList(
              blackList.map((app) => app as Map<String, dynamic>).toList());
        } else {
          // print('No whitelist entries found.');
        }
      } else {
        // print('Failed to get a successful response.');
      }
    } else {
      // print('Failed to fetch data: ${res.statusCode}, ${res.body}');
    }
  } catch (e) {
    writeToFile(e, 'backgroundlistApi');
    // print('An error occurred: $e');
  }
}

List<String> apps = [];

// Function to write the app list to a .dmj file
Future<void> writeAppsToDMJFile(List<String> apps) async {
  try {
    // Specify the path where the file will be saved
    final directory = await Directory.current;
    final filePath = '${directory.path}/background_apps.dmj';

    // Create the file
    final file = File(filePath);

    // Write the app list to the file as JSON format
    await file.writeAsString(jsonEncode(apps));

    // Log the file path and contents
    // log("DMJ file created at: $filePath");
    // log("File contents: ${await file.readAsString()}");
  } catch (e) {
    writeToFile(e, 'writeAppsToDMJFile');
    // print("Failed to write to .dmj file: $e");
  }
}

class App {
  final int appId;
  final String appBaseName;
  final String applicationFullName;
  final bool isBlock;
  final bool isKill;
  final int franchiseId;
  final String osType;
  final String createdOn;
  final String createdBy;

  App({
    required this.appId,
    required this.appBaseName,
    required this.applicationFullName,
    required this.isBlock,
    required this.isKill,
    required this.franchiseId,
    required this.osType,
    required this.createdOn,
    required this.createdBy,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      appId: json['AppId'],
      appBaseName: json['AppBaseName'],
      applicationFullName: json['ApplicationFullName'],
      isBlock: json['IsBlock'],
      isKill: json['IsKill'],
      franchiseId: json['FranchiseId'],
      osType: json['OsType'],
      createdOn: json['CreatedOn'],
      createdBy: json['CreatedBy'],
    );
  }
}

Future<void> getRunningBackgroundAppsAndKill(BuildContext context) async {
  try {
    getx.blackListProcess.value = await fetchBlackList();
    getx.whiteListProcess.value = await fetchWhiteList();

    // log("bcakground process running");

    final List<String> blacklist = getx.blackListProcess
        .map((item) => item['ApplicationBaseName'].toString().toLowerCase())
        .toList();

    final List<String> whitelist = getx.whiteListProcess
        .map((item) => item['ApplicationBaseName'].toString().toLowerCase())
        .toList();

    // Run the PowerShell command to get unique running processes
    final result = await Process.run('powershell', [
      '-Command',
      'Get-Process | Select-Object -Unique Name | Format-Table Name'
    ]);

    if (result.exitCode == 0) {
      // Parse the output and filter non-empty app names
      final apps = result.stdout
          .toString()
          .split('\n')
          .where((line) =>
              line.isNotEmpty &&
              !line.startsWith('Name') &&
              !line.startsWith('----'))
          .map((line) => line.trim())
          .toList();

      List<String> unlistedApps = [];

      for (final app in apps) {
        final appName = app.replaceAll(".exe", "");
        // log(appName);

        if (whitelist.contains(appName.toLowerCase())) {
          // log("Ignoring process: ${appName.toLowerCase()} (in whitelist)");
          continue;
        }

        if (blacklist.contains(appName.toLowerCase())) {
          //  log("Ignoring process: ${appName.toLowerCase()} (in blacklist)");
          try {
            final killResult =
                await Process.run('taskkill', ['/F', '/IM', '$app.exe']);
            if (killResult.exitCode == 0) {
              // log("Successfully killed process: $app.");
            } else {}
          } catch (e) {
            writeToFile(e, "failsed to kill process");
          }
        } else {
          // Add to the list of unlisted apps
          if (!unlistedApps.contains(appName)) {
            unlistedApps.add(appName);
          }
        }
      }

      if (unlistedApps.isNotEmpty) {
        // log(unlistedApps.toString());
      }

      // Write the list of apps to a .dmj file
      await writeAppsToDMJFile(apps);
    } else {}
  } catch (e) {
    writeToFile(e, 'getRunningBackgroundAppsAndKill');
  }
}
