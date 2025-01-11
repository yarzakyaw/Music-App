// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistModelAdapter extends TypeAdapter<ArtistModel> {
  @override
  final int typeId = 1;

  @override
  ArtistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistModel(
      id: fields[0] as String,
      nameENG: fields[1] as String,
      nameMM: fields[2] as String,
      profileImageUrl: fields[3] as String,
      ownerId: fields[4] as String,
      totalPlayCount: fields[5] as int,
      totalLikes: fields[6] as int,
      totalShare: fields[7] as int,
      totalDownloads: fields[8] as int,
      totalFollowers: fields[9] as int,
      totalFollowing: fields[10] as int,
      vault: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ArtistModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameENG)
      ..writeByte(2)
      ..write(obj.nameMM)
      ..writeByte(3)
      ..write(obj.profileImageUrl)
      ..writeByte(4)
      ..write(obj.ownerId)
      ..writeByte(5)
      ..write(obj.totalPlayCount)
      ..writeByte(6)
      ..write(obj.totalLikes)
      ..writeByte(7)
      ..write(obj.totalShare)
      ..writeByte(8)
      ..write(obj.totalDownloads)
      ..writeByte(9)
      ..write(obj.totalFollowers)
      ..writeByte(10)
      ..write(obj.totalFollowing)
      ..writeByte(11)
      ..write(obj.vault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
