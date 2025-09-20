import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

/// Slots you requested
enum SlotType { head, body, legs, feet, armLeft, armRight, waist }

/// Type of item (keeps your existing consumables etc.)
enum ItemKind { consumable, equipment, material, jutsu, quest }

/// Optional size classification for quick‑access storage (waist)
enum ItemSize { small, normal, large }

/// Flat stat bonuses provided by an item when equipped
@freezed
class EquipmentStats with _$EquipmentStats {
  const factory EquipmentStats({
    @Default(0) int str, // Strength
    @Default(0) int intel, // Intelligence
    @Default(0) int spd, // Speed
    @Default(0) int wil, // Willpower
    @Default(0) int nin, // Ninjutsu
    @Default(0) int gen, // Genjutsu
    @Default(0) int buki, // Bukijutsu
    @Default(0) int tai, // Taijutsu
    @Default(0) int hp, // extra HP max
    @Default(0) int sp, // extra Stamina max
    @Default(0) int cp, // extra Chakra max
  }) = _EquipmentStats;

  factory EquipmentStats.fromJson(Map<String, dynamic> json) => _$EquipmentStatsFromJson(json);
}

extension EquipmentStatsExtension on EquipmentStats {
  EquipmentStats operator +(EquipmentStats other) => EquipmentStats(
    str: str + other.str,
    intel: intel + other.intel,
    spd: spd + other.spd,
    wil: wil + other.wil,
    nin: nin + other.nin,
    gen: gen + other.gen,
    buki: buki + other.buki,
    tai: tai + other.tai,
    hp: hp + other.hp,
    sp: sp + other.sp,
    cp: cp + other.cp,
  );
}

/// Extra metadata for equippable items
@freezed
class EquippableMeta with _$EquippableMeta {
  const factory EquippableMeta({
    required Set<SlotType> allowedSlots, // Which slots this item can go into
    @Default(false) bool twoHanded, // If true and equipped in one arm, occupies both hands
    @Default(EquipmentStats()) EquipmentStats bonuses, // Stat bonuses granted while equipped
    @Default(0) int waistCapacity, // If this item is worn in WAIST, how many **small** items can be stored
    @Default(ItemSize.normal) ItemSize size, // Optional size classification
  }) = _EquippableMeta;

  factory EquippableMeta.fromJson(Map<String, dynamic> json) => _$EquippableMetaFromJson(json);
}

/// A minimal item interface your existing Item can conform to.
/// If you already have Item, just ADD these fields on it.
abstract class EquippableItem {
  String get id;
  String get name;
  ItemKind get kind; // equipment / consumable / etc.
  EquippableMeta? get equip; // null if not equippable
  int get quantity; // stack size for inventory
}
