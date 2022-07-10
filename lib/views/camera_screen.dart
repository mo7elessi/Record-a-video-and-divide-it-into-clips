import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/components/components.dart';
import 'package:flutter_video/db/db.dart';
import 'package:flutter_video/model/video_model.dart';
import 'package:flutter_video/views/videos_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isLoading = true;
  String error = '';
  bool _isRecording = false;
  late CameraController _cameraController;
  final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
  late String startTime;
  late String endTime;
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 0);
  XFile? file;
  List<Flags> flags = [];

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController =
        CameraController(back, ResolutionPreset.veryHigh, enableAudio: true);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  void _recordVideo() async {
    if (_isRecording) {
      _stopTimer();
      startTime = currentTime;
      final video = await _cameraController.stopVideoRecording();
      file = video;
      VideoModel videoModel = VideoModel(
        id: DateTime.now().microsecond.toString(),
        path: file!.path,
        name: "First video",
        startTime: 0,
        endTime: myDuration.inSeconds,
        flags: flags,
      );
      addVideo(videoModel);
      myDuration = const Duration(seconds: 0);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const VideosScreen(),
      //     ));
      setState(() => _isRecording = false);
    } else {
      startTimer();
      endTime = currentTime;
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  void _stopTimer() {
    countdownTimer!.cancel();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds + reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Record video"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideosScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.video_library_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CameraPreview(_cameraController),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '$minutes:$seconds',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        child: Icon(_isRecording ? Icons.stop : Icons.circle),
                        onPressed: () => _recordVideo(),
                      ),
                      const Spacer(),
                      _isRecording
                          ? FloatingActionButton(
                        backgroundColor: Colors.blueAccent,
                        child: const Icon(Icons.flag),
                        onPressed: () {
                          int start = myDuration.inSeconds - 2;
                          int end = myDuration.inSeconds + 2;
                          Flags _flags = Flags(
                            title: "default name",
                            startTime: start,
                            endTime: end,
                          );
                          flags.add(_flags);
                          toast(msg: "flag");
                        },
                      )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      );
    }
  }
}
