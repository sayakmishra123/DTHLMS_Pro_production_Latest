import 'dart:convert';
import 'dart:io';

void main() async {
  print('Reading configuration...');

  // Load config.json
  final configFile = File('config.json');
  if (!await configFile.exists()) {
    print('Error: config.json not found.');
    return;
  }

  final config = json.decode(await configFile.readAsString());

  final appName = config['app_name'] ?? 'DefaultApp';
  final appId = config['app_id'] ?? 'com.example.defaultapp';
  final versionName = config['version_name'] ?? '1.0.0';
  final versionCode = config['version_code'] ?? 1;

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
      .replaceAll(RegExp(r'applicationId ".*"'), 'applicationId "$appId"')
      .replaceAll(RegExp(r'versionName ".*"'), 'versionName "$versionName"')
      .replaceAll(RegExp(r'versionCode \d+'), 'versionCode $versionCode');
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
