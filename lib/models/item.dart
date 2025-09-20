import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

enum ItemRarity {
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
class Item with _$Item {
  const factory Item({
    required String id,
    required String name,
    required String description,
    required String icon,
    required int quantity,
    required ItemRarity rarity,
    @Default({}) Map<String, dynamic> effect,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}