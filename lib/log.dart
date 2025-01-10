import 'dart:io';

import 'package:dthlms/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

Future<void> writeToFile(e, functionname) async {
  try {
    // Get the directory to store the file
    final directory = await getApplicationDocumentsDirectory();

    // Create a file in the app's document directory
    final file = File('${directory.path}/dthlmsProLog.txt');

    // Write some text to the file
    await file.writeAsString(
        '${origin}, ${DateTime.now()}, $e, Function name: $functionname\n',
        mode: FileMode.writeOnlyAppend);

    // Update the UI with the file path
    // setState(() {
    //   _filePath = file.path;
    // });

    print("File written successfully at: ${file.path} on function : $functionname ");
  } catch (e) {
    print("Error writing to file: $e");
  }
}
