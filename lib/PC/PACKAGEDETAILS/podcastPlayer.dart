import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodCastPlayer extends StatefulWidget {
  @override
  State<PodCastPlayer> createState() => _PodCastPlayerState();
}

class _PodCastPlayerState extends State<PodCastPlayer> {
  final Dio dio = Dio();
  Getx getx = Get.put(Getx());
  late AudioPlayer audioPlayer;

  // Observables for progress and downloading status
  RxMap<int, double> downloadProgress = <int, double>{}.obs;
  RxSet<int> downloadingIndexes = <int>{}.obs;
  RxString playingPodcastPath = ''.obs;
  Rx<Duration> currentDuration = Duration.zero.obs;
  Rx<Duration> totalDuration = Duration.zero.obs;
  String platformWisePathSeparator=Platform.isWindows?"\\":"/";

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    setState(() {});

    // Listen to duration updates
    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    audioPlayer.onPositionChanged.listen((position) {
      currentDuration.value = position;
    });
  }

 

void _playPodcast(String filePath) async {
  log("Original Path: $filePath");

  // Fix incorrect path formatting (ensure consistent usage of '/')
  filePath = filePath.replaceAll('\\', '/').trim();
  log("Fixed Path: $filePath");

  File audioFile = File(filePath);

  // Check if the file exists
  if (!audioFile.existsSync()) {
    Get.snackbar("Error", "Podcast file does not exist:\n$filePath",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    return;
  }

  // Ensure file has a valid audio extension
  List<String> validExtensions = ['mp3', 'wav', 'aac', 'm4a',];
  String fileExtension = filePath.split('.').last.toLowerCase();

  if (!validExtensions.contains(fileExtension) && !Platform.isWindows) {
    Get.snackbar("Error", "Unsupported audio format ($fileExtension)",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
    return;
  }

  try {
    // Set source first to ensure the file can be loaded
    await audioPlayer.setSource(DeviceFileSource(filePath));

    // Play audio after source is set
    await audioPlayer.resume();
  } on PlatformException catch (e, stackTrace) {
    writeToFile(e, '_playPodcast_PlatformException');
    log('PlatformException: $e\nStackTrace: $stackTrace');

    Get.snackbar("Playback Error", "Unsupported audio format or file issue.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  } catch (e, stackTrace) {
    writeToFile(e, '_playPodcast_CatchAll');
    log('Unknown error playing podcast: $e\nStackTrace: $stackTrace');

    Get.snackbar("Error", "Unknown error occurred.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }
}


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ,
        title: Text('Podcast Player'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Obx(
              () => ListView.builder(
                itemCount: getx.podcastFileList.length,
                itemBuilder: (context, index) {
                  getx.podcastFileList[index];
                  final isDownloaded = File(getx
                              .userSelectedPathForDownloadFile.isEmpty
                          ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                          : getx.userSelectedPathForDownloadFile.value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}')
                      .existsSync();

                  print(isDownloaded.toString());
                  print(isDownloaded.toString());
                  print(isDownloaded.toString());

                  return Obx(
                    () => Card(
                      color: playingPodcastPath.value ==
                              (getx.userSelectedPathForDownloadFile.isEmpty
                                  ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                  : getx.userSelectedPathForDownloadFile.value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}')
                          ? Colors.blue[100]
                          : Colors.white,
                      child: ListTile(
                        onTap: () {
                          if (File(getx.userSelectedPathForDownloadFile.isEmpty
                                  ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                  : getx.userSelectedPathForDownloadFile.value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}')
                              .existsSync()) {
                            playingPodcastPath.value = getx
                                    .userSelectedPathForDownloadFile.isEmpty
                                ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                : getx.userSelectedPathForDownloadFile.value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}';
                            _playPodcast(playingPodcastPath.value);
                          }
                        },
                        leading: Icon(Icons.audiotrack),
                        title: Text(getx.podcastFileList[index]['FileIdName']),
                        subtitle: isDownloaded
                            ? Text(
                                'Ready to play',
                                style: TextStyle(color: Colors.green),
                              )
                            : null,
                        trailing: downloadingIndexes.contains(index)
                            ? CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 4.0,
                                percent: (downloadProgress[index] ?? 0.0) / 100,
                                center: Text(
                                    '${(downloadProgress[index] ?? 0.0).toInt()}%'),
                              )
                            : File(getx.userSelectedPathForDownloadFile.isEmpty
                                        ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                        : getx.userSelectedPathForDownloadFile
                                                .value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}')
                                    .existsSync()
                                ? IconButton(
                                    icon: playingPodcastPath.value ==
                                            (getx.userSelectedPathForDownloadFile
                                                    .isEmpty
                                                ? getx.defaultPathForDownloadFile +
                                                    '${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                                : getx.userSelectedPathForDownloadFile
                                                        .value +
                                                    '${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}')
                                        ? Icon(Icons.pause)
                                        : Icon(Icons.play_arrow),
                                    onPressed: () {
                                      playingPodcastPath.value = getx
                                              .userSelectedPathForDownloadFile
                                              .isEmpty
                                          ? getx.defaultPathForDownloadFile +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}'
                                          : getx.userSelectedPathForDownloadFile
                                                  .value +
'${platformWisePathSeparator}Podcast${platformWisePathSeparator}${getx.podcastFileList[index]['FileIdName']}';
                                      _playPodcast(playingPodcastPath.value);
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: () {
                                      if (getx.podcastFileList[index]
                                                  ['DocumentPath'] !=
                                              "0" &&
                                          getx.isInternet.value) {
                                        downloadPodcast(
                                          getx.podcastFileList[index]
                                              ['DocumentPath'],
                                          '${getx.podcastFileList[index]['FileIdName']}',
                                          index, downloadProgress,downloadingIndexes
                                        );
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    'Something Went Wrong !!')));
                                      }
                                    },
                                  ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Obx(
              () => playingPodcastPath.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            logopath,
                            scale: 2,
                          ),
                          Text(
                            'Select a podcast to play',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      child: Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 70,
                                  child: Icon(Icons.podcasts, size: 90)),
                              SizedBox(height: 20),
                              Text(
                                'Now Playing',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                // playingPodcastPath.value,
                                playingPodcastPath.value.split('\\').last,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 30),
                              Obx(
                                () => SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.blueAccent,
                                    inactiveTrackColor: Colors.grey.shade300,
                                    thumbColor: Colors.blueAccent,
                                    overlayColor:
                                        Colors.blueAccent.withOpacity(0.2),
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 10),
                                  ),
                                  child: Slider(
                                    value: currentDuration.value.inSeconds
                                        .toDouble()
                                        .clamp(
                                            0.0,
                                            totalDuration.value.inSeconds
                                                .toDouble()),
                                    max: totalDuration.value.inSeconds
                                                .toDouble() >
                                            0
                                        ? totalDuration.value.inSeconds
                                            .toDouble()
                                        : 1.0,
                                    min: 0.0,
                                    onChanged: (value) {
                                      audioPlayer.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          '${currentDuration.value.inMinutes}:${(currentDuration.value.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          '${totalDuration.value.inMinutes}:${(totalDuration.value.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Tooltip(
                                    message: 'Skip backward 10 Seconds',
                                    child: IconButton(
                                      icon: Icon(Icons.skip_previous),
                                      iconSize: 40,
                                      color: Colors.grey.shade600,
                                      onPressed: () {
                                        audioPlayer.seek(Duration(
                                            seconds: currentDuration
                                                    .value.inSeconds -
                                                10));
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  StreamBuilder<PlayerState>(
                                    stream: audioPlayer.onPlayerStateChanged,
                                    builder: (context, snapshot) {
                                      final state = snapshot.data;
                                      final isPlaying =
                                          state == PlayerState.playing;
                                      return IconButton(
                                        icon: Icon(
                                          isPlaying
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_filled,
                                        ),
                                        iconSize: 60,
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          if (isPlaying) {
                                            audioPlayer.pause();
                                          } else {
                                            audioPlayer.resume();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  Tooltip(
                                    message: "Skip forward 10 seconds",
                                    child: IconButton(
                                      icon: Icon(Icons.skip_next),
                                      iconSize: 40,
                                      color: Colors.grey.shade600,
                                      onPressed: () {
                                        audioPlayer.seek(Duration(
                                            seconds: currentDuration
                                                    .value.inSeconds +
                                                10));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


 Future<void> downloadPodcast(String url, String fileName, int index ,Map downloadProgress,Set downloadingIndexes ) async {


    final Dio dio = Dio();
  Getx getx = Get.put(Getx());
  final appDocDir = await getApplicationDocumentsDirectory();
  Directory dthLmsDir = Platform.isWindows?Directory('${appDocDir.path}\\$origin'): Directory('${appDocDir.path}/$origin');
  var prefs = await SharedPreferences.getInstance();

  getx.defaultPathForDownloadFile.value = dthLmsDir.path;
  prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

  // Extract file extension from URL
  String fileExtension = url.split('.').last.split('?').first; // Handling query parameters
  String fullFileName = '$fileName';

  String savePath = Platform.isWindows?getx.userSelectedPathForDownloadFile.isEmpty
      ? '${dthLmsDir.path}\\Podcast\\$fullFileName'
      : '${getx.userSelectedPathForDownloadFile.value}\\Podcast\\$fullFileName':  getx.userSelectedPathForDownloadFile.isEmpty
      ? '${dthLmsDir.path}/Podcast/$fullFileName'
      : '${getx.userSelectedPathForDownloadFile.value}/Podcast/$fullFileName';




      

  try {
    downloadingIndexes.add(index);
    downloadProgress[index] = 0.0;

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          downloadProgress[index] = (received / total * 100);
        }
      },
    );

    getx.podcastFileList[index]['DownloadedPath'] = savePath;
  } catch (e) {
    print('Download error: $e');
  } finally {
    downloadingIndexes.remove(index);
    downloadProgress.remove(index);
  }
}
