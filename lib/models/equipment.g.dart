// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentStatsImpl _$$EquipmentStatsImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentStatsImpl(
      str: (json['str'] as num?)?.toInt() ?? 0,
      intel: (json['intel'] as num?)?.toInt() ?? 0,
      spd: (json['spd'] as num?)?.toInt() ?? 0,
      wil: (json['wil'] as num?)?.toInt() ?? 0,
      nin: (json['nin'] as num?)?.toInt() ?? 0,
      gen: (json['gen'] as num?)?.toInt() ?? 0,
      buki: (json['buki'] as num?)?.toInt() ?? 0,
      tai: (json['tai'] as num?)?.toInt() ?? 0,
      hp: (json['hp'] as num?)?.toInt() ?? 0,
      sp: (json['sp'] as num?)?.toInt() ?? 0,
      cp: (json['cp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EquipmentStatsImplToJson(
        _$EquipmentStatsImpl instance) =>
    <String, dynamic>{
      'str': instance.str,
      'intel': instance.intel,
      'spd': instance.spd,
      'wil': instance.wil,
      'nin': instance.nin,
      'gen': instance.gen,
      'buki': instance.buki,
      'tai': instance.tai,
      'hp': instance.hp,
      'sp': instance.sp,
      'cp': instance.cp,
    };

_$EquippableMetaImpl _$$EquippableMetaImplFromJson(Map<String, dynamic> json) =>
    _$EquippableMetaImpl(
      allowedSlots: (json['allowedSlots'] as List<dynamic>)
          .map((e) => $enumDecode(_$SlotTypeEnumMap, e))
          .toSet(),
      twoHanded: json['twoHanded'] as bool? ?? false,
      bonuses: json['bonuses'] == null
          ? const EquipmentStats()
          : EquipmentStats.fromJson(json['bonuses'] as Map<String, dynamic>),
      waistCapacity: (json['waistCapacity'] as num?)?.toInt() ?? 0,
      size: $enumDecodeNullable(_$ItemSizeEnumMap, json['size']) ??
          ItemSize.normal,
    );

Map<String, dynamic> _$$EquippableMetaImplToJson(
        _$EquippableMetaImpl instance) =>
    <String, dynamic>{
      'allowedSlots':
          instance.allowedSlots.map((e) => _$SlotTypeEnumMap[e]!).toList(),
      'twoHanded': instance.twoHanded,
      'bonuses': instance.bonuses,
      'waistCapacity': instance.waistCapacity,
      'size': _$ItemSizeEnumMap[instance.size]!,
    };

const _$SlotTypeEnumMap = {
  SlotType.head: 'head',
  SlotType.body: 'body',
  SlotType.legs: 'legs',
  SlotType.feet: 'feet',
  SlotType.armLeft: 'armLeft',
  SlotType.armRight: 'armRight',
  SlotType.waist: 'waist',
};

const _$ItemSizeEnumMap = {
  ItemSize.small: 'small',
  ItemSize.normal: 'normal',
  ItemSize.large: 'large',
};
