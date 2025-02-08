import 'dart:io';

import 'package:dthlms/constants.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

Future writeToFile(e, functionname) async {
  try {
    // Get the directory to store the file
    final directory = await getApplicationDocumentsDirectory();
    print("Directory path: ${directory.path}");

    // Create a file in the app's document directory
    final file = File('${directory.path}/dthlmsProLog.txt');
    print("File path: ${file.path}");

    // Check if the file exists
    if (await file.exists()) {
      print("File already exists.");
    } else {
      print("File does not exist, creating new file.");
    }

    // Write some text to the file
    await file.writeAsString(
        '${origin}, ${DateTime.now()}, $e, Function name: $functionname\n',
        mode: FileMode.append);

    // Update the UI with the file path
    // setState(() {
    //   _filePath = file.path;
    // });

    print(
        "File written successfully at: ${file.path} on function : $functionname ");
    return file.path;
  } catch (e, stackTrace) {
    print("Error writing to file: $e");
    print("Stack trace: $stackTrace");
  }
}
