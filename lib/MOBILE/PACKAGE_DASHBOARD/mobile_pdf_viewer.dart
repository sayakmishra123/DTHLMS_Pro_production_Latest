import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/EditPdf/pdf_edit.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/STUDYMATERIAL/pdfViewer.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../constants.dart';

Uint8List aesDecryptPdf(Uint8List encryptedData, String key) {
  try {
    print(key + " this is en key");
    final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
    final iv = encrypt.IV(encryptedData.sublist(0, 16)); // Extract IV
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encryptedBytes =
        encryptedData.sublist(16); // Extract actual encrypted data
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
    print("succesfully decrypted");

    return Uint8List.fromList(decrypted);
  } catch (e) {
    writeToFile(e, 'aesDecryptPdf');
    return Uint8List.fromList([0]);
  }
}

Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
  final file = File(filePath);
  return file.readAsBytes();
}

class ShowChapterPDFMobile extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String folderName;
  final bool isEncrypted;

  const ShowChapterPDFMobile(
      {required this.pdfUrl,
      required this.title,
      required this.folderName,
      required this.isEncrypted,
      Key? key})
      : super(key: key);

  @override
  _ShowChapterPDFMobileState createState() => _ShowChapterPDFMobileState();
}

class _ShowChapterPDFMobileState extends State<ShowChapterPDFMobile> {
  Getx getx = Get.put(Getx());
  final PdfViewerController _pdfViewerController = PdfViewerController();
  // State variable to store decrypted PDF bytes
  bool isLoading = true; // State variable to indicate loading state
  bool hasError = false; // State variable to indicate error state

  @override
  void initState() {
    super.initState();
    getPdf(getEncryptionKeyFromTblSetting('EncryptionKey')).whenComplete(() {
      setState(() {});
    });
    print('books page encrypted or not shubha ${widget.isEncrypted}');
  }

  Future getPdf(String enkey) async {
    print("calling decrypt function");
    if (widget.isEncrypted) {
      getx.encryptedpdffile.value = await downloadAndSavePdf(
          widget.pdfUrl, widget.title, enkey, widget.folderName);
    } else {
      getx.unEncryptedPDFfile.value = await downloadAndSavePdf(
          widget.pdfUrl, widget.title, enkey, widget.folderName);
    }
  }

  double _currentZoomLevel = 1.0;

  void _zoomIn() {
    setState(() {
      if (_currentZoomLevel < 3.0) {
        // Limit the maximum zoom level
        _currentZoomLevel += 0.25;
        _pdfViewerController.zoomLevel = _currentZoomLevel;
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_currentZoomLevel > 1.0) {
        // Limit the minimum zoom level
        _currentZoomLevel -= 0.25;
        _pdfViewerController.zoomLevel = _currentZoomLevel;
      }
    });
  }

  Future<String> selectSaveLocation() async {
    try {
      // Open a directory picker
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        // Construct the full file path with the file name
        // String filePath = '$selectedDirectory/$fileName';
        print('User selected directory: $selectedDirectory');
        return selectedDirectory;
      } else {
        // User canceled the picker
        print('No directory selected');
        return "";
      }
    } catch (e) {
      print('Error selecting directory: $e');
      return "";
    }
  }

  String data = "";
  String title = "";
  void onSaveButtonPressed(BuildContext context) async {
    // Let the user select the path
    String userSelectedPath = await selectSaveLocation();

    if (userSelectedPath != "") {
      // Check if the selected path exists
      Directory selectedDir = Directory(userSelectedPath);
      if (await selectedDir.exists()) {
        try {
          // The downloaded file path from GetX
          this.data = getx.unEncryptedPDFfile.value;

          // Extract the file name from the downloaded file path
          this.title = this.data.split(Platform.pathSeparator).last;

          // Create the new file path in the user-selected directory
          String newFilePath =
              "$userSelectedPath${Platform.pathSeparator}${this.title}";

          // Copy the file to the new location
          File downloadedFile = File(this.data);
          if (await downloadedFile.exists()) {
            await downloadedFile.copy(newFilePath);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                'File saved successfully to: $newFilePath',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            );
          } else {
            // Show error message if the downloaded file does not exist
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: Downloaded file does not exist.')),
            );
          }
        } catch (e) {
          // Show error message for any exceptions
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Error saving file: $e')),
          // );
        }
      } else {
        // Show error message if the selected directory does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: The selected directory does not exist.')),
        );
      }
    } else {
      // Show message if no path was selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No path selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEncrypted
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: FontFamily.styleb,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: _zoomOut, // Zoom out functionality
                ),
                IconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: _zoomIn, // Zoom in functionality
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate to the previous page
                    _pdfViewerController.previousPage();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Navigate to the next page
                    _pdfViewerController.nextPage();
                  },
                ),
              ],
            ),
            body: Stack(children: [
              Row(
                children: [
                  // Left list part
                  // Platform.isAndroid
                  //     ? SizedBox()
                  //     : Expanded(
                  //         flex: 2,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Container(
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(20),
                  //                   color: Colors.white),
                  //               child: PdfLeftList()),
                  //         )),

                  // Right PDF viewer part
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isLoading)
                                  Center(
                                      child:
                                          CircularProgressIndicator()) // Loading indicator
                                else if (hasError)
                                  Center(
                                    child: Text(
                                      'Something went wrong while loading the PDF.',
                                      style: FontFamily.style.copyWith(
                                          color: Colors.red, fontSize: 16),
                                    ),
                                  ) // Error message
                                else
                                  Expanded(
                                      child: Obx(
                                    () => SfPdfViewer.memory(
                                        enableDoubleTapZooming: true,
                                        pageSpacing: 20,
                                        controller: _pdfViewerController,
                                        getx.encryptedpdffile.value!),
                                  )),
                              ],
                            ))
                            // Display PDF
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              !widget.isEncrypted
                  ? Positioned(
                      bottom: 40,
                      right: 40,
                      child: FloatingActionButton(
                        tooltip: 'Download Paper',
                        backgroundColor: Colors.indigo,
                        onPressed: () {
                          onSaveButtonPressed(context);
                        },
                        child: Icon(
                          FontAwesome.download,
                          color: Colors.white,
                        ),
                      ))
                  : SizedBox()
            ]),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                '${widget.title}',
                style: FontFamily.styleb,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // log(widget.pdfUrl + "      $data ");
                    Get.to(() => ImageEditorExample(
                          pdfName: this.title,
                          pdfPath: this.data,
                        ));
                  }, // Zoom out functionality
                ),
                IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: _zoomOut, // Zoom out functionality
                ),
                IconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: _zoomIn, // Zoom in functionality
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate to the previous page
                    _pdfViewerController.previousPage();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Navigate to the next page
                    _pdfViewerController.nextPage();
                  },
                ),
              ],
            ),
            body: Obx(
              () => File(getx.unEncryptedPDFfile.value).existsSync()
                  ? SfPdfViewer.file(
                      File(getx.unEncryptedPDFfile.value),
                      controller: _pdfViewerController,
                    )
                  : Center(
                      child: Text("Something went Wrong"),
                    ),
            ));
  }

  Future downloadAndSavePdf(
      String pdfUrl, String title, String enkey, String foldername) async {
    this.title = title;
    this.data = getDownloadedPathOfPDF(title, foldername);
    print(data);

    //  String enkey=await  getEncryptionKey(getx.loginuserdata[0].token);
    if (!File(data).existsSync()) {
      print("downloaing file.....");
      try {
        // Get the application's document directory
        Directory appDocDir = await getApplicationDocumentsDirectory();

        // Create the folder structure: com.si.dthLive/notes
        Directory dthLmsDir = Directory('${appDocDir.path}/$origin');
        if (!await dthLmsDir.exists()) {
          await dthLmsDir.create(recursive: true);
        }
        var prefs = await SharedPreferences.getInstance();
        getx.defaultPathForDownloadFile.value = dthLmsDir.path;
        prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

        // Correct file path to save the PDF
        String filePath = getx.userSelectedPathForDownloadFile.value.isEmpty
            ? '${dthLmsDir.path}/$foldername/$title'
            : getx.userSelectedPathForDownloadFile.value +
                "/$foldername/$title"; // Make sure to add .pdf extension if needed

        // Download the PDF using Dio
        Dio dio = Dio();
        await dio.download(pdfUrl, filePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        });

        await ShowChapterPDFState.addWatermarkToPdf(
            filePath,
            getx.loginuserdata[0].firstName +
                " " +
                getx.loginuserdata[0].lastName,
            getx.loginuserdata[0].phoneNumber,
            getx.loginuserdata[0].email);

        print('PDF downloaded and saved to: $filePath');

        if (widget.isEncrypted) {
          final encryptedBytes = await readEncryptedPdfFromFile(filePath);
          final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, enkey);
          isLoading = false;
          return decryptedPdfBytes;
        } else {
          return filePath;
        }
      } catch (e) {
        writeToFile(e, "downloadAndSavePdf");
        print('Error downloading or saving the PDF: $e');
        isLoading = false;
        return widget.isEncrypted ? Uint8List(0) : "";
      }
    } else {
      if (widget.isEncrypted) {
        final encryptedBytes = await readEncryptedPdfFromFile(data);
        final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, enkey);
        isLoading = false;
        return decryptedPdfBytes;
      } else {
        return data;
      }
    }
  }
}
