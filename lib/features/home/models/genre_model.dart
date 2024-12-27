import 'dart:convert';

class GenreModel {
  final String id;
  final String name;
  GenreModel({
    required this.id,
    required this.name,
  });

  GenreModel copyWith({
    String? id,
    String? name,
  }) {
    return GenreModel(
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

  factory GenreModel.fromMap(Map<String, dynamic> map) {
    return GenreModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GenreModel.fromJson(String source) =>
      GenreModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GenreModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant GenreModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
