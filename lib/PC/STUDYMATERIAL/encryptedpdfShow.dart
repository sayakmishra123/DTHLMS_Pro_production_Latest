import 'dart:typed_data';
import 'dart:io';
import 'package:dthlms/log.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Uint8List aesEncryptPdf(Uint8List data, String key) {
  final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
  final iv = encrypt.IV.fromLength(16); // Initialization vector (16 bytes)
  final encrypter =
      encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

  final encrypted = encrypter.encryptBytes(data, iv: iv);
  return Uint8List.fromList(
      iv.bytes + encrypted.bytes); // Prepend IV to the encrypted bytes
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

Future<Uint8List> fetchPdfFromNetwork(String url) async {
  final response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  return Uint8List.fromList(response.data);
}

Future<String> saveEncryptedPdfToFile(Uint8List encryptedPdfBytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/encrypted_pdf.aes';
  final file = File(filePath);
  await file.writeAsBytes(encryptedPdfBytes, flush: true);
  return filePath;
}

Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
  final file = File(filePath);
  return file.readAsBytes();
}

class PdfViewerPage extends StatelessWidget {
  final Uint8List pdfBytes;

  PdfViewerPage({required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}

class ShowPdf extends StatefulWidget {
  String book;
  String bookname;
  ShowPdf(this.book, this.bookname);

  @override
  _ShowPdfState createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  final String pdfUrl = 'https://pdfobject.com/pdf/sample.pdf';
  final String encryptionKey =
      '16CharLongKey!!'; // 16-character key for 128-bit encryption

  String? encryptedFilePath;
  Uint8List? decryptedPdfBytes; // State variable to store decrypted PDF bytes

  @override
  void initState() {
    super.initState();
    // decryptAndShowPdf2();
    // fetchAndEncryptPdf().whenComplete(() {
    //   decryptAndShowPdf();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookname)),
      body: Row(
        children: [
          // Expanded(
          //     flex: 2,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 2,
          //             color: Color.fromARGB(255, 192, 191, 191),
          //             offset: Offset(0, 0),
          //           ),
          //         ],
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(10),
          //         ),
          //       ),
          //     )),
          Expanded(
            flex: 3,
            child: Container(
              child: Center(
                child: widget.book == ''
                    ? CircularProgressIndicator() // Show loading indicator while decrypting
                    : SfPdfViewer.network(
                        pdfUrl, // Pass the decrypted PDF bytes here
                      ), // Show PDF once decrypted
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchAndEncryptPdf() async {
    try {
      // Fetch the PDF from the network
      final pdfBytes = await fetchPdfFromNetwork(pdfUrl);

      // Encrypt the PDF
      final encryptedBytes = aesEncryptPdf(pdfBytes, encryptionKey);

      // Save the encrypted PDF to the device
      final filePath = await saveEncryptedPdfToFile(encryptedBytes);

      setState(() {
        encryptedFilePath = filePath;
      });

      print('Encrypted PDF saved to $filePath');
    } catch (e) {
      writeToFile(e, "fetchAndEncryptPdf");
      print('Error: $e');
    }
  }

  Future<void> decryptAndShowPdf() async {
    try {
      if (encryptedFilePath != null) {
        // Read the encrypted PDF from the file
        final encryptedBytes =
            await readEncryptedPdfFromFile(encryptedFilePath!);

        // Decrypt the PDF
        final decryptedBytes = aesDecryptPdf(encryptedBytes, encryptionKey);

        // Update state with decrypted PDF bytes
        setState(() {
          decryptedPdfBytes = decryptedBytes;
        });
      } else {
        print('No encrypted file found.');
      }
    } catch (e) {
      writeToFile(e, "decryptAndShowPdf");
      print('Error: $e');
    }
  }

  Future<void> decryptAndShowPdf2() async {
    try {
      // Get the path of the file from the document directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/e548ea8689f34d9a83874a938c9ca66e.pdf';

      // Check if the file exists
      final file = File(filePath);
      if (await file.exists()) {
        print("File found at: ${file.path}");

        // Read the encrypted PDF from the file
        final encryptedBytes = await file.readAsBytes();
        print("Encrypted file read complete");

        // Decrypt the PDF using the AES decryption function
        final decryptedBytes =
            await customDecryptPdf(file.path, "16CharLongKey!!");
        print("PDF decryption complete");

        // Update the state with the decrypted PDF bytes to display it
        setState(() {
          decryptedPdfBytes = decryptedBytes;
        });
      } else {
        print('No encrypted file found at the specified path.');
      }
    } catch (e) {
      writeToFile(e, "decryptAndShowPdf2");
      print('Error: $e');
    }
  }

  Future<Uint8List?> customDecryptPdf(String filePath, String key) async {
    try {
      // Check if the file exists
      final file = File(filePath);
      if (await file.exists()) {
        print("File found at: ${file.path}");

        // Read the encrypted PDF from the file
        final encryptedBytes = await file.readAsBytes();
        print("Encrypted file read complete");

        // Decrypt the PDF using the AES decryption function
        final decryptedBytes = aesDecryptPdf(encryptedBytes, key);
        print("PDF decryption complete");
        print(decryptedBytes.toString() + "hello");

        // Return the decrypted bytes
        return decryptedBytes;
      } else {
        print('No encrypted file found at the specified path.');
        return null;
      }
    } catch (e) {
      writeToFile(e, "customDecryptPdf");
      print('Error during decryption: $e');
      return null;
    }
  }
}
