import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/battle_history.dart';

part 'combat_state.freezed.dart';

/// Combat state model for the combat feature
@freezed
class CombatState with _$CombatState {
  const factory CombatState({
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<BattleHistoryEntry> battleHistory,
  }) = _CombatState;
}

// All battle-related classes (BattleConfig, BattleEntity, BattlePosition, etc.) 
// are now imported from battle_models.dart