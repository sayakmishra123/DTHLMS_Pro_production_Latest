// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dthlms/log.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<void> copyDatabase(String assetPath, String databaseName) async {
  try {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    String filename = "$appDocPath${Platform.pathSeparator}DTHLMSProDB.sqlite";
    if (await File(filename).exists()) {
      print('object');
    }
    // else {
    //   await Directory("${dbPath.path}/database").create(recursive: true);
    // }
    // String targetPath = join("${dbPath.path}/database", databaseName);
    // print(targetPath);
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // print(targetPath);
    await File(filename).writeAsBytes(bytes);
    print('Database copied to $filename');
  } catch (e) {
    writeToFile(e, 'copyDatabase');
    print('Error copying database: $e');
  }
}

fndbpath() async {
  try {
    Directory? dbPath = await getApplicationCacheDirectory();
    return "${dbPath.path}/database";
  } catch (e) {
    writeToFile(e, 'fndbpath');
    print(e);
  }
}
