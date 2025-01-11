// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'artist_model.g.dart';

@HiveType(typeId: 1)
class ArtistModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nameENG;
  @HiveField(2)
  final String nameMM;
  @HiveField(3)
  final String profileImageUrl;
  @HiveField(4)
  final String ownerId;
  @HiveField(5)
  final int totalPlayCount;
  @HiveField(6)
  final int totalLikes;
  @HiveField(7)
  final int totalShare;
  @HiveField(8)
  final int totalDownloads;
  @HiveField(9)
  final int totalFollowers;
  @HiveField(10)
  final int totalFollowing;
  @HiveField(11)
  final int vault;
  ArtistModel({
    required this.id,
    required this.nameENG,
    required this.nameMM,
    required this.profileImageUrl,
    required this.ownerId,
    required this.totalPlayCount,
    required this.totalLikes,
    required this.totalShare,
    required this.totalDownloads,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.vault,
  });

  ArtistModel copyWith({
    String? id,
    String? nameENG,
    String? nameMM,
    String? profileImageUrl,
    String? ownerId,
    int? totalPlayCount,
    int? totalLikes,
    int? totalShare,
    int? totalDownloads,
    int? totalFollowers,
    int? totalFollowing,
    int? vault,
  }) {
    return ArtistModel(
      id: id ?? this.id,
      nameENG: nameENG ?? this.nameENG,
      nameMM: nameMM ?? this.nameMM,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      ownerId: ownerId ?? this.ownerId,
      totalPlayCount: totalPlayCount ?? this.totalPlayCount,
      totalLikes: totalLikes ?? this.totalLikes,
      totalShare: totalShare ?? this.totalShare,
      totalDownloads: totalDownloads ?? this.totalDownloads,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      vault: vault ?? this.vault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameENG': nameENG,
      'nameMM': nameMM,
      'profileImageUrl': profileImageUrl,
      'ownerId': ownerId,
      'totalPlayCount': totalPlayCount,
      'totalLikes': totalLikes,
      'totalShare': totalShare,
      'totalDownloads': totalDownloads,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'vault': vault,
    };
  }

  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(
      id: map['id'] ?? '',
      nameENG: map['nameENG'] ?? '',
      nameMM: map['nameMM'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
      totalPlayCount: map['totalPlayCount'] ?? 0,
      totalLikes: map['totalLikes'] ?? 0,
      totalShare: map['totalShare'] ?? 0,
      totalDownloads: map['totalDownloads'] ?? 0,
      totalFollowers: map['totalFollowers'] ?? 0,
      totalFollowing: map['totalFollowing'] ?? 0,
      vault: map['vault'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistModel.fromJson(String source) =>
      ArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistModel(id: $id, nameENG: $nameENG, nameMM: $nameMM, profileImageUrl: $profileImageUrl, ownerId: $ownerId, totalPlayCount: $totalPlayCount, totalLikes: $totalLikes, totalShare: $totalShare, totalDownloads: $totalDownloads, totalFollowers: $totalFollowers, totalFollowing: $totalFollowing, vault: $vault)';
  }

  @override
  bool operator ==(covariant ArtistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nameENG == nameENG &&
        other.nameMM == nameMM &&
        other.profileImageUrl == profileImageUrl &&
        other.ownerId == ownerId &&
        other.totalPlayCount == totalPlayCount &&
        other.totalLikes == totalLikes &&
        other.totalShare == totalShare &&
        other.totalDownloads == totalDownloads &&
        other.totalFollowers == totalFollowers &&
        other.totalFollowing == totalFollowing &&
        other.vault == vault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameENG.hashCode ^
        nameMM.hashCode ^
        profileImageUrl.hashCode ^
        ownerId.hashCode ^
        totalPlayCount.hashCode ^
        totalLikes.hashCode ^
        totalShare.hashCode ^
        totalDownloads.hashCode ^
        totalFollowers.hashCode ^
        totalFollowing.hashCode ^
        vault.hashCode;
  }
}
