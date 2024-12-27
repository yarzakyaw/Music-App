import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DhammaUserInteractionModel {
  final String id;
  final String userId;
  final String trackId;
  final String bhikkhuId;
  final String collectionId;
  final String interactionType;
  final DateTime timestamp;
  DhammaUserInteractionModel({
    required this.id,
    required this.userId,
    required this.trackId,
    required this.bhikkhuId,
    required this.collectionId,
    required this.interactionType,
    required this.timestamp,
  });

  DhammaUserInteractionModel copyWith({
    String? id,
    String? userId,
    String? trackId,
    String? bhikkhuId,
    String? collectionId,
    String? interactionType,
    DateTime? timestamp,
  }) {
    return DhammaUserInteractionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      trackId: trackId ?? this.trackId,
      bhikkhuId: bhikkhuId ?? this.bhikkhuId,
      collectionId: collectionId ?? this.collectionId,
      interactionType: interactionType ?? this.interactionType,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'trackId': trackId,
      'bhikkhuId': bhikkhuId,
      'collectionId': collectionId,
      'interactionType': interactionType,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory DhammaUserInteractionModel.fromMap(Map<String, dynamic> map) {
    return DhammaUserInteractionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      trackId: map['trackId'] ?? '',
      bhikkhuId: map['bhikkhuId'] ?? '',
      collectionId: map['collectionId'] ?? '',
      interactionType: map['interactionType'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory DhammaUserInteractionModel.fromJson(String source) =>
      DhammaUserInteractionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DhammaUserInteractionModel(id: $id, userId: $userId, trackId: $trackId, bhikkhuId; $bhikkhuId, collectionId: $collectionId, interactionType: $interactionType, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant DhammaUserInteractionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.trackId == trackId &&
        other.bhikkhuId == bhikkhuId &&
        other.collectionId == collectionId &&
        other.interactionType == interactionType &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        trackId.hashCode ^
        bhikkhuId.hashCode ^
        collectionId.hashCode ^
        interactionType.hashCode ^
        timestamp.hashCode;
  }
}
