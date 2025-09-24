// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jutsu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JutsuImpl _$$JutsuImplFromJson(Map<String, dynamic> json) => _$JutsuImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$JutsuTypeEnumMap, json['type']),
      chakraCost: (json['chakraCost'] as num).toInt(),
      power: (json['power'] as num).toInt(),
      description: json['description'] as String,
      isEquipped: json['isEquipped'] as bool? ?? false,
      range: (json['range'] as num?)?.toInt() ?? 1,
      targeting:
          $enumDecodeNullable(_$JutsuTargetingEnumMap, json['targeting']) ??
              JutsuTargeting.singleTarget,
      areaRadius: (json['areaRadius'] as num?)?.toInt() ?? 0,
      apCost: (json['apCost'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$JutsuImplToJson(_$JutsuImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$JutsuTypeEnumMap[instance.type]!,
      'chakraCost': instance.chakraCost,
      'power': instance.power,
      'description': instance.description,
      'isEquipped': instance.isEquipped,
      'range': instance.range,
      'targeting': _$JutsuTargetingEnumMap[instance.targeting]!,
      'areaRadius': instance.areaRadius,
      'apCost': instance.apCost,
    };

const _$JutsuTypeEnumMap = {
  JutsuType.ninjutsu: 'ninjutsu',
  JutsuType.taijutsu: 'taijutsu',
  JutsuType.genjutsu: 'genjutsu',
  JutsuType.kekkeiGenkai: 'kekkeiGenkai',
};

const _$JutsuTargetingEnumMap = {
  JutsuTargeting.straightLine: 'straight_line',
  JutsuTargeting.areaAroundPlayer: 'area_around_player',
  JutsuTargeting.singleTarget: 'single_target',
  JutsuTargeting.movementAbility: 'movement_ability',
};
