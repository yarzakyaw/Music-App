// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_defined_playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDefinedPlaylistModelAdapter
    extends TypeAdapter<UserDefinedPlaylistModel> {
  @override
  final int typeId = 3;

  @override
  UserDefinedPlaylistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDefinedPlaylistModel(
      tracks: (fields[0] as List).cast<MusicModel>(),
      id: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      createrId: fields[6] as String,
      creatorName: fields[7] as String,
      hashtags: (fields[8] as List).cast<String>(),
      likeCount: fields[9] as int,
      isShared: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserDefinedPlaylistModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.tracks)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.createrId)
      ..writeByte(7)
      ..write(obj.creatorName)
      ..writeByte(8)
      ..write(obj.hashtags)
      ..writeByte(9)
      ..write(obj.likeCount)
      ..writeByte(10)
      ..write(obj.isShared);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDefinedPlaylistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
