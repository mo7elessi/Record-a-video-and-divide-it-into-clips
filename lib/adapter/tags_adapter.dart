import 'package:flutter_video/model/video_model.dart';
import 'package:hive/hive.dart';

class TagsModelAdapter extends TypeAdapter<Flags> {
  @override
  final int typeId = 1;

  @override
  Flags read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flags(
      title: fields[0] as String,
      startTime: fields[1] as int,
      endTime: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Flags obj) {
    writer
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
