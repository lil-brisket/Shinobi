import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stats.dart';
import '../models/equipment.dart';
import 'equipment_provider.dart';
import 'providers.dart';

/// Combine base player stats with equipment bonuses for display/combat
final effectiveStatsProvider = Provider<PlayerStats>((ref) {
  final base = ref.watch(playerProvider).stats;
  final eqBonus = ref.watch(equipmentProvider.notifier).totalBonuses();
  
  return base.copyWith(
    // Update current resource values with equipment bonuses
    currentHP: (base.hp + eqBonus.hp).clamp(0, base.maxHP + eqBonus.hp),
    currentSP: (base.sp + eqBonus.sp).clamp(0, base.maxSP + eqBonus.sp),
    currentCP: (base.cp + eqBonus.cp).clamp(0, base.maxCP + eqBonus.cp),
  );
});

/// Provider for equipment stat bonuses display
final equipmentBonusesProvider = Provider<EquipmentStats>((ref) {
  return ref.watch(equipmentProvider.notifier).totalBonuses();
});

/// Provider for individual stat bonuses (useful for UI display)
final statBonusProvider = Provider.family<int, String>((ref, statName) {
  final bonuses = ref.watch(equipmentBonusesProvider);
  switch (statName) {
    case 'str': return bonuses.str;
    case 'intel': return bonuses.intel;
    case 'spd': return bonuses.spd;
    case 'wil': return bonuses.wil;
    case 'nin': return bonuses.nin;
    case 'gen': return bonuses.gen;
    case 'buki': return bonuses.buki;
    case 'tai': return bonuses.tai;
    case 'hp': return bonuses.hp;
    case 'sp': return bonuses.sp;
    case 'cp': return bonuses.cp;
    default: return 0;
  }
});
