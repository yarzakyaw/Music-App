import 'dart:convert';

import 'package:hive/hive.dart';

part 'bhikkhu_model.g.dart';

@HiveType(typeId: 2)
class BhikkhuModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nameENG;
  @HiveField(2)
  final String nameMM;
  @HiveField(3)
  final String alias;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String profileImageUrl;
  @HiveField(6)
  final String ownerId;
  @HiveField(7)
  final int totalPlayCount;
  @HiveField(8)
  final int totalLikes;
  @HiveField(9)
  final int totalShare;
  @HiveField(10)
  final int totalDownloads;
  @HiveField(11)
  final int totalFollowers;
  @HiveField(12)
  final int totalFollowing;
  @HiveField(13)
  final int vault;
  BhikkhuModel({
    required this.id,
    required this.nameENG,
    required this.nameMM,
    required this.alias,
    required this.title,
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

  BhikkhuModel copyWith({
    String? id,
    String? nameENG,
    String? nameMM,
    String? alias,
    String? title,
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
    return BhikkhuModel(
      id: id ?? this.id,
      nameENG: nameENG ?? this.nameENG,
      nameMM: nameMM ?? this.nameMM,
      alias: alias ?? this.alias,
      title: title ?? this.title,
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
      'alias': alias,
      'title': title,
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

  factory BhikkhuModel.fromMap(Map<String, dynamic> map) {
    return BhikkhuModel(
      id: map['id'] ?? '',
      nameENG: map['nameENG'] ?? '',
      nameMM: map['nameMM'] ?? '',
      alias: map['alias'] ?? '',
      title: map['title'] ?? '',
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

  factory BhikkhuModel.fromJson(String source) =>
      BhikkhuModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BhikkhuModel(id: $id, nameENG: $nameENG, nameMM: $nameMM, alias: $alias, title: $title, profileImageUrl: $profileImageUrl, totalFollowers: $totalFollowers, totalFillowing: $totalFollowing, ownerId: $ownerId, totalPlayCount: $totalPlayCount, totalLikes: $totalLikes, totalShare: $totalShare, totalDownloads: $totalDownloads, vault: $vault)';
  }

  @override
  bool operator ==(covariant BhikkhuModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nameENG == nameENG &&
        other.nameMM == nameMM &&
        other.alias == alias &&
        other.title == title &&
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
        alias.hashCode ^
        title.hashCode ^
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
