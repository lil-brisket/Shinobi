import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/player_repository.dart';
import '../../../data/failures.dart';
import '../../../models/item.dart';
import '../../../models/jutsu.dart';
import '../../../models/equipment.dart';

/// Inventory state model
class InventoryState {
  final List<Item> items;
  final List<Jutsu> jutsus;
  final bool isLoading;
  final Failure? error;

  const InventoryState({
    this.items = const [],
    this.jutsus = const [],
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<Item>? items,
    List<Jutsu>? jutsus,
    bool? isLoading,
    Failure? error,
  }) {
    return InventoryState(
      items: items ?? this.items,
      jutsus: jutsus ?? this.jutsus,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Clear error state
  InventoryState clearError() {
    return copyWith(error: null);
  }
}

/// Inventory provider using repository pattern
final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final playerRepository = ref.watch(playerRepositoryProvider);
  return InventoryNotifier(playerRepository);
});

class InventoryNotifier extends StateNotifier<InventoryState> {
  InventoryNotifier(this._playerRepository) : super(const InventoryState());

  final PlayerRepository _playerRepository;

  /// Load player's inventory items
  Future<void> loadItems(String playerId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _playerRepository.getPlayerItems(playerId);
      
      if (result.items != null) {
        state = state.copyWith(
          items: result.items!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.failure ?? ServerFailure('Failed to load items'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ServerFailure('Failed to load items: $e'),
      );
    }
  }

  /// Load player's jutsus
  Future<void> loadJutsus(String playerId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _playerRepository.getPlayerJutsus(playerId);
      
      if (result.jutsus != null) {
        state = state.copyWith(
          jutsus: result.jutsus!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.failure ?? ServerFailure('Failed to load jutsus'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ServerFailure('Failed to load jutsus: $e'),
      );
    }
  }

  /// Load both items and jutsus
  Future<void> loadInventory(String playerId) async {
    await Future.wait([
      loadItems(playerId),
      loadJutsus(playerId),
    ]);
  }

  /// Toggle jutsu equipped status
  void toggleJutsuEquipped(String jutsuId) {
    final updatedJutsus = state.jutsus.map((jutsu) {
      if (jutsu.id == jutsuId) {
        return jutsu.copyWith(isEquipped: !jutsu.isEquipped);
      }
      return jutsu;
    }).toList();
    
    state = state.copyWith(jutsus: updatedJutsus);
  }

  /// Get equipped jutsus
  List<Jutsu> get equippedJutsus {
    return state.jutsus.where((jutsu) => jutsu.isEquipped).toList();
  }

  /// Get items by kind
  List<Item> getItemsByKind(ItemKind kind) {
    return state.items.where((item) => item.kind == kind).toList();
  }

  /// Get items by rarity
  List<Item> getItemsByRarity(ItemRarity rarity) {
    return state.items.where((item) => item.rarity == rarity).toList();
  }

  /// Clear error state
  void clearError() {
    state = state.clearError();
  }
}

/// Provider for equipped jutsus only
final equippedJutsusProvider = Provider<List<Jutsu>>((ref) {
  final inventoryState = ref.watch(inventoryProvider);
  return inventoryState.jutsus.where((jutsu) => jutsu.isEquipped).toList();
});

/// Provider for equipment items only
final equipmentItemsProvider = Provider<List<Item>>((ref) {
  final inventoryState = ref.watch(inventoryProvider);
  return inventoryState.items.where((item) => item.kind == ItemKind.equipment).toList();
});

/// Provider for material items only
final materialItemsProvider = Provider<List<Item>>((ref) {
  final inventoryState = ref.watch(inventoryProvider);
  return inventoryState.items.where((item) => item.kind == ItemKind.material).toList();
});
