import 'dart:typed_data';
import 'dart:io';
// import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;

class ShowQuestionPaper extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final bool isEncrypted;

  const ShowQuestionPaper(
      {required this.pdfUrl,
      required this.title,
      Key? key,
      required this.isEncrypted})
      : super(key: key);

  @override
  _ShowQuestionPaperState createState() => _ShowQuestionPaperState();
}

class _ShowQuestionPaperState extends State<ShowQuestionPaper> {
  Getx getx = Get.put(Getx());
  // State variable to store decrypted PDF bytes
  bool isLoading = true; // State variable to indicate loading state
  bool hasError = false; // State variable to indicate error state

  String encryptionKey = '';

  @override
  void initState() {
    encryptionKey = getEncryptionKeyFromTblSetting('EncryptionKey');
    // getPdf();
    print(widget.pdfUrl);
    super.initState();
  }

  // Future getPdf() async {
  //   if (widget.isEncrypted == true) {
  //     getx.encryptedQuestionPaperfile.value =
  //         await downloadAndSavePdf(widget.pdfUrl, widget.isEncrypted);
  //   } else {
  //     getx.unEncryptedQuestionPaperfile.value =
  //         await downloadAndSavePdf(widget.pdfUrl, widget.isEncrypted);
  //   }
  // }

  // String getDownloadedPathOfPDFfileofVideo(String name, String folderName) {
  //   // Get the first result

  //   final downloadedPath = getx.userSelectedPathForDownloadFile.isEmpty
  //       ? getx.defaultPathForDownloadFile.value + '\\$folderName\\' + name
  //       : getx.userSelectedPathForDownloadFile.value + '\\$folderName\\' + name;

  //   print('downloadpath : $downloadedPath');

  //   if (downloadedPath != '0') {
  //     return downloadedPath;
  //   }
  //   return '0';
  // }

  Future downloadAndSavePdf(
    String pdfUrl,
    bool isEncrypted,
  ) async {
    try {
      // Get the application's document directory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Create the folder structure: com.si.dthLive/notes
      Directory dthLmsDir = Directory('${appDocDir.path}\\$origin');
      if (!await dthLmsDir.exists()) {
        await dthLmsDir.create(recursive: true);
      }
      getx.defaultPathForDownloadFile.value = dthLmsDir.path;

      // Extract the actual file name from the URL
      String fileName = path.basename(pdfUrl);

      // Correct file path to save the PDF with its actual name
      String filePath = path.join(dthLmsDir.path, fileName);

      // Download the PDF using Dio
      Dio dio = Dio();
      await dio.download(pdfUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      });

      print('PDF downloaded and saved to: $filePath');
      // getx.pdfFilePath.value = filePath;

      if (isEncrypted) {
        final encryptedBytes = await readEncryptedPdfFromFile(filePath);
        final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, encryptionKey);

        return decryptedPdfBytes;
      } else {
        getx.unEncryptedPDFfile.value = filePath;
        return filePath;
      }
    } catch (e) {
      writeToFile(e, "downloadAndSaveQuestionPaper");
      print('Error downloading or saving the QuestionPaper: $e');
      return isEncrypted == true ? Uint8List(0) : '';
    }
  }

  Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
    final file = File(filePath);
    return file.readAsBytes();
  }

  Uint8List aesDecryptPdf(Uint8List encryptedData, String key) {
    final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
    final iv = encrypt.IV(encryptedData.sublist(0, 16)); // Extract IV
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encryptedBytes =
        encryptedData.sublist(16); // Extract actual encrypted data
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    return Uint8List.fromList(decrypted);
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

  void onSaveButtonPressed(BuildContext context) async {
    // Let the user select the path
    String userSelectedPath = await selectSaveLocation();

    if (userSelectedPath != "") {
      // Check if the selected path exists
      Directory selectedDir = Directory(userSelectedPath);
      if (await selectedDir.exists()) {
        try {
          // The downloaded file path from GetX
          String downloadedFilePath = getx.unEncryptedPDFfile.value;

          // Extract the file name from the downloaded file path
          String fileName =
              downloadedFilePath.split(Platform.pathSeparator).last;

          // Create the new file path in the user-selected directory
          String newFilePath =
              "$userSelectedPath${Platform.pathSeparator}$fileName";

          // Copy the file to the new location
          File downloadedFile = File(downloadedFilePath);
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
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.pdfUrl.isEmpty)
                    Center(
                      child: Text(
                        'Something went wrong while loading the PDF.',
                        style: FontFamily.style
                            .copyWith(color: Colors.red, fontSize: 16),
                      ),
                    ) // Error message
                  else
                    Expanded(
                      child:
                          //  widget.isEncrypted == true
                          //     ? getx.encryptedQuestionPaperfile.value.isNotEmpty
                          //         ? SfPdfViewer.memory(
                          //             getx.encryptedQuestionPaperfile.value)
                          //         : Center(child: CircularProgressIndicator())
                          //     :
                          FutureBuilder(
                              future: downloadAndSavePdf(
                                  widget.pdfUrl, widget.isEncrypted),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return widget.isEncrypted
                                      ? Obx(() => SfPdfViewer.memory(getx
                                          .encryptedQuestionPaperfile.value))
                                      : SfPdfViewer.file(File(snapshot.data));
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                    ),
                ],
              ))
              // Display PDF
            ],
          ),
        ),
      ),
      !widget.isEncrypted
          ? Positioned(
              bottom: 100,
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
    ]);
  }
}

// new added

// class Pdf extends StatefulWidget {
//   const Pdf({super.key});

//   @override
//   State<Pdf> createState() => _PdfState();
// }

// class _PdfState extends State<Pdf> with SingleTickerProviderStateMixin {
//   String encryptionKey = '';
//   late TabController _tabController;

//   @override
//   void initState() {
//     // encryptionKey = getEncryptionKeyFromTblSetting();
//     _tabController = TabController(
//       length: getx.pdfListOfVideo.length, // Number of tabs
//       vsync: this,
//     );

//     // Set up a listener to handle tab changes
//     // _tabController.addListener(() {
//     //   if (_tabController.indexIsChanging) {
//     //     getPdf(_tabController.index).whenComplete(() {

//     //       setState(() {

//     //       });
//     //     });
//     //   }
//     // });

//     // getPdf(0);
//     super.initState();
//   }

//   Future getPdf(int index) async {
//     if (getx.pdfListOfVideo.isNotEmpty) {
//       // print("////////////////////////////////////////////////////////////////"+getx.pdfListOfVideo.length.toString());
//       final pdfDetails = getx.pdfListOfVideo[index];
//       if (pdfDetails['Encrypted'].toString() == "true") {
//         getx.encryptedpdffile.value = await downloadAndSavePdf(
//             pdfDetails['DocumentURL'],
//             pdfDetails['Names'],
//             pdfDetails['PackageId'],
//             pdfDetails['DocumentId'],
//             pdfDetails['VideoId'],
//             pdfDetails['Catagory'],
//             pdfDetails['Encrypted']);
//       } else {
//         getx.unEncryptedPDFfile.value = await downloadAndSavePdf(
//             pdfDetails['DocumentURL'],
//             pdfDetails['Names'],
//             pdfDetails['PackageId'],
//             pdfDetails['DocumentId'],
//             pdfDetails['VideoId'],
//             pdfDetails['Catagory'],
//             pdfDetails['Encrypted']);
//       }
//     } 
//   }

//   String getDownloadedPathOfPDFfileofVideo(String name, String folderName) {
//     // Get the first result

//     final downloadedPath = getx.userSelectedPathForDownloadFile.isEmpty
//         ? getx.defaultPathForDownloadFile.value + '\\$folderName\\' + name
//         : getx.userSelectedPathForDownloadFile.value + '\\$folderName\\' + name;

//     print('downloadpath : $downloadedPath');

//     if (downloadedPath != '0') {
//       return downloadedPath;
//     }
//     return '0';
//   }

//   Future downloadAndSavePdf(String pdfUrl, String title, String packageId,
//       String documentId, String fileId, String type, String isEncrypted) async {
//     final data = getDownloadedPathOfPDFfileofVideo(title, "notes");
//     print(data);

//     if (!File(data).existsSync()) {
//       try {
//         // Get the application's document directory
//         Directory appDocDir = await getApplicationDocumentsDirectory();

//         // Create the folder structure: com.si.dthLive/notes
//         Directory dthLmsDir = Directory('${appDocDir.path}\\$origin');
//         if (!await dthLmsDir.exists()) {
//           await dthLmsDir.create(recursive: true);
//         }
//         var prefs = await SharedPreferences.getInstance();
//         getx.defaultPathForDownloadFile.value = dthLmsDir.path;
//         prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

//         // Correct file path to save the PDF
//         String filePath = getx.userSelectedPathForDownloadFile.isEmpty
//             ? '${dthLmsDir.path}\\notes\\$title'
//             : getx.userSelectedPathForDownloadFile.value +
//                 "\\notes\\$title"; // Make sure to add .pdf extension if needed

//         // Download the PDF using Dio
//         Dio dio = Dio();
//         await dio.download(pdfUrl, filePath,
//             onReceiveProgress: (received, total) {
//           if (total != -1) {
//             print(
//                 'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
//           }
//         });
//         insertDownloadedFileDataOfVideo(
//             packageId, fileId, documentId, filePath, type, title);
//         insertPdfDownloadPath(fileId, packageId, filePath, documentId, context);

//         print('PDF downloaded and saved to: $filePath');
//         getx.pdfFilePath.value = filePath;
//         if (isEncrypted.toString() == "true") {
//           final encryptedBytes = await readEncryptedPdfFromFile(filePath);
//           final decryptedPdfBytes =
//               aesDecryptPdf(encryptedBytes, encryptionKey);

//           return decryptedPdfBytes;
//         } else {
//           return filePath;
//         }
//       } catch (e) {
//         writeToFile(e, "downloadAndSavePdf");
//         print('Error downloading or saving the PDF: $e');
//         return isEncrypted == "true" ? Uint8List(0) : ''; 
//       }
//     } else {
//       if (isEncrypted == "true") {
//         getx.pdfFilePath.value = data;

//         final encryptedBytes = await readEncryptedPdfFromFile(data);
//         final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, encryptionKey);
//         return decryptedPdfBytes;
//       } else {
//         return data;
//       }
//     }
//   }

//   Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
//     final file = File(filePath);
//     return file.readAsBytes();
//   }

//   Uint8List aesDecryptPdf(Uint8List encryptedData, String key) {
//     final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
//     final iv = encrypt.IV(encryptedData.sublist(0, 16)); // Extract IV
//     final encrypter =
//         encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

//     final encryptedBytes =
//         encryptedData.sublist(16); // Extract actual encrypted data
//     final decrypted =
//         encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

//     return Uint8List.fromList(decrypted);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.9,
//       child: Column(
//         children: [
//           // TabBar
//           Obx(() => TabBar(
//                 controller: _tabController,
//                 isScrollable: true,
//                 tabs: getx.pdfListOfVideo
//                     .map((pdf) => Container(
//                         margin: EdgeInsets.symmetric(vertical: 5),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.all(Radius.circular(5))),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Tab(height: 25, text: pdf['Names']),
//                         )))
//                     .toList(),
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           // PDF Viewer
//           Expanded(
//             child: Obx(() {
//               if (getx.pdfListOfVideo.isEmpty) {
//                 return Center(
//                   child: Text(
//                     "No PDF Here",
//                     style: FontFamily.font,
//                   ),
//                 );
//               }

//               final currentPdf = getx.pdfListOfVideo[_tabController.index];
//               if (currentPdf['Encrypted'].toString() == "true") {
//                 return getx.encryptedpdffile.value.isNotEmpty
//                     ? SfPdfViewer.memory(getx.encryptedpdffile.value)
//                     : Center(child: CircularProgressIndicator());
//               } else {
//                 return File(getx.unEncryptedPDFfile.value).existsSync()
//                     ? SfPdfViewer.file(File(getx.unEncryptedPDFfile.value))
//                     : Center(child: CircularProgressIndicator());
//               }
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
