import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart' as img_edit;
import 'package:image_editor_plus/options.dart' as img_opts;
import 'package:pdfx/pdfx.dart' as pdfx; // For rendering PDF pages
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ImageEditorExample extends StatefulWidget {
  final String? pdfName;
  final String? pdfPath;

  const ImageEditorExample({
    required this.pdfName,
    required this.pdfPath,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageEditorExample> createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  List<Uint8List> imageDataList = [];
  List<Image> images = [];
  List<Size> originalPageSizes = [];
  String pdfFilePath = '';
  pdfx.PdfDocument? document; // PDF document instance
  bool _isDisposed = false; // To track if the widget is disposed

  @override
  void initState() {
    super.initState();
    if (widget.pdfPath != null && widget.pdfPath!.isNotEmpty) {
      convertPdfToImages(widget.pdfPath!);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    // document?.close(); // Ensure the PDF document is closed safely
    super.dispose();
  }

  /// Pick a PDF file from the system
  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pdfFilePath = result.files.single.path!;
      });
      await convertPdfToImages(pdfFilePath);
    }
  }

  /// Convert PDF to images using pdfx, rendering as compressed JPEG
  Future<void> convertPdfToImages(String filePath) async {
    try {
      document = await pdfx.PdfDocument.openFile(filePath);
      final pageCount = document!.pagesCount;

      final List<Uint8List> imagesList = [];
      originalPageSizes.clear();

      for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
        if (_isDisposed) return; // Stop processing if the widget is disposed

        final page = await document!.getPage(pageIndex + 1);

        final double pageWidth = page.width.toDouble();
        final double pageHeight = page.height.toDouble();
        originalPageSizes.add(Size(pageWidth, pageHeight));

        final renderedPage = await page.render(
          width: page.width,
          height: page.height,
          format: pdfx.PdfPageImageFormat.jpeg,
          quality: 90, // Improved image quality
        );

        if (renderedPage != null) {
          imagesList.add(renderedPage.bytes);
        }

        page.close(); // Close each page after use
      }

      if (!_isDisposed) {
        setState(() {
          imageDataList = imagesList;
          images = imagesList
              .map((img) => Image.memory(img, fit: BoxFit.fill))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error converting PDF to images: $e");
    }
  }

  /// Save images as a new PDF, with compression enabled
  Future<void> saveImagesAsPdf() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final pdf = pw.Document(compress: true);

    for (int i = 0; i < imageDataList.length; i++) {
      final imageBytes = imageDataList[i];
      final Size pageSize = originalPageSizes[i];

      final customFormat = PdfPageFormat(
        pageSize.width,
        pageSize.height,
        marginAll: 0,
      );

      final pw.MemoryImage pdfImage = pw.MemoryImage(
        imageBytes,
        dpi: 150,
      );

      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: customFormat,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.cover,
              ),
            );
          },
        ),
      );
    }

    final outputFile = widget.pdfPath!;
    final file = File(outputFile);

    await file.writeAsBytes(await pdf.save());
    Navigator.pop(context);

    debugPrint("PDF saved to: $outputFile");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: pickPdfFile,
        child: const Icon(Icons.file_copy),
      ),
      appBar: AppBar(
        title: const Text("PDF to Image Editor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (images.isEmpty)
              const Text('No images to display')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.memory(
                        imageDataList[index],
                        fit: BoxFit.cover,
                      ),
                      ElevatedButton(
                        child: const Text("Edit Image"),
                        onPressed: () async {
                          final editedImage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => img_edit.SingleImageEditor(
                                image: imageDataList[index],
                                brushOption: const img_opts.BrushOption(
                                  colors: [
                                    img_opts.BrushColor(
                                      color: Colors.black,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.red,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.green,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.blue,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.white,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.orange,
                                      background: Colors.transparent,
                                    ),
                                    img_opts.BrushColor(
                                      color: Colors.grey,
                                      background: Colors.transparent,
                                    ),
                                  ],
                                  translatable: true,
                                ),
                              ),
                            ),
                          );

                          if (editedImage != null) {
                            setState(() {
                              imageDataList[index] = editedImage;
                              images[index] = Image.memory(
                                editedImage,
                                fit: BoxFit.cover,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save Edited Images as PDF"),
              onPressed: saveImagesAsPdf,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
