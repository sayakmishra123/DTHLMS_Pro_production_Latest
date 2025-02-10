import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/ERROR_MASSEGE/errorhandling.dart';

import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:dthlms/constants.dart';
// import 'package:dthlms/constants/constants.dart';
import 'package:dthlms/log.dart';

import 'package:flutter/material.dart';
// import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqlite3/sqlite3.dart' as sql;
import 'package:sqlite3/sqlite3.dart';

late sql.Database _db;

/// Create crypted database on Windows
void testSQLCipherOnWindows() async {
  //Create DB with password

  // final String password = "test";
  //Local DB file path
  Directory appDocDir = await getApplicationSupportDirectory();
  String appDocPath = appDocDir.path + '${Platform.pathSeparator}$origin';
  String filename = "$appDocPath${Platform.pathSeparator}DTHLMSProDB.sqlite";
  Directory("$appDocPath${Platform.pathSeparator}").createSync(recursive: true);
  getx.dbPath.value = filename;
  print(filename);

  _db = sql.sqlite3.open(
    filename,
    mode: sql.OpenMode.readWriteCreate,
  );

  print(sqlite3.version);
  if (_db.handle.address > 0) {
    print("Database created here: $filename");
    _db.execute(
      "PRAGMA key = '$dbPassword'",
    );
    print("Database password set: $dbPassword");
  }

  getVersion();
  _createDB();
  createtblPackageDetails();
  createtblMCQhistory();
  creatTableVideoplayInfo();
  createTblSetting();
  createTblStudentFeedback();
  createTblPackageData();

  createtblSectionFilesDetails();

  createtblPackageDetails();
  createTblImages();
  createTblNotifications();
}

void getVersion() {
  final sql.ResultSet resultSet = _db.select(
    "SELECT sqlite_version()",
  );
  resultSet.forEach((element) {
    log(element.entries.toString());
  });

  // _db.execute('PRAGMA user_version = 5;');
  final newVersionResult = _db.select('PRAGMA user_version;');
  final newVersion = newVersionResult.first['user_version'] as int;
  print('New user_version: $newVersion');

  final sql.ResultSet resultSet2 = _db.select("PRAGMA cipher_version");
  resultSet2.forEach((element) {});
}

void createsayak() {
  // _db.execute("CREATE TABLE Sayak (Name TEXT,Roll TEXT)");

  // _db.execute("ALTER TABLE Sayak ADD COLUMN Age TEXT");
  // _db.execute("ALTER TABLE Sayak ADD COLUMN Phone TEXT");
}

void createTblVideoComponents() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblVideoComponents( 
   ComponentId TEXT,
     PackageId TEXT ,
     VideoId TEXT,
     Names TEXT,
     Option1 TEXT,
     Option2 TEXT,
     Option3 TEXT,
     Option4 TEXT,
     VideoTime TEXT,
     Answer TEXT,
     Category TEXT,                                                                 
     TagName TEXT,
     DocumentId TEXT,
     DocumentURL TEXT,
     IsVideoCompulsory TEXT,
     IsChapterCompulsory TEXT,
     PreviousVideoId TEXT,
     MinimumVideoDuration TEXT,
     PreviousChapterId TEXT,
     SessionId TEXT,
     FranchiseId TEXT,
     DownloadedPath TEXT,
     IsEncrypted TEXT
      );
  ''');

  // log()
}

Future<void> insertTblVideoComponents(
    String componentId,
    String packageId,
    String videoId,
    String names,
    String option1,
    String option2,
    String option3,
    String option4,
    String videoTime,
    String answer,
    String category,
    String tagName,
    String documentId,
    String documentURL,
    String isVideoCompulsory,
    String isChapterCompulsory,
    String previousVideoId,
    String minimumVideoDuration,
    String previousChapterId,
    String sessionId,
    String franchiseId,
    String downloadedPath,
    String isEncrypted) async {
  _db.execute('''
       INSERT INTO TblVideoComponents(PackageId, VideoId, Names,Option1,Option2,Option3,Option4,VideoTime,Answer,Category,TagName,DocumentId,DocumentURL,IsVideoCompulsory,IsChapterCompulsory,PreviousVideoId,MinimumVideoDuration,PreviousChapterId,SessionId,FranchiseId,DownloadedPath,IsEncrypted,ComponentId) 
      VALUES ('$packageId', '$videoId', '$names','$option1','$option2','$option3','$option4','$videoTime','$answer','$category','$tagName','$documentId','$documentURL','$isVideoCompulsory','$isChapterCompulsory','$previousVideoId','$minimumVideoDuration','$previousChapterId','$sessionId','$franchiseId','$downloadedPath','$isEncrypted','$componentId');
    ''');
}

void createtblPackageDetails() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblAllPackageDetails(
   PackageId TEXT,
   PackageName TEXT,
   FileIdType TEXT,
   FileId TEXT,
   FileIdName TEXT,
   ChapterId TEXT,
   AllowDuration TEXT,
   ConsumeDuration TEXT,
   ConsumeNos TEXT,
   AllowNo TEXT,
   DocumentPath TEXT,
   ScheduleOn TEXT,
   SessionId TEXT,
   DownloadedPath TEXT,
   VideoDuration TEXT,
   IsEncrypted TEXT,
   SortedOrder TEXT,
   DurationLimitation TEXT,
   ViewCount TEXT
   );
  ''');
}

void createtblSession() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblSession(
   LoginId TEXT,
   LoginPassword TEXT,
   Session TEXT,
   LoginTime TEXT,
   UserName TEXT,
   Email TEXT,
   MobileNo TEXT,
   StudentImage TEXT,
   NameId TEXT);
  ''');
  // log()
}

void createTblStudentFeedback() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblStudentFeedback(
   ComponentId TEXT,
   VideoId TEXT,
   PackageId TEXT,
   Answer TEXT,
   UploadFlag TEXT
 );
  ''');
  // log()
}

Future<void> insertTblStudentFeedback(String componentId, String packageId,
    String answer, String uploadflag, String videoId) async {
  _db.execute('''
        INSERT INTO TblStudentFeedback (
          ComponentId, PackageId, Answer,VideoId, UploadFlag
        ) VALUES (?, ?, ?, ?,?);
      ''', [
    componentId,
    packageId,
    answer,
    videoId,
    uploadflag,
  ]);
}

Future<void> insertTblSession(
    String loginId,
    String loginPassword,
    String session,
    String loginTime,
    String userName,
    String email,
    String mobileNo,
    String studentImage,
    String nameId) async {
  _db.execute('''
       INSERT INTO TblSession(LoginId, LoginPassword, Session,LoginTime,UserName,Email,MobileNo,StudentImage,NameId) 
      VALUES ('$loginId', '$loginPassword', '$session','$loginTime','$userName','$email','$mobileNo','$studentImage','$nameId');
    ''');
}

Future<void> readTblSession() async {
  final sql.ResultSet resultSet = _db.select('SELECT * FROM TblSession');
  if (getx.sessionData.isNotEmpty) {
    getx.sessionData.clear();
  }
  resultSet.forEach((row) {
    Map<String, dynamic> details = {
      'LoginId': row['LoginId'],
      'LoginPassword': row['LoginPassword'],
      'Session': row['Session'],
      'LoginTime': row['LoginTime'],
      'UserName': row['UserName'],
      'Email': row['Email'],
      'MobileNo': row['MobileNo'],
      'StudentImage': row['StudentImage'],
      'NameId': row['NameId'],
    };
    getx.sessionData.add(details);
  });
}

void deleteSessionDetails() {
  _db.execute('DELETE FROM TblSession');
  getx.sessionData.clear();

  print("Session data cleared");
}

void deleteVideoComponents() {
  _db.execute('DELETE FROM TblVideoComponents');
  getx.sessionData.clear();

  print("TblVideoComponents data cleared");
}

void createDownloadFileData() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblDownloadedFileData( 
     PackageId TEXT ,
     FileId TEXT,
     DownloadedPath TEXT,
     FileType TEXT,
     Names TEXT
   );
  ''');
  // log()
  print('TblDownlodedFileData created!');
}

void createDownloadFileDataOfVideo() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblDownloadedFileDataOfVideo( 
     PackageId TEXT ,
     FileId TEXT,
     DocumentId TEXT,
     DownloadedPath TEXT,
     FileType TEXT,
     Names TEXT
   );
  ''');
  // log()
  print('TblDownlodedFileDataofVideo created!');
}

Future<void> insertDownloadedFileDataOfVideo(
    String packageId,
    String fileId,
    String documentId,
    String downloadedPath,
    String fileType,
    String names) async {
  // Delete existing record if it exists
  _db.execute('''
    DELETE FROM TblDownloadedFileDataOfVideo 
    WHERE PackageId = '$packageId' AND FileId = '$fileId' AND FileType='$fileType' AND DocumentId='$documentId';
  ''');

  // Insert the new record
  _db.execute('''
    INSERT INTO TblDownloadedFileDataOfVideo(PackageId, FileId, DownloadedPath,FileType,DocumentId,Names) 
    VALUES ('$packageId', '$fileId', '$downloadedPath','$fileType','$documentId','$names');
  ''');
}

Future<void> insertDownloadedFileData(String packageId, String fileId,
    String downloadedPath, String fileType, String name) async {
  // Delete existing record if it exists
  _db.execute('''
    DELETE FROM TblDownloadedFileData 
    WHERE PackageId = '$packageId' AND FileId = '$fileId' AND FileType='$fileType';
  ''');

  // Insert the new record
  _db.execute('''
    INSERT INTO TblDownloadedFileData(PackageId, FileId, DownloadedPath,FileType,Names) 
    VALUES ('$packageId', '$fileId', '$downloadedPath','$fileType','$name');
  ''');
}

void createTblPackageData() {
  _db.execute('''
    CREATE TABLE IF NOT EXISTS TblPackageData( 

     PackageId TEXT PRIMARY KEY,  
      PackageName TEXT,
      ExpiryDate TEXT,
      IsUpdate TEXT,
      IsShow TEXT,
      LastUpdatedOn TEXT,
      CourseId TEXT,
      CourseName TEXT,
      IsFree TEXT,
      IsDirectPlay
    );
  ''');
  print('TblPackageData created with PackageId as the primary key!');
}

void createTblLocalNavigation() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblLocalNavigation( 
     NavigationId TEXT ,
     NavigationType TEXT,
     NavigationName TEXT,
     NavigationOrder INTEGER );
  ''');
  // log()
  print('TblLocalNavigation created!');
}

void deletetblpackage() {
  // Create a table and insert some data
  _db.execute('''
  DROP TABLE IF EXISTS TblAllPackageDetails
  ''');
  // log()
  print('TblLocalNavigation deleted!');
}

void creatTablePackageFolderDetails() {
  _db.execute('''
CREATE TABLE IF NOT EXISTS TblAllFolderDetails(SectionChapterId TEXT,
SectionChapterName TEXT,
ParentSectionChapterId TEXT,
PackageId TEXT,
StartParentId TEXT);
''');
}

void createtblSectionFilesDetails() {
  // Create a table and insert some data
  _db.execute('''
          CREATE TABLE IF NOT EXISTS TblSectionFilesDetails(
            SectionChapterId TEXT PRIMARY KEY,
            SectionChapterName TEXT,
            SortedOrder TEXT
          )
          ''');
  // log()
  print('tblSectionFilesDetails');
}

void createTblSetting() {
  // Create a table and insert some data
  _db.execute('''
          CREATE TABLE IF NOT EXISTS TblSetting(
            FieldName TEXT,
            Value TEXT
            
          )
          ''');
  // log()
  print('createTblSetting');
}

void deleteDataFromTblSettings() {
  try {
    _db.execute('DELETE FROM TblSetting');
  } catch (e) {
    writeToFile(e, "deleteDataFromTblSettings");
    print("eror while delete deleteDataFromTblSettings---- ${e.toString()}");
  }
}

Future<void> insertTblSetting(
  String fieldName,
  String value,
) async {
  try {
    _db.execute('''
       INSERT INTO TblSetting (fieldName, value) 
      VALUES ('$fieldName', '$value');
    ''');
    print("dtails insert on Navigation table $fieldName");
  } catch (e) {
    writeToFile(e, 'insertTblSetting');
    print("error while insert in tbl settings:--" + e.toString());
  }
}

// Future<Map<String, dynamic>> fetchTblSettingKey() async {
//   final sql.ResultSet resultSet =
//       await _db.select('SELECT * FROM TblSetting');

//   // Create a list to hold the results
//   Map<String, dynamic> tblMCQSectionList = {};

//   // Loop through each row and add it to the list
//   for (var row in resultSet) {
//     // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
//     tblMCQSectionList.add({
//       'OSKKEY': row['SectionId'],
//       'ENKEY': row['PaperId'],

//     });
//   }

//   return tblMCQSectionList;
// }

Future<Map<String, dynamic>> getAllPackageDetailsForLastRow(fileId) async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
      SELECT * FROM TblAllPackageDetails 
      WHERE FileId = ? 
      ORDER BY ROWID DESC 
      LIMIT 1
    ''', [fileId]);

    if (result.isNotEmpty) {
      return result.first; // Return the last row where fileId matches as a map
    } else {
      return {}; // Return an empty map if no rows are found
    }
  } catch (e) {
    writeToFile(e, "getAllPackageDetailsForLastRow");
    print(e);
    return {}; // Return an empty map in case of an error
  }
}

Future<List<Map<String, dynamic>>> getAllPackageDetailsForVideoCount(
    String packageId) async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
      SELECT * FROM TblAllPackageDetails 
      WHERE PackageId = ? AND FileIdType = ?
    ''', [packageId, 'Video']);

    return result; // Return all rows matching the conditions
  } catch (e) {
    writeToFile(e, "getAllPackageDetailsForVideoCount");
    print(e);
    return []; // Return an empty list in case of an error
  }
}

Future<List<Map<String, dynamic>>> getAllPackageDetailsForBooksCount(
    String packageId) async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
      SELECT * FROM TblAllPackageDetails  
      WHERE PackageId = ? AND FileIdType = ?
    ''', [packageId, 'Book']);

    return result; // Return all rows matching the conditions
  } catch (e) {
    writeToFile(e, "getAllPackageDetailsForBooksCount");
    print(e);
    return []; // Return an empty list in case of an error
  }
}

Future<void> insertVideoplayInfo(
    int videoId,
    String startingTimeLine,
    String watchduration,
    String playBackSpeed,
    String startClockTime,
    int playNo,
    int uploadflag,
    {String type = "video"}) async {
  try {
    log(playBackSpeed.toString());
    log(playNo.toString());
    // print(videoId.toString() + watchduration.toString());

    // Check if the PlayNo already exists in the database
    final sql.ResultSet resultSet = await _db.select('''
      SELECT * FROM TblvideoPlayInfo WHERE PlayNo = $playNo
    ''');

    log(resultSet.toString());

    // If the record with the same PlayNo exists, update the watch duration
    if (resultSet.length > 0) {
      _db.execute('''
        UPDATE TblvideoPlayInfo
        SET SpendTime = '$watchduration'
        WHERE PlayNo = $playNo
      ''');
      print("Update successful: WatchDuration updated for PlayNo $playNo");
    } else {
      // If the record does not exist, insert a new record
      _db.execute('''
        INSERT INTO TblvideoPlayInfo (VideoId, StartDuration, SpendTime, Speed, StartTime, PlayNo,UploadFlag,Type)
        VALUES ('$videoId', '$startingTimeLine', '$watchduration', '$playBackSpeed', '$startClockTime', '$playNo','$uploadflag','$type')
      ''');
      // print("Insert successful: New record inserted");
    }
  } catch (e) {
    writeToFile(e, "insertVideoplayInfo");
    print("Error: ${e.toString()}");
  }
}

Future<double> getTotalWatchTime(int videoId) async {
  try {
    // Fetch all records for the given videoId
    final sql.ResultSet resultSet = await _db.select('''
      SELECT * FROM TblvideoPlayInfo WHERE VideoId = $videoId
    ''');

    double totalWatchTime = 0.0;

    // Iterate through the results and calculate total watch time
    for (var row in resultSet) {
      // Fetch EndDuration and Speed values from the result row
      double endDuration = double.tryParse(row['SpendTime']) ?? 0.0;
      double speed = double.tryParse(row['Speed']) ??
          1.0; // Assuming speed defaults to 1 if invalid

      // Calculate the total watch time for this row
      totalWatchTime += (endDuration * speed);
    }

    print("Total Watch Time for VideoId $videoId: $totalWatchTime");

    return totalWatchTime;
  } catch (e) {
    print("Error: ${e.toString()}");
    return 0.0; // Return 0 in case of error
  }
}

// Future<Map<String, dynamic>> getVideoDetails( fileId, packageId) async {
Future<Map<String, dynamic>> getVideoDetails(fileId, packageId) async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
      SELECT * FROM TblAllPackageDetails 
      WHERE FileId = ? AND PackageId = ?
    ''', [fileId, packageId]);

    if (result.isNotEmpty) {
      return result.first; // Return the first matching row
    } else {
      return {}; // Return an empty map if no rows are found
    }
  } catch (e) {
    writeToFile(e, "getVideoDetails");
    print(e);
    return {}; // Return an empty map in case of an error
  }
}

void creatTableVideoplayInfo() {
  _db.execute('''
CREATE TABLE IF NOT EXISTS TblvideoPlayInfo(VideoId INTEGER,
StartDuration TEXT,
SpendTime TEXT,
Speed TEXT,
StartTime TEXT,
PlayNo INTEGER,
UploadFlag INTEGER DEFAULT 0,
Type TEXT DEFAULT 'video');
''');
}

Future<Map<String, dynamic>> getLastRow() async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
    SELECT * FROM TblvideoPlayInfo WHERE Type='video'
    ORDER BY ROWID DESC 
    LIMIT 1
  ''');

    if (result.isNotEmpty) {
      return result.first; // Return the last row as a map
    } else {
      return {}; // Return null if no rows are found
    }
  } catch (e) {
    writeToFile(e, "getLastRow");
    print(e);
    return {}; // Return null if no rows are found
  }
}

Future<List<Map<String, dynamic>>> getPlayInfo() async {
  try {
    // Replace '_db' with your database instance
    List<Map<String, dynamic>> result = await _db.select('''
    SELECT * FROM TblvideoPlayInfo
  ''');

    if (result.isNotEmpty) {
      return result; // Return all rows as a list of maps
    } else {
      return []; // Return an empty list if no rows are found
    }
  } catch (e) {
    writeToFile(e, "getPlayInfo");
    print(e);
    return []; // Return an empty list in case of an error
  }
}

String getLastEndDuration(int videoId) {
  try {
    // Ensure the database is initialized and accessible as _db
    final List<Map<String, dynamic>> result = _db.select('''
      SELECT SpendTime 
      FROM TblvideoPlayInfo 
      WHERE VideoId = ? 
      ORDER BY ROWID DESC 
      LIMIT 1
    ''', [videoId]);

    // Check if the result is not empty and return the EndDuration value
    if (result.isNotEmpty) {
      print(result.first['SpendTime'] + 'End Duration');
      return result.first['SpendTime'] as String;
    } else {
      return "0"; // Return null if no result is found
    }
  } catch (e) {
    writeToFile(e, 'getLastEndDuration');

    // Handle any potential errors that may occur during the query
    print('Error fetching SpendTime: ${e.toString()}');
    return "0";
  }
}

void creatTblFileInfo() {
  _db.execute('''
CREATE TABLE IF NOT EXISTS TblFileInfo(FileId INTEGER,
FileType TEXT,
FilePath TEXT,
);
''');
}

Future<void> insertTblFileinfo(
  int fileId,
  String fileIdType,
  String filePath,
) async {
  _db.execute('''
       INSERT INTO TblFileInfo (FileId, FileType, FilePath) 
      VALUES ('$fileId', '$fileIdType', '$filePath');
    ''');
}

Future<void> insertOrUpdateTblPackageData(
    int packageId,
    String packageName,
    String expiryDate,
    String isUpdate,
    String isShow,
    String lastUpdatedOn,
    String courseId,
    String courseName,
    String isFree,
    String isDirectPlay) async {
  _db.execute('''
    INSERT INTO TblPackageData(PackageId, PackageName, ExpiryDate, IsUpdate, IsShow, LastUpdatedOn,CourseId,CourseName,IsFree,IsDirectPlay) 
    VALUES ('$packageId', '$packageName', '$expiryDate', '$isUpdate', '$isShow', '$lastUpdatedOn','$courseId','$courseName','$isFree','$isDirectPlay')
    ON CONFLICT(PackageId) 
    DO UPDATE SET 
      PackageName = excluded.PackageName,
      ExpiryDate = excluded.ExpiryDate,
      IsUpdate = excluded.IsUpdate,
      IsShow = excluded.IsShow,
      LastUpdatedOn = excluded.LastUpdatedOn,
      CourseName=excluded.CourseName,
      CourseId=excluded.CourseId,
      IsFree=excluded.IsFree,
      IsDirectPlay=excluded.IsDirectPlay;
      
      ;
  ''');
  print("Insert or update on TblPackageData");
}

// CREATE TABLE TblPackageData(
//       PackageId TEXT PRIMARY KEY,
//       PackageName TEXT,
//       ExpiryDate TEXT,
//       IsUpdate TEXT,
//       IsShow TEXT,
//       LastUpdatedOn TEXT
//     )

// Future<void> insertVideoplayInfo(
//     int videoId,
//     String startingTimeLine,
//     String watchduration,
//     String playBackSpeed,
//     String startClockTime,
//     int playNo) async {
//   try {
//     // print(videoId.toString() + watchduration.toString());

//     // Check if the PlayNo already exists in the database
//     final sql.ResultSet resultSet = await _db.select('''
//       SELECT * FROM TblvideoPlayInfo WHERE PlayNo = $playNo
//     ''');

//     // If the record with the same PlayNo exists, update the watch duration
//     if (resultSet.length > 0) {
//       _db.execute('''
//         UPDATE TblvideoPlayInfo
//         SET EndDuration = '$watchduration'
//         WHERE PlayNo = $playNo
//       ''');
//       print("Update successful: WatchDuration updated for PlayNo $playNo");
//     } else {
//       // If the record does not exist, insert a new record
//       _db.execute('''
//         INSERT INTO TblvideoPlayInfo (VideoId, StartDuration, EndDuration, Speed, StartTime, PlayNo)
//         VALUES ('$videoId', '$startingTimeLine', '$watchduration', '$playBackSpeed', '$startClockTime', '$playNo')
//       ''');
//       print("Insert successful: New record inserted");
//     }
//   } catch (e) {
//     print("Error: ${e.toString()}");
//   }
// }
// Future<void> insertVideoplayInfo(
//     int videoId,
//     String startingTimeLine,
//     String watchduration,
//     String playBackSpeed,
//     String startClockTime,
//     int playNo) async {
//   try {
//     // print(videoId.toString() + watchduration.toString());

//     // Check if the PlayNo already exists in the database
//     final sql.ResultSet resultSet = await _db.select('''
//       SELECT * FROM TblvideoPlayInfo WHERE PlayNo = $playNo
//     ''');

//     // If the record with the same PlayNo exists, update the watch duration
//     if (resultSet.length > 0) {
//       _db.execute('''
//         UPDATE TblvideoPlayInfo
//         SET EndDuration = '$watchduration'
//         WHERE PlayNo = $playNo
//       ''');
//       print("Update successful: WatchDuration updated for PlayNo $playNo");
//     } else {
//       // If the record does not exist, insert a new record
//       _db.execute('''
//         INSERT INTO TblvideoPlayInfo (VideoId, StartDuration, EndDuration, Speed, StartTime, PlayNo)
//         VALUES ('$videoId', '$startingTimeLine', '$watchduration', '$playBackSpeed', '$startClockTime', '$playNo')
//       ''');
//       print("Insert successful: New record inserted");
//     }
//   } catch (e) {
//     print("Error: ${e.toString()}");
//   }
// }

// new added
Future<void> insertPackageDetailsdata(
    String packageId,
    String packageName,
    String fileIdType,
    String fileId,
    String fileIdName,
    String chapterId,
    String allowDuration,
    String consumeDuration,
    String consumeNos,
    String allowNo,
    String documentPath,
    String scheduleOn,
    String sessionId,
    String videoDuration,
    String DownloadedPath,
    String isEncrypted,
    String sortedOrder,String? viewCount,String? durationLimitation) async {
  _db.execute('''
       INSERT INTO TblAllPackageDetails(PackageId,PackageName,FileIdType,FileId,FileIdName,ChapterId,AllowDuration,ConsumeDuration,ConsumeNos,AllowNo,DocumentPath,ScheduleOn,SessionId,DownloadedPath,VideoDuration,IsEncrypted,SortedOrder,DurationLimitation,ViewCount) 
      VALUES ('$packageId','$packageName','$fileIdType','$fileId','$fileIdName','$chapterId','$allowDuration','$consumeDuration','$consumeNos','$allowNo','$documentPath','$scheduleOn','$sessionId','$DownloadedPath','$videoDuration','$isEncrypted','$sortedOrder','$durationLimitation','$viewCount');
    ''');

  // return null;
}

Future<void> insertVideoDownloadPath(String videoId, String packageId,
    String downloadedVideoPath, BuildContext context) async {
  try {
    _db.execute('''
      UPDATE TblAllPackageDetails
      SET DownloadedPath = ?
      WHERE FileId = ? AND PackageId = ?;
    ''', [downloadedVideoPath, videoId, packageId]);

    getx.alwaysShowChapterfilesOfVideo.forEach((item) {
      if (item['PackageId'] == packageId && item['FileId'] == videoId) {
        print("foun the video of id $videoId on list");

        item['DownloadedPath'] = downloadedVideoPath;
      }
    });

    print("save on list");
  } catch (e) {
    writeToFile(e, 'insertVideoDownloadPath');
    print('Failed to update details: ${e.toString()}');
  }
}

Future<void> updateVideoConsumeDuration(
  String videoId,
  String packageId,
  String consumeDuration,
) async {
  try {
    _db.execute('''
      UPDATE TblAllPackageDetails
      SET ConsumeDuration = ?
      WHERE FileId = ? AND PackageId = ?;
    ''', [consumeDuration, videoId, packageId]);

    getx.alwaysShowChapterfilesOfVideo.forEach((item) {
      if (item['PackageId'] == packageId && item['FileId'] == videoId) {
        item['ConsumeDuration'] = consumeDuration;
      }
    });

    print("save on list");
  } catch (e) {
    writeToFile(e, 'updateVideoConsumeDuration');
    print('Failed to update details: ${e.toString()}');
  }
}

Future<Map<String, String>> getPackageVideoWatchDuration({
  required String packageId,
  required String packageName,
  required String fileIdType,
  required String fileId,
  required String fileIdName,
  required String chapterId,
}) async {
  try {
    // Query to fetch the details based on the given fields
    final sql.ResultSet resultSet = await _db.select('''
      SELECT AllowDuration, VideoDuration
      FROM TblAllPackageDetails 
      WHERE PackageId = '$packageId'
      AND PackageName = '$packageName'
      AND FileIdType = '$fileIdType'
      AND FileId = '$fileId'
      AND FileIdName = '$fileIdName'
      AND ChapterId = '$chapterId'
    ''');

    // Check if any results were returned
    if (resultSet.isNotEmpty) {
      // Extract AllowDuration and VideoDuration from the first result row
      String allowDuration = resultSet.first['AllowDuration'] ?? '';
      String videoDuration = resultSet.first['VideoDuration'] ?? '';

      // Return the result as a Map
      return {
        'AllowDuration': allowDuration,
        'VideoDuration': videoDuration,
      };
    } else {
      // If no matching record is found, return an empty map
      return {};
    }
  } catch (e) {
    print("Error: ${e.toString()}");
    return {}; // Return an empty map in case of error
  }
}

Future<void> insertTblLocalNavigation(
  String navigationtype,
  String navigationId,
  String navigationName,
) async {
  final List<Map<String, dynamic>> result =
      await _db.select('SELECT COUNT(*) AS count FROM TblLocalNavigation');

  // Extract the count from the result
  int rowCount = result.isNotEmpty ? result.first['count'] as int : 0;

  _db.execute('''
       INSERT INTO TblLocalNavigation(NavigationId,NavigationType,NavigationName,NavigationOrder) 
      VALUES ('$navigationId','$navigationtype','$navigationName','$rowCount');
    ''');
  print("dtails insert on Navigation table $navigationName");
}

Future<void> insertFolderDetailsdata(
    String sectionChapterId,
    String sectionChapterName,
    String parentSectionChapterId,
    String packageId,
    String startParentId) async {
  _db.execute('''
INSERT INTO TblAllFolderDetails(SectionChapterId,SectionChapterName,ParentSectionChapterId,PackageId,StartParentId)
VALUES ('$sectionChapterId','$sectionChapterName','$parentSectionChapterId','$packageId','$startParentId');
''');
  // print("Inserted folder Details ");
}

Future<void> inserttblChapter(String chapterId, String chapterName,
    String packageId, String parentId, String fileType) async {
  _db.execute('''
       INSERT INTO TblChapter (ChapterId, ChapterName, PackageId,ParentId,FileType) 
      VALUES ('$chapterId', '$chapterName', '$packageId','$parentId','$fileType');
    ''');
}

Future<void> readTblvideoPlayInfo() async {
  final sql.ResultSet resultSet = _db.select('SELECT * FROM TblvideoPlayInfo');
  resultSet.forEach((row) {
    print("///////////////////////////////////////////");
    print(row.values);
    print("///////////////////////////////////////////");
  });
}

Future<void> readLoginData() async {
  final sql.ResultSet resultSet = _db.select('SELECT * FROM UserLogin');
  resultSet.forEach((row) {});
}

Future<void> readPackageDetailsdata() async {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblAllPackageDetails');

  if (getx.calenderEvents.isNotEmpty) {
    getx.calenderEvents.clear();
  }
  if (getx.testWrittenExamList.isNotEmpty) {
    getx.testWrittenExamList.clear();
  }
  resultSet.forEach((row) {
    final details = {
      'PackageId': row['PackageId'],
      'FileId': row['FileId'],
      'FileIdName': row['FileIdName'],
      'ChapterId': row['ChapterId'] ?? "0",
      'ScheduleOn': row['ScheduleOn'],
      'FileIdType': row['FileIdType'],
      'SessionId': row['SessionId'] ?? "0",
      'PackageName': row['PackageName'],
      'VideoDuration': row['VideoDuration'],
      'AllowDuration': row['AllowDuration'],
      'ConsumeDuration': row['ConsumeDuration'],
      'ConsumeNos': row['ConsumeNos'],
      'AllowNo': row['AllowNo'],
      'DocumentPath': row['DocumentPath'],
      'DownloadedPath': row['DownloadedPath'],
    };
    getx.calenderEvents.add(details);
    if (row['FileIdType'] == "Test") {
      getx.testWrittenExamList.add(details);
    }
  });
}

Future<void> getAllPackageListOfStudent() async {
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblPackageData');

  if (getx.studentPackage.isNotEmpty) {
    try {
      getx.studentPackage.clear();
    } catch (e) {
      writeToFile(e, 'getAllPackageListOfStudent');
      print("Error on clear studentPackageList: ${e.toString()}");
    }
  }

  resultSet.forEach((row) {
    // Parse ExpiryDate from string to DateTime
    DateTime expiryDate = DateTime.parse(row['ExpiryDate']);
    DateTime currentDate = DateTime.now();

    // Check if the package is still valid and should be shown
    if (row['IsShow'] == '1' && expiryDate.isAfter(currentDate)) {
      Map<String, dynamic> packageData = {
        'packageId': row['PackageId'],
        'packageName': row['PackageName'],
        'ExpiryDate': row['ExpiryDate'],
        'IsShow': row['IsShow'],
        'LastUpdatedOn': row['LastUpdatedOn'],
        'CourseName': row['CourseName'],
        'IsFree': row['IsFree'],
      };
      getx.studentPackage.add(packageData);
    }
  });
}

void deleteAllPackage() {
  _db.execute('DELETE FROM TblPackageData');
  _db.execute('DELETE FROM TblAllPackageDetails');
  getx.studentPackage.clear();
  getx.sectionListOfPackage.clear();
  print("Package deleted");
}

void deleteAllFolders() {
  _db.execute('DELETE FROM TblAllFolderDetails');

  print("Package deleted");
}

Future<void> getSectionListOfPackage(
  int packageId,
) async {
  final sql.ResultSet resultSet = _db.select(
      'SELECT DISTINCT FileIdType FROM TblAllPackageDetails  WHERE PackageId= $packageId');

  if (getx.sectionListOfPackage.isNotEmpty) {
    getx.sectionListOfPackage.clear();
  }

  if (resultSet.isNotEmpty) {
    resultSet.forEach((row) {
      print(row['FileIdType']);
      Map<String, dynamic> sectionData = {
        'section': row['FileIdType'],
      };
      // getx..sectionlist.addAllIf(sectionData['section']!='Pdf', sectionData.f)
      getx.sectionListOfPackage.add(sectionData);
    });
  } else {
    // log("Section List is Empty");
  }
}

Future<void> readFolderDetailsdata() async {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblAllFolderDetails');

  resultSet.forEach((row) {});
}

Future<int> getStartParentId(int packageId) async {
  try {
    // First query to get the StartParentId

    final startParentIdResult = await _db.select(
      '''
SELECT StartParentId FROM TblAllFolderDetails WHERE PackageId = '$packageId'
  ''',
    );

    if (startParentIdResult.isNotEmpty) {
      final startParentId = startParentIdResult.first['StartParentId'];

      return int.parse(startParentId);

//       // Second query to get chapter names and IDs
//
    } else {
      print('No StartParentId found.');
      return 0;
    }
  } catch (e) {
    writeToFile(e, 'getStartParentId');
    print('Error in find StartParentId: ${e.toString()}');
    return 0;
  }
}
//hello

Future getMainChapter(int packageId) async {
  final resultSet = await _db.select(
    'SELECT DISTINCT SectionChapterName, SectionChapterId FROM TblAllFolderDetails WHERE ParentSectionChapterId = 0 AND PackageId= $packageId ',
  );
  // INVERTED COMMA REMOVED showing errors
  getx.subjectDetails.clear();
  if (resultSet.isNotEmpty) {
    resultSet.forEach(
      (row) {
        final details = {
          'SubjectName': row['SectionChapterName'],
          'SubjectId': row['SectionChapterId'],
        };
        getx.subjectDetails.add(details);
      },
    );
    insertTblLocalNavigation("Subject", getx.subjectDetails[0]['SubjectId'],
        getx.subjectDetails[0]['SubjectName']);
    // log("Subject added");
  } else {
    // log("Subject not found");
  }
}

Future<bool> getexamDataExistence(String packageId) async {
  try {
    final resultSetOfMcq = await _db.select(
      'SELECT * FROM TblMCQSet WHERE PackageId=?',
      [packageId],
    );

    final resultSetofTheory = await _db.select(
      'SELECT * FROM TblTheorySet WHERE PackageId=? ',
      [packageId],
    );

    bool mcqdata = resultSetOfMcq.isNotEmpty;
    bool theorydata = resultSetofTheory.isNotEmpty;

    return mcqdata && theorydata;
  } // Return true if data exists, otherwise false
  catch (e) {
    writeToFile(e, getexamDataExistence);
    return false;
  }
}

Future<void> getChapterContents(
  int chapterId,
) async {
  if (chapterId != 0) {
    try {
      final resultSet = await _db.select(
        'SELECT DISTINCT SectionChapterName, SectionChapterId FROM TblAllFolderDetails WHERE ParentSectionChapterId = $chapterId',
      );

      // removed inverted comma showing errors
      getx.alwaysShowChapterDetailsOfVideo.clear();

      resultSet.forEach((row) {
        if (row['SectionChapterId'] != '' && row['SectionChapterName'] != '') {
          final details = {
            'SectionChapterName': row['SectionChapterName'],
            'SectionChapterId': row['SectionChapterId'],
          };
          getx.alwaysShowChapterDetailsOfVideo.add(details);
        }
      });
    } catch (e) {
      writeToFile(e, 'getChapterContents');
      print('Error in get chaptercontent:${e.toString()}');
    }
  }
}

Future<void> getChapterFiles(String fileType, String packageId,
    {int parentId = 0}) async {
  try {
    final resultSet;
    // First query to get the StartParentId
    // Second query to get chapter names and IDs
    print(
        "SectionChapterid $parentId and file type = $fileType and packageid=$packageId");

    if (fileType == 'BOOK') {
      resultSet = await _db.select(
        '''SELECT DISTINCT * FROM TblAllPackageDetails WHERE FileIdType= '$fileType' AND PackageId='$packageId' ''',
      );
    } else if (fileType == 'Test') {
      resultSet = await _db.select(
        '''SELECT DISTINCT * FROM TblAllPackageDetails WHERE FileIdType= '$fileType' AND PackageId='$packageId' ''',
      );
    } else {
      resultSet = await _db.select(
        '''SELECT DISTINCT * FROM TblAllPackageDetails WHERE ChapterId = $parentId AND FileIdType= '$fileType' AND PackageId='$packageId' ''',
      );
    }
// removed inverted commas showing error
    if (fileType == "Video") {
      getx.alwaysShowChapterfilesOfVideo.clear();
      if (resultSet.length != 0) {}
      resultSet.forEach((row) {
        final details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'ConsumeDuration': row['ConsumeDuration'],
          'DocumentPath': row['DocumentPath'],
          'ConsumeNos': row['ConsumeNos'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'DownloadedPath': row['DownloadedPath'],
        };
        getx.alwaysShowChapterfilesOfVideo.add(details);
      });

      if (getx.alwaysShowChapterDetailsOfVideo.length == 0 &&
          getx.alwaysShowFileDetailsOfpdf.length == 0 &&
          getx.alwaysShowChapterfilesOfVideo.length != 0) {
        Platform.isMacOS
            ? Get.to(
                transition: Transition.cupertino,
                () => VideoPlayer(isPathExitsOnVideoList()))
            : null;
        // : Get.to(() => MobileVideoPlayer( videoLink: getx.alwaysShowChapterfilesOfVideo[0]['DocumentPath'],));
        // : Get.to(() =>);
      }
    }

    if (fileType == "Podcast") {
      getx.podcastFileList.clear();
      if (resultSet.length != 0) {}
      resultSet.forEach((row) {
        final details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'ConsumeDuration': row['ConsumeDuration'],
          'DocumentPath': row['DocumentPath'],
          'ConsumeNos': row['ConsumeNos'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'DownloadedPath': row['DownloadedPath'],
        };
        getx.podcastFileList.add(details);
      });

      if (getx.podcastFileList.length == 0 &&
          getx.podcastFileList.length == 0 &&
          getx.podcastFileList.length != 0) {
        Platform.isMacOS
            ? Get.to(
                transition: Transition.cupertino,
                () => VideoPlayer(isPathExitsOnVideoList()))
            : null;
        // : Get.to(() => MobileVideoPlayer( videoLink: getx.alwaysShowChapterfilesOfVideo[0]['DocumentPath'],));
        // : Get.to(() =>);
      }
    }

    if (fileType == "Live" || fileType == "YouTube") {
      if (getx.liveList.isNotEmpty) {
        getx.liveList.clear();
      }
      print("found files of live");
      resultSet.forEach((row) {
        Map<String, dynamic> details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'SessionId': row['SessionId'],
          'ConsumeDuration': row['ConsumeDuration'],
          'DocumentPath': row['DocumentPath'],
          'ConsumeNos': row['ConsumeNos'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'ScheduleOn': row['ScheduleOn'],
        };

        getx.liveList.add(details);

        print(
          'FileId: ${row['FileId']}, FileIdName: ${row['FileIdName']}',
        );
      });

      // if (getx.alwaysShowChapterDetailsOfVideo.length == 0 &&
      //     getx.alwaysShowFileDetailsOfBook.length != 0) {
      //   Platform.isWindows
      //       ? Get.to(() => ShowPdf2024())
      //       : Get.to(() => MobileVideoPlayer());
      //   // : Get.to(() =>);
      // }
    }

    if (fileType == "PDF") {
      if (getx.alwaysShowFileDetailsOfpdf.isNotEmpty) {
        getx.alwaysShowFileDetailsOfpdf.clear();
      }

      resultSet.forEach((row) {
        Map<String, dynamic> details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'ConsumeDuration': row['ConsumeDuration'],
          'DocumentPath': row['DocumentPath'],
          'ConsumeNos': row['ConsumeNos'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'DownloadedPath': row['DownloadedPath'],
          "IsEncrypted": row['IsEncrypted']
        };

        getx.alwaysShowFileDetailsOfpdf.add(details);

        print(
          'FileId: ${row['FileId']}, FileIdName: ${row['FileIdName']}',
        );
      });
    }
    if (fileType == "Book") {
      print(
          "SectionChapterid $parentId and file type = $fileType and packageid=$packageId");
      if (getx.booklist.isNotEmpty) {
        getx.booklist.clear();
      }
      print("found files of Book");
      resultSet.forEach((row) {
        Map<String, dynamic> details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'ConsumeDuration': row['ConsumeDuration'],
          'DocumentPath': row['DocumentPath'],
          'ConsumeNos': row['ConsumeNos'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'DownloadedPath': row['DownloadedPath'],
          "IsEncrypted": row['IsEncrypted']
        };

        getx.booklist.add(details);
      });
    }
    if (fileType == "Test") {
      print(
          "SectionChapterid $parentId and file type = $fileType and packageid=$packageId");
      if (getx.testWrittenExamList.isNotEmpty) {
        getx.testWrittenExamList.clear();
      }
      print("found files of test");
      resultSet.forEach((row) {
        Map<String, dynamic> details = {
          'FileIdName': row['FileIdName'],
          'FileId': row['FileId'],
          'AllowDuration': row['AllowDuration'],
          'VideoDuration': row['VideoDuration'],
          'DocumentPath': row['DocumentPath'],
          'ScheduledOn': row['ScheduledOn'],
          'AllowNo': row['AllowNo'],
          'PackageId': row['PackageId'],
          'DownloadedPath': row['DownloadedPath'],
        };

        getx.testWrittenExamList.add(details);
      });
    }
  } catch (e) {
    writeToFile(e, 'getChapterFiles');
    print('Error in get chaptercontent: ${e.toString()}');
  }
}

Future<void> getLocalNavigationDetails() async {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblLocalNavigation ORDER BY NavigationOrder');
  getx.navigationList.clear();
  resultSet.forEach((row) {
    final details = {
      'NavigationType': row['NavigationType'],
      'NavigationId': row['NavigationId'],
      'NavigationName': row['NavigationName'],
      'NavigationOrder': row['NavigationOrder']
    };
    getx.navigationList.add(details);
  });
}

String isPathExitsOnVideoList() {
  for (var element in getx.alwaysShowChapterfilesOfVideo) {
    if (File(getx.userSelectedPathForDownloadVideo.isEmpty
            ? getx.defaultPathForDownloadVideo.value +
                '\\' +
                element['FileIdName']
            : getx.userSelectedPathForDownloadVideo.value +
                '\\' +
                element['FileIdName'])
        .existsSync()) {
      getx.playLink.value = getx.userSelectedPathForDownloadVideo.isEmpty
          ? getx.defaultPathForDownloadVideo.value +
              '\\' +
              element['FileIdName']
          : getx.userSelectedPathForDownloadVideo.value +
              '\\' +
              element['FileIdName'];
      getx.playingVideoId.value = element['FileId'];

      return getx.playLink.value;
    }
  }
  return '0';
}

Future<void> getPackageDataFromTable(int packageId) async {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblPackageData WHERE PackageId="$packageId"');
  getx.packageData.clear();
  resultSet.forEach((row) {
    final details = {
      'PackageId': row['PackageId'],
      'PackageName': row['PackageName'],
      'ExpiryDate': row['ExpiryDate'],
      'IsUpdate': row['IsUpdate']
    };
    getx.packageData.add(details);
  });
}

List<Map<String, dynamic>> sortDataById(List<Map<String, dynamic>> data) {
  data.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
  return data;
}

void resetTblLocalNavigation() {
  _db.execute('DELETE FROM TblLocalNavigation');
  //  _db.execute('DELETE FROM sqlite_sequence WHERE name = "TblLocalNavigation"');
  print("table deleted");
}

void resetTblLocalNavigationByOrder(int navigationOrder) {
  _db.execute(
      'DELETE FROM TblLocalNavigation WHERE NavigationOrder > $navigationOrder');

  //  _db.execute('DELETE FROM sqlite_sequence WHERE name = "TblLocalNavigation"');
  print("row $navigationOrder deleted");
}

void resetTblLocalNavigationByOrderOnsection(int navigationOrder) {
  _db.execute(
      'DELETE FROM TblLocalNavigation WHERE NavigationOrder >= $navigationOrder');

  //  _db.execute('DELETE FROM sqlite_sequence WHERE name = "TblLocalNavigation"');
}

Future<void> getTaglistOfVideo(String packageId, String videoId) async {
  final sql.ResultSet resultSet = _db.select('''
  SELECT TagName, VideoTime 
  FROM TblVideoComponents 
  WHERE PackageId = ? AND VideoId = ? AND Category = ?
  ''', [packageId, videoId, "TAGS"]);

  if (getx.tagListOfVideo.isNotEmpty) {
    getx.tagListOfVideo.clear();
  }
  resultSet.forEach((item) {
    final details = {
      'TagName': item['TagName'],
      'VideoTime': item["VideoTime"],
      'PackageId': packageId,
      'VideoId': videoId
    };
    getx.tagListOfVideo.add(details);
  });
}

Future<void> getMCQListOfVideo(String packageId, String videoId) async {
  final sql.ResultSet resultSet = _db.select('''
  SELECT * 
  FROM TblVideoComponents 
  WHERE PackageId = ? AND VideoId = ? AND Category = ?
  ''', [packageId, videoId, "MCQ"]);

  if (getx.mcqListOfVideo.isNotEmpty) {
    getx.mcqListOfVideo.clear();
  }

  for (int item = 0; item < resultSet.length; item++) {
    final details = {
      "mcqId": "${item + 1}",
      "mcqType": "SimpleMcq",
      "mcqQuestion": resultSet[item]['Names'],
      "answer": resultSet[item]['Answer'],
      "options": [
        {"optionName": resultSet[item]['Option1']},
        {"optionName": resultSet[item]['Option2']},
        {"optionName": resultSet[item]['Option3']},
        {"optionName": resultSet[item]['Option4']}
      ]
    };

    getx.mcqListOfVideo.add(details);
  }
  print("Details added in mcq list");
}

Future<void> getReviewQuestionListOfVideo(
    String packageId, String videoId) async {
  final sql.ResultSet resultSet = _db.select('''
  SELECT * 
  FROM TblVideoComponents 
  WHERE PackageId = ? AND VideoId = ? AND Category = ?
  ''', [packageId, videoId, "REVIEW"]);

  if (getx.reviewQuestionListOfVideo.isNotEmpty) {
    getx.reviewQuestionListOfVideo.clear();
  }

  for (int item = 0; item < resultSet.length; item++) {
    final details = {
      "videoId": videoId,
      "packageId": packageId,
      "componentId": resultSet[item]['ComponentId'],
      "question": resultSet[item]['Names'],
      "options": [
        resultSet[item]['Option1'],
        resultSet[item]['Option2'],
        resultSet[item]['Option3'],
        resultSet[item]['Option4']
      ],

      // "mcqQuestion": resultSet[item]['Names'],
      // "answer": resultSet[item]['Answer'],
      // "options": [
      //   {"optionName": resultSet[item]['Option1']},
      //   {"optionName": resultSet[item]['Option2']},
      //   {"optionName": resultSet[item]['Option3']},
      //   {"optionName": resultSet[item]['Option4']}
      // ]
    };

    getx.reviewQuestionListOfVideo.add(details);
  }
  print("Details added in mcq list");
}

Future<void> getPDFlistOfVideo(String packageId, String videoId) async {
  final sql.ResultSet resultSet = _db.select('''
  SELECT DocumentURL, DocumentId,Names,IsEncrypted
  FROM TblVideoComponents 
  WHERE PackageId = ? AND VideoId = ? AND Category = ?
  ''', [packageId, videoId, "PDF"]);

  if (getx.pdfListOfVideo.length != 0) {
    print(getx.pdfListOfVideo.length);
    getx.pdfListOfVideo.clear();
  }
  resultSet.forEach((item) {
    final details = {
      'DocumentId': item['DocumentId'],
      'DocumentURL': item['DocumentURL'],
      'Catagory': "PDF",
      'PackageId': packageId,
      'VideoId': videoId,
      'Names': item['Names'],
      "Encrypted": item['IsEncrypted'].toString()
    };

    // log(resultSet.toString()+"\n packageId: $packageId\n video id:$videoId");
    bool isDuplicate = getx.pdfListOfVideo
        .any((doc) => doc['DocumentId'] == details['DocumentId']);

    if (!isDuplicate) {
      getx.pdfListOfVideo.add(details);
      print("Document added successfully!");
    } else {
      print("Duplicate document found. Skipping addition.");
    }
  });
  // print(resultSet.length.toString()+  "   bbhsdjhvdshvvfhjjjjjjjjjjjjjjjjjjjjjjzzzdfvfv");
}

String getDownloadedPathOfFile(
    String packageId, String fileId, String fileType) {
  final sql.ResultSet resultSet = _db.select('''
  SELECT DownloadedPath 
  FROM TblDownloadedFileData 
  WHERE PackageId = ? AND FileId = ? AND FileType = ?
  ''', [packageId, fileId, fileType]);

  if (resultSet.isNotEmpty) {
    final item = resultSet.first; // Get the first result
    final downloadedPath = item['DownloadedPath'];

    if (downloadedPath != '0') {
      return downloadedPath;
    }
  }

  return '0';
}

String getDownloadedPathOfFileOfVideo(
    String packageId, String fileId, String fileType, String documentId) {
  final sql.ResultSet resultSet = _db.select('''
  SELECT Names 
  FROM TblDownloadedFileDataOfVideo 
  WHERE PackageId = ? AND FileId = ? AND FileType = ? AND DocumentId = ?
  ''', [packageId, fileId, fileType, documentId]);

  // log(resultSet.toString()+"\n packageId: $packageId\n fileid:$fileId\n docid: $documentId \n type : $fileType");
  if (resultSet.isNotEmpty) {
    final item = resultSet.first; // Get the first result

    final downloadedPath = Platform.isWindows || Platform.isMacOS
        ? getx.userSelectedPathForDownloadFile.isEmpty
            ? getx.defaultPathForDownloadFile.value + '\\' + item['Names']
            : getx.userSelectedPathForDownloadFile.value + '\\' + item['Names']
        : getx.userSelectedPathForDownloadFile.isEmpty
            ? getx.defaultPathForDownloadFile.value +
                '/' +
                item['Names'] +
                ".pdf"
            : getx.userSelectedPathForDownloadFile.value +
                '/' +
                item['Names'] +
                ".pdf";

    if (downloadedPath != '0') {
      return downloadedPath;
    }
  }

  return '0';
}

String getDownloadedPathOfPDF(String name, String folderName) {
  // Get the first result

  final downloadedPath = getx.userSelectedPathForDownloadFile.isEmpty
      ? getx.defaultPathForDownloadFile.value + '/$folderName/' + name
      : getx.userSelectedPathForDownloadFile.value + '/$folderName/' + name;

  if (downloadedPath != '0') {
    return downloadedPath;
  }
  return '0';
}

Future<void> insertPdfDownloadPath(String videoId, String packageId,
    String downloadedVideoPath, String documentId, BuildContext context) async {
  try {
    _db.execute('''
      UPDATE TblVideoComponents
      SET DownloadedPath = ?
      WHERE VideoId = ? AND PackageId = ? AND DocumentId= ?;
    ''', [downloadedVideoPath, videoId, packageId, documentId]);

    getx.alwaysShowChapterfilesOfVideo.forEach((item) {
      if (item['PackageId'] == packageId &&
          item['VideoId'] == videoId &&
          item["DocumentId"]) {
        item['DownloadedPath'] = downloadedVideoPath;
      }
    });
  } catch (e) {
    writeToFile(e, 'insertPdfDownloadPath');
    print('Failed to update details: ${e.toString()}');
  }
}

Future<dynamic> getVideoHistoryDetails() async {
  final sql.ResultSet resultSet = _db.select('''
SELECT 
    T.FileId,
    T.FileIdName,
    T.ChapterId,
    T.AllowDuration,
    T.ConsumeDuration,
    C.SectionChapterName
FROM 
    TblAllPackageDetails T
JOIN 
    TblAllFolderDetails C ON T.ChapterId = C.SectionChapterId
WHERE 
    T.FileIdType = ?
''', ["Video"]);

  getx.videoHistory.clear();
  resultSet.forEach((item) {
    final history = {
      "VideoId": item['FileId'],
      "VideoName": item['FileIdName'],
      "ChapterId": item['ChapterId'],
      "AllowDuration": item['AllowDuration'],
      "ConsumeDuration": item['ConsumeDuration'],
      "ChapterName": item['SectionChapterName'],
    };

    getx.videoHistory.add(history);
  });
  return getx.videoHistory;
}

Future<List<Map<String, dynamic>>> fetchWhiteList() async {
  final sql.ResultSet resultSet = await _db.select('SELECT * FROM WhiteList');

  // Create a list to hold the results
  List<Map<String, dynamic>> whiteListEntries = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    whiteListEntries.add({
      'ApplicationBaseName': row['AppBaseName'],
      'osType': row['OsType'],
      'id': row['id'],
      'IsKill': row['IsKill']
    });
    //  print("Data get from whiteList for Appname: ${ row['AppBaseName']}.");
  }

  return whiteListEntries;
}

Future<List<Map<String, dynamic>>> fetchBlackList() async {
  final sql.ResultSet resultSet = await _db.select('SELECT * FROM BlackList');

  // Create a list to hold the results
  List<Map<String, dynamic>> blackListEntries = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    blackListEntries.add({
      'ApplicationBaseName': row['AppBaseName'],
      'osType': row['OsType'],
      'id': row['id'],
      'IsKill': row['IsKill']
    });
    // print("Data get from blacklist for Appname: ${ row['AppBaseName']}.");
  }

  return blackListEntries;
}

void deleteBlackListTable() {
  _db.execute('DELETE FROM BlackList');

  print("BlackList data cleared");
}

void deleteWhiteListTable() {
  _db.execute('DELETE FROM WhiteList');

  print("WhiteList data cleared");
}

Future<void> createTableWhiteList() async {
  _db.execute('''
    CREATE TABLE IF NOT EXISTS WhiteList (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      AppId TEXT NOT NULL,
      AppBaseName TEXT NOT NULL,
      ApplicationFullName TEXT NOT NULL,
      IsBlock TEXT NOT NULL CHECK (IsBlock IN (0, 1)),
      IsKill TEXT NOT NULL CHECK (IsKill IN (0, 1)),
      FranchiseId TEXT,
      OsType TEXT NOT NULL,
      CreatedOn TEXT NOT NULL,
      CreatedBy TEXT NOT NULL
    )
  ''');
  print("WhiteList table created successfully.");
}

Future<void> createTableBlckList() async {
  _db.execute('''
    CREATE TABLE IF NOT EXISTS BlackList (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      AppId TEXT NOT NULL,
      AppBaseName TEXT NOT NULL,
      ApplicationFullName TEXT NOT NULL,
      IsBlock TEXT NOT NULL CHECK (IsBlock IN (0, 1)),
      IsKill TEXT NOT NULL CHECK (IsKill IN (0, 1)),
      FranchiseId TEXT,
      OsType TEXT NOT NULL,
      CreatedOn TEXT NOT NULL,
      CreatedBy TEXT NOT NULL
    )
  ''');
  print("blcklist table created successfully.");
}

Future<void> insertWhiteList(List<dynamic> apps) async {
  for (var app in apps) {
    try {
      _db.execute(
        '''
        INSERT INTO WhiteList (AppId, AppBaseName, ApplicationFullName, IsBlock, IsKill, FranchiseId, OsType, CreatedOn, CreatedBy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          app['AppId'],
          app['AppBaseName'],
          app['ApplicationFullName'],
          app['IsBlock'],
          app['IsKill'],
          app['FranchiseId'],
          app['OsType'],
          app['CreatedOn'],
          app['CreatedBy'],
        ],
      );
    } catch (e) {
      writeToFile(e, 'insertWhiteList');
      print("Error inserting into WhiteList: ${e.toString()}");
    }
  }
}

Future<void> insertBlackList(List<dynamic> apps) async {
  for (var app in apps) {
    try {
      _db.execute(
        '''
        INSERT INTO BlackList (AppId, AppBaseName, ApplicationFullName, IsBlock, IsKill, FranchiseId, OsType, CreatedOn, CreatedBy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          app['AppId'],
          app['AppBaseName'],
          app['ApplicationFullName'],
          app['IsBlock'],
          app['IsKill'],
          app['FranchiseId'],
          app['OsType'],
          app['CreatedOn'],
          app['CreatedBy'],
        ],
      );
    } catch (e) {
      writeToFile(e, 'insertBlackList');
      print("Error inserting into blacklist: ${e.toString()}");
    }
  }
}

void createMCQSet() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQSet( 
     SetId TEXT ,
     PackageId TEXT,
     SetName TEXT,
     ServicesTypeName TEXT
   
   );
  ''');
  // log()
  print('TblMCQSet created!');
}

Future<void> inserTblMCQSet(String setId, String packageId, String setName,
    String servicesTypeName) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQSet (SetId, PackageId, SetName,ServicesTypeName)
        VALUES (?, ?, ?,?)
        ''',
      [setId, packageId, setName, servicesTypeName],
    );
  } catch (e) {
    writeToFile(e, 'insertMCQSet');
    print("Error inserting into TblMCQSet: ${e.toString()}");
  }
}

void createMCQPaper() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQPaper( 
     PaperId TEXT ,
     SetId TEXT,
     PaperName TEXT,
     TotalMarks TEXT,
     TermAndCondition TEXT,
     Duration TEXT,
     DateFrom TEXT,
     DateUpto TEXT,
     SortedOrder TEXT,
     MCQStartTime TEXT,
     TotalPassMarks TEXT,
     NoOfTotalQuestions TEXT,
     MCQPaperEndDate TEXT,
     MCQPaperStartDate TEXT,
     IsNegativeMark TEXT,
     IsAnswerSheetShow TEXT

   
   
   );
  ''');
  // log()
  print('TblMCQPaper created!');
}

Future<void> inserTblMCQPaper(
    String paperId,
    String setId,
    String paperName,
    String totalMarks,
    String termAndCondition,
    String duration,
    String dateFrom,
    String dateUpto,
    String sortedOrder,
    String mCQStartTime,
    String totalPassMarks,
    String noOfTotalQuestions,
    String mCQPaperEndDate,
    String mCQPaperStartDate,
    String isNegativeMark,
    String isAnswerSheetShow) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQPaper (PaperId, SetId, PaperName,TotalMarks,TermAndCondition,Duration,DateFrom,DateUpto,SortedOrder,MCQStartTime,TotalPassMarks,NoOfTotalQuestions,MCQPaperEndDate,MCQPaperStartDate,IsNegativeMark,IsAnswerSheetShow)
        VALUES (?, ?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        ''',
      [
        paperId,
        setId,
        paperName,
        totalMarks,
        termAndCondition,
        duration,
        dateFrom,
        dateUpto,
        sortedOrder,
        mCQStartTime,
        totalPassMarks,
        noOfTotalQuestions,
        mCQPaperEndDate,
        mCQPaperStartDate,
        isNegativeMark,
        isAnswerSheetShow
      ],
    );
    // log(mCQPaperEndDate);
  } catch (e) {
    writeToFile(e, 'inserTblMCQPaper');
    print("Error inserting into TblMCQPaper: ${e.toString()}");
  }
}

void createMCQPSection() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQSection( 
     SectionId TEXT ,
     PaperId TEXT,
     SectionName TEXT,
     SortedOrder TEXT,
     DefaultMark TEXT,
     MinQuestionAttempt TEXT,
     MinQuestionDisplay TEXT,
     DefaultNegativeMarks TEXT

   );
  ''');
  // log()
  print('TblMCQSection created!');
}

Future<void> inserTblMCQSection(
    String sectionId,
    String paperId,
    String sectionName,
    String sortedOrder,
    String defaultMark,
    String minQuestionAttempt,
    String minQuestionDisplay,
    String defaultNegativeMarks) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQSection (SectionId, PaperId, SectionName,SortedOrder,DefaultMark,MinQuestionAttempt,MinQuestionDisplay,DefaultNegativeMarks)
        VALUES (?, ?, ?,?,?,?,?,?)
        ''',
      [
        sectionId,
        paperId,
        sectionName,
        sortedOrder,
        defaultMark,
        minQuestionAttempt,
        minQuestionDisplay,
        defaultNegativeMarks
      ],
    );
  } catch (e) {
    writeToFile(e, 'inserTblMCQSection');
    print("Error inserting into TblMCQSection:${e.toString()}");
  }
}

void createMCQQuestion() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQQuestion( 
     QuestionId TEXT ,
     SectionId TEXT,
     McqQuestion TEXT,
     isMultiple TEXT,
    DocumentUrl TEXT,
     MCQQuestionTag TEXT,
     MCQQuestionMarks TEXT,
     MCQQuestionType TEXT,
     AnswerExplanation TEXT,
     AnswerLink TEXT,
     AnswerDocumentId TEXT,
    AnswerDocumentUrl TEXT,
     PassageDocumentUrl TEXT,
     PassageLink TEXT,
     PassageDocumentId TEXT,
     MCQQuestionDocumentId TEXT,
     MCQQuestionUrl TEXT,
     PassageDetails TEXT
   


   );
  ''');
  // log()
  print('TblMCQQuestion created!');
}

Future<void> inserTblMCQQuestion(
    String questionId,
    String sectionId,
    String mcqQuestion,
    String isMultiple,
    String mCQQuestionTag,
    String documentUrl,
    String mCQQuestionMarks,
    String mCQQuestionType,
    String answerExplanation,
    String answerLink,
    String answerDocumentId,
    String answerDocumentUrl,
    String passageDocumentUrl,
    String passageLink,
    String mCQQuestionDocumentId,
    String passageDocumentId,
    String mCQQuestionUrl,
    String passageDetails) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQQuestion (QuestionId, SectionId, McqQuestion,isMultiple,DocumentUrl,MCQQuestionTag,MCQQuestionMarks,MCQQuestionType,AnswerExplanation,AnswerLink,AnswerDocumentId,AnswerDocumentUrl,PassageDocumentUrl,PassageLink,PassageDocumentId,MCQQuestionDocumentId,MCQQuestionUrl,PassageDetails)
        VALUES (?, ?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        ''',
      [
        questionId,
        sectionId,
        mcqQuestion,
        isMultiple,
        documentUrl,
        mCQQuestionTag,
        mCQQuestionMarks,
        mCQQuestionType,
        answerExplanation,
        answerLink,
        answerDocumentId,
        answerDocumentUrl,
        passageDocumentUrl,
        passageLink,
        passageDocumentId,
        mCQQuestionDocumentId,
        mCQQuestionUrl,
        passageDetails
      ],
    );
  } catch (e) {
    writeToFile(e, 'inserTblMCQQuestion');
    print("Error inserting into TblMCQQuestion:${e.toString()}");
  }
}

void createMCQOption() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQOption( 
     OptionId TEXT ,
     QuestionId TEXT,
    OptionName TEXT,
     MCQPartialCorrectMarks TEXT,
     MCQPartialNegativeMarks TEXT,
     IsCorrect TEXT
   
  
   
   );
  ''');
  // log()
  print('TblMCQOption created!');
}

Future<void> inserTblMCQOption(
  String optionId,
  String questionId,
  String optionName,
  String mCQPartialCorrectMarks,
  String mCQPartialNegativeMarks,
  String isCorrect,
) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQOption (OptionId, QuestionId, OptionName,MCQPartialCorrectMarks,MCQPartialNegativeMarks,IsCorrect)
        VALUES (?, ?, ?,?,?,?)
        ''',
      [
        optionId,
        questionId,
        optionName,
        mCQPartialCorrectMarks,
        mCQPartialNegativeMarks,
        isCorrect
      ],
    );
  } catch (e) {
    writeToFile(e, 'inserTblMCQOption');
    print("Error inserting into TblMCQOption: ${e.toString()}");
  }
}

void createMCQAnswer() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQAnswer( 
     OptionId TEXT ,
     QuestionId TEXT,
    AnswerExplanation TEXT,
     DocumentId TEXT,
     LinkId TEXT,
     OptionName TEXT
  
   
   );
  ''');
  // log()
  print('TblMCQAnswer created!');
}

Future<void> inserTblMCQAnswer(
    String optionId,
    String questionId,
    String answerExplanation,
    String documentId,
    String linkId,
    String optionName) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblMCQAnswer (OptionId, QuestionId, AnswerExplanation,DocumentId,LinkId,OptionName)
        VALUES (?, ?, ?,?,?,?)
        ''',
      [optionId, questionId, answerExplanation, documentId, linkId, optionName],
    );
  } catch (e) {
    writeToFile(e, 'inserTblMCQAnswer');
    print("Error inserting into TblMCQAnswer: ${e.toString()}");
  }
}

Future<void> deleteAllMcqDataTable() async {
  try {
    _deleteAllMcqDataTableSync();

    print("Cleared all data from MCQ Data Table");
  } catch (e) {
    print("Error while clearing MCQ Data Table: $e");
    writeToFile(e, 'deleteAllMcqDataTable');
  }
}

void _deleteAllMcqDataTableSync() async {
  _db.execute('DELETE FROM TblMCQSet');
  _db.execute('DELETE FROM TblMCQPaper');
  _db.execute('DELETE FROM TblMCQSection');
  _db.execute('DELETE FROM TblMCQQuestion');
  _db.execute('DELETE FROM TblMCQOption');
  _db.execute('DELETE FROM TblMCQAnswer');

  print("Clear all data of MCQ Data Table");
}

void deleteTblUserResultDetails() {
  _db.execute('DELETE FROM TblUserResultDetails');
}

Future<List<Map<String, dynamic>>> fetchMCQSetList(String packageId) async {
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblMCQSet WHERE PackageId=$packageId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQSetList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQSetList.add({
      'SetId': row['SetId'],
      'PackageId': row['PackageId'],
      'SetName': row['SetName'],
      'ServicesTypeName': row['ServicesTypeName']
    });
    //  print("Data get from whiteList for Appname: ${ row['AppBaseName']}.");
  }

  return tblMCQSetList;
}

Future<List<Map<String, dynamic>>> fetchPodcast(String packageId,FileIdType) async {
  final sql.ResultSet result = _db.select(
      'SELECT * FROM TblAllPackageDetails WHERE PackageId= ? AND FileIdType = ?',
      [packageId, FileIdType]);

  return result;
}

Future<List<Map<String, dynamic>>> fetchMCQPapertList(String setId) async {
  print("Set id is $setId");
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblMCQPaper WHERE SetId=$setId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQPaperList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQPaperList.add({
      'PaperId': row['PaperId'],
      'SetId': row['SetId'],
      'PaperName': row['PaperName'],
      "TotalMarks": row['TotalMarks'],
      "TermAndCondition": row['TermAndCondition'],
      "Duration": row['Duration'],
      "DateFrom": row['DateFrom'],
      "DateUpto": row['DateUpto'],
      "MCQPaperStartDate": row['MCQPaperStartDate'],
      "MCQPaperEndDate": row['MCQPaperEndDate'],
      "SortedOrder": row["SortedOrder"],
      "MCQStartTime": row["MCQStartTime"],
      "TotalPassMarks": row['TotalPassMarks'],
      "NoOfTotalQuestions": row['NoOfTotalQuestions'],
      "IsNegativeMark": row['IsNegativeMark'],
      "IsAnswerSheetShow": row['IsAnswerSheetShow']
    });
    print("Data get from whiteList for Appname: ${row['PaperName']}.");
  }

  return tblMCQPaperList;
}

Future<List<Map<String, dynamic>>> fetchMCQSectonList(String paperId) async {
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblMCQSection WHERE PaperId=$paperId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQSectionList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQSectionList.add({
      'SectionId': row['SectionId'],
      'PaperId': row['PaperId'],
      'SectionName': row['SectionName'],
      'SortedOrder': row['SortedOrder'],
      'DefaultMark': row['DefaultMark']
    });
  }

  return tblMCQSectionList;
}

Future<List<Map<String, dynamic>>> fetchTblMCQQuestionList(
    String sectionId) async {
  final sql.ResultSet resultSet = await _db
      .select('SELECT * FROM TblMCQQuestion WHERE SectionId=$sectionId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQQuestionList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQQuestionList.add({
      'QuestionId': row['QuestionId'],
      'SectionId': row['SectionId'],
      'McqQuestion': row['McqQuestion'],
      'isMultiple': row['isMultiple'],
      'documentUrl': row['DocumentUrl'],
      "MCQQuestionType": row["MCQQuestionType"],
      "AnswerExplanation": row['AnswerExplanation'],
      "AnswerLink": row['AnswerLink'],
      "AnswerDocumentId": row['AnswerDocumentId'],
      "AnswerDocumentUrl": row['AnswerDocumentUrl'],
      "PassageDocumentUrl": row['PassageDocumentUrl'],
      "PassageLink": row['PassageLink'],
      "PassageDocumentId": row['PassageDocumentId'],
      "MCQQuestionDocumentId": row['MCQQuestionDocumentId'],
      "MCQQuestionUrl": row['MCQQuestionUrl'],
      "MCQQuestionTag": row['MCQQuestionTag'],
      "MCQQuestionMarks": row['MCQQuestionMarks'],
      "PassageDetails": row["PassageDetails"]
    });
  }

  return tblMCQQuestionList;
}

Future<List<Map<String, dynamic>>> fetchTblMCQOptionList(
    String questionId) async {
  final sql.ResultSet resultSet = await _db
      .select('SELECT * FROM TblMCQOption WHERE QuestionId=$questionId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQOptionList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQOptionList.add({
      'OptionId': row['OptionId'].toString(),
      'QuestionId': row['QuestionId'].toString(),
      'OptionName': row['OptionName'].toString(),
      'MCQPartialCorrectMarks': row['MCQPartialCorrectMarks'].toString(),
      'MCQPartialNegativeMarks': row['MCQPartialNegativeMarks'].toString(),
      'IsCorrect': row['IsCorrect'].toString(),
    });
  }

  return tblMCQOptionList;
}

Future<List<Map<String, dynamic>>> fetchTblMCQAnswerList(
    String questionId) async {
  final sql.ResultSet resultSet = await _db
      .select('SELECT * FROM TblMCQAnswer WHERE QuestionId=$questionId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQAnswerList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQAnswerList.add({
      'OptionId': row['OptionId'],
      'QuestionId': row['QuestionId'],
      'AnswerExplanation': row['AnswerExplanation'],
      'DocumentId': row['DocumentId'],
      'LinkId': row['LinkId']
    });
  }

  return tblMCQAnswerList;
}

String fetchSectionName(String sectionId) {
  // print(sectionId + " sid");
  final sql.ResultSet resultSet = _db.select(
      'SELECT SectionName FROM TblMCQSection WHERE SectionId = ?', [sectionId]);

  // Ensure that we have at least one result
  String sectionName = "";

  if (resultSet.isNotEmpty) {
    sectionName = resultSet.first['SectionName'] as String;
  }
  // print(sectionName + " section name");
  return sectionName;
}

void createUserMCQResult() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblUserResult(
   PaperId TEXT, 
   QuestionId TEXT,
   QuestionName TEXT,
     CorrectOptionId TEXT ,
     CorrectOption TEXT,
     UserSelectedOptionId TEXT,
     UserSelectedOption TEXt,
    AnswerExplanation TEXT,
     DocumentId TEXT,
     LinkId TEXT,
     UploadFlag INTEGER DEFAULT 0
  
   
   );
  ''');
  // log()
  print('TblUserResult created!');
}

Future<void> inserUserTblMCQAnswer(
  String paperId,
  String questionId,
  String questionName,
  String correctOptionId,
  String correctOption,
  String userSelectedOptionId,
  String userSelectedOption,
  String answerExplanation,
  String documentId,
  String linkId,
) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblUserResult (PaperId, QuestionId, CorrectOptionId,CorrectOption,UserSelectedOptionId,UserSelectedOption,AnswerExplanation,DocumentId,LinkId,QuestionName)
        VALUES (?, ?, ?,?,?,?,?,?,?,?)
        ''',
      [
        paperId,
        questionId,
        correctOptionId,
        correctOption,
        userSelectedOptionId,
        userSelectedOption,
        answerExplanation,
        documentId,
        linkId,
        questionName
      ],
    );
  } catch (e) {
    writeToFile(e, 'inserUserTblMCQAnswer');
    print("Error inserting into TblUserMCQAnswer:${e.toString()}");
  }
}

void createUserResultDetails() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblUserResultDetails(
   PaperId TEXT, 
   ExamStartDate TEXT,
   ExamEndDate TEXT,
   isSubmit TEXT,
   SubmissionDate TEXT,
   Type TEXT
   
  
   
   );
  ''');
  // log()
  print('TblUserResult created!');
}

Future<void> inserUserResultDetails(String paperId, String examStartDate,
    String isSubmit, String submission, String examEndDate, String type) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblUserResultDetails (PaperId, ExamStartDate, isSubmit,SubmissionDate,ExamEndDate,Type)
        VALUES (?, ?, ?,?,?,?)
        ''',
      [paperId, examStartDate, isSubmit, submission, examEndDate, type],
    );
  } catch (e) {
    writeToFile(e, 'inserUserResultDetails');
    print("Error inserting into TblUserMCQAnswer: ${e.toString()}");
  }
}

List fetchResultOfStudent(String paperId) {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblUserResult WHERE PaperId = ?', [paperId]);
  List<Map<String, dynamic>> resultSetList = [];
  for (var row in resultSet) {
    resultSetList.add({
      "questionid": row['QuestionId'],
      "question name": row['QuestionName'],
      "correctanswerId": parseStringToList(row['CorrectOptionId']),
      "correctanswer": parseStringToListOfStrings(row['CorrectOption']),
      "userselectedanswer id": parseStringToList(row['UserSelectedOptionId']),
      "userselectedanswer":
          parseStringToListOfStrings(row['UserSelectedOption']),
    });
  }

  return resultSetList;
}

List<int> parseStringToList(String? input) {
  print(input);
  if (input == null || input.isEmpty) {
    return []; // Return null if the input is null or empty
  }

  try {
    // Remove the brackets and whitespace, then split the string by commas
    List<String> items =
        input.replaceAll('[', '').replaceAll(']', '').split(',');

    // Convert each item to an integer and return the list
    return items.map((item) => int.parse(item.trim())).toList();
  } catch (e) {
    writeToFile(e, 'parseStringToList');
    // Return null if there's a FormatException or any other error
    print('Error:${e.toString()} from int');
    return [];
  }
}

List<String> parseStringToListOfStrings(String input) {
  if (input.isEmpty) {
    return []; // Return null if the input is null or empty
  }

  try {
    // Remove the brackets and whitespace, then split the string by commas
    List<String> items =
        input.replaceAll('[', '').replaceAll(']', '').split(',');

    // Convert each item to an integer and return the list
    return items.map((item) => item.replaceAll('"', '').trim()).toList();
  } catch (e) {
    writeToFile(e, 'parseStringToListOfStrings');
    // Return null if there's a FormatException or any other error
    print('Error: ${e.toString()} from string ');
    return [];
  }
}

Future<void> updateTblUserResultDetails(
  String isSubmited,
  String paperId,
  String submisionDate,
) async {
  try {
    _db.execute('''
      UPDATE TblUserResultDetails
      SET isSubmit = ?,SubmissionDate=?
      WHERE PaperId = ?;
    ''', [isSubmited, submisionDate, paperId]);

    // print("Data updated into TblUserResult for optionId: ${paperId}.");
  } catch (e) {
    writeToFile(e, 'updateTblUserResultDetails');
    print('Failed to update details:${e.toString()}');
  }
}

Future<bool> checkIsSubmited(String paperId) async {
  final sql.ResultSet resultSet = await _db.select(
      "SELECT * FROM TblUserResultDetails WHERE PaperId = ?", [paperId]);

  for (var row in resultSet) {
    if (row['isSubmit'] == "true") {
      return true;
    }
  }
  return false;
}

Future<List> fetchExamHistory() async {
  final sql.ResultSet resultSet =
      _db.select('SELECT * FROM TblUserResultDetails');
  List<dynamic> resultSetList = [];
  for (var row in resultSet) {
    resultSetList.add({
      "PaperId": row['PaperId'],
      "ExamStartDate": row['ExamStartDate'],
      "ExamEndDate": row['ExamEndDate'],
      "isSubmit": row['isSubmit'],
      "SubmissionDate ": row['SubmissionDate'],
      "Type": row['Type'],
    });
  }
  return resultSetList;
}

double fetchMCQPartialCorrectMarks(String optionId, String questionId) {
  // print(optionId+" sid");
  final sql.ResultSet resultSet = _db.select(
      'SELECT MCQPartialCorrectMarks FROM TblMCQOption WHERE OptionId = ? AND QuestionId=?',
      [optionId, questionId]);

  // Ensure that we have at least one result
  String mCQPartialCorrectMarks = "";

  if (resultSet.isNotEmpty) {
    mCQPartialCorrectMarks =
        resultSet.first['MCQPartialCorrectMarks'] as String;
  }
  print(mCQPartialCorrectMarks + " section name");
  return double.parse(
      mCQPartialCorrectMarks == "" ? "0.0" : mCQPartialCorrectMarks);
}

double fetchMCQPartialNegativeMarks(String optionId, String questionId) {
  // print(optionId+" sid");
  final sql.ResultSet resultSet = _db.select(
      'SELECT MCQPartialNegativeMarks FROM TblMCQOption WHERE OptionId = ? AND QuestionId=?',
      [optionId, questionId]);

  // Ensure that we have at least one result
  String mCQPartialNegativeMarks = "";

  if (resultSet.isNotEmpty) {
    mCQPartialNegativeMarks =
        resultSet.first['MCQPartialNegativeMarks'] as String;
  }

  return double.parse(
      mCQPartialNegativeMarks == "" ? "0.0" : mCQPartialNegativeMarks);
}

String fetchsectionIdfromquestion(String questionId) {
  // print(optionId+" sid");
  final sql.ResultSet resultSet = _db.select(
      'SELECT SectionId FROM TblMCQQuestion WHERE QuestionId = ?',
      [questionId]);

  // Ensure that we have at least one result
  String sectionid = "";

  if (resultSet.isNotEmpty) {
    sectionid = resultSet.first['SectionId'] as String;
  }
  return sectionid;
}

double fetchnagetivemarksFromsection(String sectionid) {
  // print(optionId+" sid");
  final sql.ResultSet result = _db.select(
      'SELECT DefaultNegativeMarks FROM TblMCQSection WHERE SectionId = ?',
      [sectionid]);
  String nagetivemarks = "";
  if (result.isNotEmpty) {}

  if (result.isNotEmpty) {
    nagetivemarks = result.first['DefaultNegativeMarks'] as String;
  }
  return double.parse(nagetivemarks == "" ? "0.0" : nagetivemarks);
}

String fetchDownloadPathOfVideo(String videoId, String packageId) {
  final sql.ResultSet result = _db.select(
      'SELECT DownloadedPath FROM TblAllPackageDetails WHERE PackageId= ? AND FileId = ?',
      [packageId, videoId]);
  String downloadPath = "";

  if (result.isNotEmpty) {
    downloadPath = result.first['DownloadedPath'];
  }
  return downloadPath;
}

void createTheorySet() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblTheorySet( 
     SetId TEXT ,
     PackageId TEXT,
     SetName TEXT,
     ServicesTypeId TEXT,
     ServicesTypeName TEXT
   
   );
  ''');
  // log()
  print('TblMCQSet created!');
}

Future<void> inserTheorySet(String setId, String packageId, String setName,
    String servicesTypeName, String servicesTypeId) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblTheorySet (SetId, PackageId, SetName,ServicesTypeId,ServicesTypeName)
        VALUES (?, ?, ?,?,?)
        ''',
      [setId, packageId, setName, servicesTypeId, servicesTypeName],
    );
  } catch (e) {
    writeToFile(e, "inserTheorySet");
    print("Error inserting into TblMCQSet: ${e.toString()}");
  }
}

void createTheoryPaper() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblTheoryPaper( 
     PaperId TEXT,
     SetId TEXT,
     PaperName TEXT,
   
     TermAndCondition TEXT,
     TotalMarks TEXT,
     DocumentUrl TEXT,
  
     Duration TEXT,
     StartTime TEXT,
     PassMarks TEXT,
   
     PaperEndDate TEXT,
     PaperStartDate TEXT,
     IsSubmitted TEXT,
     AnswerSheet TEXT
   
   
   
   );
  ''');
  // log()
  print('TblTheoryPaper created!');
}

Future<void> inserTblTheoryPaper(
    String paperId,
    String setId,
    String paperName,
    String totalMarks,
    String termAndCondition,
    String duration,
    String documentUrl,
    String startTime,
    String passMarks,
    String paperEndDate,
    String paperStartDate,
    String isSubmited,
    {String answerSheet = ""}) async {
  try {
    _db.execute(
      '''
        INSERT INTO TblTheoryPaper (PaperId, SetId, PaperName,TotalMarks,TermAndCondition,Duration,DocumentUrl,StartTime,PassMarks,PaperEndDate,PaperStartDate,IsSubmitted, AnswerSheet)
        VALUES (?, ?, ?,?,?,?,?,?,?,?,?,?,?)
        ''',
      [
        paperId,
        setId,
        paperName,
        totalMarks,
        termAndCondition,
        duration,
        documentUrl,
        startTime,
        passMarks,
        paperEndDate,
        paperStartDate,
        isSubmited,
        answerSheet
      ],
    );
    // log("insert Successfull   $paperId");
  } catch (e) {
    writeToFile(e, "inserTblTheoryPaper");
    print("Error inserting into TblTheoryPaper: ${e.toString()}");
  }
}

Future<List<Map<String, dynamic>>> fetchTheorySetList(String packageId) async {
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblTheorySet WHERE PackageId=$packageId');

  List<Map<String, dynamic>> tblMCQSetList = [];

  for (var row in resultSet) {
    tblMCQSetList.add({
      'SetId': row['SetId'],
      'PackageId': row['PackageId'],
      'SetName': row['SetName'],
      'ServicesTypeId': row['ServicesTypeId'],
      'ServicesTypeName': row['ServicesTypeName']
    });
  }

  return tblMCQSetList;
}

Future<List<Map<String, dynamic>>> fetchTheoryPapertList(String setId) async {
  print("Set id is $setId");
  final sql.ResultSet resultSet =
      await _db.select('SELECT * FROM TblTheoryPaper WHERE SetId=$setId');

  // Create a list to hold the results
  List<Map<String, dynamic>> tblMCQPaperList = [];

  // Loop through each row and add it to the list
  for (var row in resultSet) {
    // Assuming your WhiteList table has columns 'id' and 'osType', adjust as necessary
    tblMCQPaperList.add({
      'PaperId': row['PaperId'],
      'SetId': row['SetId'],
      'PaperName': row['PaperName'],
      "TotalMarks": row['TotalMarks'],
      "TermAndCondition": row['TermAndCondition'],
      "Duration": row['Duration'],
      "PaperEndDate": row['PaperEndDate'],
      "PaperStartDate": row['PaperStartDate'],
      "StartTime": row["StartTime"],
      "PassMarks": row['PassMarks'],
      "DocumentUrl": row['DocumentUrl'],
      "AnswerSheet": row['AnswerSheet'],
      'IsSubmitted': row['IsSubmitted'],
    });
    print("Data get papername form theory paper list: ${row['PaperName']}.");
  }

  return tblMCQPaperList;
}

Future deleteAllTheoryTable() async {
  _db.execute('DELETE FROM TblTheorySet');
  _db.execute('DELETE FROM TblTheoryPaper');

  print("Clear all data of Theory Data Table");
}

String formatDate(String dateString) {
  // Parse the date string
  try {
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date as desired
    DateFormat formatter = DateFormat('MMMM dd, yyyy'); // October 30, 2024
    return formatter.format(dateTime);
  } catch (e) {
    writeToFile(e, "formatDate");
    return "No datetime found";
  }
}

String formatDateWithOrdinal(String dateTimeString) {
  print(dateTimeString);
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Get the day of the month to add the ordinal suffix
    int day = dateTime.day;
    String dayWithSuffix = _getDayWithSuffix(day);

    // Formatting the month and year
    String formattedMonthYear = DateFormat('MMMM, yyyy').format(dateTime);

    // Formatting the time
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Combining the parts together
    return '$dayWithSuffix $formattedMonthYear, $formattedTime';
  } catch (e) {
    writeToFile(e, "formatDateWithOrdinal");
    return "No datetime found";
  }
}

String _getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

void createtblMCQhistory() {
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblMCQHistory( 
     PaperId TEXT,
     ExamType TEXT,
     ExamName TEXT,
     ObtainMarks TEXT,
     SubmitDate TEXT,
     AttemptDate TEXT,
     UploadFlag TEXT
   
   );
  ''');
  // log()
  print('TblMCQHistory created!');
}

Future<void> inserTblMCQhistory(
    String examId,
    String examType,
    String examName,
    String obtainMarks,
    String submitDate,
    String attemptDate,
    String uploadflag) async {
  try {
    print("start");
    _db.execute(
      '''
        INSERT INTO TblMCQHistory (PaperId, ExamType, ExamName,ObtainMarks,SubmitDate,AttemptDate,UploadFlag)
        VALUES (?, ?, ?,?,?,?,?)
        ''',
      [
        examId,
        examType,
        examName,
        obtainMarks,
        submitDate,
        attemptDate,
        uploadflag
      ],
    );
    // log("insert Successfull on  TblMCQHistory  $examId");
  } catch (e) {
    writeToFile(e, "inserTblMCQhistory");
    print("Error inserting into TblMCQHistory: ${e.toString()}");
  }
}

Future<List<Map<String, dynamic>>> fetchTblMCQHistory(String type) async {
  print("type is $type");
  try {
    final sql.ResultSet resultSet = type != ""
        ? await _db.select(
            'SELECT * FROM TblMCQHistory WHERE ExamType = ? AND UploadFlag=?',
            [type, "0"])
        : await _db
            .select('SELECT * FROM TblMCQHistory WHERE UploadFlag=?', ["0"]);

    List<Map<String, dynamic>> tblMCQhistoryList = [];

    // Loop through each row and add it to the list
    for (var row in resultSet) {
      tblMCQhistoryList.add({
        'ExamId': row['PaperId'] ?? 0,
        'ExamType': row['ExamType'] ?? "",
        'ExamName': row['ExamName'] ?? "",
        "ObtainMarks": row['ObtainMarks'] ?? -100,
        "SubmitDate": type == ""
            ? formatDateTimeTakeLastThreeNumber(row['SubmitDate'].toString())
            : row['SubmitDate'],
        "AttemptDate": type == ""
            ? formatDateTimeTakeLastThreeNumber(
                    row['AttemptDate'].toString()) ??
                00
            : row['AttemptDate'],
      });
      print("Data get ExamName list: ${row['ObtainMarks']}.");
    }

    // Reverse the list to get descending order
    // tblMCQhistoryList = tblMCQhistoryList.reversed.toList();

    return tblMCQhistoryList;
  } catch (e) {
    writeToFile(e, "fetchTblMCQHistory");
    print("Error fetching from TblMCQHistory: ${e.toString()}");
    return [];
  }
}

Future<void> updateTblMCQhistoryForUploadFlag() async {
  try {
    _db.execute('''
      UPDATE TblMCQHistory
      SET UploadFlag = ?
      WHERE UploadFlag = ?;
    ''', ["1", "0"]);

    print("save on list");
  } catch (e) {
    writeToFile(e, 'updateupdateTblMCQhistoryForUploadFlag');
    print('Failed to update details: ${e.toString()}');
  }
}

Future<void> updateTblMCQhistory(String examId, String attemptDate,
    String obtainMarks, String submitdate, BuildContext context) async {
  try {
    _db.execute('''
      UPDATE TblMCQHistory
      SET SubmitDate = ?,ObtainMarks=?,UploadFlag=?
      WHERE PaperId = ? AND AttemptDate = ? ;
    ''', [submitdate, obtainMarks, "0", examId, attemptDate]);

    print("save on list");
  } catch (e) {
    writeToFile(e, 'updateTblMCQhistory');
    print('Failed to update details: ${e.toString()}');
  }
}

String fetchtotalMarksOfExma(String examId) {
  final sql.ResultSet result = _db.select(
      'SELECT TotalMarks FROM TblTheoryPaper WHERE PaperId= ?', [examId]);
  String totalmarks = "";

  if (result.isNotEmpty) {
    totalmarks = result.first['TotalMarks'];
  }
  return totalmarks;
}

Future<dynamic> fetchUploadableVideoInfo() async {
  try {
    final sql.ResultSet resultSet = await _db.select('''
    SELECT t.*
    FROM TblvideoPlayInfo t
    JOIN (
        SELECT PlayNo, MAX(SpendTime) AS max_endduration
        FROM TblvideoPlayInfo
        WHERE UploadFlag = 0
        GROUP BY PlayNo
    ) sub 
    ON t.PlayNo = sub.PlayNo AND t.SpendTime = sub.max_endduration
    WHERE t.UploadFlag = 0;
    ''');

    List<dynamic> unUploadedVideoInfo = [];

    // Check if resultSet is empty
    if (resultSet.isEmpty) {
      print("No unuploaded video info found.");
      return [];
    }

    // Loop through each row and add it to the list
    for (var row in resultSet) {
      print(
          "${row['VideoId']}\n,${row['StartDuration']}\n,${row['SpendTime']}\n,${row['Speed']}\n,${row['StartTime']},\n${row['PlayNo']}");
      unUploadedVideoInfo.add({
        'Type': row['Type'],
        'VideoId': row['VideoId'],
        'StartDuration': row['StartDuration'],
        'SpendTime': row['SpendTime'],
        "Speed": row['Speed'],
        "StartTime":
            formatDateTimeTakeLastThreeNumber(row['StartTime'].toString()),
        "PlayNo": row['PlayNo'],
      });
      print("Data get ExamName list: ${row['PlayNo']}.");
    }

    return unUploadedVideoInfo;
  } catch (e) {
    writeToFile(e, "fetchUploadableVideoInfo");
    print("Error fetching from unuploadedvideoinfo: ${e.toString()}");
    return [];
  }
}

Future<void> updateUploadableVideoInfo() async {
  try {
    _db.execute('''
      UPDATE TblvideoPlayInfo
      SET UploadFlag = 1
      WHERE UploadFlag = 0;
    ''');
  } catch (e) {
    writeToFile(e, "updateUploadableVideoInfo");
    print("Error updating uploadable video info: ${e.toString()}");
  }
}

String formatDateTimeTakeLastThreeNumber(String datetimeStr) {
  // Split the string at the decimal point
  try {
    if (datetimeStr != "null") {
      List<String> parts = datetimeStr.split('.');

      // Keep only the first three digits after the decimal point, if they exist
      if (parts.length > 1) {
        String timePart =
            parts[1].substring(0, 3); // Get first 3 digits after decimal
        return '${parts[0]}.$timePart';
      } else {
        return datetimeStr; // No decimal part found, return the original string
      }
    } else {
      return datetimeStr;
    }
  } catch (e) {
    print("Error formatDateTimeTakeLastThreeNumber: ${e.toString()}");
    writeToFile(e, 'formatDateTimeTakeLastThreeNumber');
    return datetimeStr;
  }
}

List readAllpackageInfo() {
  final sql.ResultSet resultSet = _db.select('SELECT * FROM TblPackageData');

  List packageDeails = [];

  resultSet.forEach((row) {
    final details = {
      'packageId': row['PackageId'],
      'packageName': row['PackageName'],
      'ExpiryeDate': row['ExpiryDate'],
      'IsShow': row['IsShow'],
      'LastUpdatedOn': row['LastUpdatedOn']
    };
    packageDeails.add(details);
  });
  return packageDeails;
}

void deletePartularPackageData(String packageId, BuildContext context) {
  try {
    _db.execute('DELETE FROM TblAllFolderDetails WHERE PackageId=$packageId');
    _db.execute('DELETE FROM TblAllPackageDetails WHERE PackageId=$packageId');
    _db.execute('DELETE FROM TblVideoComponents WHERE PackageId=$packageId');
    getMcqDataForTest(context, getx.loginuserdata[0].token, packageId);
    gettheoryExamDataForTest2(context, getx.loginuserdata[0].token, packageId);
    getAllFolders(context, getx.loginuserdata[0].token, packageId);
    getAllFiles(context, getx.loginuserdata[0].token, packageId);
    getAllFreeFiles(context, getx.loginuserdata[0].token, packageId);
    getVideoComponents(context, getx.loginuserdata[0].token, packageId);
  } catch (e) {
    writeToFile(e, "deletePartularPackageData");
    ClsErrorMsg.fnErrorDialog(
        context, '', e.toString().replaceAll("[", "").replaceAll("]", ""), "");
  }
}

void deleteMCQHistroyTable() {
  _db.execute('DELETE FROM TblMCQHistory WHERE UploadFlag=?', ["1"]);
}

void deleteVideoWatchHistroyTable() {
  _db.execute('DELETE FROM TblvideoPlayInfo WHERE UploadFlag=1');
}

void deleteTblUserResult() {
  _db.execute('DELETE FROM TblUserResult WHERE UploadFlag=1');
}

List<String> getCorrectOptionIdList(String questionId) {
  // Execute the SQL query
  final sql.ResultSet resultSet = _db.select(
      'SELECT OptionId FROM TblMCQOption WHERE QuestionId = ? AND IsCorrect = "true"',
      [questionId]);

  // Extract OptionId values into a list
  return resultSet.map((row) => row['OptionId'] as String).toList();
}

String getOptionNameFromOptionId(String optionId) {
  // Execute the SQL query
  final sql.ResultSet resultSet = _db.select(
      'SELECT OptionName FROM TblMCQOption WHERE OptionId = ?', [optionId]);

  // Check if a result is returned and fetch the OptionName
  if (resultSet.isNotEmpty) {
    return resultSet.first['OptionName'] as String;
  } else {
    throw Exception('OptionId not found: $optionId');
  }
}

String getQuestionNameFromQuestionId(String questionId) {
  // Execute the SQL query
  final sql.ResultSet resultSet = _db.select(
      'SELECT McqQuestion FROM TblMCQQuestion WHERE QuestionId = ?',
      [questionId]);

  // Check if a result is returned and fetch the OptionName
  if (resultSet.isNotEmpty) {
    return resultSet.first['McqQuestion'] as String;
  } else {
    throw Exception('OptionId not found: $questionId');
  }
}

List<String> getCorrectOptionNameList(String questionId) {
  // Execute the SQL query
  final sql.ResultSet resultSet = _db.select(
      'SELECT OptionName FROM TblMCQOption WHERE QuestionId = ? AND IsCorrect = "true"',
      [questionId]);

  // Extract OptionId values into a list
  return resultSet.map((row) => row['OptionId'] as String).toList();
}

List<String> getOptionNamesFromOptionIdsString(String optionIdsString) {
  // Parse the string into a list by removing brackets and splitting by commas
  List<String> optionIds = optionIdsString
      .replaceAll('[', '') // Remove opening bracket
      .replaceAll(']', '') // Remove closing bracket
      .replaceAll('\'', '') // Remove single quotes
      .split(',')
      .map((id) => id.trim()) // Trim any extra whitespace
      .toList();

  // Join the optionIds into a comma-separated string for SQL IN clause
  String optionIdsForQuery = optionIds.map((id) => "'$id'").join(',');

  // Execute the SQL query
  final sql.ResultSet resultSet = _db.select(
      'SELECT OptionName FROM TblMCQOption WHERE OptionId IN ($optionIdsForQuery)');

  // Extract OptionName values into a list
  return resultSet.map((row) => row['OptionName'] as String).toList();
}

Future<void> updateTblUserResult() async {
  try {
    _db.execute('''
      UPDATE TblUserResult
      SET UploadFlag = 1
      WHERE UploadFlag = 0;
    ''');
  } catch (e) {
    writeToFile(e, "updateTblUserResult");
    print("Error updating TblUserResult: ${e.toString()}");
  }
}
// void deleteMCQHistroyTable() {
//   try {
//     _db.execute('DELETE FROM TblMCQHistory WHERE UploadFlag="1"');
//   } catch (e) {}
//   //  _db.execute('DELETE FROM BlackList');
// }

Future infoTetch(packageId, type) async {
  try {
    getx.infoFetch = [];

    final sql.ResultSet resultSet = _db.select(
        "SELECT * FROM TblAllPackageDetails WHERE PackageId=$packageId AND FileIdType='$type'");

    // List packageDeails = [];

    resultSet.forEach((row) async {
      final details = {
        'packageId': row['PackageId'],
        'packageName': row['PackageName'],
        'FileIdType': row['FileIdType'],
        'ScheduleOn': row['ScheduleOn']
        // 'ExpiryeDate': row['ExpiryDate'],
        // 'IsShow': row['IsShow'],
        // 'LastUpdatedOn': row['LastUpdatedOn']
      };
      // log(details.toString() + "sayak");

      // if (dateCheck(row['ScheduleOn'])) {
      //   getx.infoFetch.add(details);
      // }
      log(row['ScheduleOn'].toString());

      switch (row['FileIdType']) {
        case 'Live':
          // if (await dateCheck(details['ScheduleOn'].toString())) {

          getx.infoFetch.add(details);
          // }
          break;
        case 'Video':
          getx.infoFetch.add(details);
          break;
        case 'Book':
          getx.infoFetch.add(details);
          break;
        case 'Theory':
          await theoryitemCheck();
          break;
        case 'VideosBackup':
          getx.infoFetch.add(details);
          break;
        case 'MCQ':
          await testitemCheck();
          // getx.infoFetch.add(details);
          break;
        default:
          getx.infoFetch.add(details);
          break;
        // case 'Test':
        //   break;
      }
    });
    // return infoTetch(packageId, type);

    // infoTeach.rows.forEach((r) {
    //   getx.infoFetch.add({'':r['']});
    // });
  } catch (e) {
    // log(e.toString() + "kjn");
    writeToFile(e, 'infoTetch');
    // return [];
  }
  //  _db.execute('DELETE FROM BlackList');
}

testitemCheck() {
  final sql.ResultSet resultSet = _db.select("SELECT * FROM TblMCQSet");
  // if (getx.infoFetch.isNotEmpty) {
  getx.infoFetch.clear();
  // }
  getx.infoFetch = resultSet;
  // .where((item) =>
  //     item['serviceTypeName'] == 'Comprehensive' ||
  //     item['serviceTypeName'] == 'Quick Practice' ||
  //     item['serviceTypeName'] == 'Ranked Competition')
  // .toList();
}

Future theoryitemCheck() async {
  final sql.ResultSet resultSet = _db.select("SELECT * FROM TblTheorySet");
  // if (getx.infoFetch.isNotEmpty) {
  getx.infoFetch.clear();
  // }
  getx.infoFetch = resultSet;
  // .where((item) => item['serviceTypeName'] == 'Theory Exam')
  // .toList();
}

Future<bool> dateCheck(date) async {
  DateTime inputDate = DateTime.parse(date);
  DateTime now = DateTime.now();

  bool isToday = inputDate.year == now.year &&
      inputDate.month == now.month &&
      inputDate.day == now.day;

  if (isToday) {
    print("The date is today!");

    return isToday;
  } else {
    print("The date is not today.");
    return isToday;
  }
}

String getFranchiseNameFromTblSetting() {
  try {
    // Execute the SQL query
    final sql.ResultSet resultSet = _db.select(
      'SELECT Value FROM TblSetting WHERE FieldName = ?',
      ["FranchiseName"],
    );

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      print(resultSet.first['Value'] + "shubha this is freschise id");
      return resultSet.first['Value'];
    }
  } catch (e) {
    writeToFile(e, "getFranchiseNameFromTblSetting");
  }
  return '';
}

String getEncryptionKeyFromTblSetting(String keyName) {
  try {
    // Parameterized SQL query
    final sql.ResultSet resultSet = _db.select(
      'SELECT Value FROM TblSetting WHERE FieldName = ?',
      [keyName], // Bind the parameter
    );

    // Check if a result is returned and fetch the Value
    if (resultSet.isNotEmpty) {
      return resultSet.first['Value'] as String;
    }
  } catch (e) {
    print(e.toString());
    writeToFile(e, "getEncryptionKeyFromTblSetting");
  }
  return '';
}

String getPackagNameById(String packageId) {
  try {
    // Execute the SQL query
    final sql.ResultSet resultSet = _db.select(
      'SELECT PackageName FROM TblPackageData WHERE PackageId = ?',
      [packageId],
    );

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['PackageName'] as String;
    }
  } catch (e) {
    print(e.toString);
    writeToFile(e, "getPackagNameById");
  }
  return '';
}

String getRequiredMarksForPaperId(String paperID) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT TotalPassMarks FROM TblMCQPaper WHERE PaperId = ?', [paperID]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['TotalPassMarks'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

String getQuestionTypeFromId(String questionId) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT MCQQuestionType FROM TblMCQQuestion WHERE QuestionId = ?',
        [questionId]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['MCQQuestionType'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

String getOneWordAnswerFromQuestionId(String questionId) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT OptionName FROM TblMCQAnswer WHERE QuestionId = ?',
        [questionId]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['OptionName'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

String getOneWordUserAnswerFromQuestionId(String questionId) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT OptionName FROM TblMCQOption WHERE QuestionId = ?',
        [questionId]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['OptionName'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

String getOneWordAnswerFromQuestionIdofStudent(String questionId) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT OptionName FROM TblMCQOption WHERE QuestionId = ?',
        [questionId]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['OptionName'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

Future<void> updateOneWordAnswerofStudent(
  String optionId,
  String questionId,
  String userAnswer,
) async {
  try {
    // Perform the update
    _db.execute('''
      UPDATE TblMCQOption
      SET OptionName = ?
      WHERE OptionId = ? AND QuestionId = ?;
    ''', [userAnswer, optionId, questionId]);

    // Verify the update
    final result = await _db.select('''
      SELECT OptionName 
      FROM TblMCQOption
      WHERE OptionId = ? AND QuestionId = ?;
    ''', [optionId, questionId]);

    if (result.isNotEmpty && result[0]['OptionName'] == userAnswer) {
      print("Table updated successfully. $userAnswer updated on table.");
    } else {
      print("Update failed. No matching row found or update did not apply.");
    }
  } catch (e) {
    writeToFile(e, 'updateOneWordAnswerofStudent');
    print('Failed to update details: ${e.toString()}');
  }
}

void createTblImages() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblImages( 
     ImageId TEXT, 
     ImagePath TEXT,
     DocumentId TEXT,
     ImageUrl TEXT,
     ImageType TEXT,
     DisplayPage TEXT,
     BannerImagePosition TEXT,
     ImageText TEXT
   ); 
  ''');
}

Future<void> insertOrUpdateTblImages(
  String imageId,
  String imagePath,
  String documentId,
  String imageUrl,
  String imageType,
  String displayPage,
  String bannerImagePosition,
  String imageText,
) async {
  try {
    // Check if the imageId already exists
    final result = _db.select(
      'SELECT COUNT(*) as count FROM TblImages WHERE ImageId = ?;',
      [imageId],
    );

    if (result.isNotEmpty && result.first['count'] > 0) {
      // If the imageId exists, update the row
      _db.execute('''
        UPDATE TblImages
        SET ImagePath = ?,
            DocumentId = ?,
            ImageUrl = ?,
            ImageType = ?,
            DisplayPage = ?,
            BannerImagePosition = ?,
            ImageText = ?
        WHERE ImageId = ?;
      ''', [
        imagePath,
        documentId,
        imageUrl,
        imageType,
        displayPage,
        bannerImagePosition,
        imageText,
        imageId
      ]);
    } else {
      // If the imageId does not exist, insert a new row
      _db.execute('''
        INSERT INTO TblImages (
          ImageId, ImagePath, DocumentId, ImageUrl, ImageType, DisplayPage, BannerImagePosition, ImageText
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
        imageId,
        imagePath,
        documentId,
        imageUrl,
        imageType,
        displayPage,
        bannerImagePosition,
        imageText
      ]);
    }
  } catch (e) {
    // Handle the error, e.g., log it
    // print('Error inserting or updating data in TblImages: $e');
  }
}

Future<List<Map<String, dynamic>>> getAllTblImages() async {
  try {
    // Ensure '_db' is your initialized database instance
    List<Map<String, dynamic>> result = _db.select('''
      SELECT * FROM TblImages''');
    // print("shubha getAllTblImages");
    log(result.toString());
    return result; // Return all rows as a list of maps
  } catch (e) {
    writeToFile(e, "getAllTblImages");
    print('Error in getAllTblImages: $e');
    return []; // Return an empty list in case of an error
  }
}

void createTblNotifications() {
  // Create a table and insert some data
  _db.execute('''
   CREATE TABLE IF NOT EXISTS TblNotifications( 
     DisplayDate TEXT,
     NotificationId TEXT PRIMARY KEY,
     NotificationTitle TEXT,
     NotificationBody TEXT,
     NotificationUpdatedOn TEXT,
     NotificationImageUrl TEXT,
     Type TEXT
   );
  ''');
}

Future<void> insertOrUpdateTblNotifications(
    String DisplayDate,
    String NotificationId,
    String NotificationTitle,
    String NotificationBody,
    String NotificationUpdatedOn,
    String NotificationImageUrl) async {
  // Check if the NotificationId exists
  final result = _db.select('''
      SELECT COUNT(*) as count FROM TblNotifications WHERE NotificationId = ?
  ''', [NotificationId]);

  int count = result.isNotEmpty ? result.first['count'] as int : 0;

  if (count > 0) {
    // If it exists, update the row
    _db.execute('''
        UPDATE TblNotifications
        SET 
          DisplayDate = ?,
          NotificationTitle = ?,
          NotificationBody = ?,
          NotificationUpdatedOn = ?,
          NotificationImageUrl = ?
        WHERE NotificationId = ?;
    ''', [
      DisplayDate,
      NotificationTitle,
      NotificationBody,
      NotificationUpdatedOn,
      NotificationImageUrl,
      NotificationId
    ]);
  } else {
    // If it does not exist, insert a new row
    _db.execute('''
        INSERT INTO TblNotifications (
          DisplayDate, 
          NotificationId, 
          NotificationTitle, 
          NotificationBody, 
          NotificationUpdatedOn,
          NotificationImageUrl
        ) VALUES (?, ?, ?, ?, ?, ?);
    ''', [
      DisplayDate,
      NotificationId,
      NotificationTitle,
      NotificationBody,
      NotificationUpdatedOn,
      NotificationImageUrl
    ]);
  }
}

Future<List<Map<String, dynamic>>> getAllTblNotifications() async {
  try {
    // Ensure '_db' is your initialized database instance
    List<Map<String, dynamic>> result = _db.select('''
      SELECT * FROM TblNotifications
      ORDER BY ROWID DESC''');
    // print("shubha getAllTblNotifications");
// log(result.toString());
    return result; // Return all rows as a list of maps
  } catch (e) {
    writeToFile(e, "getAllTblNotifications");
    print('Error in getAllTblNotifications: $e');
    return []; // Return an empty list in case of an error
  }
}

String getVideoPlayModeFromPackageId(String packageId) {
  // Execute the SQL query
  try {
    final sql.ResultSet resultSet = _db.select(
        'SELECT IsDirectPlay FROM TblPackageData WHERE PackageId = ?',
        [packageId]);

    // Check if a result is returned and fetch the OptionName
    if (resultSet.isNotEmpty) {
      return resultSet.first['IsDirectPlay'] as String;
    }
    return "";
  } catch (e) {
    return "";
  }
  // else {
  //   // throw Exception('TotalPassMarks not found: $paperID');
  // }
}

Future<void> updateIsSubmittedOnTblTheoryPaperTable(
    String paperId, String issubmited, BuildContext context) async {
  try {
    _db.execute('''
      UPDATE TblTheoryPaper
      SET IsSubmitted = ?
      WHERE PaperId = ?;
    ''', [issubmited, paperId]);
  } catch (e) {
    writeToFile(e, 'updateIsSubmittedOnTblTheoryPaperTable');
    print('Failed to update details: ${e.toString()}');
  }
}

Future<void> _createDB() async {
  _db.execute('''
      CREATE TABLE IF NOT EXISTS packages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        appStoreId INTEGER,
        categoryOrder INTEGER,
        imageType TEXT,
        heading TEXT
      );
    ''');

  _db.execute('''
      CREATE TABLE IF NOT EXISTS premium_packages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        packageId INTEGER,
        packageName TEXT,
        packageBannerPathUrl TEXT,
        minPackagePrice REAL
      );
    ''');
}

Future<void> deleteAllPackages() async {
  _db.execute('DELETE FROM packages');
}

Future<void> deleteAllPremiumPackages() async {
  _db.execute('DELETE FROM premium_packages');
}

// Insert PackageInfo into database
Future<void> insertPackages(List<PackageInfo> packages) async {
  for (var package in packages) {
    _db.execute('''
      INSERT INTO packages (appStoreId, categoryOrder, imageType, heading) 
      VALUES (?, ?, ?, ?)
    ''', [
      package.appStoreId,
      package.categoryOrder,
      package.imageType,
      package.heading
    ]);
  }
}

// // Insert PremiumPackage into database
Future<void> insertPremiumPackages(List<PremiumPackage> packages) async {
  for (var package in packages) {
    _db.execute('''
      INSERT INTO premium_packages (packageId, packageName, packageBannerPathUrl, minPackagePrice) 
      VALUES (?, ?, ?, ?)
    ''', [
      package.packageId,
      package.packageName,
      package.packageBannerPathUrl,
      package.minPackagePrice
    ]);
  }
}

Future<List<PackageInfo>> fetchAllData() async {
  // final db = await database;

  // Fetch all packages
  final packageResults = _db.select('SELECT * FROM packages');
  List<PackageInfo> packageList = packageResults.map((row) {
    print(row['imageType']);
    return PackageInfo(
      appStoreId: row['appStoreId'],
      categoryOrder: row['categoryOrder'],
      imageType: row['imageType'],
      heading: row['heading'],
      premiumPackageListInfo: [], //Ensure it's initialized properly
    );
  }).toList();

  // Fetch all premium packages
  final premiumResults = _db.select('SELECT * FROM premium_packages');
  List<PremiumPackage> premiumPackageList = premiumResults.map((row) {
    return PremiumPackage(
      packageId: row['packageId'],
      packageName: row['packageName'],
      packageBannerPathUrl: row['packageBannerPathUrl'],
      minPackagePrice: row['minPackagePrice'],
      sortingOrder: 0,
      documentUrl: '',
    );
  }).toList();

  // Map premium packages to their respective PackageInfo
  for (var package in packageList) {
    package.premiumPackageListInfo.addAll(premiumPackageList);
  }

  return packageList;
}
