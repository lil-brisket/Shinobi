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
