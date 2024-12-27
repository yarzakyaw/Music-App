// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DhammaCollectionModel {
  final String id;
  final String bhikkhuId;
  final String collectionName;
  final DateTime releaseDate;
  final String collectionImageUrl;

  DhammaCollectionModel({
    required this.id,
    required this.bhikkhuId,
    required this.collectionName,
    required this.releaseDate,
    required this.collectionImageUrl,
  });

  DhammaCollectionModel copyWith({
    String? id,
    String? bhikkhuId,
    String? collectionName,
    DateTime? releaseDate,
    String? collectionImageUrl,
  }) {
    return DhammaCollectionModel(
      id: id ?? this.id,
      bhikkhuId: bhikkhuId ?? this.bhikkhuId,
      collectionName: collectionName ?? this.collectionName,
      releaseDate: releaseDate ?? this.releaseDate,
      collectionImageUrl: collectionImageUrl ?? this.collectionImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bhikkhuId': bhikkhuId,
      'collectionName': collectionName,
      'releaseDate': releaseDate.millisecondsSinceEpoch,
      'collectionImageUrl': collectionImageUrl,
    };
  }

  factory DhammaCollectionModel.fromMap(Map<String, dynamic> map) {
    return DhammaCollectionModel(
      id: map['id'] ?? '',
      bhikkhuId: map['bhikkhuId'] ?? '',
      collectionName: map['collectionName'] ?? '',
      releaseDate: map['releaseDate'] is Timestamp
          ? (map['releaseDate'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['releaseDate'] ?? 0),
      collectionImageUrl: map['collectionImageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DhammaCollectionModel.fromJson(String source) =>
      DhammaCollectionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DhammaCollectionModel(id: $id, bhikkhuId: $bhikkhuId, collectionName: $collectionName, releaseDate: $releaseDate, collectionImageUrl: $collectionImageUrl)';
  }

  @override
  bool operator ==(covariant DhammaCollectionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bhikkhuId == bhikkhuId &&
        other.collectionName == collectionName &&
        other.releaseDate == releaseDate &&
        other.collectionImageUrl == collectionImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bhikkhuId.hashCode ^
        collectionName.hashCode ^
        releaseDate.hashCode ^
        collectionImageUrl.hashCode;
  }
}
