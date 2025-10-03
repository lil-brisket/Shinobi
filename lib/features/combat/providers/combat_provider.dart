import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/failures.dart';
import '../../../models/battle_history.dart';
import '../../battle/battle_models.dart';

/// Combat state model
class CombatState {
  final BattleState? battleState;
  final bool isLoading;
  final Failure? error;
  final List<BattleHistoryEntry> battleHistory;

  const CombatState({
    this.battleState,
    this.isLoading = false,
    this.error,
    this.battleHistory = const [],
  });

  CombatState copyWith({
    BattleState? battleState,
    bool? isLoading,
    Failure? error,
    List<BattleHistoryEntry>? battleHistory,
  }) {
    return CombatState(
      battleState: battleState ?? this.battleState,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      battleHistory: battleHistory ?? this.battleHistory,
    );
  }

  /// Clear error state
  CombatState clearError() {
    return copyWith(error: null);
  }
}

/// Combat provider using repository pattern
final combatProvider = StateNotifierProvider<CombatNotifier, CombatState>((ref) {
  return CombatNotifier();
});

class CombatNotifier extends StateNotifier<CombatState> {
  CombatNotifier() : super(const CombatState());

  /// Start a new battle
  Future<void> startBattle(BattleConfig config) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate battle initialization
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Convert BattleConfig entities to BattleState entities
      final players = config.players.map((entity) => Entity(
        id: entity.id,
        name: entity.name,
        isPlayerControlled: entity.isPlayerControlled,
        pos: entity.pos,
        hp: entity.hp,
        hpMax: entity.hpMax,
        cp: entity.cp,
        cpMax: entity.cpMax,
        sp: entity.sp,
        spMax: entity.spMax,
        ap: entity.ap,
        apMax: entity.apMax,
        str: entity.str,
        spd: entity.spd,
        intStat: entity.intStat,
        wil: entity.wil,
      )).toList();
      
      final enemies = config.enemies.map((entity) => Entity(
        id: entity.id,
        name: entity.name,
        isPlayerControlled: entity.isPlayerControlled,
        pos: entity.pos,
        hp: entity.hp,
        hpMax: entity.hpMax,
        cp: entity.cp,
        cpMax: entity.cpMax,
        sp: entity.sp,
        spMax: entity.spMax,
        ap: entity.ap,
        apMax: entity.apMax,
        str: entity.str,
        spd: entity.spd,
        intStat: entity.intStat,
        wil: entity.wil,
      )).toList();
      
      // Create empty grid
      final tiles = List.generate(config.rows, (row) => 
        List.generate(config.cols, (col) => Tile(
          row: row,
          col: col,
          highlight: TileHighlight.none,
        ))
      );
      
      final battleState = BattleState(
        rows: config.rows,
        cols: config.cols,
        tiles: tiles,
        players: players,
        enemies: enemies,
        turnOrder: [], // Will be calculated
        currentTurnIndex: 0,
        activeEntityId: players.isNotEmpty ? players.first.id : '',
        phase: BattlePhase.selectingAction,
        log: ['Battle started!'],
        rngSeed: config.rngSeed,
      );
      
      state = state.copyWith(
        battleState: battleState,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ServerFailure('Failed to start battle: $e'),
      );
    }
  }

  /// End the current battle
  void endBattle() {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        phase: BattlePhase.ended,
      );
      
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  /// Clear the current battle
  void clearBattle() {
    state = state.copyWith(battleState: null);
  }

  /// Update battle state (for battle controller integration)
  void updateBattleState(BattleState battleState) {
    state = state.copyWith(battleState: battleState);
  }

  /// Add battle to history
  void addBattleToHistory(BattleHistoryEntry battle) {
    final updatedHistory = [...state.battleHistory, battle];
    state = state.copyWith(battleHistory: updatedHistory);
  }

  /// Get battle history
  List<BattleHistoryEntry> getBattleHistory() {
    return state.battleHistory;
  }

  /// Clear error state
  void clearError() {
    state = state.clearError();
  }

  /// Battle control methods for compatibility with battle screen
  void cancelCurrentMode() {
    // Implementation for canceling current battle mode
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        isMoveMode: false,
        isPunchMode: false,
        isHealMode: false,
        isJutsuMode: false,
        selectedJutsuId: null,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void toggleMoveMode() {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        isMoveMode: !state.battleState!.isMoveMode,
        isPunchMode: false,
        isHealMode: false,
        isJutsuMode: false,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void togglePunchMode() {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        isMoveMode: false,
        isPunchMode: !state.battleState!.isPunchMode,
        isHealMode: false,
        isJutsuMode: false,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void toggleHealMode() {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        isMoveMode: false,
        isPunchMode: false,
        isHealMode: !state.battleState!.isHealMode,
        isJutsuMode: false,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void switchToActionMode() {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        isMoveMode: false,
        isPunchMode: false,
        isHealMode: false,
        isJutsuMode: false,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void actFlee() {
    // Implementation for flee action
    if (state.battleState != null) {
      // Add flee logic here
      final updatedBattleState = state.battleState!.copyWith(
        phase: BattlePhase.ended,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }

  void selectJutsu(String jutsuId) {
    if (state.battleState != null) {
      final updatedBattleState = state.battleState!.copyWith(
        selectedJutsuId: jutsuId,
        isJutsuMode: true,
        isMoveMode: false,
        isPunchMode: false,
        isHealMode: false,
      );
      state = state.copyWith(battleState: updatedBattleState);
    }
  }
}

/// Provider for current battle state
final currentBattleProvider = Provider<BattleState?>((ref) {
  final combatState = ref.watch(combatProvider);
  return combatState.battleState;
});

/// Provider for battle history
final battleHistoryProvider = Provider<List<BattleHistoryEntry>>((ref) {
  final combatState = ref.watch(combatProvider);
  return combatState.battleHistory;
});

/// Provider for battle status
final battleStatusProvider = Provider<BattleStatus>((ref) {
  final combatState = ref.watch(combatProvider);
  
  if (combatState.battleState == null) {
    return BattleStatus.noBattle;
  } else if (combatState.battleState!.isBattleEnded) {
    return BattleStatus.ended;
  } else if (combatState.battleState!.players.isNotEmpty && 
             combatState.battleState!.enemies.isNotEmpty) {
    return BattleStatus.active;
  } else {
    return BattleStatus.noBattle;
  }
});

/// Battle status enum
enum BattleStatus {
  noBattle,
  active,
  ended,
}
