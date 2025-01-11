import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  final String accountType;
  final DateTime createdAt;
  final String email;
  final String name;
  final String ownedAccountId;
  final bool ownedAccountIsIn;
  final int totalFollowing;
  final String userId;
  final int vault;

  UserInfoModel({
    required this.accountType,
    required this.createdAt,
    required this.email,
    required this.name,
    required this.ownedAccountId,
    required this.ownedAccountIsIn,
    required this.totalFollowing,
    required this.userId,
    required this.vault,
  });

  UserInfoModel copyWith({
    String? accountType,
    DateTime? createdAt,
    String? email,
    String? name,
    String? ownedAccountId,
    bool? ownedAccountIsIn,
    int? totalFollowing,
    String? userId,
    int? vault,
  }) {
    return UserInfoModel(
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      name: name ?? this.name,
      ownedAccountId: ownedAccountId ?? this.ownedAccountId,
      ownedAccountIsIn: ownedAccountIsIn ?? this.ownedAccountIsIn,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      userId: userId ?? this.userId,
      vault: vault ?? this.vault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountType': accountType,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'email': email,
      'name': name,
      'ownedAccountId': ownedAccountId,
      'ownedAccountIsIn': ownedAccountIsIn,
      'totalFollowing': totalFollowing,
      'userId': userId,
      'vault': vault,
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      accountType: map['accountType'] as String,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      email: map['email'] as String,
      name: map['name'] as String,
      ownedAccountId: map['ownedAccountId'] as String,
      ownedAccountIsIn: map['ownedAccountIsIn'] as bool,
      totalFollowing: map['totalFollowing'] as int,
      userId: map['userId'] as String,
      vault: map['vault'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoModel.fromJson(String source) =>
      UserInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfoModel(accountType: $accountType, createdAt: $createdAt, email: $email, name: $name, ownedAccountId: $ownedAccountId, ownedAccountIsIn: $ownedAccountIsIn, totalFollowing: $totalFollowing, userId: $userId, vault: $vault)';
  }

  @override
  bool operator ==(covariant UserInfoModel other) {
    if (identical(this, other)) return true;

    return other.accountType == accountType &&
        other.createdAt == createdAt &&
        other.email == email &&
        other.name == name &&
        other.ownedAccountId == ownedAccountId &&
        other.ownedAccountIsIn == ownedAccountIsIn &&
        other.totalFollowing == totalFollowing &&
        other.userId == userId &&
        other.vault == vault;
  }

  @override
  int get hashCode {
    return accountType.hashCode ^
        createdAt.hashCode ^
        email.hashCode ^
        name.hashCode ^
        ownedAccountId.hashCode ^
        ownedAccountIsIn.hashCode ^
        totalFollowing.hashCode ^
        userId.hashCode ^
        vault.hashCode;
  }
}
