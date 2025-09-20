class Village {
  final String id;
  final String name;
  final String emblem;
  final int tileX;
  final int tileY;
  final String description;

  const Village({
    required this.id,
    required this.name,
    required this.emblem,
    required this.tileX,
    required this.tileY,
    required this.description,
  });

  Village copyWith({
    String? id,
    String? name,
    String? emblem,
    int? tileX,
    int? tileY,
    String? description,
  }) {
    return Village(
      id: id ?? this.id,
      name: name ?? this.name,
      emblem: emblem ?? this.emblem,
      tileX: tileX ?? this.tileX,
      tileY: tileY ?? this.tileY,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emblem': emblem,
      'tileX': tileX,
      'tileY': tileY,
      'description': description,
    };
  }

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      emblem: json['emblem'] ?? '',
      tileX: json['tileX'] ?? 0,
      tileY: json['tileY'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}
