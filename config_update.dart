// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// void main() async {
//   print('Reading configuration...');

//   // Load config.json
//   final configFile = File('config.json');
//   if (!await configFile.exists()) {
//     print('Error: config.json not found.');
//     return;
//   }

//   final config = json.decode(await configFile.readAsString());

//   final appName = config['app_name'] ?? 'DefaultApp';
//   final appId = config['app_id'] ?? 'com.example.defaultapp';
//   final versionName = config['version_name'] ?? '1.0.0';
//   final versionCode = config['version_code'] ?? 1;

//   print('Configuration loaded:');
//   print('App Name: $appName');
//   print('App ID: $appId');
//   print('Version Name: $versionName');
//   print('Version Code: $versionCode');

//   // Update Android build.gradle
//   print('Updating Android build.gradle...');
//   final buildGradleFile = File('android/app/build.gradle');
//   if (!await buildGradleFile.exists()) {
//     print('Error: android/app/build.gradle not found.');
//     return;
//   }

//   String buildGradleContent = await buildGradleFile.readAsString();
//   print(buildGradleContent + "gdsjhfgdshfshf////////////////");
//   buildGradleContent = buildGradleContent
//       .replaceAll(
//         RegExp(r'applicationId\s*=\s*".*"', caseSensitive: false),
//         'applicationId = "$appId"',
//       )
//       .replaceAll(
//         RegExp(r'versionName\s*=\s*".*"', caseSensitive: false),
//         'versionName = "$versionName"',
//       )
//       .replaceAll(
//         RegExp(r'versionCode\s*=\s*\d+', caseSensitive: false),
//         'versionCode = $versionCode',
//       );

//   // Write the updated content back to build.gradle
//   await buildGradleFile.writeAsString(buildGradleContent);
//   print('Android build.gradle updated successfully.');

//   // Update Windows runner.rc
//   print('Updating Windows runner.rc...');
//   final runnerRcFile = File('windows/runner/Runner.rc');
//   if (!await runnerRcFile.exists()) {
//     print('Error: windows/runner/Runner.rc not found.');
//     return;
//   }
//   String runnerRcContent = await runnerRcFile.readAsString();

//   // Replace placeholders in the .rc file
//   runnerRcContent = runnerRcContent.replaceAll(
//       RegExp(r'VALUE "CompanyName", ".*"'), 'VALUE "CompanyName", "$appId"');
//   runnerRcContent = runnerRcContent.replaceAll(
//       RegExp(r'VALUE "FileDescription", ".*"'),
//       'VALUE "FileDescription", "$appName"');
//   runnerRcContent = runnerRcContent.replaceAll(
//       RegExp(r'VALUE "ProductName", ".*"'), 'VALUE "ProductName", "$appName"');
//   runnerRcContent = runnerRcContent.replaceAll(
//       RegExp(r'VALUE "FileVersion", ".*"'),
//       'VALUE "FileVersion", "$versionName"');
//   runnerRcContent = runnerRcContent.replaceAll(
//       RegExp(r'VALUE "ProductVersion", ".*"'),
//       'VALUE "ProductVersion", "$versionName"');

//   await runnerRcFile.writeAsString(runnerRcContent);
//   print('Windows runner.rc updated successfully.');

//   // Update Windows CMakeLists.txt
//   print('Updating Windows CMakeLists.txt...');
//   final cmakeFile = File('windows/runner/CMakeLists.txt');
//   if (!await cmakeFile.exists()) {
//     print('Error: windows/runner/CMakeLists.txt not found.');
//     return;
//   }
//   String cmakeContent = await cmakeFile.readAsString();
//   cmakeContent = cmakeContent.replaceAll(
//       RegExp(r'set\(BINARY_NAME ".*"\)'), 'set(BINARY_NAME "$appName")');
//   await cmakeFile.writeAsString(cmakeContent);
//   print('Windows CMakeLists.txt updated successfully.');

//   print('Configuration updates completed successfully!');
// }

import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  // Check if all arguments are provided
  // Check if all arguments are provided
  if (arguments.length < 4) {
    print('Error: Missing required arguments. Usage:');
    print(
        'dart run update_config.dart <app_name> <app_id> <version_name> <version_code>');
    return;
  }

  // Parse arguments from the terminal
  final appName = arguments[0];
  final appId = arguments[1];
  final versionName = arguments[2];
  final versionCode = int.tryParse(arguments[3]) ?? 1;
  final logopath = arguments.length > 4
      ? arguments[4]
      : 'assets/icons/AAC.png'; // Optional argument for logopath
  final franchiseWebsiteLink = arguments.length > 5
      ? arguments[5]
      : ''; // Optional argument for franchise website link
  final facebookPageLink = arguments.length > 6
      ? arguments[6]
      : ''; // Optional argument for facebook page link
  final dbPassword = arguments.length > 7
      ? arguments[7]
      : 'test'; // Optional argument for db password
  final webSiteLink = arguments.length > 8
      ? arguments[8]
      : 'https://solutioninfotech.in'; // Optional argument for website link

  final constantFileLocation = File('lib/constants.dart');
  final constantFile = await constantFileLocation.readAsString();

  // Update constants.dart with new values
  String updatedConstantFile = constantFile
      .replaceAll(RegExp(r"const String origin = '.*';"),
          "const String origin = '$appId';")
      .replaceAll(RegExp(r"const String logopath = '.*';"),
          "const String logopath = '$logopath';")
      .replaceAll(RegExp(r"const String franchiseWebsiteLink = '.*';"),
          "const String franchiseWebsiteLink = '$franchiseWebsiteLink';")
      .replaceAll(RegExp(r"const String facebookPageLink = '.*';"),
          "const String facebookPageLink = '$facebookPageLink';")
      .replaceAll(RegExp(r"const String dbPassword = '.*';"),
          "const String dbPassword = '$dbPassword';")
      .replaceAll(RegExp(r"String webSiteLink = '.*';"),
          "String webSiteLink = '$webSiteLink';");

  // Write the updated content back to constants.dart
  await constantFileLocation.writeAsString(updatedConstantFile);
  print('Constants file updated successfully.');

  print('Configuration loaded:');
  print('App Name: $appName');
  print('App ID: $appId');
  print('Version Name: $versionName');
  print('Version Code: $versionCode');

  // Update Android build.gradle
  print('Updating Android build.gradle...');
  final buildGradleFile = File('android/app/build.gradle');
  if (!await buildGradleFile.exists()) {
    print('Error: android/app/build.gradle not found.');
    return;
  }

  String buildGradleContent = await buildGradleFile.readAsString();
  buildGradleContent = buildGradleContent
      .replaceAll(
        RegExp(r'applicationId\s*=\s*".*"', caseSensitive: false),
        'applicationId = "$appId"',
      )
      .replaceAll(
        RegExp(r'versionName\s*=\s*".*"', caseSensitive: false),
        'versionName = "$versionName"',
      )
      .replaceAll(
        RegExp(r'versionCode\s*=\s*\d+', caseSensitive: false),
        'versionCode = $versionCode',
      );

  // Write the updated content back to build.gradle
  await buildGradleFile.writeAsString(buildGradleContent);
  print('Android build.gradle updated successfully.');

  // Update Windows runner.rc
  print('Updating Windows runner.rc...');
  final runnerRcFile = File('windows/runner/Runner.rc');
  if (!await runnerRcFile.exists()) {
    print('Error: windows/runner/Runner.rc not found.');
    return;
  }
  String runnerRcContent = await runnerRcFile.readAsString();

  // Replace placeholders in the .rc file
  runnerRcContent = runnerRcContent.replaceAll(
      RegExp(r'VALUE "CompanyName", ".*"'), 'VALUE "CompanyName", "$appId"');
  runnerRcContent = runnerRcContent.replaceAll(
      RegExp(r'VALUE "FileDescription", ".*"'),
      'VALUE "FileDescription", "$appName"');
  runnerRcContent = runnerRcContent.replaceAll(
      RegExp(r'VALUE "ProductName", ".*"'), 'VALUE "ProductName", "$appName"');
  runnerRcContent = runnerRcContent.replaceAll(
      RegExp(r'VALUE "FileVersion", ".*"'),
      'VALUE "FileVersion", "$versionName"');
  runnerRcContent = runnerRcContent.replaceAll(
      RegExp(r'VALUE "ProductVersion", ".*"'),
      'VALUE "ProductVersion", "$versionName"');

  await runnerRcFile.writeAsString(runnerRcContent);
  print('Windows runner.rc updated successfully.');

  // Update Windows CMakeLists.txt
  print('Updating Windows CMakeLists.txt...');
  final cmakeFile = File('windows/runner/CMakeLists.txt');
  if (!await cmakeFile.exists()) {
    print('Error: windows/runner/CMakeLists.txt not found.');
    return;
  }
  String cmakeContent = await cmakeFile.readAsString();
  cmakeContent = cmakeContent.replaceAll(
      RegExp(r'set\(BINARY_NAME ".*"\)'), 'set(BINARY_NAME "$appName")');
  await cmakeFile.writeAsString(cmakeContent);
  print('Windows CMakeLists.txt updated successfully.');

  print('Configuration updates completed successfully!');
}
