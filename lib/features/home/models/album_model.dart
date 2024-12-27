import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumModel {
  final String id;
  final String artistId;
  final String albumName;
  final DateTime releaseDate;
  final String albumImageUrl;
  final int totalDownloads;
  final int totalLikes;
  final int totalPlayCount;
  final int totalShare;
  AlbumModel({
    required this.id,
    required this.artistId,
    required this.albumName,
    required this.releaseDate,
    required this.albumImageUrl,
    required this.totalDownloads,
    required this.totalLikes,
    required this.totalPlayCount,
    required this.totalShare,
  });

  AlbumModel copyWith({
    String? id,
    String? artistId,
    String? albumName,
    DateTime? releaseDate,
    String? albumImageUrl,
    int? totalDownloads,
    int? totalLikes,
    int? totalPlayCount,
    int? totalShare,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      artistId: artistId ?? this.artistId,
      albumName: albumName ?? this.albumName,
      releaseDate: releaseDate ?? this.releaseDate,
      albumImageUrl: albumImageUrl ?? this.albumImageUrl,
      totalDownloads: totalDownloads ?? this.totalDownloads,
      totalLikes: totalLikes ?? this.totalLikes,
      totalPlayCount: totalPlayCount ?? this.totalPlayCount,
      totalShare: totalShare ?? this.totalShare,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'artistId': artistId,
      'albumName': albumName,
      'releaseDate': releaseDate.millisecondsSinceEpoch,
      'albumImageUrl': albumImageUrl,
      'totalDownloads': totalDownloads,
      'totalLikes': totalLikes,
      'totalPlayCount': totalPlayCount,
      'totalShare': totalShare,
    };
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      id: map['id'] ?? '',
      artistId: map['artistId'] ?? '',
      albumName: map['albumName'] ?? '',
      releaseDate: map['releaseDate'] is Timestamp
          ? (map['releaseDate'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['releaseDate'] ?? 0),
      albumImageUrl: map['albumImageUrl'] ?? '',
      totalDownloads: map['totalDownloads'] ?? 0,
      totalLikes: map['totalLikes'] ?? 0,
      totalPlayCount: map['totalPlayCount'] ?? 0,
      totalShare: map['totalShare'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModel.fromJson(String source) =>
      AlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumModel(id: $id, artistId: $artistId, albumName: $albumName, releaseDate: $releaseDate, albumImageUrl: $albumImageUrl, totalDownloads: $totalDownloads, totalLikes: $totalLikes, totalPlayCount: $totalPlayCount, totalShare: $totalShare)';
  }

  @override
  bool operator ==(covariant AlbumModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.artistId == artistId &&
        other.albumName == albumName &&
        other.releaseDate == releaseDate &&
        other.albumImageUrl == albumImageUrl &&
        other.totalDownloads == totalDownloads &&
        other.totalLikes == totalLikes &&
        other.totalPlayCount == totalPlayCount &&
        other.totalShare == totalShare;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        artistId.hashCode ^
        albumName.hashCode ^
        releaseDate.hashCode ^
        albumImageUrl.hashCode ^
        totalDownloads.hashCode ^
        totalLikes.hashCode ^
        totalPlayCount.hashCode ^
        totalShare.hashCode;
  }
}
