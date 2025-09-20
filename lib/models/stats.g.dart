// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatsImpl _$$StatsImplFromJson(Map<String, dynamic> json) => _$StatsImpl(
      hp: (json['hp'] as num).toInt(),
      maxHp: (json['maxHp'] as num).toInt(),
      chakra: (json['chakra'] as num).toInt(),
      maxChakra: (json['maxChakra'] as num).toInt(),
      stamina: (json['stamina'] as num).toInt(),
      maxStamina: (json['maxStamina'] as num).toInt(),
      attack: (json['attack'] as num).toInt(),
      defense: (json['defense'] as num).toInt(),
      speed: (json['speed'] as num).toInt(),
    );

Map<String, dynamic> _$$StatsImplToJson(_$StatsImpl instance) =>
    <String, dynamic>{
      'hp': instance.hp,
      'maxHp': instance.maxHp,
      'chakra': instance.chakra,
      'maxChakra': instance.maxChakra,
      'stamina': instance.stamina,
      'maxStamina': instance.maxStamina,
      'attack': instance.attack,
      'defense': instance.defense,
      'speed': instance.speed,
    };
