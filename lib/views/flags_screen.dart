import 'package:flutter/material.dart';
import 'package:flutter_video/model/video_model.dart';
import 'package:flutter_video/views/video_player_screen.dart';

class FlagsVideoScreen extends StatelessWidget {
  VideoModel video;

  FlagsVideoScreen({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${video.name}"),
      ),
      body: video.flags != null
          ? ListView.builder(
            itemCount: video.flags.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text("${video.flags[i].title}"),
                leading: const Image(
                  image: NetworkImage(
                      "https://png.pngtree.com/png-vector/20190215/ourlarge/pngtree-play-video-icon-graphic-design-template-vector-png-image_530837.jpg"),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                subtitle: Text(
                  "${video.flags[i].startTime}s - ${video.flags[i].endTime}s",
                  style: const TextStyle(color: Colors.red,fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        filePath: "${video.path}",
                        startTime: video.flags[i].startTime!,
                        endTime: video.flags[i].endTime!,
                        title: "${video.flags[i].title}",
                      ),
                    ),
                  );
                },
              );
            },
          )
          : const Center(child: Text("no flags yet!")),
    );
  }
}
