import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MusicModel {
  final String id;
  final String musicName;
  final String genre;
  final String audioType;
  final String userId;
  final String artistId;
  final String artist;
  final String artistMM;
  final String alias;
  final String title;
  final String albumId;
  final String albumName;
  final String featuring;
  final String thumbnailUrl;
  final String musicUrl;
  final DateTime releaseDate;
  final DateTime uploadDate;
  final int likeCount;
  final int playCount;
  final int shareCount;
  final int downloadCount;
  final String downloadOption;
  final String creditTo;
  final String hexCode;
  final List<String> hashtags;
  MusicModel({
    required this.id,
    required this.musicName,
    required this.audioType,
    required this.genre,
    required this.userId,
    required this.artistId,
    required this.artist,
    required this.artistMM,
    required this.alias,
    required this.title,
    required this.albumId,
    required this.albumName,
    required this.featuring,
    required this.thumbnailUrl,
    required this.musicUrl,
    required this.releaseDate,
    required this.uploadDate,
    required this.likeCount,
    required this.playCount,
    required this.shareCount,
    required this.downloadCount,
    required this.downloadOption,
    required this.creditTo,
    required this.hexCode,
    required this.hashtags,
  });

  MusicModel copyWith({
    String? id,
    String? musicName,
    String? audioType,
    String? genre,
    String? userId,
    String? artistId,
    String? artist,
    String? artistMM,
    String? alias,
    String? title,
    String? albumId,
    String? albumName,
    String? featuring,
    String? thumbnailUrl,
    String? musicUrl,
    DateTime? releaseDate,
    DateTime? uploadDate,
    int? likeCount,
    int? playCount,
    int? shareCount,
    int? downloadCount,
    String? downloadOption,
    String? creditTo,
    String? hexCode,
    List<String>? hashtags,
  }) {
    return MusicModel(
      id: id ?? this.id,
      musicName: musicName ?? this.musicName,
      audioType: audioType ?? this.audioType,
      genre: genre ?? this.genre,
      userId: userId ?? this.userId,
      artistId: artistId ?? this.artistId,
      artist: artist ?? this.artist,
      artistMM: artistMM ?? this.artistMM,
      alias: alias ?? this.alias,
      title: title ?? this.title,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      featuring: featuring ?? this.featuring,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      musicUrl: musicUrl ?? this.musicUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      uploadDate: uploadDate ?? this.uploadDate,
      likeCount: likeCount ?? this.likeCount,
      playCount: playCount ?? this.playCount,
      shareCount: shareCount ?? this.shareCount,
      downloadCount: downloadCount ?? this.downloadCount,
      downloadOption: downloadOption ?? this.downloadOption,
      creditTo: creditTo ?? this.creditTo,
      hexCode: hexCode ?? this.hexCode,
      hashtags: hashtags ?? this.hashtags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'musicName': musicName,
      'audioType': audioType,
      'genre': genre,
      'userId': userId,
      'artistId': artistId,
      'artist': artist,
      'artistMM': artistMM,
      'alias': alias,
      'title': title,
      'albumId': albumId,
      'albumName': albumName,
      'featuring': featuring,
      'thumbnailUrl': thumbnailUrl,
      'musicUrl': musicUrl,
      'releaseDate': releaseDate.millisecondsSinceEpoch,
      'uploadDate': uploadDate.millisecondsSinceEpoch,
      'likeCount': likeCount,
      'playCount': playCount,
      'shareCount': shareCount,
      'downloadCount': downloadCount,
      'downloadOption': downloadOption,
      'creditTo': creditTo,
      'hexCode': hexCode,
      'hashtags': hashtags,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] ?? '',
      musicName: map['musicName'] ?? '',
      audioType: map['audioType'] ?? '',
      genre: map['genre'] ?? '',
      userId: map['userId'] ?? '',
      artistId: map['artistId'] ?? '',
      artist: map['artist'] ?? '',
      artistMM: map['artistMM'] ?? '',
      alias: map['alias'] ?? '',
      title: map['title'] ?? '',
      albumId: map['albumId'] ?? '',
      albumName: map['albumName'] ?? '',
      featuring: map['featuring'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      musicUrl: map['musicUrl'] ?? '',
      releaseDate: map['releaseDate'] is Timestamp
          ? (map['releaseDate'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['releaseDate'] ?? 0),
      uploadDate: map['uploadDate'] is Timestamp
          ? (map['uploadDate'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['uploadDate'] ?? 0),
      likeCount: map['likeCount'] ?? 0,
      playCount: map['playCount'] ?? 0,
      shareCount: map['shareCount'] ?? 0,
      downloadCount: map['downloadCount'] ?? 0,
      downloadOption: map['downloadOption'] ?? '',
      creditTo: map['creditTo'] ?? '',
      hexCode: map['hexCode'] ?? '',
      hashtags: List<String>.from(map['hashtags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(String source) =>
      MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MusicModel(id: $id, musicName: $musicName, audioType: $audioType, genre: $genre, userId: $userId, artistId: $artistId, artist: $artist, artistMM: $artistMM, alias: $alias, title: $title, albumId: $albumId, albumName: $albumName, featuring: $featuring, thumbnailUrl: $thumbnailUrl, musicUrl: $musicUrl, releaseDate: $releaseDate, uploadDate: $uploadDate, likeCount: $likeCount, playCount: $playCount, shareCount: $shareCount, downloadCount: $downloadCount, downloadOption: $downloadOption, creditTo: $creditTo, hexCode: $hexCode, hashtags: $hashtags)';
  }

  @override
  bool operator ==(covariant MusicModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.musicName == musicName &&
        other.audioType == audioType &&
        other.genre == genre &&
        other.userId == userId &&
        other.artistId == artistId &&
        other.artist == artist &&
        other.artistMM == artistMM &&
        other.alias == alias &&
        other.title == title &&
        other.albumId == albumId &&
        other.albumName == albumName &&
        other.featuring == featuring &&
        other.thumbnailUrl == thumbnailUrl &&
        other.musicUrl == musicUrl &&
        other.releaseDate == releaseDate &&
        other.uploadDate == uploadDate &&
        other.likeCount == likeCount &&
        other.playCount == playCount &&
        other.shareCount == shareCount &&
        other.downloadCount == downloadCount &&
        other.downloadOption == downloadOption &&
        other.creditTo == creditTo &&
        other.hexCode == hexCode &&
        other.hashtags == hashtags;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        musicName.hashCode ^
        audioType.hashCode ^
        genre.hashCode ^
        userId.hashCode ^
        artistId.hashCode ^
        artist.hashCode ^
        artistMM.hashCode ^
        alias.hashCode ^
        title.hashCode ^
        albumId.hashCode ^
        albumName.hashCode ^
        featuring.hashCode ^
        thumbnailUrl.hashCode ^
        musicUrl.hashCode ^
        releaseDate.hashCode ^
        uploadDate.hashCode ^
        likeCount.hashCode ^
        playCount.hashCode ^
        shareCount.hashCode ^
        downloadCount.hashCode ^
        downloadOption.hashCode ^
        creditTo.hashCode ^
        hexCode.hashCode ^
        hashtags.hashCode;
  }
}
