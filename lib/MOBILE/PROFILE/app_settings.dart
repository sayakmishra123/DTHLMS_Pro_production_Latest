import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsAndroid extends StatefulWidget {
  const AppSettingsAndroid({super.key});

  @override
  State<AppSettingsAndroid> createState() => _AppSettingsAndroidState();
}

class _AppSettingsAndroidState extends State<AppSettingsAndroid> {
  TextEditingController videoDownloadPath = TextEditingController();
  TextEditingController pdfDownloadPath = TextEditingController();

  Getx getx = Get.put(Getx());

  Future<void> _pickVideoPath() async {
    final String? selectedDirectory = await getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        videoDownloadPath.text = selectedDirectory;
        getx.userSelectedPathForDownloadVideo.value = selectedDirectory;
        FlutterToastr.show("Saved!", context);
      });
    }
  }

  Future<void> _pickPdfPath() async {
    final String? selectedDirectory = await getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        pdfDownloadPath.text = selectedDirectory;
        getx.userSelectedPathForDownloadFile.value = selectedDirectory;
        FlutterToastr.show("Saved!", context);
      });
    }
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restore Default Settings'),
          content:
              Text('Are you sure you want to restore to default settings?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _restoreToDefaultPaths();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _restoreToDefaultPaths() async {
    var prefs = await SharedPreferences.getInstance();

    videoDownloadPath.text = prefs.getString("DefaultDownloadpathOfVieo") ?? '';
    pdfDownloadPath.text = prefs.getString("DefaultDownloadpathOfFile") ?? '';
  }

  _getPaths() async {
    try {
      var prefs = await SharedPreferences.getInstance();

      // Retrieve the saved paths from SharedPreferences
      String? videoPath = prefs.getString('SelectedDownloadPathOfVieo') != null
          ? prefs.getString('SelectedDownloadPathOfVieo')
          : prefs.getString("DefaultDownloadpathOfVieo");
      String? filePath = prefs.getString('SelectedDownloadPathOfFile') != null
          ? prefs.getString('SelectedDownloadPathOfFile')
          : prefs.getString("DefaultDownloadpathOfFile");

      // Check if the retrieved paths are not null and update the TextEditingControllers
      setState(() {
        if (videoPath != null) {
          videoDownloadPath.text =
              videoPath; // Set the value to the video download path controller
        }
        if (filePath != null) {
          pdfDownloadPath.text =
              filePath; // Set the value to the PDF download path controller
        }
      });
    } catch (e) {
      writeToFile(e,"_getPaths" );
      print("path noy found:$e");
    }
  }

  @override
  void initState() {
    _getPaths();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings_backup_restore_rounded),
              onPressed: () {
                _showRestoreDialog(context);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //   Row(
            //   children: [
            //     Text(
            //       'App Settings',
            //       style: styleb.copyWith(
            //           color: const Color.fromARGB(255, 68, 68, 68)),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20,),
            Row(
              children: [
                Text(
                  'Video Download Path',
                  style: FontFamily.styleb.copyWith(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 68, 68, 68)),
                ),
              ],
            ),
            TextFormField(
              readOnly: true, // Prevent manual editing
              onTap: _pickVideoPath, // Open folder picker on tap
              decoration: InputDecoration(
                hintText: 'Select Video Download Path',
                suffixIcon: Icon(
                  Icons.folder,
                  color: Colors.grey[600],
                ),
                hintStyle:
                    FontFamily.style.copyWith(fontSize: 15, color: Colors.grey),
              ),
              controller: videoDownloadPath, // Display the selected path
            ),
            SizedBox(height: 20), // Add spacing between fields
            Row(
              children: [
                Text(
                  'PDF Download Path',
                  style: FontFamily.styleb.copyWith(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 68, 68, 68)),
                ),
              ],
            ),
            TextFormField(
              readOnly: true, // Prevent manual editing
              onTap: _pickPdfPath, // Open folder picker on tap
              decoration: InputDecoration(
                hintText: 'Select PDF Download Path',
                suffixIcon: Icon(
                  Icons.folder,
                  color: Colors.grey[600],
                ),
                hintStyle:
                    FontFamily.style.copyWith(fontSize: 15, color: Colors.grey),
              ),
              controller: pdfDownloadPath, // Display the selected path
            ),
            Expanded(child: SizedBox()),
            //     Row(
            //   children: [
            //     Expanded(
            //       child: MaterialButton(
            //         shape: ContinuousRectangleBorder(
            //             borderRadius: BorderRadius.circular(20)),
            //         height: 50,
            //         color: ColorPage.mainBlue,
            //         onPressed: () {},
            //         child: Text(
            //           'Save',
            //           style:
            //               FontFamily.style.copyWith(color: Colors.white, fontSize: 15),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
