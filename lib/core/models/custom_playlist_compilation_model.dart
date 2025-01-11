import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'custom_playlist_compilation_model.g.dart';

@HiveType(typeId: 4)
class CustomPlaylistCompilationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime updatedAt;
  @HiveField(5)
  final String createrId;
  @HiveField(6)
  final String creatorName;
  @HiveField(7)
  final int likeCount;
  @HiveField(8)
  final bool isShared;
  @HiveField(9)
  final List<String> hashtags;
  CustomPlaylistCompilationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.createrId,
    required this.creatorName,
    required this.likeCount,
    required this.isShared,
    required this.hashtags,
  });

  CustomPlaylistCompilationModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createrId,
    String? creatorName,
    int? likeCount,
    bool? isShared,
    List<String>? hashtags,
  }) {
    return CustomPlaylistCompilationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createrId: createrId ?? this.createrId,
      creatorName: creatorName ?? this.creatorName,
      likeCount: likeCount ?? this.likeCount,
      isShared: isShared ?? this.isShared,
      hashtags: hashtags ?? this.hashtags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createrId': createrId,
      'creatorName': creatorName,
      'likeCount': likeCount,
      'isShared': isShared,
      'hashtags': hashtags,
    };
  }

  factory CustomPlaylistCompilationModel.fromMap(Map<String, dynamic> map) {
    return CustomPlaylistCompilationModel(
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
        likeCount: map['likeCount'] ?? 0,
        isShared: map['isShared'] ?? false,
        hashtags: List<String>.from(
          (map['hashtags'] ?? []),
        ));
  }

  String toJson() => json.encode(toMap());

  factory CustomPlaylistCompilationModel.fromJson(String source) =>
      CustomPlaylistCompilationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomPlaylistCompilationModel(id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, createrId: $createrId, creatorName: $creatorName, likeCount: $likeCount, isShared: $isShared, hashtags: $hashtags)';
  }

  @override
  bool operator ==(covariant CustomPlaylistCompilationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createrId == createrId &&
        other.creatorName == creatorName &&
        other.likeCount == likeCount &&
        other.isShared == isShared &&
        listEquals(other.hashtags, hashtags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        createrId.hashCode ^
        creatorName.hashCode ^
        likeCount.hashCode ^
        isShared.hashCode ^
        hashtags.hashCode;
  }
}
