import 'dart:io';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/ERROR_MASSEGE/errorhandling.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:crypto/crypto.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image/image.dart' as img;

class SelectExamPapers extends StatefulWidget {
  final String paperId;
  const SelectExamPapers({required this.paperId});
  @override
  State<SelectExamPapers> createState() => _SelectExamPapersState();
}

class _SelectExamPapersState extends State<SelectExamPapers> {
  final List<File> _images = [];

  File? _selectedImage;
  RxBool isUploaded = false.obs;

  double sheetNumber = 1.0;

  bool _isFilePickerOpen = false;

  Getx getxController = Get.put(Getx());

  final GlobalKey<FormState> sheetkey = GlobalKey();

  Future<void> _pickImage() async {
    if (_isFilePickerOpen) return;
    if (getxController.isPaperSubmit.value) {
      _isFilePickerOpen = true;
      try {
        final ImagePicker _picker = ImagePicker();
        final List<XFile>? selectedFiles = await _picker.pickMultiImage(
          imageQuality: 85, // Reduce image quality to save space if needed
        );

        if (selectedFiles != null) {
          if (sheetNumber < selectedFiles.length) {
            _onSheetOverFlow(globalContext, selectedFiles);
          } else {
            for (var xFile in selectedFiles) {
              File file = File(xFile.path);
              if (!_isDuplicateImage(file)) {
                _images.add(await resizeImage(file));
                setState(() {});
              } else {
                _showDuplicateImageAlert(file.absolute.path.split('/').last);
              }
            }
          }
        }
      } finally {
        _isFilePickerOpen = false;
      }
    } else {
      editSheetNumber(context);
    }
  }

  Future<File> resizeImage(File inputFile) async {
    try {
      // Make a copy of the input file
      final tempDir = Directory.systemTemp;
      final copiedFile = File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_${inputFile.uri.pathSegments.last}');
      inputFile.copySync(copiedFile.path);

      // Read and decode the image
      final imageBytes = copiedFile.readAsBytesSync();
      final img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Error: Unable to decode the image.');
      }

      // Dimensions of A4 in pixels at 300 DPI
      const a4Width = 1240; // pixels
      const a4Height = 1754; // pixels

      // Temporary file for resized image
      final tempFile = File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_resized_${inputFile.uri.pathSegments.last}');

      // Check if the original image size exceeds A4 dimensions
      if (image.width > a4Width || image.height > a4Height) {
        print(
            'Original image size: ${image.width}x${image.height}. Resizing to A4 dimensions.');

        // Resize the image to A4 dimensions while maintaining aspect ratio
        final img.Image thumbnail =
            img.copyResize(image, width: a4Width, height: a4Height);

        // Save the resized image in memory
        final resizedBytes = img.encodePng(thumbnail);

        // Create and return resized file
        return tempFile..writeAsBytesSync(resizedBytes);
      } else {
        print(
            'Original image size: ${image.width}x${image.height}. No resizing needed.');

        // Return copied file without resizing
        return copiedFile;
      }
    } catch (e) {
      return File('path');
    }
  }

  bool _isDuplicateImage(File file) {
    for (var image in _images) {
      if (_calculateFileHash(image) == _calculateFileHash(file)) {
        return true;
      }
    }
    return false;
  }

  String _calculateFileHash(File file) {
    var bytes = file.readAsBytesSync();
    return md5.convert(bytes).toString();
  }

  void _selectImage(File image) {
    setState(() {
      _selectedImage = image;
    });
  }

  BuildContext? globalContext;
  void _deleteImage(File image) {
    setState(() {
      _images.remove(image);
      if (_selectedImage == image) {
        _selectedImage = null;
      }
    });
  }

  void _uploadImages(BuildContext context) {
    if (_images.length == sheetNumber) {
      _uploadImageList(_images, context);
      // _onUploadSuccessFull(globalContext);
      print("Images uploaded: ${_images.length} images");
    } else if (_images.length > sheetNumber) {
      _onSheetOverFlow(globalContext, _images);
    } else if (_images.length < sheetNumber) {
      _onSheetUnderFlow(globalContext);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return WillPopScope(
      onWillPop: () async {
        if (isUploaded.value) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          _exitConfirmetionBox(context, () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
        return false;
      },
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "editebutton",
              backgroundColor: Colors.white,
              onPressed: () {
                editSheetNumber(context);
              },
              child: Icon(Icons.edit, color: ColorPage.appbarcolor),
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              heroTag: "uploadbutton",
              backgroundColor: Colors.white,
              onPressed: () {
                _uploadConfirmetionBox(context, () {
                  Navigator.pop(context);
                  _uploadImages(context);
                });
              },
              child: Icon(Icons.upload_rounded, color: ColorPage.appbarcolor),
            ),
          ],
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: ColorPage.appbarcolor,
          title: Text(
            'Paper Upload',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                _images.isNotEmpty
                    ? Expanded(
                        flex: 3,
                        child: Container(
                          child: _images.isNotEmpty
                              ? Image.file(
                                  _selectedImage != null
                                      ? _selectedImage!
                                      : _images[0],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : SizedBox(),
                        ),
                      )
                    : SizedBox(),
                _images.isNotEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),
                                scrollDirection: Axis.horizontal,
                                itemCount: sheetNumber.toInt(),
                                itemBuilder: (context, index) {
                                  if (index < _images.length) {
                                    return DragTarget<int>(
                                      onWillAccept: (fromIndex) =>
                                          fromIndex !=
                                          index, // Avoid dropping on itself
                                      onAccept: (fromIndex) {
                                        setState(() {
                                          final draggedImage =
                                              _images.removeAt(fromIndex);
                                          _images.insert(index, draggedImage);
                                        });
                                      },
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        return LongPressDraggable<int>(
                                          data: index,
                                          feedback: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              _images[index],
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 150,
                                            ),
                                          ),
                                          childWhenDragging:
                                              const SizedBox(), // Placeholder during drag
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectImage(_images[index]);
                                              },
                                              child: Stack(
                                                children: [
                                                  AnimatedContainer(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            _selectedImage ==
                                                                    _images[
                                                                        index]
                                                                ? 10
                                                                : 0),
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                        _images[index],
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.close_rounded,
                                                          color: Color(
                                                              0xFF008080)),
                                                      onPressed: () =>
                                                          _deleteImage(
                                                              _images[index]),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 10,
                                                    top: 10,
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: FontFamily.styleb
                                                          .copyWith(
                                                              color: Colors
                                                                  .blueGrey),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      child: Icon(
                                                        Icons
                                                            .drag_indicator_rounded,
                                                        color: Colors.blueGrey,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_rounded,
                                                  size: 30,
                                                  color: Colors.grey[700]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  height: 200,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_rounded,
                                          size: 30, color: Colors.grey[700]),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  editSheetNumber(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey),
      ),
      titleStyle: TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: 350),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );

    Alert(
      context: context,
      style: alertStyle,
      title: "Enter Your Sheet Number",
      content: Form(
        key: sheetkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter How Many Sheets\n You Want To Upload',
                    style: TextStyle(fontSize: 14)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SpinBox(
                min: 1,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  sheetNumber = value;
                },
                decoration: InputDecoration(
                  border:
                      UnderlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
                value: sheetNumber,
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width / 5.5,
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 15)),
          onPressed: () {
            if (sheetNumber == 0) {
              _onSheetNull(context);
            } else if (sheetNumber > 0 && sheetNumber > _images.length) {
              setState(() {
                getxController.isPaperSubmit.value = true;
                Navigator.pop(context);
                _pickImage();
              });
            } else if (sheetNumber < _images.length) {
              setState(() {
                getxController.isPaperSubmit.value = true;
                _images.removeRange(sheetNumber.toInt(), _images.length);
                Navigator.pop(context);
              });
            } else {
              setState(() {
                print("elsepart+$sheetNumber");
                getxController.isPaperSubmit.value = true;
                Navigator.pop(context);
              });
            }
          },
          color: ColorPage.colorgrey,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  _onSheetOverFlow(context, List images) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(
        titleStyle: TextStyle(color: ColorPage.red),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "NUMBER OF SHEET NOT MATCH !!",
      desc:
          "Your Assign ${sheetNumber.toStringAsFixed(0)} Sheets.\n But you selected ${images.length} Sheets.\n Please edit the sheet number or\n remove the extra Pages",
      buttons: [
        DialogButton(
          child:
              Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.pop(context);
            editSheetNumber(context);
          },
          color: Color.fromARGB(255, 32, 194, 209),
        ),
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorPage.buttonColor,
        ),
      ],
    ).show();
  }

  _onSheetNull(context) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(color: ColorPage.red),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "INVALID SHEET !!",
      desc: "At least 1 sheet you should assign",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.appbarcolor,
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorPage.blue,
        ),
      ],
    ).show();
  }

  _onSheetUnderFlow(context) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(
        titleStyle: TextStyle(color: ColorPage.red),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "NUMBER OF SHEET NOT MATCH !!",
      desc:
          "Your Assign ${sheetNumber.toStringAsFixed(0)} Sheets.\n But you selected ${_images.length} Sheets.\n Please edit the sheet number or\n add more Pages",
      buttons: [
        DialogButton(
          child:
              Text("Add", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.blue,
          onPressed: () {
            Navigator.pop(context);
            _pickImage();
          },
          color: const Color.fromARGB(255, 33, 226, 243),
        ),
        DialogButton(
          highlightColor: Color.fromARGB(255, 2, 2, 60),
          child:
              Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.pop(context);
            editSheetNumber(context);
          },
          color: ColorPage.blue,
        ),
      ],
    ).show();
  }

  void _showDuplicateImageAlert(String file) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Duplicate Image",
      desc: "$file\nThis image has already been selected.",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.pop(context);
            _pickImage();
          },
          color: ColorPage.blue,
        ),
      ],
    ).show();
  }

  _onUploadSuccessFull(context) {
    Alert(
      context: context,
      type: AlertType.success,
      style: AlertStyle(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "UPLOAD SUCCESSFUL!!",
      desc: "Your answer sheets are uploaded successfully!",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.blue,
          onPressed: () {
            if (isUploaded.value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          color: ColorPage.green,
        ),
      ],
    ).show();
    //  final snackBar = SnackBar(
    //               /// need to set following properties for best effect of awesome_snackbar_content
    //               elevation: 0,
    //               behavior: SnackBarBehavior.floating,
    //               backgroundColor: Colors.transparent,
    //               content: Padding(
    //                 padding: EdgeInsets.symmetric(vertical: 10),
    //                 child: AwesomeSnackbarContent(
    //                   title: 'UPLOAD SUCCESSFUL!!',
    //                   message:
    //                       'Your answer sheets are uploaded successfully!',

    //                   /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
    //                   contentType: ContentType.success,
    //                 ),
    //               ),
    //             );

    //             ScaffoldMessenger.of(context)
    //               ..hideCurrentSnackBar()
    //               ..showSnackBar(snackBar);
  }

  void _uploadImageList(List images, BuildContext context) async {
    String key = await getUploadAccessKey(context, getx.loginuserdata[0].token);
    if (key != "") {
      if (images.length == sheetNumber) {
        // Show progress indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        try {
          // Map each image to an uploadImage Future
          List<Future<String>> uploadFutures = images
              .map((image) => uploadSheet(image, getx.loginuserdata[0].token,
                  key, "AnswerSheet", context))
              .toList();

          // Wait for all uploads to complete and collect the IDs
          List<String> imageIds = await Future.wait(uploadFutures);
          print(imageIds);
          String documentId =
              imageIds.toString().replaceAll("[", "").replaceAll("]", "");
          print(documentId);
          sendDocumentIdOfanswerSheets(
                  context,
                  getxController.loginuserdata[0].token,
                  int.parse(widget.paperId),
                  documentId)
              .then((value) {
            if (value) {
              _onUploadSuccessFull(context);
              print("Images uploaded: ${_images.length} images");
            }
          });
          // Hide progress indicator
          Navigator.of(context).pop();

          // Now you have a list of IDs
          print('Uploaded image IDs: $imageIds');
          isUploaded.value = true;
        } catch (e) {
          writeToFile(e, "_uploadImageList");
          // Handle errors here
          Navigator.of(context).pop();
          ClsErrorMsg.fnErrorDialog(
              context, "Uploadfailed", "Something went wrong", e.toString());
          print('Error uploading images: $e');
        }
      }
    } else {
      ClsErrorMsg.fnErrorDialog(context, "Uploadfailed", "Something went wrong",
          "Access Key not found");
    }
  }
}

_exitConfirmetionBox(context, VoidCallback ontap) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    alertPadding: EdgeInsets.only(top: 200),
    descStyle: TextStyle(),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.grey),
    ),
    titleStyle: TextStyle(
        color: const Color.fromARGB(255, 243, 33, 33),
        fontWeight: FontWeight.bold),
    constraints: BoxConstraints.expand(width: 350),
    overlayColor: Color(0x55000000),
    alertElevation: 0,
    alertAlignment: Alignment.center,
  );
  Alert(
    context: context,
    type: AlertType.warning,
    style: alertStyle,
    title: "Are you sure you want to exit ?",
    // desc:
    //     "",
    buttons: [
      DialogButton(
        width: 150,
        child:
            Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromARGB(255, 203, 46, 46),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Color.fromARGB(255, 139, 19, 19),
      ),
      DialogButton(
        width: 150,
        highlightColor: Color.fromARGB(255, 2, 2, 60),
        child: Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: ontap,
        color: const Color.fromARGB(255, 1, 12, 31),
      ),
    ],
  ).show();
}

void _uploadConfirmetionBox(context, VoidCallback ontap) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    alertPadding: EdgeInsets.only(top: 200),
    descStyle: TextStyle(),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.grey),
    ),
    titleStyle: TextStyle(
        color: const Color.fromARGB(255, 243, 33, 33),
        fontWeight: FontWeight.bold),
    constraints: BoxConstraints.expand(width: 350),
    overlayColor: Color(0x55000000),
    alertElevation: 0,
    alertAlignment: Alignment.center,
  );
  Alert(
    context: context,
    type: AlertType.warning,
    style: alertStyle,
    title: "Are you sure you want to Upload ?",
    // desc:
    //     "",
    buttons: [
      DialogButton(
        width: 150,
        child:
            Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromARGB(255, 203, 46, 46),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Color.fromARGB(255, 139, 19, 19),
      ),
      DialogButton(
        width: 150,
        highlightColor: Color.fromARGB(255, 2, 2, 60),
        child: Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: ontap,
        color: const Color.fromARGB(255, 1, 12, 31),
      ),
    ],
  ).show();
}
