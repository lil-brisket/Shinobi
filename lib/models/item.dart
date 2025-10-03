import 'package:freezed_annotation/freezed_annotation.dart';
import 'equipment.dart';

part 'item.freezed.dart';
part 'item.g.dart';

enum ItemRarity {
  @JsonValue('all')
  all,
  @JsonValue('common')
  common,
  @JsonValue('uncommon')
  uncommon,
  @JsonValue('rare')
  rare,
  @JsonValue('epic')
  epic,
  @JsonValue('legendary')
  legendary,
}

@freezed
class Item with _$Item implements EquippableItem {
  const factory Item({
    required String id,
    required String name,
    required String description,
    required String icon,
    required int quantity,
    required ItemRarity rarity,
    @Default({}) Map<String, dynamic> effect,
    @Default(ItemKind.consumable) ItemKind kind,
    EquippableMeta? equip,
    @Default(ItemSize.normal) ItemSize size,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

extension ItemEquippable on Item {
  bool get isEquippable => kind == ItemKind.equipment && equip != null;
}