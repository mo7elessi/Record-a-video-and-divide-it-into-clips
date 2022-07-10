import 'package:flutter/material.dart';
import 'package:flutter_video/components/components.dart';
import 'package:flutter_video/model/video_model.dart';
import 'package:hive_flutter/adapters.dart';

var videoBox = Hive.box<VideoModel>('video_db');

Future addVideo(VideoModel video) async {
  videoBox.add(video).catchError((onError){
    toast(msg: onError.toString());
  });
}
