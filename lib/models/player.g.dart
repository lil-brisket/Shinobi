// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicalNinjaProfessionImpl _$$MedicalNinjaProfessionImplFromJson(
        Map<String, dynamic> json) =>
    _$MedicalNinjaProfessionImpl(
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MedicalNinjaProfessionImplToJson(
        _$MedicalNinjaProfessionImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'xp': instance.xp,
    };

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      village: json['village'] as String,
      ryo: (json['ryo'] as num).toInt(),
      stats: PlayerStats.fromJson(json['stats'] as Map<String, dynamic>),
      jutsuIds: (json['jutsuIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      itemIds: (json['itemIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rank: $enumDecodeNullable(_$PlayerRankEnumMap, json['rank']) ??
          PlayerRank.genin,
      medNinja: json['medNinja'] == null
          ? const MedicalNinjaProfession()
          : MedicalNinjaProfession.fromJson(
              json['medNinja'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'village': instance.village,
      'ryo': instance.ryo,
      'stats': instance.stats,
      'jutsuIds': instance.jutsuIds,
      'itemIds': instance.itemIds,
      'rank': _$PlayerRankEnumMap[instance.rank]!,
      'medNinja': instance.medNinja,
    };

const _$PlayerRankEnumMap = {
  PlayerRank.genin: 'genin',
  PlayerRank.chunin: 'chunin',
  PlayerRank.jonin: 'jonin',
  PlayerRank.anbu: 'anbu',
  PlayerRank.kage: 'kage',
};
