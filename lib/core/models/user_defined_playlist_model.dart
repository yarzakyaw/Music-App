import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:mingalar_music_app/features/home/models/music_model.dart';

part 'user_defined_playlist_model.g.dart';

@HiveType(typeId: 3)
class UserDefinedPlaylistModel {
  @HiveField(0)
  final List<MusicModel> tracks;
  @HiveField(1)
  final String id;
  @HiveField(2)
  String title;
  @HiveField(3)
  String description;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  DateTime updatedAt;
  @HiveField(6)
  final String createrId;
  @HiveField(7)
  final String creatorName;
  @HiveField(8)
  List<String> hashtags;
  @HiveField(9)
  final int likeCount;
  @HiveField(10)
  bool isShared;
  UserDefinedPlaylistModel({
    required this.tracks,
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.createrId,
    required this.creatorName,
    required this.hashtags,
    required this.likeCount,
    required this.isShared,
  });

  UserDefinedPlaylistModel copyWith({
    List<MusicModel>? tracks,
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createrId,
    String? creatorName,
    List<String>? hashtags,
    int? likeCount,
    bool? isShared,
  }) {
    return UserDefinedPlaylistModel(
      tracks: tracks ?? this.tracks,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createrId: createrId ?? this.createrId,
      creatorName: creatorName ?? this.creatorName,
      hashtags: hashtags ?? this.hashtags,
      likeCount: likeCount ?? this.likeCount,
      isShared: isShared ?? this.isShared,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tracks': tracks.map((x) => x.toMap()).toList(),
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createrId': createrId,
      'creatorName': creatorName,
      'hashtags': hashtags,
      'likeCount': likeCount,
      'isShared': isShared,
    };
  }

  factory UserDefinedPlaylistModel.fromMap(Map<String, dynamic> map) {
    return UserDefinedPlaylistModel(
      tracks: List<MusicModel>.from(
        (map['tracks'] as List<dynamic>).map<MusicModel>(
          (x) => MusicModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      createrId: map['createrId'] ?? '',
      creatorName: map['creatorName'] ?? '',
      hashtags: List<String>.from(
        (map['hashtags'] ?? []),
      ),
      likeCount: map['likeCount'] ?? 0,
      isShared: map['isShared'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDefinedPlaylistModel.fromJson(String source) =>
      UserDefinedPlaylistModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDefinedPlaylistModel(tracks: $tracks, id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, createrId: $createrId, creatorName: $creatorName, hashtags: $hashtags, likeCount: $likeCount, isShared: $isShared)';
  }

  @override
  bool operator ==(covariant UserDefinedPlaylistModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.tracks, tracks) &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createrId == createrId &&
        other.creatorName == creatorName &&
        listEquals(other.hashtags, hashtags) &&
        other.likeCount == likeCount &&
        other.isShared == isShared;
  }

  @override
  int get hashCode {
    return tracks.hashCode ^
        id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        createrId.hashCode ^
        creatorName.hashCode ^
        hashtags.hashCode ^
        likeCount.hashCode ^
        isShared.hashCode;
  }

  /* void addTrack(MusicModel track) {
    // Avoid duplicates by checking if the track already exists
    if (!tracks.any((existingTrack) => existingTrack.id == track.id)) {
      tracks.add(track);
    }
  } */
}
