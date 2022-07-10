import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class VideoModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(2)
  String? path;
  @HiveField(1)
  String? name;
  @HiveField(3)
  int? startTime;
  @HiveField(4)
  List<Flags> flags = [];
  @HiveField(5)
  int? endTime;
  VideoModel({
    required this.id,
    required this.path,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.flags,
  });
}

@HiveType(typeId: 1)
class Flags {
  @HiveField(0)
  String? title;
  @HiveField(1)
  int? startTime;
  @HiveField(2)
  int? endTime;

  Flags({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}
