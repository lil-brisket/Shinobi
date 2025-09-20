import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

@freezed
class TrainableStat with _$TrainableStat {
  const factory TrainableStat({
    @Default(1) int level,
    @Default(0) int xp,
  }) = _TrainableStat;

  factory TrainableStat.fromJson(Map<String, dynamic> json) => _$TrainableStatFromJson(json);
}

@freezed
class PlayerStats with _$PlayerStats {
  const factory PlayerStats({
    required int level,
    @Default(TrainableStat()) TrainableStat str,
    @Default(TrainableStat()) TrainableStat intl,
    @Default(TrainableStat()) TrainableStat spd,
    @Default(TrainableStat()) TrainableStat wil,
    @Default(TrainableStat()) TrainableStat nin,
    @Default(TrainableStat()) TrainableStat gen,
    @Default(TrainableStat()) TrainableStat buk,
    @Default(TrainableStat()) TrainableStat tai,
    // Current resource values (for UI display)
    int? currentHP,
    int? currentSP,
    int? currentCP,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
}

extension PlayerStatsExtension on PlayerStats {
  // Level-tied resources (auto-derived)
  int get maxHP => (80 + 20 * level + 6 * str.level + 2 * wil.level);
  int get maxSP => (60 + 12 * level + 4 * spd.level + 3 * wil.level);
  int get maxCP => (60 + 15 * level + 6 * intl.level + 2 * wil.level);

  // Current resource values (default to max if not set)
  int get hp => currentHP ?? maxHP;
  int get sp => currentSP ?? maxSP;
  int get cp => currentCP ?? maxCP;

  // Legacy compatibility getters
  int get maxHp => maxHP;
  int get maxStamina => maxSP;
  int get maxChakra => maxCP;
  int get stamina => sp;
  int get chakra => cp;

  // Combat stats (derived from trainable stats)
  int get attack => (str.level + nin.level + buk.level + tai.level) ~/ 2;
  int get defense => (wil.level + spd.level) ~/ 2;
  int get speed => spd.level;

  // Regeneration rates per minute
  double get hpRegenPerMin => 0.2 * wil.level;
  double get spRegenPerMin => 0.3 * spd.level + 0.1 * wil.level;
  double get cpRegenPerMin => 0.35 * intl.level + 0.1 * wil.level;

  // XP calculation for next level
  int xpToNext(TrainableStat stat) {
    final L = stat.level;
    return (50 + 10 * L + 2 * (L * L));
  }

  // Soft cap calculation
  int softCap() => 10 + 2 * level;

  // Apply training XP with soft cap and fatigue modifiers
  PlayerStats applyTrainingXP(TrainableStat stat, int rawXP, {double fatigue = 1.0}) {
    final overCap = stat.level > softCap();
    final capMult = overCap ? 0.5 : 1.0;
    int gained = (rawXP * capMult * fatigue).round();
    
    int newXp = stat.xp + gained;
    int newLevel = stat.level;
    
    while (newXp >= xpToNext(TrainableStat(level: newLevel, xp: 0))) {
      newXp -= xpToNext(TrainableStat(level: newLevel, xp: 0));
      newLevel += 1;
    }
    
    // Update the specific stat
    TrainableStat updatedStat = stat.copyWith(level: newLevel, xp: newXp);
    
    // Debug: Print the stat update
    print('Training XP applied: ${stat.level} -> ${updatedStat.level} (XP: ${stat.xp} -> ${updatedStat.xp})');
    
    // Return updated PlayerStats with the modified stat
    if (stat == str) {
      return copyWith(str: updatedStat);
    } else if (stat == intl) {
      return copyWith(intl: updatedStat);
    } else if (stat == spd) {
      return copyWith(spd: updatedStat);
    } else if (stat == wil) {
      return copyWith(wil: updatedStat);
    } else if (stat == nin) {
      return copyWith(nin: updatedStat);
    } else if (stat == gen) {
      return copyWith(gen: updatedStat);
    } else if (stat == buk) {
      return copyWith(buk: updatedStat);
    } else if (stat == tai) {
      return copyWith(tai: updatedStat);
    }
    
    return this;
  }

  // Damage calculation methods
  double damageNinjutsu(double base) =>
      base * (1 + nin.level / 100.0) * (1 + intl.level / 120.0);

  double damageGenjutsu(double base) =>
      base * (1 + gen.level / 100.0) * (1 + wil.level / 120.0);

  double damageBukijutsu(double base) =>
      base * (1 + buk.level / 100.0) * (1 + str.level / 120.0);

  double damageTaijutsu(double base) =>
      base * (1 + tai.level / 100.0) * (1 + spd.level / 120.0);

  // Resource management methods
  PlayerStats updateHP(int newHP) {
    return copyWith(currentHP: newHP.clamp(0, maxHP));
  }

  PlayerStats updateSP(int newSP) {
    return copyWith(currentSP: newSP.clamp(0, maxSP));
  }

  PlayerStats updateCP(int newCP) {
    return copyWith(currentCP: newCP.clamp(0, maxCP));
  }

  PlayerStats healHP(int amount) {
    return updateHP(hp + amount);
  }

  PlayerStats restoreSP(int amount) {
    return updateSP(sp + amount);
  }

  PlayerStats restoreCP(int amount) {
    return updateCP(cp + amount);
  }

  PlayerStats restoreAll() {
    return copyWith(
      currentHP: maxHP,
      currentSP: maxSP,
      currentCP: maxCP,
    );
  }
}