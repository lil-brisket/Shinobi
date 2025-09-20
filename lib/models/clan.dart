class ClanMember {
  final String id;
  final String name;
  final String rank;
  final DateTime joinedAt;

  const ClanMember({
    required this.id,
    required this.name,
    required this.rank,
    required this.joinedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory ClanMember.fromJson(Map<String, dynamic> json) {
    return ClanMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rank: json['rank'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Clan {
  final String id;
  final String name;
  final String description;
  final String rank;
  final List<ClanMember> members;
  final String leaderId;
  final DateTime createdAt;

  const Clan({
    required this.id,
    required this.name,
    required this.description,
    required this.rank,
    required this.members,
    required this.leaderId,
    required this.createdAt,
  });

  Clan copyWith({
    String? id,
    String? name,
    String? description,
    String? rank,
    List<ClanMember>? members,
    String? leaderId,
    DateTime? createdAt,
  }) {
    return Clan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rank: rank ?? this.rank,
      members: members ?? this.members,
      leaderId: leaderId ?? this.leaderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rank': rank,
      'members': members.map((m) => m.toJson()).toList(),
      'leaderId': leaderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rank: json['rank'] ?? '',
      members: (json['members'] as List<dynamic>?)
          ?.map((m) => ClanMember.fromJson(m))
          .toList() ?? [],
      leaderId: json['leaderId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
