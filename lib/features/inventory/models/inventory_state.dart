import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/item.dart';
import '../../../models/jutsu.dart';
import '../../../models/equipment.dart';

part 'inventory_state.freezed.dart';

/// Inventory state model for the inventory feature
@freezed
class InventoryState with _$InventoryState {
  const factory InventoryState({
    @Default([]) List<Item> items,
    @Default([]) List<Jutsu> jutsus,
    @Default(false) bool isLoading,
    String? error,
  }) = _InventoryState;
}

/// Inventory filter options
@freezed
class InventoryFilter with _$InventoryFilter {
  const factory InventoryFilter({
    @Default(ItemKind.all) ItemKind kind,
    @Default(ItemRarity.all) ItemRarity rarity,
    @Default('') String searchQuery,
    @Default(false) bool showEquippedOnly,
  }) = _InventoryFilter;
}

/// Inventory sort options
enum InventorySortBy {
  name,
  rarity,
  quantity,
  dateAdded,
}

/// Inventory sort order
enum InventorySortOrder {
  ascending,
  descending,
}
