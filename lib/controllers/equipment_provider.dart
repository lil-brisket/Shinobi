import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/equipment.dart';
import '../models/item.dart';
import 'providers.dart';

class ItemStack {
  final String itemId;
  final int qty;
  const ItemStack(this.itemId, this.qty);

  ItemStack copyWith({String? itemId, int? qty}) => ItemStack(itemId ?? this.itemId, qty ?? this.qty);
}

class EquipmentState {
  final Item? head;
  final Item? body;
  final Item? legs;
  final Item? feet;
  final Item? armLeft;
  final Item? armRight;
  final Item? waist; // belt/pouch that defines capacity

  /// Small items stored on the waist for quick use (kunai, shuriken, etc.)
  final List<ItemStack> waistSmallItems;

  const EquipmentState({
    this.head,
    this.body,
    this.legs,
    this.feet,
    this.armLeft,
    this.armRight,
    this.waist,
    this.waistSmallItems = const [],
  });

  factory EquipmentState.initial() => const EquipmentState();

  EquipmentState copyWith({
    Item? head,
    Item? body,
    Item? legs,
    Item? feet,
    Item? armLeft,
    Item? armRight,
    Item? waist,
    List<ItemStack>? waistSmallItems,
  }) => EquipmentState(
    head: head ?? this.head,
    body: body ?? this.body,
    legs: legs ?? this.legs,
    feet: feet ?? this.feet,
    armLeft: armLeft ?? this.armLeft,
    armRight: armRight ?? this.armRight,
    waist: waist ?? this.waist,
    waistSmallItems: waistSmallItems ?? this.waistSmallItems,
  );
}

final equipmentProvider = StateNotifierProvider<EquipmentController, EquipmentState>((ref) {
  return EquipmentController(ref);
});

class EquipmentController extends StateNotifier<EquipmentState> {
  final Ref ref;
  EquipmentController(this.ref) : super(EquipmentState.initial());

  /// Utility — what capacity do we currently have on the waist?
  int get currentWaistCapacity => state.waist?.equip?.waistCapacity ?? 0;
  int get currentWaistUsed => state.waistSmallItems.fold(0, (sum, s) => sum + s.qty);

  /// Compute total bonuses across all equipped items
  EquipmentStats totalBonuses() {
    final items = [
      state.head, state.body, state.legs, state.feet, state.armLeft, state.armRight, state.waist
    ].whereType<Item>();
    return items.fold(const EquipmentStats(), (acc, it) => acc + (it.equip?.bonuses ?? const EquipmentStats()));
  }

  bool _slotAcceptsItem(SlotType slot, Item item) {
    final meta = item.equip; 
    if (meta == null) return false;
    return meta.allowedSlots.contains(slot);
  }

  /// Try to equip [item] into [preferredSlot] (optional). Handles 2‑handed.
  /// Returns true if equipped.
  bool equip(Item item, {SlotType? preferredSlot}) {
    if (item.equip == null) return false;

    // Find a valid slot if none provided
    final Set<SlotType> targets = preferredSlot != null
        ? {preferredSlot}
        : item.equip!.allowedSlots;

    for (final slot in targets) {
      if (!_slotAcceptsItem(slot, item)) continue;
      switch (slot) {
        case SlotType.head:
          state = state.copyWith(head: item); 
          return true;
        case SlotType.body:
          state = state.copyWith(body: item); 
          return true;
        case SlotType.legs:
          state = state.copyWith(legs: item); 
          return true;
        case SlotType.feet:
          state = state.copyWith(feet: item); 
          return true;
        case SlotType.waist:
          // Equipping a new belt wipes stored small items if capacity shrinks
          final cap = item.equip!.waistCapacity;
          final trimmed = List<ItemStack>.from(state.waistSmallItems);
          final used = trimmed.fold(0, (s, it) => s + it.qty);
          if (used > cap) {
            // drop extras back to inventory
            final overflow = used - cap;
            _returnSmallItemsToInventory(overflow);
          }
          state = state.copyWith(waist: item);
          return true;
        case SlotType.armLeft:
        case SlotType.armRight:
          final twoH = item.equip!.twoHanded;
          if (twoH) {
            state = state.copyWith(armLeft: item, armRight: item); 
            return true;
          } else {
            // Prefer empty hand
            if (slot == SlotType.armLeft) {
              state = state.copyWith(armLeft: item); 
              return true;
            } else {
              state = state.copyWith(armRight: item); 
              return true;
            }
          }
      }
    }
    return false;
  }

  /// Unequip a single slot. Returns the item that was removed.
  Item? unequip(SlotType slot) {
    Item? removed;
    switch (slot) {
      case SlotType.head: 
        removed = state.head; 
        state = state.copyWith(head: null); 
        break;
      case SlotType.body: 
        removed = state.body; 
        state = state.copyWith(body: null); 
        break;
      case SlotType.legs: 
        removed = state.legs; 
        state = state.copyWith(legs: null); 
        break;
      case SlotType.feet: 
        removed = state.feet; 
        state = state.copyWith(feet: null); 
        break;
      case SlotType.waist:
        removed = state.waist; 
        state = state.copyWith(waist: null, waistSmallItems: []); 
        break;
      case SlotType.armLeft:
        removed = state.armLeft; 
        state = state.copyWith(armLeft: null);
        // If 2H, clear both
        if (state.armRight?.id == removed?.id && removed?.equip?.twoHanded == true) {
          state = state.copyWith(armRight: null);
        }
        break;
      case SlotType.armRight:
        removed = state.armRight; 
        state = state.copyWith(armRight: null);
        if (state.armLeft?.id == removed?.id && removed?.equip?.twoHanded == true) {
          state = state.copyWith(armLeft: null);
        }
        break;
    }
    if (removed != null) {
      _returnItemToInventory(removed);
    }
    return removed;
  }

  /// Add small items (kunai/shuriken) to the waist quick‑slots
  bool addToWaist(String itemId, {int qty = 1}) {
    final inv = ref.read(inventoryProvider);
    final item = inv.firstWhere((i) => i.id == itemId, orElse: () => const Item(
      id: '', name: '', description: '', icon: '', quantity: 0, rarity: ItemRarity.common
    ));
    if (item.id.isEmpty) return false;
    if (item.size != ItemSize.small) return false;
    if (currentWaistCapacity == 0) return false; // no belt equipped

    final space = currentWaistCapacity - currentWaistUsed;
    if (space <= 0) return false;

    final toAdd = qty.clamp(0, space);
    if (toAdd == 0) return false;

    // remove from inventory
    _decrementInventory(itemId, toAdd);

    // add to waist list
    final list = List<ItemStack>.from(state.waistSmallItems);
    final idx = list.indexWhere((s) => s.itemId == itemId);
    if (idx == -1) {
      list.add(ItemStack(itemId, toAdd));
    } else {
      list[idx] = list[idx].copyWith(qty: list[idx].qty + toAdd);
    }

    state = state.copyWith(waistSmallItems: list);
    return true;
  }

  /// Remove small items from waist back to inventory
  void removeFromWaist(String itemId, {int qty = 1}) {
    final list = List<ItemStack>.from(state.waistSmallItems);
    final idx = list.indexWhere((s) => s.itemId == itemId);
    if (idx == -1) return;

    final take = qty.clamp(0, list[idx].qty);
    list[idx] = list[idx].copyWith(qty: list[idx].qty - take);
    if (list[idx].qty == 0) list.removeAt(idx);

    // return to inventory
    _incrementInventory(itemId, take);
    state = state.copyWith(waistSmallItems: list);
  }

  // ————— helpers that touch your inventoryProvider —————
  void _returnItemToInventory(Item item) {
    _incrementInventory(item.id, 1);
  }

  void _returnSmallItemsToInventory(int overflow) {
    // move from tail until overflow satisfied
    var remain = overflow;
    final list = List<ItemStack>.from(state.waistSmallItems);
    while (remain > 0 && list.isNotEmpty) {
      final last = list.removeLast();
      final giveBack = (last.qty <= remain) ? last.qty : remain;
      _incrementInventory(last.itemId, giveBack);
      remain -= giveBack;
      final leftover = last.qty - giveBack;
      if (leftover > 0) list.add(ItemStack(last.itemId, leftover));
    }
    state = state.copyWith(waistSmallItems: list);
  }

  void _incrementInventory(String itemId, int qty) {
    final inv = List<Item>.from(ref.read(inventoryProvider));
    final idx = inv.indexWhere((i) => i.id == itemId);
    if (idx == -1) {
      return; // or create stack if needed
    }
    inv[idx] = inv[idx].copyWith(quantity: inv[idx].quantity + qty);
    ref.read(inventoryProvider.notifier).state = inv;
  }

  void _decrementInventory(String itemId, int qty) {
    final inv = List<Item>.from(ref.read(inventoryProvider));
    final idx = inv.indexWhere((i) => i.id == itemId);
    if (idx == -1) {
      return;
    }
    final newQty = (inv[idx].quantity - qty).clamp(0, 1<<30);
    inv[idx] = inv[idx].copyWith(quantity: newQty);
    ref.read(inventoryProvider.notifier).state = inv;
  }
}
