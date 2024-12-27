import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mingalar_music_app/features/home/models/music_model.dart';

class CustomPlaylistModel {
  final List<MusicModel> playlist;
  final String id;
  final String title;
  final String playListType;
  final int count;

  CustomPlaylistModel({
    required this.playlist,
    required this.id,
    required this.title,
    required this.playListType,
    required this.count,
  });

  CustomPlaylistModel copyWith({
    List<MusicModel>? playlist,
    String? id,
    String? title,
    String? playListType,
    int? count,
  }) {
    return CustomPlaylistModel(
      playlist: playlist ?? this.playlist,
      id: id ?? this.id,
      title: title ?? this.title,
      playListType: playListType ?? this.playListType,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playlist': playlist.map((x) => x.toMap()).toList(),
      'id': id,
      'title': title,
      'playListType': playListType,
      'count': count,
    };
  }

  factory CustomPlaylistModel.fromMap(Map<String, dynamic> map) {
    return CustomPlaylistModel(
      playlist: List<MusicModel>.from(
        (map['playlist'] as List<dynamic>).map<MusicModel>(
          (x) => MusicModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      playListType: map['playListType'] ?? '',
      count: map['count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomPlaylistModel.fromJson(String source) =>
      CustomPlaylistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomPlaylistModel(playlist: $playlist, id: $id, title: $title, playListType: $playListType, count: $count)';
  }

  @override
  bool operator ==(covariant CustomPlaylistModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.playlist, playlist) &&
        other.id == id &&
        other.title == title &&
        other.playListType == playListType &&
        other.count == count;
  }

  @override
  int get hashCode {
    return playlist.hashCode ^
        id.hashCode ^
        title.hashCode ^
        playListType.hashCode ^
        count.hashCode;
  }
}
