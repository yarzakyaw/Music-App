import 'dart:convert';

class DhammaCategoryModel {
  final String id;
  final String name;
  DhammaCategoryModel({
    required this.id,
    required this.name,
  });

  DhammaCategoryModel copyWith({
    String? id,
    String? name,
  }) {
    return DhammaCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory DhammaCategoryModel.fromMap(Map<String, dynamic> map) {
    return DhammaCategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DhammaCategoryModel.fromJson(String source) =>
      DhammaCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DhammaCategoryModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant DhammaCategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
