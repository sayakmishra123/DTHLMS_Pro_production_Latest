import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MOBILE/resultpage/test_result_mobile.dart';

class Downloadsheet {
  CancelToken cancelToken = CancelToken();
  Getx getx = Get.put(Getx());
  double downloadProgress = 0.0;

  Future<void> downloadAnswerSheet(String url, String examId,
      {String examName = "", BuildContext? context}) async {
    Dio dio = Dio();

    // Determine the appropriate directory based on platform
    Directory appDocDir;
    if (Platform.isAndroid || Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isMacOS) {
      appDocDir = await getApplicationSupportDirectory();
    } else {
      appDocDir = await getApplicationDocumentsDirectory();
    }

    String directorySeparator = Platform.pathSeparator;
    Directory dthLmsDir =
        Directory('${appDocDir.path}$directorySeparator$origin');

    // Ensure the directory exists
    if (!await dthLmsDir.exists()) {
      await dthLmsDir.create(recursive: true);
    }

    // Save the default download path
    var prefs = await SharedPreferences.getInstance();
    getx.defaultPathForDownloadFile.value = dthLmsDir.path;
    prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

    // Construct the file path
    String filePath = getx.userSelectedPathForDownloadFile.value.isEmpty
        ? '${dthLmsDir.path}$directorySeparator$examId $examName.pdf'
        : '${getx.userSelectedPathForDownloadFile.value}$directorySeparator$examId $examName.pdf';

    if (filePath.isEmpty) {
      debugPrint("No file path selected. Cancelling download.");
      return;
    }

    try {
      getx.isDownloading.value = true;

      // Start downloading the file
      await dio.download(
        url.replaceAll('"', ''),
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = received / total;
          }
        },
        cancelToken: cancelToken,
      );

      getx.isDownloading.value = false;
      debugPrint("Download complete: $filePath");

      // Show download complete dialog
      if (context != null) {
        showDownloadCompleteDialog(examName, examId, context);
      }
    } catch (e) {
      getx.isDownloading.value = false;
      debugPrint("Error downloading file: $e");
    }
  }

  
  
  void cancelDownload() {
    cancelToken.cancel();
    getx.isDownloading.value = false;
  }

  void showDownloadCompleteDialog(String examName, String examId, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Download Complete"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("The answer sheet has been downloaded."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.off(() => ShowResultPage(
                      filePath: getx.userSelectedPathForDownloadFile.value.isEmpty
                          ? '${getx.defaultPathForDownloadFile.value}${Platform.pathSeparator}$examId $examName.pdf'
                          : '${getx.userSelectedPathForDownloadFile.value}${Platform.pathSeparator}$examId $examName.pdf',
                      isnet: false,
                    ));
              },
              child: Text("Show Sheet"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
