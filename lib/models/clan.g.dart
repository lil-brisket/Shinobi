// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClanImpl _$$ClanImplFromJson(Map<String, dynamic> json) => _$ClanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      villageId: json['villageId'] as String,
      leaderId: json['leaderId'] as String,
      emblemUrl: json['emblemUrl'] as String?,
      description: json['description'] as String?,
      score: (json['score'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ClanImplToJson(_$ClanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'villageId': instance.villageId,
      'leaderId': instance.leaderId,
      'emblemUrl': instance.emblemUrl,
      'description': instance.description,
      'score': instance.score,
      'wins': instance.wins,
      'losses': instance.losses,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ClanWithDetailsImpl _$$ClanWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$ClanWithDetailsImpl(
      clan: Clan.fromJson(json['clan'] as Map<String, dynamic>),
      leaderName: json['leaderName'] as String,
      memberCount: (json['memberCount'] as num).toInt(),
      advisorCount: (json['advisorCount'] as num).toInt(),
    );

Map<String, dynamic> _$$ClanWithDetailsImplToJson(
        _$ClanWithDetailsImpl instance) =>
    <String, dynamic>{
      'clan': instance.clan,
      'leaderName': instance.leaderName,
      'memberCount': instance.memberCount,
      'advisorCount': instance.advisorCount,
    };
