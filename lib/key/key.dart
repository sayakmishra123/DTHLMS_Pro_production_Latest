import 'package:flutter/foundation.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';

// import 'package:path_provider/path_provider.dart';
final key = encrypt.Key.fromUtf8(
    'my32lengthsupersecretnooneknows1'); // 32 chars for AES-256
final iv = encrypt.IV.fromUtf8('16lengthsuperivv'); // 16 chars for AES

encryptPdf(pdfFile) async {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encryptBytes(pdfFile, iv: iv);
  return encrypted.bytes;
}

decryptPdf(encryptedPdfFile) async {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decrypted =
      encrypter.decryptBytes(encrypt.Encrypted(encryptedPdfFile), iv: iv);
  return Uint8List.fromList(decrypted);
}

Future<dynamic> writedata(List<int> encResult, String s) async {
  if (kDebugMode) {
    print('Writting data');
  }
  File f = File(s);
  await f.writeAsBytes(encResult);
  return f.absolute.toString();
}

Future<Uint8List> readData(planstring) async {
  if (kDebugMode) {
    print('reading encrypted file data.......');
  }
  File f = File(planstring);
  return await f.readAsBytes();
}



// encrypte(bodyBytes) async {
//   if (kDebugMode) {
//     print('encrypting file......');
//   }
//   final encrypted =
//       MyEncrypt.encrypter.encryptBytes(bodyBytes, iv: MyEncrypt.myiv);
//   // print(encrypted.bytes);
//   return encrypted.bytes;
// }

// decrypteData(encdata) async {
//   if (kDebugMode) {
//     print('file decryption in progress .......');
//   }
//   encrypt.Encrypted en = encrypt.Encrypted(encdata);
//   var decrypted = MyEncrypt.encrypter.decryptBytes(en, iv: MyEncrypt.myiv);
//   // print(decrypted);
//   return Uint8List.fromList(decrypted);
// }


// encryptPdf(pdfFile) async {
//   final key = encrypt.Key.fromLength(32);
//   final iv = encrypt.IV.fromLength(16);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   final encrypted = encrypter.encryptBytes(pdfFile, iv: iv);
//   return encrypted.bytes;
// }

// decryptPdf(encryptedPdfFile) async {
//   final key = encrypt.Key.fromLength(32);
//   final iv = encrypt.IV.fromLength(16);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   final decrypted =
//       encrypter.decryptBytes(encrypt.Encrypted(encryptedPdfFile), iv: iv);
//   return Uint8List.fromList(decrypted);
// }
