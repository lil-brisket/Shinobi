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
    // Raw stat values instead of TrainableStat objects
    @Default(0) int str,
    @Default(0) int intl,
    @Default(0) int spd,
    @Default(0) int wil,
    @Default(0) int nin,
    @Default(0) int gen,
    @Default(0) int buk,
    @Default(0) int tai,
    // Current resource values (for UI display)
    int? currentHP,
    int? currentSP,
    int? currentCP,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
}

extension PlayerStatsExtension on PlayerStats {
  // Level-tied resources (auto-derived)
  // Base: 500, +100 per level
  int get maxHP => (500 + 100 * level);
  int get maxSP => (500 + 100 * level);
  int get maxCP => (500 + 100 * level);

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

  // Combat stats (derived from raw stats)
  int get attack => (str + nin + buk + tai) ~/ 2;
  int get defense => (wil + spd) ~/ 2;
  int get speed => spd;

  // Regeneration rates per minute
  double get hpRegenPerMin => 0.2 * wil;
  double get spRegenPerMin => 0.3 * spd + 0.1 * wil;
  double get cpRegenPerMin => 0.35 * intl + 0.1 * wil;

  // Soft cap calculation (now based on raw stat values)
  int softCap() => 10000 + 2000 * level;

  // Damage calculation methods
  double damageNinjutsu(double base) =>
      base * (1 + nin / 1000.0) * (1 + intl / 1200.0);

  double damageGenjutsu(double base) =>
      base * (1 + gen / 1000.0) * (1 + wil / 1200.0);

  double damageBukijutsu(double base) =>
      base * (1 + buk / 1000.0) * (1 + str / 1200.0);

  double damageTaijutsu(double base) =>
      base * (1 + tai / 1000.0) * (1 + spd / 1200.0);

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

  // Rank system
  String get rank {
    if (level >= 1 && level <= 10) return 'Student';
    if (level >= 11 && level <= 20) return 'Genin';
    if (level >= 21 && level <= 50) return 'Chunin';
    if (level >= 51 && level <= 80) return 'Jounin';
    if (level >= 81 && level <= 100) return 'Elite Jounin';
    return 'Student';
  }

  // Rank color for UI
  String get rankColor {
    switch (rank) {
      case 'Student':
        return 'grey';
      case 'Genin':
        return 'green';
      case 'Chunin':
        return 'blue';
      case 'Jounin':
        return 'purple';
      case 'Elite Jounin':
        return 'amber';
      default:
        return 'grey';
    }
  }
}