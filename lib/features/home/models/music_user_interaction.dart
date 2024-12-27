import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MusicUserInteractionModel {
  final String id;
  final String userId;
  final String trackId;
  final String artistId;
  final String albumId;
  final String interactionType;
  final DateTime timestamp;
  MusicUserInteractionModel({
    required this.id,
    required this.userId,
    required this.trackId,
    required this.artistId,
    required this.albumId,
    required this.interactionType,
    required this.timestamp,
  });

  MusicUserInteractionModel copyWith({
    String? id,
    String? userId,
    String? trackId,
    String? artistId,
    String? albumId,
    String? interactionType,
    DateTime? timestamp,
  }) {
    return MusicUserInteractionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      trackId: trackId ?? this.trackId,
      artistId: artistId ?? this.artistId,
      albumId: albumId ?? this.albumId,
      interactionType: interactionType ?? this.interactionType,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'trackId': trackId,
      'artistId': artistId,
      'albumId': albumId,
      'interactionType': interactionType,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory MusicUserInteractionModel.fromMap(Map<String, dynamic> map) {
    return MusicUserInteractionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      trackId: map['trackId'] ?? '',
      artistId: map['artistId'] ?? '',
      albumId: map['albumId'] ?? '',
      interactionType: map['interactionType'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicUserInteractionModel.fromJson(String source) =>
      MusicUserInteractionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MusicUserInteractionModel(id: $id, userId: $userId, trackId: $trackId, artistId: $artistId, albumId: $albumId, interactionType: $interactionType, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant MusicUserInteractionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.trackId == trackId &&
        other.artistId == artistId &&
        other.albumId == albumId &&
        other.interactionType == interactionType &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        trackId.hashCode ^
        artistId.hashCode ^
        albumId.hashCode ^
        interactionType.hashCode ^
        timestamp.hashCode;
  }
}
