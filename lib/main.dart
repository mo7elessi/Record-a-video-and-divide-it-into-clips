import 'package:flutter/material.dart';
import 'package:flutter_video/views/camera_screen.dart';
import 'package:flutter_video/adapter/tags_adapter.dart';
import 'package:flutter_video/adapter/video_adapter.dart';
import 'package:flutter_video/model/video_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

Box<VideoModel>? videoBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(TagsModelAdapter());
  await Hive.openBox<VideoModel>('video_db');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
      theme: ThemeData(
          primaryColor: Colors.red,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              elevation: 0.0,
              backgroundColor: Colors.red,
              centerTitle: true,
              titleTextStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
    );
  }
}
