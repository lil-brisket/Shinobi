// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerDtoImpl _$$PlayerDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlayerDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      village: json['village'] as String,
      ryo: (json['ryo'] as num).toInt(),
      stats: PlayerStatsDto.fromJson(json['stats'] as Map<String, dynamic>),
      jutsuIds:
          (json['jutsuIds'] as List<dynamic>).map((e) => e as String).toList(),
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      rank: json['rank'] as String,
    );

Map<String, dynamic> _$$PlayerDtoImplToJson(_$PlayerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'village': instance.village,
      'ryo': instance.ryo,
      'stats': instance.stats,
      'jutsuIds': instance.jutsuIds,
      'itemIds': instance.itemIds,
      'rank': instance.rank,
    };

_$PlayerStatsDtoImpl _$$PlayerStatsDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlayerStatsDtoImpl(
      level: (json['level'] as num).toInt(),
      str: (json['str'] as num?)?.toInt() ?? 0,
      intl: (json['intl'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      wil: (json['wil'] as num?)?.toInt() ?? 0,
      nin: (json['nin'] as num?)?.toInt() ?? 0,
      gen: (json['gen'] as num?)?.toInt() ?? 0,
      buk: (json['buk'] as num?)?.toInt() ?? 0,
      tai: (json['tai'] as num?)?.toInt() ?? 0,
      currentHP: (json['currentHP'] as num?)?.toInt(),
      currentSP: (json['currentSP'] as num?)?.toInt(),
      currentCP: (json['currentCP'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlayerStatsDtoImplToJson(
        _$PlayerStatsDtoImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'str': instance.str,
      'intl': instance.intl,
      'spd': instance.spd,
      'wil': instance.wil,
      'nin': instance.nin,
      'gen': instance.gen,
      'buk': instance.buk,
      'tai': instance.tai,
      'currentHP': instance.currentHP,
      'currentSP': instance.currentSP,
      'currentCP': instance.currentCP,
    };

_$ItemDtoImpl _$$ItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$ItemDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      quantity: (json['quantity'] as num).toInt(),
      rarity: json['rarity'] as String,
      effect: json['effect'] as Map<String, dynamic>,
      kind: json['kind'] as String,
      size: json['size'] as String?,
      equip: json['equip'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ItemDtoImplToJson(_$ItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'quantity': instance.quantity,
      'rarity': instance.rarity,
      'effect': instance.effect,
      'kind': instance.kind,
      'size': instance.size,
      'equip': instance.equip,
    };

_$JutsuDtoImpl _$$JutsuDtoImplFromJson(Map<String, dynamic> json) =>
    _$JutsuDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      chakraCost: (json['chakraCost'] as num).toInt(),
      power: (json['power'] as num).toInt(),
      description: json['description'] as String,
      isEquipped: json['isEquipped'] as bool,
      range: (json['range'] as num).toInt(),
      targeting: json['targeting'] as String,
      apCost: (json['apCost'] as num).toInt(),
      areaRadius: (json['areaRadius'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$JutsuDtoImplToJson(_$JutsuDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'chakraCost': instance.chakraCost,
      'power': instance.power,
      'description': instance.description,
      'isEquipped': instance.isEquipped,
      'range': instance.range,
      'targeting': instance.targeting,
      'apCost': instance.apCost,
      'areaRadius': instance.areaRadius,
    };
