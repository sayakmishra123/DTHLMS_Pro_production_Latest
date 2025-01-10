// import 'dart:async';
// import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
// import 'package:dthlms/GETXCONTROLLER/getxController.dart';
// import 'package:dthlms/THEME_DATA/color/color.dart';
// import 'package:crypto/crypto.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
// import 'package:dthlms/THEORY_EXAM/ShowQuestionPaper.dart';
// import 'package:dthlms/log.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinbox/flutter_spinbox.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class TheoryExamPageMobile extends StatefulWidget {
//   final String documentPath;
//   final String title;
//   final String duration;
//   final String paperId;
//   final bool issubmit;
//   TheoryExamPageMobile(
//       {super.key,
//       required this.documentPath,
//       required this.title,
//       required this.duration,
//       required this.paperId,
//       required this.issubmit});

//   @override
//   State<TheoryExamPageMobile> createState() => _TheoryExamPageMobileState();
// }

// class _TheoryExamPageMobileState extends State<TheoryExamPageMobile> {
//   final List<File> _images = [];
//   File? _selectedImage;
//   double sheetNumber = 1.0;
//   Getx getxController = Get.put(Getx());
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//   String? _localPdfPath;
//   bool _isFilePickerOpen = false; // Add this variable
//   RxInt _start = 0.obs;
//   late BuildContext golablContext;
//   TextEditingController sheetController = TextEditingController();
//   final GlobalKey<FormState> sheetkey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.issubmit) {
//       timer = Timer.periodic(Duration(seconds: 1), (_) {
//         setState(() {
//           _currentNumber++;
//         });
//         if (_currentNumber.value == 4) {
//           timer?.cancel();

//           startTimer();
//         }
//       });
//     }

//     _downloadPdf();

//     _start.value = int.parse(widget.duration) * 60;

//     // setState(() {});
//   }

//   bool isTimeOver = false;

//   Future<void> _pickImage() async {
//     if (_isFilePickerOpen) {
//       Get.showSnackbar(GetSnackBar(
//         isDismissible: true,
//         shouldIconPulse: true,
//         icon: const Icon(
//           Icons.file_copy,
//           color: Colors.white,
//         ),
//         snackPosition: SnackPosition.TOP,
//         title: 'File Picker is already open ',
//         message: 'Please check your Taskbar.',
//         mainButton: TextButton(
//           onPressed: () {
//             Get.back();
//           },
//           child: const Text(
//             'Ok',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         duration: const Duration(seconds: 3),
//       ));
//       return;
//     }
//     // Prevent multiple file pickers from opening
//     if (getxController.isPaperSubmit.value) {
//       _isFilePickerOpen =
//           true; // Set the variable to true when opening the picker
//       try {
//         FilePickerResult? result = await FilePicker.platform.pickFiles(
//             type: FileType.image,
//             allowMultiple: true,
//             dialogTitle: "Press & Hold CTRL to Select Multiple Sheet!");

//         if (result != null) {
//           setState(() {
//             for (var path in result.paths) {
//               if (path != null) {
//                 File file = File(path);
//                 if (!_isDuplicateImage(file)) {
//                   _images.add(file);
//                 } else {
//                   _showDuplicateImageAlert(file.absolute.path.split('\\').last);
//                 }
//               }
//             }
//           });
//         }
//       } finally {
//         _isFilePickerOpen = false; // Reset the variable after picker is closed
//       }
//     } else {
//       editSheetNumber(context);
//     }
//   }

//   bool _isDuplicateImage(File file) {
//     for (var image in _images) {
//       if (_calculateFileHash(image) == _calculateFileHash(file)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   String _calculateFileHash(File file) {
//     var bytes = file.readAsBytesSync();
//     return md5.convert(bytes).toString();
//   }

//   void _selectImage(File image) {
//     setState(() {
//       _selectedImage = image;
//     });
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Stack(
//             children: [
//               Image.file(
//                 image,
//                 fit: BoxFit.contain,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//               Positioned(
//                 right: 20,
//                 top: 20,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.red, size: 38),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _deleteImage(File image) {
//     setState(() {
//       _images.remove(image);
//       if (_selectedImage == image) {
//         _selectedImage = null;
//       }
//     });
//   }

// //   void _uploadImages() async {
// //   if (_images.length == sheetNumber) {
// //     // Upload images in parallel
// //     await Future.wait(_images.map((image) => uploadSheet(image,getx.loginuserdata[0].token)));
// //     _onUploadSuccessFull(context);
// //     print("Images uploaded: ${_images.length} images");
// //   } else if (_images.length > sheetNumber) {
// //     _onSheetOverFlow(context);
// //   } else if (_images.length < sheetNumber) {
// //     _onSheetUnderFlow(context);
// //   }
// // }

//   _uploadImages(BuildContext context) async {
//     String key = await getUploadAccessKey(context, getx.loginuserdata[0].token);

//     if (key != "") {
//       if (_images.length == sheetNumber) {
//         // Show progress indicator
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => Center(child: CircularProgressIndicator()),
//         );

//         try {
//           // Map each image to an uploadImage Future
//           List<Future<String>> uploadFutures = _images
//               .map((image) =>
//                   uploadSheet(image, getx.loginuserdata[0].token, key))
//               .toList();

//           // Wait for all uploads to complete and collect the IDs
//           List<String> imageIds = await Future.wait(uploadFutures);
//           print(imageIds);
//           String documentId =
//               imageIds.toString().replaceAll("[", "").replaceAll("]", "");
//           print(documentId);
//           sendDocumentIdOfanswerSheets(context, getx.loginuserdata[0].token,
//               int.parse(widget.paperId), documentId);
//           // Hide progress indicator
//           Navigator.of(context).pop();

//           // Now you have a list of IDs
//           print('Uploaded image IDs: $imageIds');
//           // Get.to(TestResultPage());
//           _onUploadSuccessFull(context);
//           print("Images uploaded: ${_images.length} images");
//         } catch (e) {
//           writeToFile(e, "_uploadImages");
//           // Handle errors here
//           Navigator.of(context).pop();
//           print('Error uploading images: $e');
//         }
//       } else if (_images.length > sheetNumber) {
//         _onSheetOverFlow(context);
//       } else if (_images.length < sheetNumber) {
//         _onSheetUnderFlow(context);
//       }
//     } else {
//       Get.snackbar("Error", "Access Key is not available");
//     }
//   }

//   Future<void> _downloadPdf() async {
//     try {
//       final response = await http.get(Uri.parse('${widget.documentPath}'));
//       if (response.statusCode == 200) {
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/QuestionPaper.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//         setState(() {
//           // Get.back();
//           _localPdfPath = filePath;
//           print(filePath);
//         });
//       } else {
//         print('Failed to download PDF.');
//       }
//     } catch (e) {
//         writeToFile(e, "_uploadImages");
//       Get.back();
//     }
//   }

//   void _openFullScreenPdf(int pageNumber) {
//     final PdfViewerController fullScreenController = PdfViewerController();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             iconTheme: IconThemeData(color: ColorPage.white),
//             title: Text("Full Screen PDF",
//                 style: FontFamily.font3.copyWith(color: Colors.white)),
//             backgroundColor: ColorPage.appbarcolor,
//           ),
//           body: ShowQuestionPaper(
//             pdfUrl: widget.documentPath,
//             title: widget.title,
//           ),
//           // body: SfPdfViewer.file(
//           //   File(_localPdfPath!),
//           //   controller: fullScreenController,
//           //   key: GlobalKey<SfPdfViewerState>(),
//           //   onDocumentLoaded: (PdfDocumentLoadedDetails details) {
//           //     fullScreenController.jumpToPage(pageNumber);
//           //   },
//           // ),
//         ),
//       ),
//     );
//   }

//   Timer? _timer;
//   Timer? timer;

//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start.value == 0) {
//           timer.cancel();
//           isTimeOver = true;
//           _onTimeUp(context);
//         } else {
//           _start.value--;
//         }
//       },
//     );
//   }

//   void dispose() {
//     if (_timer != null && _timer!.isActive) {
//       _timer!.cancel();
//     }
//     super.dispose();
//     getxController.isPaperSubmit.value = false;
//   }

//   String get timerText {
//     int hours = _start.value ~/ 3600;
//     int minutes = (_start.value % 3600) ~/ 60;
//     int seconds = _start.value % 60;
//     return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }

//   void _printPdf() async {
//     // try {
//     //   if (_localPdfPath != null) {
//     //     final file = File(_localPdfPath!);
//     //     final pdfBytes = await file.readAsBytes();

//     //     List<Printer> filteredPrinters = [];
//     //     //  Future<void> fetchPrinters() async {
//     //   final printers = await Printing.listPrinters();

//     //   setState(() {
//     //     filteredPrinters = printers.where((printer) {
//     //       return printer.isAvailable;
//     //     }).toList();
//     //   });
//     // // }

//     // // Future<void> printDocument() async {
//     //   if (filteredPrinters.isNotEmpty) {
//     //     await Printing.layoutPdf(
//     //       onLayout: (format) async {
//     //         // Generate your PDF document here
//     //         // final pdfBytes =pdfBytes;
//     //         return pdfBytes;
//     //       },
//     //       usePrinterSettings: true,
//     //       dynamicLayout: true,
//     //     );
//     //   } else {
//     //     print('No suitable printers found. Please check your printer connections.');
//     //   }
//     // // }

//     //   } else {
//     //     print('No PDF file available to print.');
//     //   }
//     // } catch (e) {
//     //   print('Error printing PDF: $e');
//     // }
//   }
//   RxInt _currentNumber = 1.obs;
//   // late Timer _timer;

// //  ProfessionalUI()
//   @override
//   Widget build(BuildContext context) {
//     golablContext = context;
//     return Obx(
//       () => SafeArea(
//           child:
//               // _currentNumber.value == 4
//               Stack(
//         children: [
//           AnimatedOpacity(
//             opacity: _currentNumber.value != 4 && widget.issubmit ? 0.4 : 1,
//             duration: Duration(seconds: 3),
//             child: Scaffold(
//               appBar: AppBar(
//                 automaticallyImplyLeading: true,
//                 backgroundColor: Colors.blueAccent,
//                 iconTheme: IconThemeData(color: Colors.white),
//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: widget.issubmit
//                         ? Obx(() => _currentNumber.value == 4
//                             ? Row(
//                                 children: [
//                                   Text(
//                                     'Remaining Time',
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Icon(Icons.timer, color: Colors.white),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '$timerText',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white),
//                                   ),
//                                   SizedBox(width: 20),
//                                 ],
//                               )
//                             : SizedBox())
//                         : SizedBox(),
//                   ),
//                 ],
//                 title: Text(
//                   widget.title,
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: ColorPage.white),
//                 ),
//               ),
//               body: Column(
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         widget.issubmit
//                             ? Expanded(
//                                 flex: 2,
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       child:
//                                           //  _localPdfPath == null
//                                           //     ? Center(
//                                           //         child: CircularProgressIndicator(),
//                                           //       )
//                                           //     :
//                                           //  widget.documentPath.endsWith(".pdf")?SfPdfViewer.network( widget.documentPath):
//                                           ShowQuestionPaper(
//                                         pdfUrl: widget.documentPath,
//                                         title: widget.title,
//                                       ),
//                                     ),
//                                     // Positioned(
//                                     //   bottom: 10,
//                                     //   right: 20,
//                                     //   child: Column(
//                                     //     children: [
//                                     //       // Container(
//                                     //       //   height: 40,
//                                     //       //   width: 40,
//                                     //       //   child: FloatingActionButton(
//                                     //       //     heroTag: "download button",
//                                     //       //     hoverColor: ColorPage.deepblue,
//                                     //       //     backgroundColor:
//                                     //       //         ColorPage.appbarcolorcopy,
//                                     //       //     child: Icon(
//                                     //       //       Icons.download,
//                                     //       //       color: ColorPage.white,
//                                     //       //     ),
//                                     //       //     onPressed: () {
//                                     //       //       _downloadPdf();
//                                     //       //     }, // Update this line
//                                     //       //   ),
//                                     //       // ),
//                                     //       // SizedBox(
//                                     //       //   height: 20,
//                                     //       // ),
//                                     //       // Container(
//                                     //       //   height: 40,
//                                     //       //   width: 40,
//                                     //       //   child: ClipRRect(
//                                     //       //     borderRadius: BorderRadius.all(
//                                     //       //         Radius.circular(17)),
//                                     //       //     child: MaterialButton(
//                                     //       //       hoverColor: ColorPage.deepblue,
//                                     //       //       color: ColorPage.appbarcolorcopy,
//                                     //       //       child: Icon(
//                                     //       //         Icons.fullscreen,
//                                     //       //         color: ColorPage.white,
//                                     //       //       ),
//                                     //       //       onPressed: () {
//                                     //       //         if (_localPdfPath != null) {
//                                     //       //           _openFullScreenPdf(
//                                     //       //               _pdfViewerController
//                                     //       //                   .pageNumber);
//                                     //       //         }
//                                     //       //       },
//                                     //       //     ),
//                                     //       //   ),
//                                     //       // ),
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               )
//                             : SizedBox(),
//                         isTimeOver
//                             ? Expanded(
//                                 child: Container(
//                                 child: Center(
//                                   child: Text("You are too Late!!"),
//                                 ),
//                               ))
//                             : Expanded(
//                                 child: Container(
//                                   // color: Color.fromARGB(255, 225, 253, 254),
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: GridView.builder(
//                                           padding: const EdgeInsets.all(8.0),
//                                           gridDelegate:
//                                               SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 3,
//                                             crossAxisSpacing: 8.0,
//                                             mainAxisSpacing: 8.0,
//                                           ),
//                                           itemCount: sheetNumber.toInt(),
//                                           itemBuilder: (context, index) {
//                                             if (index < _images.length) {
//                                               return Card(
//                                                 elevation: 4,
//                                                 child: Container(
//                                                   color: ColorPage.white,
//                                                   padding: EdgeInsets.all(6),
//                                                   child: GestureDetector(
//                                                     onTap: () => _selectImage(
//                                                         _images[index]),
//                                                     child: Stack(
//                                                       children: [
//                                                         ClipRRect(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(4),
//                                                           child: Image.file(
//                                                             _images[index],
//                                                             fit: BoxFit.cover,
//                                                             width:
//                                                                 double.infinity,
//                                                             height:
//                                                                 double.infinity,
//                                                           ),
//                                                         ),
//                                                         Positioned(
//                                                           right: 0,
//                                                           top: 0,
//                                                           child: IconButton(
//                                                             icon: Icon(
//                                                                 Icons.delete,
//                                                                 color:
//                                                                     Colors.red),
//                                                             onPressed: () =>
//                                                                 _deleteImage(
//                                                                     _images[
//                                                                         index]),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             } else {
//                                               return Container(
//                                                   color: Colors.grey.shade100,
//                                                   child: Center(
//                                                     child: GestureDetector(
//                                                       onTap: _pickImage,
//                                                       child: Container(
//                                                         width: 150,
//                                                         height: 150,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(8),
//                                                           border: Border.all(
//                                                               color: Colors
//                                                                   .blueAccent,
//                                                               width: 2),
//                                                           color: Colors.white,
//                                                         ),
//                                                         child: Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Icon(Icons.add,
//                                                                 size: 40,
//                                                                 color: Colors
//                                                                     .blueAccent),
//                                                             const SizedBox(
//                                                                 height: 8),
//                                                             Text(
//                                                               "   r Sheet",
//                                                               style: TextStyle(
//                                                                 fontSize: 14,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: Colors
//                                                                     .blueAccent,
//                                                               ),
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ));

//                                               // GestureDetector(
//                                               //   onTap: _pickImage,
//                                               //   child: Container(
//                                               //     decoration: BoxDecoration(
//                                               //       color: Colors.grey[300],
//                                               //       borderRadius:
//                                               //           BorderRadius.circular(10),
//                                               //     ),
//                                               //     child: Column(
//                                               //       mainAxisAlignment:
//                                               //           MainAxisAlignment.center,
//                                               //       children: [
//                                               //         Icon(Icons.add,
//                                               //             size: 50,
//                                               //             color: Colors.grey[700]),
//                                               //         Text("Select your Sheet",
//                                               //             style: FontFamily.font3
//                                               //                 .copyWith(
//                                               //                     color: Colors
//                                               //                         .grey[700])),
//                                               //       ],
//                                               //     ),
//                                               //   ),
//                                               // );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                       Obx(
//                                         () => getxController.isPaperSubmit.value
//                                             ? Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     ElevatedButton(
//                                                       onPressed: () {
//                                                         _uploadImages(context);
//                                                       },
//                                                       child: Text(
//                                                           "Upload Images",
//                                                           style: TextStyle(
//                                                               fontSize: 14,
//                                                               color: Colors
//                                                                   .white)),
//                                                       style: ElevatedButton
//                                                           .styleFrom(
//                                                         backgroundColor:
//                                                             ColorPage
//                                                                 .colorbutton,
//                                                         // padding: EdgeInsets.symmetric(
//                                                         //     vertical: 15,
//                                                         //     horizontal: 50),
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(5),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 30,
//                                                     ),
//                                                     ElevatedButton(
//                                                       onPressed: () {
//                                                         editSheetNumber(
//                                                             context);
//                                                       },
//                                                       child: Text(
//                                                           "Edit Sheet number",
//                                                           style: TextStyle(
//                                                               fontSize: 14,
//                                                               color: Colors
//                                                                   .white)),
//                                                       style: ElevatedButton
//                                                           .styleFrom(
//                                                         backgroundColor:
//                                                             ColorPage.red,
//                                                         // padding: EdgeInsets.symmetric(
//                                                         //     vertical: 15,
//                                                         //     horizontal: 50),
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(5),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             : SizedBox(),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Visibility(
//             visible: _currentNumber.value != 4 && widget.issubmit,
//             child: Positioned.fill(
//                 child: Scaffold(
//               backgroundColor: Colors.transparent,
//               body: Center(
//                 child: AnimatedOpacity(
//                   opacity: 1,
//                   duration: Duration(seconds: 3),
//                   child: Text(
//                     _currentNumber.toString(),
//                     style: TextStyle(
//                       fontSize: 150,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red, // Color of the number text
//                     ),
//                   ),
//                 ),
//               ),
//             )),
//           )
//         ],
//       )),
//     );
//   }

//   editSheetNumber(context) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.fromTop,
//       isCloseButton: false,
//       isOverlayTapDismiss: true,
//       alertPadding: EdgeInsets.only(top: 200),
//       descStyle: TextStyle(fontWeight: FontWeight.bold),
//       animationDuration: Duration(milliseconds: 400),
//       alertBorder: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//         side: BorderSide(color: Colors.grey),
//       ),
//       titleStyle: TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
//       constraints: BoxConstraints.expand(width: 350),
//       overlayColor: Color(0x55000000),
//       alertElevation: 0,
//       alertAlignment: Alignment.center,
//     );

//     Alert(
//       context: context,
//       style: alertStyle,
//       title: "Enter Your Sheet Number",
//       content: Form(
//         key: sheetkey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('How Many Sheets You Want To Upload',
//                     style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: SpinBox(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   sheetNumber = value;
//                 },
//                 decoration: InputDecoration(
//                   border:
//                       UnderlineInputBorder(borderSide: BorderSide(width: 2)),
//                 ),
//                 value: sheetNumber,
//               ),
//             ),
//           ],
//         ),
//       ),
//       buttons: [
//         DialogButton(
//           // width: MediaQuery.of(context).size.width / 5.5,
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 15)),
//           onPressed: () {
//             // ignore: unnecessary_null_comparison
//             if (sheetNumber == null || sheetNumber == 0) {
//               _onSheetNull(context);
//             } else if (sheetNumber > 0 && sheetNumber > _images.length) {
//               setState(() {
//                 getxController.isPaperSubmit.value = true;
//                 Navigator.pop(context);
//                 _pickImage();
//               });
//             } else {
//               setState(() {
//                 getxController.isPaperSubmit.value = true;
//                 Navigator.pop(context);
//               });
//             }
//           },
//           color: ColorPage.colorgrey,
//           radius: BorderRadius.circular(5.0),
//         ),
//       ],
//     ).show();
//   }

//   _onSheetOverFlow(context) {
//     Alert(
//       context: context,
//       type: AlertType.error,
//       style: AlertStyle(
//         titleStyle: TextStyle(color: ColorPage.red),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "NUMBER OF SHEET NOT MATCH !!",
//       desc:
//           "Your Assign ${sheetNumber.toStringAsFixed(0)} Sheets.\n But you selected ${_images.length} Sheets.\n Please edit the sheet number or\n remove the extra Pages",
//       buttons: [
//         DialogButton(
//           child:
//               Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18)),
//           onPressed: () {
//             Navigator.pop(context);
//             editSheetNumber(context);
//           },
//           color: Color.fromARGB(255, 32, 194, 209),
//         ),
//         DialogButton(
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: ColorPage.buttonColor,
//         ),
//       ],
//     ).show();
//   }

//   _onSheetNull(context) {
//     Alert(
//       context: context,
//       type: AlertType.error,
//       style: AlertStyle(
//         titleStyle: TextStyle(color: ColorPage.red),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "INVALID SHEET !!",
//       desc: "At least 1 sheet you should assign",
//       buttons: [
//         DialogButton(
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: ColorPage.appbarcolor,
//           onPressed: () {
//             Navigator.pop(context);
//             _pickImage();
//           },
//           color: ColorPage.blue,
//         ),
//       ],
//     ).show();
//   }

//   _onSheetUnderFlow(context) {
//     Alert(
//       context: context,
//       type: AlertType.error,
//       style: AlertStyle(
//         titleStyle: TextStyle(color: ColorPage.red),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "NUMBER OF SHEET NOT MATCH !!",
//       desc:
//           "Your Assign ${sheetNumber.toStringAsFixed(0)} Sheets.\n But you selected ${_images.length} Sheets.\n Please edit the sheet number or\n add more Pages",
//       buttons: [
//         DialogButton(
//           child:
//               Text("Add", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: ColorPage.blue,
//           onPressed: () {
//             Navigator.pop(context);
//             _pickImage();
//           },
//           color: const Color.fromARGB(255, 33, 226, 243),
//         ),
//         DialogButton(
//           highlightColor: Color.fromARGB(255, 2, 2, 60),
//           child:
//               Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18)),
//           onPressed: () {
//             Navigator.pop(context);
//             editSheetNumber(context);
//           },
//           color: ColorPage.blue,
//         ),
//       ],
//     ).show();
//   }

//   void _showDuplicateImageAlert(String file) {
//     Alert(
//       context: context,
//       type: AlertType.error,
//       title: "Duplicate Image",
//       desc: "$file\nThis image has already been selected.",
//       buttons: [
//         DialogButton(
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//           onPressed: () {
//             Navigator.pop(context);
//             _pickImage();
//           },
//           color: ColorPage.blue,
//         ),
//       ],
//     ).show();
//   }

//   _onUploadSuccessFull(context) {
//     Alert(
//       context: context,
//       type: AlertType.success,
//       style: AlertStyle(
//         titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "UPLOAD SUCCESSFUL!!",
//       desc: "Your answer sheets are uploaded successfully!",
//       buttons: [
//         DialogButton(
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: ColorPage.blue,
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           color: ColorPage.green,
//         ),
//       ],
//     ).show();
//   }

//   _onTimeUp(context) {
//     Alert(
//       context: context,
//       onWillPopActive: false,
//       type: AlertType.info,
//       style: AlertStyle(
//         isOverlayTapDismiss: false,
//         animationType: AnimationType.fromTop,
//         titleStyle:
//             TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "Your Time is Up !!",
//       desc: "Sorry! But Your time is over. \n Your can't  submit your exam.",
//       buttons: [
//         DialogButton(
//           child:
//               Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(3, 77, 59, 1),
//           onPressed: () {
//             setState(() {});
//             Navigator.pop(context);
//           },
//           color: Color.fromRGBO(9, 89, 158, 1),
//         ),
//       ],
//     ).show();
//   }
// }
