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

    // Get the application documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Set the path based on platform
    String directorySeparator = Platform.isWindows ? '\\' : '/';
    Directory dthLmsDir =
        Directory('${appDocDir.path}$directorySeparator$origin');

    // Check if the directory exists, if not, create it
    if (!await dthLmsDir.exists()) {
      await dthLmsDir.create(recursive: true);
    }

    // Get the SharedPreferences instance to save the path
    var prefs = await SharedPreferences.getInstance();
    getx.defaultPathForDownloadFile.value = dthLmsDir.path;
    prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

    // Set the file path for download based on user preferences and platform
    String filePath = getx.userSelectedPathForDownloadFile.value.isEmpty
        ? '${dthLmsDir.path}$directorySeparator$examId $examName'
        : getx.userSelectedPathForDownloadFile.value +
            "$directorySeparator$examId $examName";

    if (filePath.isEmpty) {
      debugPrint("No file path selected. Cancelling download.");
      return;
    }

    try {
      getx.isDownloading.value = true;

      // Start the download
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
      showDownloadCompleteDialog(examName, examId, context);
    } catch (e) {
      getx.isDownloading.value = false;
      debugPrint("Error downloading file: $e");
      // Optionally show error dialog
      // showErrorDialog("Download Failed", "An error occurred while downloading the file.");
    }
  }

  void cancelDownload() {
    cancelToken.cancel();
    // setState(() {
    getx.isDownloading.value = false;
    // });
  }

  void showDownloadCompleteDialog(String examName, examId, context) {
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
                // Navigator.of(context).pop();
                Get.off(() => ShowResultPage(
                      filePath: getx
                              .userSelectedPathForDownloadFile.value.isEmpty
                          ? '${getx.defaultPathForDownloadFile.value}\\${examId} $examName'
                          : getx.userSelectedPathForDownloadFile.value +
                              "/${examId} $examName",
                      // filePath: downloadedFilePath,
                      isnet: false,
                    ));
                // showPdfDialog(downloadedFilePath);
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
