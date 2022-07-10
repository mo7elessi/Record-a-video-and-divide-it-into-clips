import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String filePath;
  final int startTime;
  final int endTime;
  final String title;

  const VideoPlayerScreen({
    Key? key,
    required this.filePath,
    required this.startTime,
    required this.endTime,
    required this.title,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() =>
      _VideoPlayerScreenState(filePath, startTime, title, endTime);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final String filePath;
  final int startTime;
  final int endTime;
  final String title;

  _VideoPlayerScreenState(
      this.filePath, this.startTime, this.title, this.endTime);

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.seekTo(
      (await _videoPlayerController.position)! + Duration(seconds: startTime),
    );
    await _videoPlayerController.setLooping(false);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: false,
      showControlsOnInitialize: true,
      progressIndicatorDelay: const Duration(),
      showOptions: true,
      materialProgressColors: ChewieProgressColors(playedColor: Colors.red),
      fullScreenByDefault: true,
      subtitleBuilder: (context, subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: SizedBox(
                height: 500,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
