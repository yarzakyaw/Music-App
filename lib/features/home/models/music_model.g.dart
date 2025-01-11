// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 0;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      id: fields[0] as String,
      musicName: fields[1] as String,
      audioType: fields[3] as String,
      genre: fields[2] as String,
      userId: fields[4] as String,
      artistId: fields[5] as String,
      artist: fields[6] as String,
      artistMM: fields[7] as String,
      alias: fields[8] as String,
      title: fields[9] as String,
      albumId: fields[10] as String,
      albumName: fields[11] as String,
      featuring: fields[12] as String,
      thumbnailUrl: fields[13] as String,
      musicUrl: fields[14] as String,
      releaseDate: fields[15] as DateTime,
      uploadDate: fields[16] as DateTime,
      likeCount: fields[17] as int,
      playCount: fields[18] as int,
      shareCount: fields[19] as int,
      downloadCount: fields[20] as int,
      downloadOption: fields[21] as String,
      creditTo: fields[22] as String,
      hexCode: fields[23] as String,
      hashtags: (fields[24] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.musicName)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.audioType)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.artistId)
      ..writeByte(6)
      ..write(obj.artist)
      ..writeByte(7)
      ..write(obj.artistMM)
      ..writeByte(8)
      ..write(obj.alias)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.albumId)
      ..writeByte(11)
      ..write(obj.albumName)
      ..writeByte(12)
      ..write(obj.featuring)
      ..writeByte(13)
      ..write(obj.thumbnailUrl)
      ..writeByte(14)
      ..write(obj.musicUrl)
      ..writeByte(15)
      ..write(obj.releaseDate)
      ..writeByte(16)
      ..write(obj.uploadDate)
      ..writeByte(17)
      ..write(obj.likeCount)
      ..writeByte(18)
      ..write(obj.playCount)
      ..writeByte(19)
      ..write(obj.shareCount)
      ..writeByte(20)
      ..write(obj.downloadCount)
      ..writeByte(21)
      ..write(obj.downloadOption)
      ..writeByte(22)
      ..write(obj.creditTo)
      ..writeByte(23)
      ..write(obj.hexCode)
      ..writeByte(24)
      ..write(obj.hashtags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
