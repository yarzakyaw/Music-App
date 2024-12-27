import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:mingalar_music_app/features/home/models/music_model.dart';

class UserDefinedPlaylistModel {
  final List<MusicModel> tracks;
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createrId;
  final String createrName;
  final List<String> hashtags;
  UserDefinedPlaylistModel({
    required this.tracks,
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.createrId,
    required this.createrName,
    required this.hashtags,
  });

  UserDefinedPlaylistModel copyWith({
    List<MusicModel>? tracks,
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createrId,
    String? createrName,
    List<String>? hashtags,
  }) {
    return UserDefinedPlaylistModel(
      tracks: tracks ?? this.tracks,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createrId: createrId ?? this.createrId,
      createrName: createrName ?? this.createrName,
      hashtags: hashtags ?? this.hashtags,
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
      'createrName': createrName,
      'hashtags': hashtags,
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
      createrName: map['createrName'] ?? '',
      hashtags: List<String>.from(
        (map['hashtags'] ?? []),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDefinedPlaylistModel.fromJson(String source) =>
      UserDefinedPlaylistModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDefinedPlaylistModel(tracks: $tracks, id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, createrId: $createrId, createrName: $createrName, hashtags: $hashtags)';
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
        other.createrName == createrName &&
        listEquals(other.hashtags, hashtags);
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
        createrName.hashCode ^
        hashtags.hashCode;
  }
}
