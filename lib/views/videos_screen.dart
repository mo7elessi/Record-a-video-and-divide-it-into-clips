import 'package:flutter/material.dart';
import 'package:flutter_video/db/db.dart';
import 'package:flutter_video/model/video_model.dart';
import 'package:flutter_video/views/flags_screen.dart';
import 'package:flutter_video/views/video_player_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<VideoModel> _videoModelBox;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Videos"),
      ),
      body:videoBox.listenable().value.values.isNotEmpty? ValueListenableBuilder(
        valueListenable: videoBox.listenable(),
        builder: (context, Box<VideoModel> videoBox, _) {
          _videoModelBox = videoBox;
          return ListView.builder(
              itemCount: videoBox.values.length,
              itemBuilder: (BuildContext context, int index) {
                final video = _videoModelBox.getAt(index)!;
                return ListTile(
                  title: Text("${video.name}"),
                  leading: const Image(
                    image: NetworkImage(
                        "https://png.pngtree.com/png-vector/20190215/ourlarge/pngtree-play-video-icon-graphic-design-template-vector-png-image_530837.jpg"),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FlagsVideoScreen(video: video),
                          ));
                    },
                    icon: const Icon(Icons.flag),
                  ),
                  subtitle: Text(
                    "${video.endTime}s",
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                 // onLongPress: () => _videoModelBox.deleteAt(index),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            filePath: "${video.path}",
                            startTime: 0,
                            endTime: video.endTime!,
                            title: "${video.name}",
                          ),
                        ));
                  },
                );
              });
        },
      ):const Center(child: Text("no video yet!")),
    );
  }
}
