// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      quantity: (json['quantity'] as num).toInt(),
      rarity: $enumDecode(_$ItemRarityEnumMap, json['rarity']),
      effect: json['effect'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'quantity': instance.quantity,
      'rarity': _$ItemRarityEnumMap[instance.rarity]!,
      'effect': instance.effect,
    };

const _$ItemRarityEnumMap = {
  ItemRarity.common: 'common',
  ItemRarity.uncommon: 'uncommon',
  ItemRarity.rare: 'rare',
  ItemRarity.epic: 'epic',
  ItemRarity.legendary: 'legendary',
};
