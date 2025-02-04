import 'dart:async';
import 'dart:convert';
// import 'dart:core';
import 'dart:developer';
// import 'dart:ffi';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ERROR_MASSEGE/errorhandling.dart';
import 'package:dthlms/API/MAP_DATA/apiobject.dart';
import 'package:dthlms/API/url/api_url.dart';
import 'package:dthlms/DEVICE_INFORMATION/device_info.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/GLOBAL_WIDGET/loader.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/Live/url.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart'
    as modelclass;
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
// import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
// import 'package:dthlms/MODEL_CLASS/Icon_model.dart';
// import 'package:dthlms/MOBILE/PROFILE/profilrmodelclass.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/MODEL_CLASS/allPackageDetails.dart';
import 'package:dthlms/MODEL_CLASS/folderdetails.dart';
import 'package:dthlms/MODEL_CLASS/infinite_marquee_model.dart';
import 'package:dthlms/MODEL_CLASS/packageData.dart';
import 'package:dthlms/MODEL_CLASS/profileDetails.dart';
import 'package:dthlms/MODEL_CLASS/social_media_links_model.dart';
import 'package:dthlms/MODEL_CLASS/videoComponents.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
// import 'package:dthlms/GLOBAL_WIDGET/confirmActivationCode.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart' as pinfo;
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:html/parser.dart';
import '../../GLOBAL_WIDGET/confirmActivationCode.dart';

Getx getx = Get.put(Getx());

Future forgetPassword(BuildContext context, String signupemail, String key,
    String otpcode) async {
  try {
    loader(context);

    Map body = ClsMap().objforgetPassword(signupemail, otpcode);
    final client = HttpClient();

    final request = await client.postUrl(
        Uri.https(ClsUrlApi.mainurl, '${ClsUrlApi.forgetpassword}$key'));
    request.followRedirects = false;
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set('Origin', origin);

    final jsondata = jsonEncode(body);
    request.add(utf8.encode(jsondata));
    final response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var json = jsonDecode(responseBody);

    if (json['isSuccess'] == true && json['statusCode'] == 303) {
      Get.back();
      getx.forgetpageshow.value = true;
      return {
        "phone": json['result']['phoneNumber'],
        "email": json['result']['email'],
        "token": json['result']['token']
      };
      // return json['result']['token'];
    } else {
      getx.forgetpageshow.value = false;
      Get.back();
      ClsErrorMsg.fnErrorDialog(
        context,
        'Forget Password',
        json['errorMessages']
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        responseBody.toString().replaceAll("[", "").replaceAll("]", ""),
      );
    }
  } catch (e) {
    writeToFile(e, 'forgetPassword');
    getx.forgetpageshow.value = false;
    Get.back();
    ClsErrorMsg.fnErrorDialog(context, 'Forget Password',
        e.toString().replaceAll("[", "").replaceAll("]", ""), e);
  }
}

Future resetPassword(BuildContext context, String email, String ph, String pass,
    String confirmpass, String code) async {
  try {
    loader(context);
    Map body = ClsMap().objresetPassword(email, ph, pass, confirmpass);

    final client = HttpClient();
    final request = await client.postUrl(
        Uri.https(ClsUrlApi.mainurl, '${ClsUrlApi.resetPassword}$code'));
    request.followRedirects = false;
    request.headers.set('Origin', origin);

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/json',
    );

    final jsondata = jsonEncode(body);
    request.add(utf8.encode(jsondata));
    final response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    var json = jsonDecode(responseBody);

    if (json['statusCode'] == 200 && json['isSuccess'] == true) {
      Get.back();

      ClsErrorMsg.fnErrorDialog(context, 'Password reset',
          'Password reset successfully', responseBody);
      Get.to(transition: Transition.cupertino, () => DthLmsLogin());
    } else {
      Get.back();
      ClsErrorMsg.fnErrorDialog(
          context,
          'Password reset error',
          json['errorMessages']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          responseBody);
    }
  } catch (e) {
    writeToFile(e, 'resetPassword');
    ClsErrorMsg.fnErrorDialog(context, 'Forget Password',
        e.toString().replaceAll("[", "").replaceAll("]", ""), "");
  }
}

Future studentWatchtime(BuildContext context) async {
  try {
    loader(context);

    Map body = ClsMap().objStudentWatchTime(1, 300, 5);
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.generateCodeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode(body));
    var jsondata = jsonDecode(res.body);

    Get.back();
    if (jsondata['statusCode'] == 200 && jsondata['isSuccess'] == true) {
      return jsondata['result'].toString();
    } else {
      return 'kmlfmkzmfkdk';
    }
  } catch (e) {
    writeToFile(e, 'studentWatchtime');
    return 'kmlfmkzmfkdk';
  }
}

Future packactivationKey(
    BuildContext context, packageactivationkey, token) async {
  loader(context);
  Map data = {
    "tblActivationKeys": {"ActivationKey": packageactivationkey.toString()}
  };

  try {
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.studentActivationkey),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
        body: jsonEncode(data));
    // // print(res.body);
    if (res.statusCode == 201) {
      deleteAllFolders();
      deleteAllPackage();
      deleteVideoComponents();
      getPackageData(context, token);
      getAllFolders(context, token, "");
      getAllFiles(context, token, "");
      getAllFreeFiles(context, token, "");
      getVideoComponents(context, token, "");

      deleteSessionDetails();

      await confirmActivationCode(context, 'Package activated', true);
      Get.back();

      Platform.isAndroid
          ? Get.offAll(() => HomePageMobile())
          : Get.offAll(() => DthDashboard());
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else if (res.statusCode == 400) {
      Get.back();

      await confirmActivationCode(context, 'Package activation failed', false);
    } else {
      Get.back();
      await confirmActivationCode(context, 'Package activation failed', false);
    }
  } catch (e) {
    writeToFile(e, 'packactivationKey');
    Get.back();

    await confirmActivationCode(
        context, 'Package activation failed- error', false);
  }
}

Future<void> getMeetingList(BuildContext context) async {
  Map<String, dynamic> data = {};
  // prnt("calling live methdo");
  try {
    // Sending the POST request
    var res = await http.post(
      Uri.https(
        ClsUrlApi.mainurl,
        ClsUrlApi.getMeeting,
      ),
      headers: {
        'Authorization': 'Bearer ${getx.loginuserdata[0].token}',
        'Content-Type': 'application/json',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    // Checking if the request was successful
    if (res.statusCode == 200) {
      // Parsing the response body
      Map<String, dynamic> parsedResponse = jsonDecode(res.body);

      // Checking if the response indicates success
      if (parsedResponse['isSuccess']) {
        // Parsing the result field, which is a stringified JSON array
        List<dynamic> resultList = jsonDecode(parsedResponse['result']);
        getx.upcomingmeeting.clear();
        getx.todaymeeting.clear();
        getx.pastmeeting.clear();

        // Separating the meetings into Past, Today, and Upcoming
        for (var meetingJson in resultList) {
          MeetingDeatils meeting = MeetingDeatils.fromJson(meetingJson);
          String programStatus = meeting.programStatus;

          if (programStatus == 'Past') {
            getx.pastmeeting.add(meeting);
          } else if (programStatus == 'Today') {
            getx.todaymeeting.add(meeting);
          } else if (programStatus == 'Upcoming') {
            getx.upcomingmeeting.add(meeting);
          }
        }

        // Combine all lists into a single list if needed

        // // printing the categorized meetings
      } else {}
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {}
  } catch (e) {
    writeToFile(e, 'getMeetingList');
  }
}

Future<String> getEncryptionKey(String token, BuildContext context) async {
  Map data = {};
  // Show a loading indicator
  // showDialog(
  //   context: context,
  //   builder: (context) => const Center(child: CircularProgressIndicator()),
  // );

  try {
    final res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getEncryptionKey),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(data),
    );

    var jsondata = json.decode(res.body);

    if (res.statusCode == 200 && jsondata['isSuccess'] == true) {
      // Decode the response body to a map
      Map<String, dynamic> jsonMap = jsonDecode(res.body);

      // Decode the 'result' string into a JSON map
      Map<String, dynamic> result = jsonDecode(jsonMap['result']);

      // Extract the encryption key
      String encryptionKey = result['PDfEncryptionKey'] ?? "";
      String secretKey = result['EncryptionSecretKey'] ?? "";
      String franchiseName = result['FranchiseName'] ?? "";
      String onesignalId = result['OneSignalId'] ?? "";
      print('PDF Encryption Key: $encryptionKey');

      print('PDF secret key Key: $secretKey');
      print('PDF secret key Key: $franchiseName');
      print('onesignalId id  Key: $onesignalId');

      deleteDataFromTblSettings();
      insertTblSetting("OldSKey", secretKey);
      insertTblSetting("EncryptionKey", encryptionKey);
      insertTblSetting("FranchiseName", franchiseName);
      insertTblSetting("Origin", origin);
      insertTblSetting("OneSignalId", onesignalId);

      // Return the encryption key
      return encryptionKey;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return 'null';
    } else {
      return 'null';
      // _showErrorDialog(context, jsondata['errorMessages'][0]);
    }
  } catch (error) {
    writeToFile(error, 'getEncryptionKey');
    // print('Error2: $error');
    return 'null';
  }
}

Future getAllFolders(BuildContext context, token, String packageId) async {
  // loader(context);
  Map data = packageId == "" ? {} : {"PackageId": packageId};

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getFolderData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);
      if (responseBody['isSuccess'] == true) {
        // Decode the result, which is a JSON string
        if (jsonDecode(responseBody['result']) != null) {
          List<dynamic> resultData = jsonDecode(responseBody['result']);
          resultData.forEach((folder) {
            FolderDetails folderdata = FolderDetails(
                packageId: folder['PackageId'],
                parentSectionChapterId: folder['ParentSectionChapterId'],
                sectionChapterId: folder['SectionChapterId'],
                sectionChapterName: folder['SectionChapterName'],
                startParentId: folder['StartParentId']);

            insertFolderDetailsdata(
                folder['SectionChapterId'].toString(),
                folder['SectionChapterName'],
                folder['ParentSectionChapterId'].toString(),
                folder['PackageId'].toString(),
                folder['StartParentId'].toString());

            getx.folderDetailsdata.add(folderdata);
          });
          readFolderDetailsdata();
        }
      }
      // Get.back();
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // Get.back();
    }
  } catch (r) {
    writeToFile(r, 'getAllFolders');
    // print("error:$r folder");
  }
}

Future getAllFiles(BuildContext context, token, String packageId) async {
  // loader(context);
  Map data = packageId == "" ? {} : {'PackageId': packageId};

  try {
    var res =
        await http.post(Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getFileData),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'Origin': origin,
            },
            body: jsonEncode(data));

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);

      // log(responseBody['result'].toString());

      List<AllPackageDetails> resultData =
          AllPackageDetails.fromJsonList(responseBody['result']);

      resultData.forEach((file) async {
        AllPackageDetails details = AllPackageDetails(
            packageId: file.packageId,
            packageName: file.packageName,
            fileIdType: file.fileIdType,
            fileId: file.fileId,
            fileIdName: file.fileIdName,
            chapterId: file.chapterId,
            allowDuration: file.allowDuration,
            consumeDuration: file.consumeDuration,
            allowNo: file.allowNo,
            consumeNos: file.consumeNos,
            documentPath: file.documentPath,
            scheduleOn: file.scheduleOn,
            sessionId: file.sessionId,
            videoDuration: file.videoDuration,
            DownloadedPath: "0",
            isEncrypted: file.isEncrypted,
            sortedOrder: file.sortedOrder);
        await insertPackageDetailsdata(
                file.packageId.toString(),
                file.packageName ?? '',
                file.fileIdType ?? '',
                file.fileId.toString(),
                file.fileIdName ?? '',
                file.chapterId.toString(),
                file.allowDuration.toString(),
                file.consumeDuration.toString(),
                file.allowNo.toString(),
                file.consumeNos.toString(),
                file.documentPath.toString(),
                file.scheduleOn.toString(),
                file.sessionId.toString(),
                file.videoDuration.toString(),
                getDownloadedPathOfFile(
                  file.packageId.toString(),
                  file.fileId.toString(),
                  file.fileIdType ?? '',
                ),
                file.isEncrypted,
                file.sortedOrder.toString())
            .whenComplete(() {
          // log('Inserted');
          getx.packageDetailsdata.add(details);
        });
      });
      await readPackageDetailsdata();

      // Get.back();
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      // print("Error: in user files");
    } else {
      // Get.back();
    }
  } catch (p) {
    writeToFile(p, 'getAllFiles');
    // print("error:$p files2");
  }
}

Future getAllFreeFiles(BuildContext context, token, String packageId) async {
  // loader(context);
  Map data = packageId == "" ? {} : {'PackageId': packageId};

  try {
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getFreePackageFiles),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
        body: jsonEncode(data));

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);

      // log(responseBody['result'].toString());

      List<AllPackageDetails> resultData =
          AllPackageDetails.fromJsonList(responseBody['result']);

      resultData.forEach((file) async {
        AllPackageDetails details = AllPackageDetails(
            packageId: file.packageId,
            packageName: file.packageName,
            fileIdType: file.fileIdType,
            fileId: file.fileId,
            fileIdName: file.fileIdName,
            chapterId: file.chapterId,
            allowDuration: file.allowDuration,
            consumeDuration: file.consumeDuration,
            allowNo: file.allowNo,
            consumeNos: file.consumeNos,
            documentPath: file.documentPath,
            scheduleOn: file.scheduleOn,
            sessionId: file.sessionId,
            videoDuration: file.videoDuration,
            DownloadedPath: "0",
            isEncrypted: file.isEncrypted,
            sortedOrder: file.sortedOrder);
        await insertPackageDetailsdata(
                file.packageId.toString(),
                file.packageName ?? '',
                file.fileIdType ?? '',
                file.fileId.toString(),
                file.fileIdName ?? '',
                file.chapterId.toString(),
                file.allowDuration.toString(),
                file.consumeDuration.toString(),
                file.allowNo.toString(),
                file.consumeNos.toString(),
                file.documentPath.toString(),
                file.scheduleOn.toString(),
                file.sessionId.toString(),
                file.videoDuration.toString(),
                getDownloadedPathOfFile(
                  file.packageId.toString(),
                  file.fileId.toString(),
                  file.fileIdType ?? '',
                ),
                file.isEncrypted,
                file.sortedOrder.toString())
            .whenComplete(() {
          // log('Inserted');
          getx.packageDetailsdata.add(details);
        });
      });
      await readPackageDetailsdata();

      // Get.back();
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      // print("Error: in user files");
    } else {
      // Get.back();
    }
  } catch (p) {
    writeToFile(p, 'getAllFiles');
    // print("error:$p files2");
  }
}

String formatTimestamp(String timestamp) {
  // Split the string by the period
  List<String> parts = timestamp.split('.');

  // Get only the first three digits after the decimal point
  String afterDecimal = parts[1].substring(0, 3);

  // Join the parts back together
  return parts[0] + '.' + afterDecimal;
}

// Future videoInfo(context, startingTimeLine, videoId, duration, playBackSpeed,
//     startClockTime, String token) async {
//   loader(context);
//   try {
//     Map data = {
//       "tblStudentPackageHistory": {
//         "StartingTimeLine": startingTimeLine.toString(),
//         "VideoId": videoId.toString(),
//         "Duration": duration.toString(),
//         "PlayBackSpeed": playBackSpeed.toString(),
//         "StartClockTime": formatTimestamp(startClockTime.toString()),
//         // 'EndClockTime': '15.30'
//       }
//     };

//     final res = await http.post(
//       Uri.https(
//         ClsUrlApi.mainurl,
//         ClsUrlApi.insertvideoTimeDetails,
//       ),
//       body: jsonEncode(data),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Origin': origin,
//       },
//     );

//     var jsondata = jsonDecode(res.body);

//     if (jsondata['status'] == true) {
//       Get.back();
//     } else {
//       //
//       Get.back();
//     }
//   } catch (e) {
//     writeToFile(e, 'formatTimestamp');
//     Get.back();
//   }
// }

Future<void> getPackageData(BuildContext context, String token) async {
  Map<String, dynamic> data = {};

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getPackageData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);

      String resultString = jsonResponse['result'];
      // log(resultString);
      // log(resultString);
      // Step 2: Decode the result string and store data in a list
      List<dynamic> packageJsonList = jsonDecode(resultString);
      List<PackageData> packageList = packageJsonList
          .map((packageJson) => PackageData.fromJson(packageJson))
          .toList();

      packageList.forEach((package) {
        insertOrUpdateTblPackageData(
            package.packageId,
            package.packageName,
            package.packageExpiryDate.toString(),
            package.isUpdated.toString(),
            package.isShow.toString(),
            package.lastUpdatedOn.toString(),
            package.courseId.toString(),
            package.courseName.toString(),
            package.isFree.toString(),
            package.isDirectPlay.toString());
      });

      // Get.back();
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print("errorn in insert");
      // Get.back();
    }
  } catch (e) {
    writeToFile(e, 'getPackageData');
    // print("Error: $e+'package details'");
  }
}

onSweetAleartDialog(
    context, VoidCallback ontap, String title, String subtitle) async {
  await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          showCancelBtn: false,

          // denyButtonText: "Cancel",
          title: "$title",
          text: "$subtitle",
          confirmButtonText:
              "                           Ok                            ",
          onConfirm: ontap,
          type: ArtSweetAlertType.warning));
}

onTokenExpire(
  context,
) {
  Alert(
    context: context,
    type: AlertType.warning,
    style: AlertStyle(
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: "SESSION EXPIRE!!",
    desc: "Your session is expire! need to re login",
    buttons: [
      DialogButton(
        child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: ColorPage.blue,
        onPressed: () {
          Navigator.pop(context);
          Get.offAll(() => DthLmsLogin());
        },
        color: const Color.fromARGB(255, 207, 43, 43),
      ),
    ],
  ).show();
}

Future getVideoComponents(BuildContext context, token, String packageId) async {
  // loader(context);
  Map data = packageId == "" ? {} : {"PackageId": packageId};

  try {
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getVideoComponents),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
        body: jsonEncode(data));

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);
      // // print(responseBody.toString());
      List<dynamic> resultList = jsonDecode(responseBody['result']);
      List<VideoComponents> videoResults =
          resultList.map((item) => VideoComponents.fromJson(item)).toList();
      videoResults.forEach((item) {
        insertTblVideoComponents(
          item.componentId.toString(),
          item.packageId.toString(),
          item.videoId.toString(),
          item.names,
          item.option1,
          item.option2,
          item.option3,
          item.option4,
          item.videoTime,
          item.answer,
          item.category,
          item.tagName,
          item.documentId.toString(),
          item.documentURL,
          item.isVideoCompulsory.toString(),
          item.isChapterCompulsory.toString(),
          item.previousVideoId.toString(),
          item.minimumVideoDuration.toString(),
          item.previousChapterId.toString(),
          item.sessionId,
          item.franchiseId.toString(),
          getDownloadedPathOfFileOfVideo(
            item.packageId.toString(),
            item.videoId.toString(),
            item.category,
            item.documentId.toString(),
          ),
          item.isEncrypted,
        );
      });

      // Get.back();
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      // print("Error: in user components");
    } else {
      // Get.back();
    }
  } catch (p) {
    writeToFile(p, 'getVideoComponents');
    // print("error:$p files2 video component");
  }
}

Future<String> uploadImage(
    File imageFile, String token, BuildContext context) async {
  // Retrieve token from shared preferences

  // Extract the file name and mime type
  String fileName = basename(imageFile.path);
  String? mimeType = lookupMimeType(imageFile.path);

  // Validate MIME type to ensure it's an image
  if (mimeType == null || !mimeType.startsWith('image/')) {
    // print('The selected file is not an image.');
    return 'null';
  }

  try {
    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.https(
          ClsUrlApi.mainurl,
          ClsUrlApi
              .uploadFile), // Ensure to use the correct endpoint URL for image upload
    );

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['accept'] = 'text/plain';

    // Create a ByteStream for the image file
    var byteStream = http.ByteStream(imageFile.openRead());

    // Add the image file to the request
    request.files.add(
      http.MultipartFile(
        'FileDetails', // Field name for the image file in the form
        byteStream,
        imageFile.lengthSync(),
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    );
    request.fields['folderPath'] = "UserImage";
    request.fields['DocumentTitle'] = fileName;
    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      // print('Image uploaded successfully!');
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      var jsondata = jsonDecode(jsonResponse["result"]);

      String documentPath = jsondata['returnPath'];
      getx.userProfileDocumentId.value = jsondata['DocumentId'];
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt("UserImagedocumentId", jsondata['DocumentId']);

      // // print response data if needed
      return documentPath;
    } else if (response.statusCode == 401) {
      onTokenExpire(context);
      return 'null';
    } else {
      var responseData = await response.stream.bytesToString();

      return 'null';
    }
  } catch (e) {
    writeToFile(e, 'uploadImage');
    // print("error on upload image:$e");
    return 'null';
  }
}

Future changeProfileDetails(
  String token,
  String key,
  BuildContext context,
  String signupuser,
  String signupfirstname,
  String signuplastname,
  signupemail,
  String profileImageDocumentId,
  signupphno,
) async {
  try {
    loader(context);

    var signupdata = ClsMap().objChangeProfileDetails(
        signupuser,
        signupfirstname,
        signuplastname,
        signupemail,
        signupphno,
        profileImageDocumentId);

    final http.Response res = await http.post(
        Uri.https(ClsUrlApi.mainurl, '${ClsUrlApi.changeProfileDetails}$key'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Origin': origin,
        },
        body: jsonEncode(signupdata));

    var jsondata = json.decode(res.body);

    if (res.statusCode == 200 &&
        jsondata['statusCode'] == 200 &&
        jsondata['isSuccess'] == true) {
      Get.back();

      final result = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: 'Profile Picture',
        text: 'update Sucessfull',
        positiveButtonTitle: "Ok",
      );
      Getx getxController = Get.put(Getx());
      if (CustomButton.positiveButton == result) {
        getxController.show.value = false;
      } else {}
    } else {
      Get.back();

      ClsErrorMsg.fnErrorDialog(
          context, 'Sign up', jsondata['errorMessages'], res);
    }
  } catch (e) {
    writeToFile(e, 'changeProfileDetails');
    Get.back();
    ClsErrorMsg.fnErrorDialog(
        context, e.toString(), e.toString(), e.toString());
  }
}

Future<Map<String, dynamic>> getUserImage(
    BuildContext context, String token) async {
  Map<String, dynamic> data = {};

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getUserImage),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);

      List<dynamic> resultList = jsonDecode(
          jsonResponse['result']); // Correctly decode the JSON string

      // Create a map to store all key-value pairs from the result
      Map<String, dynamic> userResult = {};

      // Iterate through the list of results and store the key-value pairs
      for (var item in resultList) {
        item.forEach((key, value) {
          userResult[key] = value; // Store each key-value pair
        });
      }

      // // print the map of all keys and values
      return userResult; // Return the map with all key-value pairs
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      // print("Error: in user image"); // Handle token expiration
    } else {
      Get.back(); // Handle other responses
    }
  } catch (e) {
    writeToFile(e, 'getUserImage');

    // print("Error: $e+'package details'"); // Error handling
  }

  return {};
}

Future<void> getHomePageBannerImage(BuildContext context, String token) async {
  List<Map<String, dynamic>> resultList = [];

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getHompageBanners),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode({}),
    );

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);

      // Correctly decode the result JSON string into a List of Maps
      List<dynamic> resultData = jsonDecode(jsonResponse['result']);
      if (getx.bannerImageList.isNotEmpty) {
        getx.bannerImageList.clear();
      }
      // Iterate through the list of banner objects
      for (var item in resultData) {
        Map<String, dynamic> bannerData = Map<String, dynamic>.from(item);
        String imgUrl = await downloadBannerAndSave(bannerData['DocumentUrl']);
        imgUrl = Platform.isWindows
            ? imgUrl.replaceAll('/', '\\')
            : imgUrl.replaceAll('\\', '/');
        // log(imgUrl+ " this is downloaded banner image shubha");
        await insertOrUpdateTblImages(
            bannerData['AppBannerId'].toString(),
            bannerData['DocumentUrl'].toString(),
            bannerData['ImageDocumentId'].toString(),
            imgUrl,
            bannerData['BannerName'].toString(),
            'homepage',
            bannerData['BannerImagePosition'].toString(),
            '');

        resultList.add(bannerData);
        if (bannerData['ImageType']
            .toString()
            .toLowerCase()
            .contains('banner')) {
          getx.bannerImageList.add(bannerData);
        }

        // log(bannerData.toString());

        // log(bannerData.toString());

        // Add the cleaned map to the result list
      }
      insertOrUpdateTblImages('116589', 'DocumentUrl', 'ImageDocumentId',
          "ImageUrl", "Marquee", "HomePage", "", "welcome to our app");
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // Handle other responses
    }
  } catch (e) {
    writeToFile(e, 'getHomePageBannerImage');
    // print("Error: $e+'image details'"); // Error handling
  }
}

Future<String> downloadBannerAndSave(String documentUrl) async {
  try {
    // Ensure the URL is not empty or null
    if (documentUrl.isEmpty) {
      // print('URL is empty');
      return '';
    }

    final fileName = documentUrl.split('/').last;

    // Get the application's document directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create the folder structure: com.si.dthLive/BannerImages
    Directory dthLmsDir = Directory('${appDocDir.path}/$origin');
    Directory bannerImagesDir = Directory('${dthLmsDir.path}/BannerImages');

    if (!await bannerImagesDir.exists()) {
      await bannerImagesDir.create(recursive: true);
      // print('BannerImages directory created at ${bannerImagesDir.path}');
    }

    // Save the path in SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    getx.defaultPathForDownloadFile.value = dthLmsDir.path;
    prefs.setString("downloadBannerAndSave", bannerImagesDir.path);

    // Construct the file path
    String filePath = '${bannerImagesDir.path}/$fileName';

    // Initialize Dio
    final dio = Dio();

    // Check if fileName is valid
    if (fileName.isEmpty) {
      // print('Failed to extract file name from URL');
      return '';
    }

    // Download the file
    // print('Downloading banner from: $documentUrl');
    await dio.download(
      documentUrl,
      filePath,
      options: Options(responseType: ResponseType.bytes),
    );

    // Verify if the file exists
    final file = File(filePath);
    if (await file.exists()) {
      // print('File saved successfully at: $filePath');
      return filePath;
    } else {
      // print('File download failed: $filePath does not exist.');
      return '';
    }
  } catch (e) {
    // Log and rethrow the error
    // print('Error downloading banner: $e');
    rethrow;
  }
}

// Future downloadAndSavePdf(
//     String pdfUrl, String title, String enkey, String foldername) async {
//   this.title = title;
//   this.data = getDownloadedPathOfPDF(title, foldername);
//   // print(data);

//   //  String enkey=await  getEncryptionKey(getx.loginuserdata[0].token);
//   if (!File(data).existsSync()) {
//     // print("downloaing file.....");
//     try {
//       // Get the application's document directory
//       Directory appDocDir = await getApplicationDocumentsDirectory();

//       // Create the folder structure: com.si.dthLive/notes
//       Directory dthLmsDir = Directory('${appDocDir.path}/$origin');
//       if (!await dthLmsDir.exists()) {
//         await dthLmsDir.create(recursive: true);
//       }
//       var prefs = await SharedPreferences.getInstance();
//       getx.defaultPathForDownloadFile.value = dthLmsDir.path;
//       prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

//       // Correct file path to save the PDF
//       String filePath = getx.userSelectedPathForDownloadFile.value.isEmpty
//           ? '${dthLmsDir.path}/$foldername/$title'
//           : getx.userSelectedPathForDownloadFile.value +
//               "/$foldername/$title"; // Make sure to add .pdf extension if needed

//       // Download the PDF using Dio
//       Dio dio = Dio();
//       await dio.download(pdfUrl, filePath,
//           onReceiveProgress: (received, total) {
//         if (total != -1) {
//           // print(
//               'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
//         }
//       });

//       // print('PDF downloaded and saved to: $filePath');

//       if (widget.isEncrypted) {
//         final encryptedBytes = await readEncryptedPdfFromFile(filePath);
//         final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, enkey);
//         isLoading = false;
//         return decryptedPdfBytes;
//       } else {
//         return filePath;
//       }
//     } catch (e) {
//       writeToFile(e, "downloadAndSavePdf");
//       // print('Error downloading or saving the PDF: $e');
//       isLoading = false;
//       return widget.isEncrypted ? Uint8List(0) : "";
//     }
//   } else {
//     if (widget.isEncrypted) {
//       final encryptedBytes = await readEncryptedPdfFromFile(data);
//       final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, enkey);
//       isLoading = false;
//       return decryptedPdfBytes;
//     } else {
//       return data;
//     }
//   }
// }

Future<bool> logoutFunction(BuildContext context, token) async {
  loader(context);

  try {
    var deviceinfo;
    if (Platform.isAndroid) {
      deviceinfo = await ClsDeviceInfo.androidInfo(context);
    } else if (Platform.isWindows) {
      deviceinfo = await ClsDeviceInfo.windowsInfo(context);
    } else if (Platform.isIOS) {
      deviceinfo = await ClsDeviceInfo.androidInfo(context);
    } else if (Platform.isMacOS) {
      deviceinfo = await ClsDeviceInfo.windowsInfo(context);
    }
    var responce = await http.delete(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.logoutapi),
      headers: <String, String>{
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
        'DeviceInfo': jsonEncode(deviceinfo),
        'Origin': origin,
      },
    );

    if (responce.statusCode == 200) {
      Get.back();
      return true;
    } else if (responce.statusCode == 401) {
      onTokenExpire(context);
      return false;
    } else {
      Get.back();
      return false;
    }
  } catch (e) {
    writeToFile(e, 'logoutFunction');
    Get.back();
    return false;
  }
}

Future<String> checkUserBeforeRegister(BuildContext context, String loginemail,
    String phone, String activationkey) async {
  loader(context);
  Map logindata = {
    "Email": loginemail,
    "Phone": phone,
    "ActivationKey": activationkey,
  };

  // // print(token);
  // log(jsonEncode(logindata.toString()+"///////////////////////////////////////////////////"));
  try {
    var responce = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.checkUserExitenceBeforeregister),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Origin': origin
      },
      body: json.encode(logindata),
    );

    var jsondata = jsonDecode(responce.body);

    // log(jsondata.toString() + "///////////////////////////");

    if (jsondata['result'] != null) {
      activationkey = jsonDecode(jsondata['result']);
    } else {
      activationkey = "";
    }
// log(jsondata['result'].toString().contains('signup').toString());
    if (responce.statusCode == 200) {
      // log('true');
      Get.back();
      return activationkey;
    } else {
      Get.back();

      onregisterexists(context, jsondata["errorMessages"].toString());

      return activationkey;
    }
  } catch (e) {
    writeToFile(e, 'checkUserBeforeRegisterFunction');
    // print(e.toString());
    onregisterexists(context, e.toString());
    Get.back();
    return activationkey;
  }
}

onregisterexists(context, String msg) {
  Alert(
    context: context,
    type: AlertType.warning,
    style: AlertStyle(
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: "Authentication failed",
    desc: msg.replaceAll("[", "").replaceAll("]", ""),
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

Future<bool> getMcqDataForTest(
    BuildContext context, String token, String packageId) async {
  // loader(context);

  try {
    Map data = {"PackageId": packageId};
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getMcqData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      await deleteAllMcqDataTable();
      var jsonResponse = jsonDecode(res.body);

      // Decode the result JSON string into a List of Maps
      List<dynamic> resultData = jsonDecode(jsonResponse['result']);
// // print(resultData.toString());
      // Level 1: Package Level
      for (var package in resultData) {
        // Level 2: MCQSet Level
        if (package.containsKey('TblMasterMCQSet')) {
          List<dynamic> mcqSets = package['TblMasterMCQSet'];
          print(mcqSets);
          for (var mcqSet in mcqSets) {
            await inserTblMCQSet(
              mcqSet['MCQSetId'].toString(),
              mcqSet["PackageId"].toString(),
              mcqSet['MCQSetName'].toString(),
              mcqSet['ServicesTypeName'].toString(),
            );

            if (mcqSet.containsKey('TblMasterMCQPaper')) {
              List<dynamic> mcqPapers = mcqSet['TblMasterMCQPaper'];
              for (var mcqPaper in mcqPapers) {
                if (mcqPaper['MCQPaperId'].toString() == "178") {
                  // print(mcqPaper['TblMasterMCQSection'].toString());
                }
                // log(  mcqPaper["MCQPaperEndDate"].toString());
                await inserTblMCQPaper(
                    mcqPaper['MCQPaperId'].toString(),
                    mcqPaper['MCQSetId'].toString(),
                    mcqPaper['MCQPaperName'].toString(),
                    mcqPaper['TotalMarks'].toString(),
                    mcqPaper["Instruction"].toString(),
                    mcqPaper["PaperDuration"].toString(),
                    mcqPaper["FromDate"].toString(),
                    mcqPaper["ToDate"].toString(),
                    mcqPaper["SortedOrder"].toString(),
                    mcqPaper["MCQStartTime"].toString(),
                    mcqPaper["TotalPassMarks"].toString(),
                    mcqPaper["NoOfTotalQuestions"].toString(),
                    mcqPaper["MCQPaperEndDate"].toString(),
                    mcqPaper["MCQPaperStartDate"].toString(),
                    mcqPaper["IsNegativeMark"].toString(),
                    mcqPaper["IsAnswerSheetShow"].toString());

                await inserUserResultDetails(
                    mcqPaper['MCQPaperId'].toString(),
                    mcqPaper["MCQPaperStartDate"].toString(),
                    "false",
                    "",
                    mcqPaper["MCQPaperEndDate"].toString(),
                    mcqSet['ServicesTypeName'].toString());

                // Level 4: MCQSection Level
                if (mcqPaper.containsKey('TblMasterMCQSection')) {
                  List<dynamic> mcqSections = mcqPaper['TblMasterMCQSection'];
                  for (var mcqSection in mcqSections) {
                    await inserTblMCQSection(
                      mcqSection['MCQSectionId'].toString(),
                      mcqSection["MCQPaperId"].toString(),
                      mcqSection['MCQSectionName'].toString(),
                      mcqSection["SortedOrder"].toString(),
                      mcqSection["DefaultMarks"].toString(),
                      mcqSection["MinQuestionAttempt"].toString(),
                      mcqSection["MinQuestionDisplay"].toString(),
                      mcqSection['DefaultNegativeMarks'].toString(),
                    );

                    if (mcqSection.containsKey('TblMasterMCQQuestion')) {
                      List<dynamic> mcqQuestions =
                          mcqSection['TblMasterMCQQuestion'];
                      for (var mcqQuestion in mcqQuestions) {
                        await inserTblMCQQuestion(
                          mcqQuestion['MCQQuestionId'].toString(),
                          mcqQuestion["MCQSectionId"].toString(),
                          mcqQuestion['MCQQuestion'].toString(),
                          mcqQuestion["IsMultipleCorrect"].toString(),
                          mcqQuestion["MCQQuestionTag"].toString(),
                          mcqQuestion['MCQQuestionDocumentUrl'].toString(),
                          mcqQuestion["MCQQuestionMarks"].toString(),
                          mcqQuestion["MCQQuestionType"].toString(),
                          mcqQuestion["AnswerExplanation"].toString(),
                          mcqQuestion["AnswerLink"].toString(),
                          mcqQuestion["AnswerDocumentId"].toString(),
                          mcqQuestion["AnswerDocumentUrl"].toString(),
                          mcqQuestion["PassageDocumentUrl"].toString(),
                          mcqQuestion["PassageLink"].toString(),
                          mcqQuestion["MCQQuestionDocumentId"].toString(),
                          mcqQuestion["PassageDocumentId"].toString(),
                          mcqQuestion["MCQQuestionUrl"].toString(),
                          mcqQuestion['PassageDetails'].toString(),
                        );
                        // mcqQuestion['PassageLink'].toString()

                        if (mcqQuestion.containsKey('MCQOptions')) {
                          List<dynamic> mcqOptions = mcqQuestion['MCQOptions'];
                          for (var mcqOption in mcqOptions) {
                            await inserTblMCQOption(
                                mcqOption['MCQOptionId'].toString(),
                                mcqQuestion['MCQQuestionId'].toString(),
                                mcqOption["MCQOption"].toString(),
                                mcqOption["MCQPartialCorrectMarks"].toString(),
                                mcqOption["MCQPartialNegativeMarks"].toString(),
                                mcqOption["IsCorrect"].toString());
                            if (mcqOption['IsCorrect']) {
                              await inserTblMCQAnswer(
                                  mcqOption['MCQOptionId'].toString(),
                                  mcqQuestion['MCQQuestionId'].toString(),
                                  mcqQuestion["AnswerExplanation"].toString(),
                                  "0",
                                  mcqQuestion["AnswerLink"].toString(),
                                  mcqOption["MCQOption"].toString());
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      // Get.back();
      return true;
    } else if (res.statusCode == 401) {
      // Get.back();
      onTokenExpire(context);
      return false;
    } else {
      // Get.back();

      return false;
    }
  } catch (e) {
    // Get.back();

    // log("Error: $e");
    writeToFile(e, 'getMcqDataForTest');
    return false;
  }
}

Future<void> sendmarksToCalculateLeaderboard(
    BuildContext context, String token, String marks, String paperId) async {
  List<Map<String, dynamic>> resultList = [];
  Map data = {"MCQPaperId": paperId, "Marks": marks};
  // print("call send");

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.sendMarksToCalculateLeaderboard),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    // // print(res.body);

    if (res.statusCode == 201) {
      var jsonResponse = jsonDecode(res.body);

      // // print the list of all keys and values
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // Handle other responses
    }
  } catch (e) {
    writeToFile(e, 'sendmarksToCalculateLeaderboard');

    // print("Error: $e+'sendmarksToCalculateLeaderboard'"); // Error handling
  }
}

Future<List> getRankDataOfMockTest(
    BuildContext context, String token, String paperId) async {
  List<Map<String, dynamic>> resultList = [];
  Map data = {
    "MCQExamHistory": {"MCQPaperId": paperId}
  };

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getRankedData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    // // print(res.body);

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      // log(res.body);

      // Correctly decode the result JSON string into a List of Maps
      // List<dynamic> resultList = jsonDecode(jsonResponse['result']);

      // for (var data in resultList) {
      //   if (data['UserId'] == getx.loginuserdata[0].nameId) {
      //     getx.userRankDetails.value = {
      //       "Rank": data['Rank'],
      //       "RankWithSuffix": data['RankWithSuffix'],
      //       "Marks": data['Marks'],
      //       "StudentName": data['StudentName'],
      //       "ProfileImageDocumentURL": data['ProfileImageDocumentURL']
      //     };
      //   }
      // }

      //hello

      // log(resultList.toString());

      // getx.rankerList.value = resultList;

      // // print the list of all keys and values
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // Handle other responses
    }
  } catch (e) {
    writeToFile(e, 'getRankDataOfMockTest');
    // print("Error: $e+'getRanked data'"); // Error handling
  }
  return resultList;
}

Future<List> getRankDataOfMockTest2(
    BuildContext context, String token, String paperId) async {
  List<Map<String, dynamic>> resultList = [];
  Map data = {
    "MCQExamHistory": {"MCQPaperId": paperId}
  };

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getRankedData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      // Decode the top-level response
      var jsonResponse = jsonDecode(res.body);
      // log(res.body);

      if (jsonResponse['isSuccess'] == true) {
        // Decode the `result` string
        String resultString = jsonResponse['result'];
        var resultArray = jsonDecode(resultString); // Decode to List

        if (resultArray.isNotEmpty) {
          var nestedJson = resultArray[0]; // First object in the array

          // Extract `YourRank` and `TopTen`
          List<dynamic> yourRankList = nestedJson['YourRank'];
          List<dynamic> topTenList = nestedJson['TopTen'];

          // Safely process `YourRank`
          if (yourRankList.isNotEmpty) {
            var yourRank = yourRankList[0]; // First item in `YourRank`

            // Update user rank details in GetX (assuming GetX state management)
            if (yourRank['StudentId'] == getx.loginuserdata[0].nameId) {
              getx.userRankDetails.value = {
                "Rank": yourRank['Rank'],
                "RankWithSuffix": yourRank['RankWithSuffix'] ?? '',
                "TotalMarks": yourRank['TotalMarks'],
                "StudentName": yourRank['StudentName'],
                "ProfileImageDocumentURL": yourRank['ProfileImageDocumentURL']
              };
            }

            // log("Your Rank: $yourRank");
          }

          // Convert `TopTen` to List<Map<String, dynamic>> and assign to resultList
          resultList = List<Map<String, dynamic>>.from(topTenList);

          getx.rankerList.value = resultList;

          // log("Top Ten List: $topTenList");
        }
      }
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      log("Unexpected status code: ${res.statusCode}");
    }
  } catch (e) {
    writeToFile(e, 'getRankDataOfMockTest');
    // print("Error: $e + 'getRanked data'"); // Error handling
  }
  return resultList;
}

Future<bool> senddatatoRankedmcqtest(BuildContext context, String token,
    List questionanswer, String spendedTime) async {
  // print(questionanswer.toString() + "Question answer list");
  //     "////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
  loader(context);
  List<Map<String, dynamic>> resultList = [];
  Map data = {
    "QuestionAnswerListofStudent": questionanswer,
    "SpendedTime": spendedTime
  };

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.sendQuestionAnswerList),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );
    var jsondata = jsonDecode(res.body);
    if (res.statusCode == 200) {
      Get.back();

      updateTblUserResult();

      // print("spwnd time: $spendedTime");
      // _onUploadSuccessFull(context,(){
      //   Get.back();
      //   Get.back();
      // });

      return true;
      // Correctly decode the result JSON string into a List of Maps
      // List<dynamic> resultList = jsonDecode(jsonResponse['result']);

      // // print(rest);
      // getx.rankerList.value = resultList;

      // // print the list of all keys and values
    } else if (res.statusCode == 401) {
      Get.back();
      onTokenExpire(context);
      return false;
    } else {
      Get.back();
      ClsErrorMsg.fnErrorDialog(
          context,
          res.statusCode.toString(),
          jsondata["errorMassage"]
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          "");
      return false;

      // Handle other responses
    }
  } catch (e) {
    // Get.back();
    writeToFile(e, 'sendQuestionAnswerList');
    // print("Error: $e sendQuestionAnswerList");
    return false; // Error handling
  }
}

_onUploadSuccessFull(context, VoidCallback ontap) {
  Alert(
    context: context,
    type: AlertType.success,
    style: AlertStyle(
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: "UPLOAD SUCCESSFUL!!",
    desc: "Your answer sheets are Submitted successfully!",
    buttons: [
      DialogButton(
        child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: ColorPage.blue,
        onPressed: ontap,
        color: ColorPage.green,
      ),
    ],
  ).show();
}

Future<String> uploadSheet(
    File file, String token, String key, String folderPath, context) async {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
  try {
    String fileName = basename(file.path);
    String mimeType = lookupMimeType(file.path) ?? '.jpg';

    var request = http.MultipartRequest('POST',   
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.uploadVideoiInCloudeUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['accept'] = 'text/plain';

    var byteStream = http.ByteStream(
      file.openRead().transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data);
            // setState(() {
            //   uploadProgress += data.length / file.lengthSync();
            // });
          },
        ),
      ),
    );

// Update the request
    request.files.add(http.MultipartFile(
      'FileDetails',
      byteStream,
      file.lengthSync(),
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    request.fields['folderPath'] = folderPath;
    request.fields['DocumentTitle'] = fileName;

    // Send the request with a 10-minute timeout
    var response = await request.send().timeout(
      const Duration(minutes: 50), // Set the timeout duration here
      onTimeout: () {
        // You can handle the timeout separately if needed
        // ClsErrorMsg.fnErrorDialog(context, '', 'File upload timed out after 10 minutes', "");
        return http.StreamedResponse(
          const Stream.empty(),
          408, // HTTP status code for timeout
        );
      },
    );

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      var json = jsonDecode(jsonResponse["result"]);
      print(json.toString());
      String documentId = json['DocumentId'].toString();

      Get.back();
      // NoticationDialog.noticationDialogsuccess(context, description: '');
      return documentId;
    } else {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData.toString());
      log(jsonResponse['errorMessages'].toString());
      Get.back();
      // NoticationDialog.noticationDialogerror(context,
      //     description: jsonResponse['errorMessages'].toString());
      ClsErrorMsg.fnErrorDialog(context, '',
          'Failed to upload Images. Status code: ${response.statusCode}', "");
      return "";
    }
  } catch (e) {
    Get.back();
    // ClsErrorMsg.fnErrorDialog(context, '', e.toString(), "");
    return '';
  }
}
// Future<String> uploadSheet(
//     File file, String token, String key, String folderPath,context) async {
//   try {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     String fileName = basename(file.path);
//     String mimeType = lookupMimeType(file.path) ?? 'jpg';

//     // Create a multipart request
//     var request = http.MultipartRequest('POST',
//         Uri.https(ClsUrlApi.mainurl, ClsUrlApi.uploadVideoiInCloudeUrl));

//     // Add headers
//     request.headers['Authorization'] = 'Bearer $token';
//     request.headers['accept'] = 'text/plain';

//     getx.uploadProgress.value = 0.0;

//     // Create a ByteStream to track progress
//     var byteStream = http.ByteStream(
//       file.openRead().transform(
//         StreamTransformer.fromHandlers(
//           handleData: (data, sink) {
//             sink.add(data);
//             getx.uploadProgress.value += data.length / file.lengthSync();
//           },
//         ),
//       ),
//     );

//     // Add the file
//     request.files.add(
//       http.MultipartFile(
//         'FileDetails',
//         byteStream,
//         file.lengthSync(),
//         filename: fileName,
//         contentType: MediaType.parse(mimeType),
//       ),
//     );

//     // Add other form fields
//     request.fields['folderPath'] = "folderPath";
//     request.fields['DocumentTitle'] = fileName;
//     request.fields['key'] = key;

//     // Send the request
//     var response = await request.send();
//     log(response.statusCode.toString());

//     var responseData = await response.stream.bytesToString();
//     var jsonResponse = json.decode(responseData);
//     // Check the response
//     if (response.statusCode == 200) {
//       // print('sheet uploaded successfully! ${jsonResponse["result"]} $file');
//       var json = jsonDecode(jsonResponse["result"]);

//       String documentId = json['DocumentId'].toString();

//       String documentPath = json['returnPath'];
//       // SettingsStorage storage = SettingsStorage();
//       String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

//       // rename video name add by Sayak Mishra

//       // renameVideoFile(videoFile.path, documentId, currentTime)
//       //     .then((bool isrename) async {

//       //   if (isrename) {
// log(documentId);
//       return documentId;
//       // }
//       // f.uploadProgress.value = 1.0;
//       // });

//       // return
//       // Ensure progress is set to 100% on success
//     } else {
//       ClsErrorMsg.fnErrorDialog(
//         context
// ,
//       'Failed',
//       "Failed to upload video. Status code: ${response.statusCode}".toString()
//             .replaceAll("[", "")
//             .replaceAll("]", ""),
//       "");
//       print('Failed to upload video. Status code: ${response.statusCode}');
//       return "";
//     }
//   } catch (e) {
//     writeToFile(e, 'uploadSheet');
//     return '';
//     //  ClsErrorMsg.fnErrorDialog(
//     //     context,
//     //     '',
//     //    e. toString()
//     //           .replaceAll("[", "")
//     //           .replaceAll("]", ""),
//     //     "");
//   }
// }

Future sendDocumentIdOfanswerSheets(
    BuildContext context, String token, int paperid, String documentId) async {




      log('message');

  // // print(questionanswer);
  // loader(context);
  // List<Map<String, dynamic>> resultList = [];
  Map data = {
    "spAppApi": {
      "TheoryExamId": paperid,
      "OriginalDocumentIds": documentId,
    }
  };

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.sendAnswerSheedIdList),
      headers: <String, String>{ 
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    print(res.body);

    if (res.statusCode == 201) {
      var jsonResponse = jsonDecode(res.body);
      updateIsSubmittedOnTblTheoryPaperTable(paperid.toString(), "1", context);

      return true;

// Get.back();

      // Correctly decode the result JSON string into a List of Maps
      // List<dynamic> resultList = jsonDecode(jsonResponse['result']);

      // // print(rest);
      // getx.rankerList.value = resultList;

      // // print the list of all keys and values
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      ClsErrorMsg.fnErrorDialog(
          context, res.statusCode.toString(), "Something went wrong!", "");
      // Get.back();

      // Handle other responses
    }
  } catch (e) {
    writeToFile(e, 'sendDocumentIdOfanswerSheets');
    // print("Error: $e+'sendDocumentIdOfanswerSheets'"); // Error handling
  }
  return false;
}

Future<List<modelclass.PackageInfo>> getFullBannerPackages(
    BuildContext context, String token) async {
  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.premiumPackageList),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode({}),
    );

    if (res.statusCode == 201) {
      var apiResponse = ApiResponse.fromJson(json.decode(res.body));

      // Clear previous packages and premium packages from the database
      await deleteAllPackages();
      await deleteAllPremiumPackages();

      // Insert the packages into the database
      await insertPackages(apiResponse.result);

      // Insert the premium packages for each package into the database
      for (var package in apiResponse.result) {
        await insertPremiumPackages(package.premiumPackageListInfo);
      }

      // Return the list of packages
      return apiResponse.result;
    } else {
      return []; // Return empty list if API fails
    }
  } catch (e) {
    debugPrint("Error fetching packages: $e");
    return []; // Return empty list in case of error
  }
}

Future<PackagInfoData> getPremiumPackageinfo(
    BuildContext context, String token, String packageId) async {
  try {
    Map<String, String> obj = {'PackageId': packageId};

    var res = await http.post(
      Uri.https(
          ClsUrlApi.mainurl,
          ClsUrlApi
              .premiumPackageInfo), // Replace with your API URL and endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);

      return PackagInfoData.fromJson(data);
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return PackagInfoData.fromJson({});
    } else {
      // print('Error r: ${res.body}');

      return PackagInfoData.fromJson({});
    }
  } catch (e) {
    writeToFile(e, 'getPremiumPackageinfo');
    // print("Error rx: $e");
    return PackagInfoData.fromJson({});
    // return ;
  }
}

Future<List<DeviceLoginHistoryDetails>> getDeviceLoginHistory(
  BuildContext context,
  String token,
) async {
  try {
    Map obj = {};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getdeviceloginhistory),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result']);
      return getx.DeviceLoginHistorylist.value = result
          .map((item) => DeviceLoginHistoryDetails.fromJson(item))
          .toList();

      // Load the data into the GetX controller
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return [];
    } else {
      // print('Error r: ${res.body}');
      return [];
    }
  } catch (e) {
    writeToFile(e, 'getDeviceLoginHistory');
    // print("Error rx: $e");
    return [];
  }

  // return fullBannerPackages;
}

Future getExamStatus(
  BuildContext context,
  String token,
  String examId,
) async {
  try {
    Map obj = {"TheoryExamId": examId};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getExamStatus),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );

    if (res.statusCode == 401) {
      onTokenExpire(context);
      return res.body;
    } else {
      log(res.body);
      return res.body;
    }
  } catch (e) {
    writeToFile(e, 'getExamStatus');
    // print("Error rx: $e");
    return 0;
  }

  // return fullBannerPackages;
}

Future<List<Map<String, dynamic>>> getCountryId() async {
  try {
    List<Map<String, dynamic>> countryList =
        []; // Create a list to store country data
    Map<String, dynamic> obj = {}; // Empty object if required by API

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getCountryCode),
      headers: <String, String>{
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token', // Uncomment if token is required
        'Origin': origin,
      },
      body: json.encode(obj),
    );

    var jsondata = jsonDecode(res.body);
    if (jsondata["isSuccess"] == true) {
      var resultdata = jsonDecode(jsondata["result"]);
      // // print(resultdata);
      // Store result values in the list
      countryList = List<Map<String, dynamic>>.from(resultdata.map(
          (country) => {"value": country["value"], "label": country["label"]}));

      // // print or use the list as needed

      return countryList; // Optional: to verify the list contents
    } else {
      // print("API Response Error: ${res.body}");
      return [];
      // // print("API Response Error: ${res.body}");
    }
  } catch (e) {
    writeToFile(e, 'getCountryId');
    // print("Error: $e");
    return [];
  }
}

Future forgetPasswordGeneratecode(
    BuildContext context,
    int phoneCountryId,
    String phoneNumber,
    String email,
    int whatsappCountryId,
    String whatsappNumber) async {
  try {
    loader(context);
    Map body = ClsMap().objForgetPasswordGanarete(
        phoneCountryId, phoneNumber, email, whatsappCountryId, whatsappNumber);
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.generateCodeForgetPassword),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode(body));
    var jsondata = jsonDecode(res.body);
    // print(jsondata.toString());

    Get.back();
    if (jsondata['isSuccess'] == true) {
      snackbar();
      getx.forgetpasswordemailcode.value = true;

      return jsondata['result'].toString();
    } else {
      return 'jhsbjknbfkjnkajnasd';
    }
  } catch (e) {
    writeToFile(e, 'forgetPasswordGeneratecode');
    ClsErrorMsg.fnErrorDialog(
        context, '', e.toString().replaceAll("[", "").replaceAll("]", ""), "");
  }

  // forgetPassword(context, signupemail, jsondata['result']);
}

snackbar() {
  Get.snackbar(
    "", // Title
    "Your OTP has been successfully sent!", // Message
    animationDuration: Duration(milliseconds: 600),

    leftBarIndicatorColor: Colors.blueAccent,
    // showProgressIndicator: true,
    titleText: Text('OTP Verification',
        style: FontFamily.styleb.copyWith(color: Colors.amber)),
    snackPosition: SnackPosition.TOP, // Display at the top of the screen
    backgroundColor:
        const Color.fromARGB(255, 41, 41, 41), // Custom background color
    colorText: Colors.white, // White text for better contrast

    borderRadius: 10, // Slightly rounded corners
    margin: EdgeInsets.symmetric(
        horizontal: 15, vertical: 10), // Margin for positioning
    duration: Duration(seconds: 4), // Visible for 4 seconds
    // icon: Icon(
    //   FontAwesome., // SMS icon for relevance
    //   color: Colors.white, // Icon coloryyyy
    //   size: 30, // Slightly larger icon
    // ),
    // shouldIconPulse: true, // Add subtle pulse animation to the icon
    forwardAnimationCurve: Curves.easeInOut, // Smooth animation
    reverseAnimationCurve: Curves.easeOut, // Smooth fade-out
    overlayBlur: 2.0, // Blur the background slightly for focus
    barBlur: 5.0, // Blur the snackbar itself for a glassy effect
    snackStyle: SnackStyle.FLOATING, // Make it appear like a floating card
  );
}

Future<bool> forgetPasswordEmailVerify(
  BuildContext context,
  String email,
) async {
  // print("forgetPasswordEmailVerify");
  try {
    loader(context);
    Map data = {'UserName': email};
    // // print(data);
    var res = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getEmailValidation),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Origin': origin,
        },
        body: jsonEncode(data));

    var jsondata = jsonDecode(res.body);

// log("${jsondata} forgetPasswordEmailVerify shubha");
    Get.back();
    if (jsondata['isSuccess'] == true) {
      return true;
    } else {
      ClsErrorMsg.fnErrorDialog(
          context,
          'Forget Password',
          jsondata['errorMessages']
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", ""),
          "");
      return false;
    }
  } catch (e) {
    Get.back();

    ClsErrorMsg.fnErrorDialog(
        context, '', e.toString().replaceAll("[", "").replaceAll("]", ""), "");
    // print(e.toString());
    return false;
  }
}

Future<Map> getEncryptionKeyAndIdofVideo(
  BuildContext context,
  String token,
  String videoId,
) async {
  try {
    Map obj = {"VideoId": videoId};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getEncryptionKeyAndId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result']);

      return {
        "EncryptionKey": "",
        "EncryptionId": "",
      };
      // Load the data into the GetX controller
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return {};
    } else {
      // print('Error r: ${res.body}');
      return {};
    }
  } catch (e) {
    writeToFile(e, 'getEncryptionKeyAndIdofVideo');
    // print("Error rx: $e");
    return {};
  }

  // return fullBannerPackages;
}

Future<List> getTheryExamHistoryList(
  BuildContext context,
  String token,
) async {
  try {
    Map obj = {};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getTheoryExamHistory),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // // print(res.body);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result'] ?? []);

      List<Map<String, dynamic>> parsedResult =
          result.map((e) => Map<String, dynamic>.from(e)).toList();
      parsedResult.forEach((exam) {
        // print('TheoryExamId: ${exam['TheoryExamId']}');
        // print('TheoryExamName: ${exam['TheoryExamName']}');
        // print('TotalCheckedMarks: ${exam['TotalCheckedMarks']}');
        // print('TotalReCheckedMarks: ${exam['TotalReCheckedMarks']}');
        // print('AttamptOn: ${exam['AttamptOn']}');
        // print('isAttempt: ${exam['isAttempt']}');
        // print('SubmitedOn: ${exam['SubmitedOn']}');
        // print('isSubmitted: ${exam['isSubmitted']}');
        // print('IsResultPublished: ${exam['IsResultPublished']}');
        // print('ReportPublishDate:${exam['ReportPublishDate']}');
        // print('PassMarks:${exam['PassMarks']}');
        // print('TotalMarks:${exam['TotalMarks']}');
        // print('---------------------------');
      });

      return parsedResult;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return [];
    } else {
      // print('Error r: ${res.body}');
      return [];
    }
  } catch (e) {
    writeToFile(e, 'getTheryExamHistoryList');
    // print("Error rx: $e");
    return [];
  }

  // return fullBannerPackages;
}

Future<String> getUploadAccessKey(BuildContext context, String token) async {
  Map data = {};

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getuploadAccessKey),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );
    // log(res.body);
    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['isSuccess'] == true) {
        String resultString = jsonResponse['result'];
        List<dynamic> resultList = jsonDecode(resultString);
        // // print(resultList.toString());
        if (resultList.isNotEmpty) {
          // Extract the first TestUploadAccessKey from the list
          String accessKey = resultList[0]['TestUploadAccessKey'];
          return accessKey;
        }
      }
      return "";
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return "";
    } else {
      return "";
    }
  } catch (e) {
    writeToFile(e, 'getUploadAccessKey');
    // print("Error: $e+'get upload access key'");
    return "";
  }
}

Future<bool> gettheoryExamDataForTest2(
    BuildContext context, String token, String packageId) async {
  try {
    // loader(context);
    // Request body with PackageId
    Map data = {"PackageId": packageId};
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getTestSerisdata),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    log(res.body.toString());
    if (res.statusCode == 200) {
      await deleteAllTheoryTable(); // Clear old data before inserting new

      var jsonResponse = jsonDecode(res.body);
      List<dynamic> resultData =
          jsonDecode(jsonResponse['result']); // List of all packages

      // Loop through the resultData (each package)
      for (var package in resultData) {
        // Check if setpackage exists in the package
        if (package.containsKey('setpackage')) {
          List<dynamic> setPackages = package['setpackage'];

          // Loop through each set package in the package
          for (var setPackage in setPackages) {
            // Loop through the exam sets in each setPackage
            if (setPackage.containsKey('examset')) {
              List<dynamic> examSets = setPackage['examset'];

              for (var examSet in examSets) {
                // Insert data into the "set" table (exam set)
                await inserTheorySet(
                  examSet['TheoryExamSetId'].toString(),
                  setPackage['PackageId'].toString(),
                  examSet['TheoryExamSetName'].toString(),
                  examSet['ServicesTypeName'].toString(),
                  examSet['TheorySegment'].toString(),
                );

                // Now, loop through each theory exam in this exam set and insert into the "paper" table
                if (examSet.containsKey('theoryexam')) {
                  List<dynamic> theoryExams = examSet['theoryexam'];

                  for (var theoryExam in theoryExams) {
                    // Insert data into the "paper" table (theory exam)
                    await inserTblTheoryPaper(
                        theoryExam['TheoryExamId'].toString(),
                        examSet['TheoryExamSetId']
                            .toString(), // Linking TheoryExamId with TheoryExamSetId
                        theoryExam['TheoryExamName'].toString(),
                        theoryExam['TotalMarks'].toString(),
                        examSet['DefaultExamInstructions'].toString(),
                        theoryExam['ExamDuration'].toString(),
                        theoryExam['QuestionDocumentUrl'].toString(),
                        theoryExam['TheoryExamDate'].toString(),
                        theoryExam['PassMarks'].toString(),
                        examSet['SetUptoDate'].toString(),
                        examSet['SetFromDate'].toString(),
                        "0",
                        answerSheet: examSet['SamplePaparUrl'] ?? '');
                  }
                }
              }
            }
          }
        }
      }
      // Get.back();
      return true;
    } else if (res.statusCode == 401) {
      // Get.back();
      onTokenExpire(context);
      return false;
    } else {
      // Get.back();
      return false;
    }
  } catch (e) {
    // Get.back();
    writeToFile(e, "gettheoryExamDataForTest2");
    // log("Error: $e");
    return false;
  }
}

Future unUploadedVideoInfoInsert(
    context, List videolist, String token, bool isLive) async {
  // loader(context);
  try {
    Map data = {"tblStudentPackageHistory": videolist};

    final res = await http.post(
      Uri.https(
        ClsUrlApi.mainurl,
        ClsUrlApi.insertvideoTimeDetails,
      ),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
    );

    var jsondata = jsonDecode(res.body);

    if (jsondata['isSuccess'] == true) {
      if (!isLive) {
        updateUploadableVideoInfo();
      }
      log("sucessfulli insert video  ${res.statusCode}");

      // log(res.body);

      return true;

      // Get.back();
    } else {
      Get.back();
      // ClsErrorMsg.fnErrorDialog(
      //     context,
      //     'video insert',
      //     jsondata['errorMessages']
      //             .toString()
      //             .replaceAll("[", "")
      //             .replaceAll("]", "") +
      //         "${res.statusCode}",
      //     "");
      return false;
      //
      // Get.back();
    }
  } catch (e) {
    Get.back();
    // ClsErrorMsg.fnErrorDialog(context, 'video insert',
    //     e.toString().replaceAll("[", "").replaceAll("]", ""), "");
    writeToFile(e, 'formatTimestamp');
    return false;
    // Get.back();
  }
}

Future<Map<String, dynamic>> getTheryExamResultForIndividual(
  BuildContext context,
  String token,
  String examId,
) async {
  try {
    Map obj = {
      "TheoryExamId": examId,
    };

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getExamResultForIndividual),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // // print(res.body);

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> result = jsonDecode(response['result']);

      // Check if the result list is not empty, and return the first element as a map
      if (result.isNotEmpty) {
        Map<String, dynamic> exam = Map<String, dynamic>.from(result[0]);

        // // print the data (you can remove this if not needed)
        // print('TheoryExamId: ${exam['TheoryExamId']}');
        // // print('TheoryExamName: ${exam['TheoryExamName']}');
        // // print('TotalCheckedMarks: ${exam['TotalCheckedMarks']}');
        // // print('TotalReCheckedMarks: ${exam['TotalReCheckedMarks']}');
        // // print('AttamptOn: ${exam['AttamptOn']}');
        // // print('isAttempt: ${exam['isAttempt']}');
        // // print('SubmitedOn: ${exam['SubmitedOn']}');
        // // print('isSubmitted: ${exam['isSubmitted']}');
        // // print('IsResultPublished: ${exam['IsResultPublished']}');
        // // print('ReportPublishDate:${exam['ReportPublishDate']}');
        // // print('PassMarks:${exam['PassMarks']}');
        // // print('TotalMarks:${exam['TotalMarks']}');
        // print('---------------------------');

        return exam; // Return the first item as a Map<String, dynamic>
      } else {
        return {}; // Return an empty map if the result list is empty
      }
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return {};
    } else {
      // print('Error: ${res.body}');
      return {}; // Return an empty map in case of an error
    }
  } catch (e) {
    writeToFile(e, 'getTheryExamHistoryList');
    // print("Error: $e");
    return {}; // Return an empty map in case of an exception
  }
}

// void insertTblExamSet(String theoryExamSetId, String theoryExamSetName, String theorySegment, String servicesTypeName) {
//   // Insert logic for the set table (exam set)
//   log("Inserting into Set Table: $theoryExamSetId, $theoryExamSetName, $theorySegment, $servicesTypeName");
//   // Database insert query here (for example, SQLite or other DB query)
//   // You would typically call your database insert method here.
// }

// void insertTblTheoryExamPaper(String theoryExamId, String theoryExamSetId, String theoryExamName, String examDuration, String totalMarks, String passMarks, String questionUrl, String answerUrl) {
//   // Insert logic for the paper table (theory exam)
//   log("Inserting into Paper Table: $theoryExamId, $theoryExamSetId, $theoryExamName, $examDuration, $totalMarks, $passMarks, $questionUrl, $answerUrl");
//   // Database insert query here (for example, SQLite or other DB query)
//   // You would typically call your database insert method here.
// }

Future updatePackage(BuildContext context, String token, bool isPackage,
    String packageId) async {
  if (isPackage) {
    loader(context);
  }
  Map<String, dynamic> data = {};

  try {
    // Make the HTTP request to get package data from the server
    // print('Sending request to fetch package data...');
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getPackageData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: jsonEncode(data),
    );

    // Check if the request was successful
    if (res.statusCode == 200) {
      // print('Request successful. Parsing response...');

      var jsonResponse = jsonDecode(res.body);
      List oldPackageData =
          readAllpackageInfo(); // Get the old package data from the local database

      // print('Old package data (local DB):');
      // print(oldPackageData);

      String resultString = jsonResponse['result'];

      // Decode the result string into a list of packages
      List<dynamic> packageJsonList = jsonDecode(resultString);
      List<PackageData> packageList = packageJsonList
          .map((packageJson) => PackageData.fromJson(packageJson))
          .toList();

      // print('New package data (from API):');
      for (var item in packageList) {
        // print(item.packageId);
      }

      // Check for newly found package IDs
      for (var newPackage in packageList) {
        var oldPackage = oldPackageData.firstWhere(
          (oldPackage) =>
              oldPackage['packageId'].toString() ==
              newPackage.packageId.toString(),
          orElse: () => null,
        );

        if (oldPackage == null) {
          // print('New package found with ID: ${newPackage.packageId}');

          insertOrUpdateTblPackageData(
              newPackage.packageId,
              newPackage.packageName,
              newPackage.packageExpiryDate,
              newPackage.isUpdated.toString(),
              newPackage.isShow.toString(),
              newPackage.lastUpdatedOn.toString(),
              newPackage.courseId,
              newPackage.courseName,
              newPackage.isFree.toString(),
              newPackage.isDirectPlay.toString());

          // Delete the old package data (if needed)
          deletePartularPackageData(newPackage.packageId.toString(), context);
          // print(
          // 'Old package data for ${newPackage.packageId} has been deleted.');

          getx.mcqdataList.value = await getMcqDataForTest(context,
              getx.loginuserdata[0].token, newPackage.packageId.toString());
          getx.theoryExamvalue.value = await gettheoryExamDataForTest2(context,
              getx.loginuserdata[0].token, newPackage.packageId.toString());
        }
      }

      // Loop through each old package to compare with the new data
      for (var oldPackage in oldPackageData) {
        // print('Processing old package with ID: ${oldPackage['packageId']}');

        // Find the matching package in the new data using packageId
        var newPackage = packageList.firstWhere(
          (package) =>
              package.packageId.toString() ==
              oldPackage['packageId'].toString(),
          orElse: () => PackageData(
              packageId: -1, // Return a default PackageData if no match
              packageName: '',
              packageExpiryDate: '',
              isShow: 0,
              lastUpdatedOn: '',
              isUpdated: 0,
              isActive: false,
              isBlocked: false,
              isDeleted: false,
              courseId: "",
              courseName: "",
              isFree: false,
              isDirectPlay: false),
        );

        if (!isPackage) {
          if (!await getexamDataExistence(packageId)) {
            getx.mcqdataList.value = await getMcqDataForTest(
                context, getx.loginuserdata[0].token, packageId);
            getx.theoryExamvalue.value = await gettheoryExamDataForTest2(
                context, getx.loginuserdata[0].token, packageId);
          }
        }

        // If we found a valid new package (packageId != -1), we proceed with the comparison
        if (newPackage.packageId != -1) {
          // print('Found matching new package with ID: ${newPackage.packageId}');
          // print('Old LastUpdatedOn: ${oldPackage['LastUpdatedOn']}');
          // print('New LastUpdatedOn: ${newPackage.lastUpdatedOn}');

          // Compare LastUpdatedOn values
          String oldLastUpdatedOn = oldPackage['LastUpdatedOn'];
          String newLastUpdatedOn = newPackage.lastUpdatedOn;

          if (oldLastUpdatedOn.toString() != newLastUpdatedOn.toString()) {
            if (isPackage) {
              // print(
              // 'LastUpdatedOn has changed for package ${newPackage.packageId}. Updating package...');

              // Insert or update the package data in the DB
              insertOrUpdateTblPackageData(
                  newPackage.packageId,
                  newPackage.packageName,
                  newPackage.packageExpiryDate,
                  newPackage.isUpdated.toString(),
                  newPackage.isShow.toString(),
                  newPackage.lastUpdatedOn.toString(),
                  newPackage.courseId,
                  newPackage.courseName,
                  newPackage.isFree.toString(),
                  newPackage.isDirectPlay.toString());

              // print(
              // 'Package ${newPackage.packageId} has been updated in the database.');

              // Delete the old package data (if needed)
              deletePartularPackageData(
                  newPackage.packageId.toString(), context);
              // print(
              // 'Old package data for ${newPackage.packageId} has been deleted.');
            } else {
              getx.mcqdataList.value = await getMcqDataForTest(
                  context, getx.loginuserdata[0].token, packageId);
              getx.theoryExamvalue.value = await gettheoryExamDataForTest2(
                  context, getx.loginuserdata[0].token, packageId);
            }
          } else {
            getx.mcqdataList.value = true;
            getx.theoryExamvalue.value = true;

            // print(
            // 'No update needed for package ${newPackage.packageId} (LastUpdatedOn is the same).');
          }
        } else {
          // print(
          // 'No matching new package found for old package ${oldPackage['packageId']}');
        }
      }
      if (isPackage) {
        Get.back();
      }
    } else if (res.statusCode == 401) {
      // print('Unauthorized (Token expired). Redirecting to login...');
      if (isPackage) {
        Get.back();
      }
      onTokenExpire(context);
    } else {
      if (isPackage) {
        Get.back();
      }
      // Handle other status codes
      // print('Request failed with status code: ${res.statusCode}');
    }
  } catch (e) {
    if (isPackage) {
      Get.back();
    }
    // Catch any errors during the HTTP request or processing
    // print('Error occurred while fetching or processing package data: $e');
    writeToFile(e, 'getPackageData');
  }
}

onNoInternetConnection(context, VoidCallback ontap) async {
  ArtDialogResponse? response = await ArtSweetAlert.show(
    barrierDismissible: false, // Prevent dialog dismissal by tapping outside
    context: context,
    artDialogArgs: ArtDialogArgs(
      title: "No Internet", // Title of the alert
      text: "Please check your internet connection and try again.",
      type: ArtSweetAlertType.info, // Warning alert type
      // confirmButtonText: "Retry", // Text for retry button
      // denyButtonText: "ok", // Text for cancel button
    ),
  );

  // Handle the user's response to the alert
  if (response != null && response.isTapConfirmButton) {
    // Attempt to retry or refresh the internet-dependent action
    // retryInternetConnection(context);
  } else {
    // Optionally handle cancel action
    // print("User chose to cancel.");
  }
}

Future unUploadedMcQHistoryInfoInsert(
    context, List mcqHistoryList, String token) async {
  // print("$mcqHistoryList lllllllllll");
  // loader(context);
  try {
    Map data = {"MCQExamHistory": mcqHistoryList};

    final res = await http.post(
      Uri.https(
        ClsUrlApi.mainurl,
        ClsUrlApi.insertMCQHistory,
      ),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
    );

    var jsondata = jsonDecode(res.body);

    if (jsondata['isSuccess'] == true) {
      updateTblMCQhistoryForUploadFlag();
      // log("sucessfulli insert  mcq history ${res.statusCode}");
      // log(res.body);
      return true;

      // Get.back();
    } else {
      ClsErrorMsg.fnErrorDialog(
          context,
          'mcq insert',
          jsondata['errorMessages']
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "") +
              "${res.statusCode}",
          "");
      return false;
      //
      // Get.back();
    }
  } catch (e) {
    ClsErrorMsg.fnErrorDialog(context, 'mcq insert',
        e.toString().replaceAll("[", "").replaceAll("]", ""), "");
    writeToFile(e, 'formatTimestamp');
    // Get.back();
    return false;
  }
}

Future<void> getMCQExamHistory(
  BuildContext context,
  String token,
) async {
  try {
    Map obj = {};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getMCQExamHistory),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // // print(res.body);

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> result = jsonDecode(response['result']);

      // Check if the result list is not empty
      if (result.isNotEmpty) {
        deleteMCQHistroyTable();
        // Loop through all the records in the result list and insert each one
        for (var examData in result) {
          Map<String, dynamic> exam = Map<String, dynamic>.from(examData);

// Prepare the data for insertion into your table
          Map<String, dynamic> dataForInsert = {
            'MCQHistoryId': exam['MCQHistoryId'],
            'ExamId': exam['ExamId'],
            'ExamType': exam['ExamType'],
            'ExamName': exam['ExamName'],
            'SubmitDate': exam['SubmitDate'],
            'AttemptDate': exam['AttemptDate'],
            'StudentId': exam['StudentId'],
            'FranchiseId': exam['FranchiseId'],
            'Obtainmarks': exam['Obtainmarks'] ?? 0.0, // Default to 0.0 if null
          };
          inserTblMCQhistory(
              exam['ExamId'].toString(),
              exam['ExamType'],
              exam['ExamName'],
              exam['Obtainmarks'].toString(),
              exam['SubmitDate'].toString(),
              exam['AttemptDate'].toString(),
              "1");
        }

        ; // Return success after all records are inserted
      } else {
        // Return no data status if result list is empty
      }
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print('Error: ${res.body}////////////////// fetchmcqhistory data');
    }
  } catch (e) {
    writeToFile(e, 'getTheryExamHistoryList');
    // print("Error: $e ////////// mcqhistorydata");
  }
}

Future<void> getVideowatchHistory(
  BuildContext context,
  String token,
) async {
  try {
    Map obj = {};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getVideoWatchHistory),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // // print(res.body);

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> result = jsonDecode(response['result']);

      // Check if the result list is not empty
      if (result.isNotEmpty) {
        deleteVideoWatchHistroyTable();
        // Loop through all the records in the result list and insert each one
        for (var examData in result) {
          Map<String, dynamic> video = Map<String, dynamic>.from(examData);

          // Prepare the data for insertion into your table
          Map<String, dynamic> dataForInsert = {
            'StudentPackageHistoryId': video['StudentPackageHistoryId'],
            'VideoId': video['VideoId'],
            'StartingTimeLine': video['StartingTimeLine'],
            'Duration': video['Duration'],
            'PlayBackSpeed': video['PlayBackSpeed'],
            'StartClockTime': video['StartClockTime'],
            'PlayNo': video['PlayNo'] ?? 0,
            // Default to 0.0 if null
          };
          insertVideoplayInfo(
              video['VideoId'],
              video['StartingTimeLine'].toString(),
              video['Duration'].toString(),
              video['PlayBackSpeed'].toString(),
              video['StartClockTime'].toString(),
              video['PlayNo'] ?? 111,
              1);
          // Insert the exam data into your table
          // await insertData(dataForInsert);  // Assuming insertData is an async function

          // // print each inserted record (optional)
          // // print('Inserted VideoData :');
        }

        ; // Return success after all records are inserted
      } else {
        // Return no data status if result list is empty
      }
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print('Error: ${res.body}////////////////// fetchVideowatch data');
    }
  } catch (e) {
    writeToFile(e, 'getVideowatchHistory');
    // print("Error: $e ////////// getVideowatchHistoryyyyy");
  }
}

Future<void> getMCQhistoryResult(
  BuildContext context,
  String token,
) async {
  try {
    Map obj = {};

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getRankMcqResult),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // print(res.body);

    if (res.statusCode == 200) {
      deleteTblUserResult();
      Map<String, dynamic> response = jsonDecode(res.body);

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> result = jsonDecode(response['result']);

      // Check if the result list is not empty
      if (result.isNotEmpty) {
        deleteVideoWatchHistroyTable();
        // Loop through all the records in the result list and insert each one
        for (var examData in result) {
          Map<String, dynamic> exam = Map<String, dynamic>.from(examData);

          // Prepare the data for insertion into your table
          Map<String, dynamic> dataForInsert = {
            'MCQRankedExamDetailsId': exam['MCQRankedExamDetailsId'],
            'MCQPaperId': exam['MCQPaperId'],
            'MCQQuestionId': exam['MCQQuestionId'],
            'MCQOptionId': exam['MCQOptionId'],
            'IsCorrect': exam['IsCorrect'],
            'Marks': exam['Marks'],
            'SubmitedOn': exam['SubmitedOn'],

            // Default to 0.0 if null
          };

          inserUserTblMCQAnswer(
                  exam['MCQPaperId'].toString(),
                  exam['MCQQuestionId'].toString(),
                  getQuestionNameFromQuestionId(
                      exam['MCQQuestionId'].toString()),
                  getCorrectOptionIdList(exam['MCQQuestionId'].toString())
                      .toString(),
                  getCorrectOptionNameList(exam['MCQQuestionId'].toString())
                      .toString(),
                  exam['MCQOptionId'].toString(),
                  getOptionNamesFromOptionIdsString(
                          exam['MCQOptionId'].toString())
                      .toString(),
                  "",
                  "",
                  "")
              .then((_) {
            updateTblUserResult();
          });
// insertVideoplayInfo(exam['VideoId'],exam['StartingTimeLine'].toString(),exam['Duration'].toString(), exam['PlayBackSpeed'].toString(),exam['StartClockTime'],exam['PlayNo']);
          // Insert the exam data into your table
          // await insertData(dataForInsert);  // Assuming insertData is an async function

          // // print each inserted record (optional)
          // // print('Inserted exam data:');
        }

        ; // Return success after all records are inserted
      } else {
        // Return no data status if result list is empty
      }
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print('Error: ${res.body}////////////////// getMCQhistoryResult data');
    }
  } catch (e) {
    writeToFile(e, 'getMCQhistoryResult');
    // print("Error: $e ////////// getMCQhistoryResult");
  }
}

Future<List> getMCQRankresultForIndividual(
    BuildContext context, String token, String paperId) async {
  try {
    Map obj = {
      "MCQExamHistory": {"MCQPaperId": paperId}
    };

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getRankMcqResultforIndividual),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // print(res.body);
    List<Map<String, dynamic>> resultSetList = [];

    if (res.statusCode == 200) {
      deleteTblUserResult();
      Map<String, dynamic> response = jsonDecode(res.body);

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> result = jsonDecode(response['result']);

      // Prepare a list to store the formatted data

      // Iterate over the result to extract the required fields
      for (var question in result) {
        List<int> correctAnswerIds = [];
        List<String> correctAnswers = [];
        List<int> userSelectedAnswerIds = [];
        List<String> userSelectedAnswers = [];

        for (var option in question['AnswerOptions']) {
          if (option['IsCorrect'] == true) {
            correctAnswerIds.add(option['MCQOptionId']);
            correctAnswers.add(option['MCQOption']);
          }
          if (option['IsSelected'] == true) {
            if (option.containsKey("OneWordAnswer")) {
              userSelectedAnswers.add(option['OneWordAnswer'] ?? "Not answerd");
            } else {
              userSelectedAnswers.add(option['MCQOption']);
            }

            userSelectedAnswerIds.add(option['MCQOptionId']);
            // userSelectedAnswers.add(   option['MCQOption']);
          }
        }

        resultSetList.add({
          "questionid": question['MCQQuestionId'],
          "question name": question['MCQQuestion'],
          "correctanswerId": correctAnswerIds,
          "correctanswer": correctAnswers,
          "userselectedanswer id": userSelectedAnswerIds,
          "userselectedanswer": userSelectedAnswers.length == 0
              ? ["Not answered"]
              : userSelectedAnswers,
          "ObtainMarks": question['MarksObtain']
        });
      }
      // print(resultSetList);
      return resultSetList;

      // // print or process the resultSetList as needed
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return resultSetList;
    } else {
      return resultSetList;
    }
  } catch (e) {
    writeToFile(e, 'getMCQRankresultForIndividual');
    // print("Error: $e ////////// getMCQRankresultForIndividual");
    return [];
  }
}

Future<Map> checkMCQRankStatus(
    BuildContext context, String token, String paperId) async {
  try {
    Map obj = {
      "MCQExamHistory": {"MCQPaperId": paperId}
    };

    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.checkRankedCompetitionStatus),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Origin': origin,
      },
      body: json.encode(obj),
    );
    // print(res.body);
    Map<int, List<int>> resultSet = {};
    Map<String, dynamic> response = jsonDecode(res.body);
    // print(response['statusCode'].toString());

    if (res.statusCode == 200) {
      // deleteTblUserResult();

      // Decode the 'result' field which is a string containing a JSON array
      // List<dynamic> result = jsonDecode(response['result']);

      //     // Prepare a list to store the formatted data

      //     // Iterate over the result to extract the required fields
      //     for (var question in result) {
      //       List<int> correctAnswerIds = [];
      //       List<String> correctAnswers = [];
      //       List<int> userSelectedAnswerIds = [];
      //       List<String> userSelectedAnswers = [];

      //       for (var option in question['AnswerOptions']) {
      //         if (option['IsCorrect'] == true) {
      //           correctAnswerIds.add(option['MCQOptionId']);
      //           correctAnswers.add(option['MCQOption']);
      //         }
      //         if (option['IsSelected'] == true) {
      //           userSelectedAnswerIds.add(option['MCQOptionId']);
      //           userSelectedAnswers.add(option['MCQOption']);
      //         }
      //       }

      //       resultSetList.add({
      //         "questionid": question['MCQQuestionId'],
      //         "question name": question['MCQQuestion'],
      //         "correctanswerId": correctAnswerIds,
      //         "correctanswer": correctAnswers,
      //         "userselectedanswer id": userSelectedAnswerIds,
      //         "userselectedanswer": userSelectedAnswers.length==0?["Not answered"]:userSelectedAnswers,
      //       });
      //     }
      //  // print(resultSetList);
      //     return resultSetList;
      return {};

      // // print or process the resultSetList as needed
    } else if (response['statusCode'] == 220) {
      // Initialize variables
      double spentimeInminutes = 0.0;
      // print("Response status code is 220, processing the result...");

      // Decode the 'result' field which is a string containing a JSON array
      List<dynamic> mainResult = jsonDecode(response['result']);

      // Initialize an empty map to store the questionId and selected answer IDs
      Map<int, List<int>> resultSet = {};

      // Iterate through each main result (assume one main result item with AttemptedQuestions array)
      for (var resultItem in mainResult) {
        if (resultItem.containsKey('AttemptedQuestions')) {
          List<dynamic> attemptedQuestions = resultItem['AttemptedQuestions'];
          spentimeInminutes = resultItem['SpendedTime'];

          // Iterate through each question in the attemptedQuestions array
          for (var question in attemptedQuestions) {
            int questionId = question['MCQQuestionId'];
            // print("Processing question with ID: $questionId");

            // Initialize an empty list to store selected answer IDs for this question
            List<int> selectedAnswerIds = [];

            // Check if AnswerOptions exists and is iterable
            if (question['AnswerOptions'] is List) {
              for (var option in question['AnswerOptions']) {
                // print(
                // "Checking option: ${option['MCQOption']} with ID: ${option['MCQOptionId']}");

                // Add the MCQOptionId to the selectedAnswerIds list
                selectedAnswerIds.add(option['MCQOptionId']);
              }
            }

            // Add to resultSet if there are selected answers
            if (selectedAnswerIds.isNotEmpty) {
              // print(
              // "Selected answers for question $questionId: $selectedAnswerIds");
              resultSet[questionId] = selectedAnswerIds;
            } else {
              // print("No selected answers for question $questionId");
            }
          }
        }
      }

      // // print and return the final response
      // print("Spent time in minutes: $spentimeInminutes");
      return {
        "StatusCode": response['statusCode'],
        "IsSuccess": true,
        "ErrorMessages": response["errorMessages"]
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "UserAnswerList": resultSet,
        "RemainingTimeInSeconds": spentimeInminutes
      };
    } else if (response['statusCode'] == 400) {
      // onSweetAleartDialog(context, () {
      //   Get.back();
      // }, "Submited!", "Exam already Submited!");
      return {
        "StatusCode": res.statusCode,
        "UserAnswerList": [],
        "ErrorMessages": response["errorMessages"]
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "RemainingTimeInSeconds": 0
      };
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
      return {
        "StatusCode": res.statusCode,
        "UserAnswerList": [],
        "ErrorMessages": response["errorMessages"]
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "RemainingTimeInSeconds": 0
      };
    } else {
      // print('Error: ${res.body} ////////////////// checkMCQRankStatus  ');
      return {
        "StatusCode": res.statusCode,
        "UserAnswerList": [],
        "ErrorMessages": response["errorMessages"]
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "RemainingTimeInSeconds": 0
      };
    }
  } catch (e) {
    writeToFile(e, 'checkMCQRankStatus');
    // print("Error Exeption: $e ////////// checkMCQRankStatus");

    return {
      "StatusCode": 999,
      "UserAnswerList": [],
      "ErrorMessages":
          e.toString().toString().replaceAll("[", "").replaceAll("]", ""),
      "RemainingTimeInSeconds": 0
    };
  }
}

Future<List<SocialMediaIconModel>> getSocialMediaIcons(
  BuildContext context,
  String token,
) async {
  Map<String, dynamic> data = {};
  List<SocialMediaIconModel> resultSetList = [];

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.socialMediaIconsApi),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result']);
      // print("${result} ////////////////// get social media links");

      resultSetList =
          result.map((item) => SocialMediaIconModel.fromJson(item)).toList();
      for (var i in resultSetList) {
        await insertOrUpdateTblImages(
            i.servicesTypeName.toString(),
            i.link.toString(),
            'ImageDocumentId',
            i.icon.toString(),
            'socialmediaicons',
            'homepage',
            'bannerImagePosition',
            "");
      }

      return resultSetList;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print('Error: ${res.body} ////////////////// get social media links');
    }
  } catch (e) {
    // print("Error: $e ////////// get social media links");
    writeToFile(e, 'getSocialMediaIcons');
  }

  return resultSetList;
}

Future<List<InfiniteMarqueeModel>> getInfiniteMarqueeDetails(
  BuildContext context,
  String token,
) async {
  Map<String, dynamic> data = {};
  List<InfiniteMarqueeModel> resultSetList = [];

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getInfiniteMarqueeDetailsApi),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result']);

      // log("${result} ////////////////// get infinite marquee details");

      resultSetList =
          result.map((item) => InfiniteMarqueeModel.fromJson(item)).toList();

      // log("${resultSetList} ////////////////// get infinite marquee details");
      for (final t in resultSetList) {
        // log("${t.marqueeId} ////////////////// get infinite marquee details");
        // insertTblNotifications(
        //     DateTime.now().toString(),
        //     t.marqueeId.toString(),
        //     t.title,
        //     'NotificationBody',
        //     DateTime.now().toString(),
        //     );
      }

      return resultSetList;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print(
      // 'Error: ${res.body} ////////////////// get infinite marquee details');
    }
  } catch (e) {
    // print("Error: $e ////////// get infinite marquee details");
    writeToFile(e, 'getInfiniteMarqueeDetails');
  }

  return resultSetList;
}

// Future<List<IconModel>> getIconData(
//   BuildContext context,
//   String token,
// ) async {
//   Map<String, dynamic> data = {};
//   List<IconModel> resultSetList = [];

//   try {
//     var res = await http.post(
//       Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getIconDataApi),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(data),
//     );

//     if (res.statusCode == 200) {
//       Map<String, dynamic> response = jsonDecode(res.body);

//       List<dynamic> result = jsonDecode(response['result']);

//       // log("${result} ////////////////// get infinite marquee details");

//       resultSetList = result.map((item) => IconModel.fromJson(item)).toList();
//       // log("${resultSetList} ////////////////// get infinite marquee details");
//       log(resultSetList[0].logo);
//       // insertTblImages(
//       //   '0',
//       //   resultSetList[0].logo.toString(),
//       //   'DocumentId',
//       //   'ImageUrl',
//       //   "AppIcon",
//       //   "abc"
//       // );
//       downloadAndSaveAppIcon(resultSetList[0].logo, "appLogo.png");
//       return resultSetList;
//     } else if (res.statusCode == 401) {
//       onTokenExpire(context);
//     } else {
//       // print('Error: ${res.body} ////////////////// get Icon details');
//     }
//   } catch (e) {
//     // print("Error: $e ////////// get Icon details");
//     writeToFile(e, 'getIconData');
//   }

//   return resultSetList;
// }

Future<bool> downloadAndSaveAppIcon(String url, String fileName) async {
  try {
    // Get the application's documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create a subdirectory for storing the icon
    Directory dthLmsDir = Directory('${appDocDir.path}/$origin');

    // Ensure the directory exists
    if (!await dthLmsDir.exists()) {
      await dthLmsDir.create(recursive: true);
    }

    // Set the file path (directory + file name)
    String filePath = '${dthLmsDir.path}/$fileName';

    // Save the path to SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("DefaultDownloadpathOfAppIcon", dthLmsDir.path);

    // Use Dio to download the file
    Dio dio = Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          // log('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );

    // log('Icon downloaded and saved to: $filePath');
    // logopath = filePath;
    // log(logopath);
    return true;
  } catch (e) {
    writeToFile(e, "downloadAndSaveAppIcon");
    log('Error downloading or saving the AppIcon: $e');
    writeToFile(e, 'downloadAndSaveAppIcon');
    return false;
  }
}

Future<List> getNotificationDetails(
  BuildContext context,
  String token,
) async {
  Map<String, dynamic> data = {};
  List resultSetList = [];

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getNotificationsDetailsApi),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      List<dynamic> result = jsonDecode(response['result']);

      // log("${result} ////////////////// get Notifications details");

      // resultSetList = result.map((item) => IconModel.fromJson(item)).toList();
      // log("${resultSetList} ////////////////// get infinite marquee details");
      for (var notification in result) {
        // Check for null values before using them
        String imgPath = await downloadNotificationImageAndSave(
            notification['NotificationImageUrl'] ?? '');
        imgPath = imgPath.replaceAll('/', '\\');

        insertOrUpdateTblNotifications(
          notification['StartTime']?.toString() ?? '',
          notification['id']?.toString() ?? '',
          notification['Title']?.toString() ?? '',
          notification['Description']?.toString() ?? '',
          notification['EndTime']?.toString() ?? '',
          imgPath,
        );
      }

      return resultSetList;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print(
      // 'Error: ${res.body} ////////////////// get Notifications details 401');
    }
  } catch (e) {
    // print("Error: $e ////////// get Notifications details exception");
    writeToFile(e, 'getNotificationDetails');
  }

  return resultSetList;
}

Future<String> downloadNotificationImageAndSave(String documentUrl) async {
  try {
    // Ensure the URL is not empty or null
    if (documentUrl.isEmpty) {
      // print('URL is empty');
      return '';
    }

    final fileName = documentUrl.split('/').last;

    // Get the application's document directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create the folder structure: com.si.dthLive/BannerImages
    Directory dthLmsDir = Directory('${appDocDir.path}/$origin');
    Directory notificationImagesDir =
        Directory('${dthLmsDir.path}/NotificationImages');

    if (!await notificationImagesDir.exists()) {
      await notificationImagesDir.create(recursive: true);
      // print(
      // 'NotificationImages directory created at ${notificationImagesDir.path}');
    }

    // Save the path in SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    getx.defaultPathForDownloadFile.value = dthLmsDir.path;
    prefs.setString(
        "downloadNotificationImageAndSave", notificationImagesDir.path);

    // Construct the file path
    String filePath = '${notificationImagesDir.path}/$fileName';

    // Initialize Dio
    final dio = Dio();

    // Check if fileName is valid
    if (fileName.isEmpty) {
      // print('Failed to extract file name from URL');
      return '';
    }

    // Download the file
    // print('Downloading banner from: $documentUrl');
    await dio.download(
      documentUrl,
      filePath,
      options: Options(responseType: ResponseType.bytes),
    );

    // Verify if the file exists
    final file = File(filePath);
    if (await file.exists()) {
      // print('File saved successfully at: $filePath');
      return filePath;
    } else {
      // print('File download failed: $filePath does not exist.');
      return '';
    }
  } catch (e) {
    // Log and rethrow the error
    // print('Error downloading banner: $e');
    rethrow;
  }
}

Future<bool> requestForRecheckAnswerSheet(
    BuildContext context, String token, String examid, String reson) async {
  Map<String, dynamic> data = {
    "ExamId": examid,
    "ReviewReason": reson,
  };
  bool returnValue = false;

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.answerSheetRecheckRequestForTest),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      var result = jsonDecode(response['result']);

      // log("${result} ////////////////// get infinite marquee details");

      returnValue = true;

      return true;
    } else if (res.statusCode == 401) {
      onTokenExpire(context);
    } else {
      // print('Error: ${res.body} ////////////////// recheckAnswerSheet');
    }
  } catch (e) {
    // print("Error: $e ////////// get recheckAnswerSheet");
    writeToFile(e, 'recheckAnswerSheet');
  }
  return returnValue;
}

Future<String> getAnswerSheetURLforStudent(
  BuildContext context,
  String token,
  String examid,
) async {
  loader(context);
  Map<String, dynamic> data = {"ExamId": examid};
  String returnValue = "";

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.getanswerSheetUrlOfStudent),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    print(res.body);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      var result = jsonDecode(response['result']);

      // log("${result} ////////////////// get infinite marquee details");

      returnValue = result.toString();
      Get.back();

      return result.toString();
    } else if (res.statusCode == 401) {
      Get.back();
      onTokenExpire(context);
    } else {
      Get.back();
      // print('Error: ${res.body} ////////////////// getAnswerSheetURLforStudent');
    }
  } catch (e) {
    Get.back();
    // print("Error: $e ////////// get getAnswerSheetURLforStudent");
    writeToFile(e, 'getAnswerSheetURLforStudent');
  }
  return returnValue;
}

Future<bool> uploadStudentFeedBack(
  BuildContext context,
  String token,
  String feedBackList,
) async {
  loader(context);
  Map<String, dynamic> data = {"ExamId": feedBackList};

  try {
    var res = await http.post(
      Uri.https(ClsUrlApi.mainurl, ClsUrlApi.uploadStudentFeedback),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    print(res.body);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);

      var result = jsonDecode(response['result']);

      // log("${result} ////////////////// get infinite marquee details");

      Get.back();

      return true;
    } else if (res.statusCode == 401) {
      Get.back();
      onTokenExpire(context);
    } else {
      Get.back();
      // print('Error: ${res.body} ////////////////// getAnswerSheetURLforStudent');
    }
  } catch (e) {
    Get.back();
    // print("Error: $e ////////// get getAnswerSheetURLforStudent");
    writeToFile(e, 'uploadStudentFeedBack');
  }
  return false;
}

appVersionGet() async {
  try {
    pinfo.PackageInfo packageInfo = await pinfo.PackageInfo.fromPlatform();

    getx.appVersion.value = packageInfo.version;
  } catch (e) {
    writeToFile(e, "appVersionGet");
  }
}
