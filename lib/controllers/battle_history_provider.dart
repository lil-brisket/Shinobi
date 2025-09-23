import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/battle_history.dart';

/// Provider for battle history state
final battleHistoryProvider = FutureProvider<List<BattleHistoryEntry>>((ref) async {
  return await BattleHistoryService.getBattleHistory();
});

/// Provider for battle history refresh trigger
final battleHistoryRefreshProvider = StateProvider<int>((ref) => 0);

/// Provider that combines battle history with refresh trigger
final battleHistoryWithRefreshProvider = FutureProvider<List<BattleHistoryEntry>>((ref) async {
  // Watch the refresh trigger
  ref.watch(battleHistoryRefreshProvider);
  
  return await BattleHistoryService.getBattleHistory();
});

/// Notifier for battle history operations
class BattleHistoryNotifier extends StateNotifier<AsyncValue<List<BattleHistoryEntry>>> {
  BattleHistoryNotifier() : super(const AsyncValue.loading()) {
    _loadBattleHistory();
  }

  Future<void> _loadBattleHistory() async {
    try {
      state = const AsyncValue.loading();
      final history = await BattleHistoryService.getBattleHistory();
      state = AsyncValue.data(history);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadBattleHistory();
  }

  Future<void> clearHistory() async {
    try {
      await BattleHistoryService.clearBattleHistory();
      state = const AsyncValue.data([]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for battle history notifier
final battleHistoryNotifierProvider = StateNotifierProvider<BattleHistoryNotifier, AsyncValue<List<BattleHistoryEntry>>>((ref) {
  return BattleHistoryNotifier();
});
