// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainableStatImpl _$$TrainableStatImplFromJson(Map<String, dynamic> json) =>
    _$TrainableStatImpl(
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TrainableStatImplToJson(_$TrainableStatImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'xp': instance.xp,
    };

_$PlayerStatsImpl _$$PlayerStatsImplFromJson(Map<String, dynamic> json) =>
    _$PlayerStatsImpl(
      level: (json['level'] as num).toInt(),
      str: json['str'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['str'] as Map<String, dynamic>),
      intl: json['intl'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['intl'] as Map<String, dynamic>),
      spd: json['spd'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['spd'] as Map<String, dynamic>),
      wil: json['wil'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['wil'] as Map<String, dynamic>),
      nin: json['nin'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['nin'] as Map<String, dynamic>),
      gen: json['gen'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['gen'] as Map<String, dynamic>),
      buk: json['buk'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['buk'] as Map<String, dynamic>),
      tai: json['tai'] == null
          ? const TrainableStat()
          : TrainableStat.fromJson(json['tai'] as Map<String, dynamic>),
      currentHP: (json['currentHP'] as num?)?.toInt(),
      currentSP: (json['currentSP'] as num?)?.toInt(),
      currentCP: (json['currentCP'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlayerStatsImplToJson(_$PlayerStatsImpl instance) =>
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
