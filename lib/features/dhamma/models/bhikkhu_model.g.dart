// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bhikkhu_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BhikkhuModelAdapter extends TypeAdapter<BhikkhuModel> {
  @override
  final int typeId = 2;

  @override
  BhikkhuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BhikkhuModel(
      id: fields[0] as String,
      nameENG: fields[1] as String,
      nameMM: fields[2] as String,
      alias: fields[3] as String,
      title: fields[4] as String,
      profileImageUrl: fields[5] as String,
      ownerId: fields[6] as String,
      totalPlayCount: fields[7] as int,
      totalLikes: fields[8] as int,
      totalShare: fields[9] as int,
      totalDownloads: fields[10] as int,
      totalFollowers: fields[11] as int,
      totalFollowing: fields[12] as int,
      vault: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BhikkhuModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameENG)
      ..writeByte(2)
      ..write(obj.nameMM)
      ..writeByte(3)
      ..write(obj.alias)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.profileImageUrl)
      ..writeByte(6)
      ..write(obj.ownerId)
      ..writeByte(7)
      ..write(obj.totalPlayCount)
      ..writeByte(8)
      ..write(obj.totalLikes)
      ..writeByte(9)
      ..write(obj.totalShare)
      ..writeByte(10)
      ..write(obj.totalDownloads)
      ..writeByte(11)
      ..write(obj.totalFollowers)
      ..writeByte(12)
      ..write(obj.totalFollowing)
      ..writeByte(13)
      ..write(obj.vault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BhikkhuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
