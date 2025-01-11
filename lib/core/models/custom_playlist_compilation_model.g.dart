// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_playlist_compilation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomPlaylistCompilationModelAdapter
    extends TypeAdapter<CustomPlaylistCompilationModel> {
  @override
  final int typeId = 4;

  @override
  CustomPlaylistCompilationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomPlaylistCompilationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      createrId: fields[5] as String,
      creatorName: fields[6] as String,
      likeCount: fields[7] as int,
      isShared: fields[8] as bool,
      hashtags: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomPlaylistCompilationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.createrId)
      ..writeByte(6)
      ..write(obj.creatorName)
      ..writeByte(7)
      ..write(obj.likeCount)
      ..writeByte(8)
      ..write(obj.isShared)
      ..writeByte(9)
      ..write(obj.hashtags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomPlaylistCompilationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
