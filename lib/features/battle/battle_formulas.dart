import 'dart:math' as math;
import 'battle_models.dart';

/// Central balance configuration for the battle system
class BalanceConfig {
  // Stat caps from your game (adjust anytime)
  static const int capSTR = 500000;
  static const int capINT = 500000;
  static const int capSPD = 500000;
  static const int capWIL = 500000;

  // Curve shape: knee = where diminishing returns start to bite,
  // exp = how sharp the curve saturates (1.0 gentle, 2.0 steeper).
  static const double kneeSTR = 30000; // try 30k
  static const double kneeINT = 30000;
  static const double kneeSPD = 25000;
  static const double kneeWIL = 25000;
  static const double expSTR = 1.4;
  static const double expINT = 1.4;
  static const double expSPD = 1.3;
  static const double expWIL = 1.2;

  // Coefficients (post-curve) that translate "effective stat" into power.
  static const double dmgPerEffSTR = 5.0;     // melee scaling
  static const double mitPerEffWIL = 1.6;     // mitigation scaling
  static const double healPerEffINT = 8.0;    // self-heal scaling

  // Randomness & crits
  static const int punchVarianceMin = 0;      // add rand in [min..max]
  static const int punchVarianceMax = 3;
  static const double critChance = 0.05;      // 5%
  static const double critMultiplier = 2.0;

  // Flee
  static const double fleeBase = 0.50;        // 50%
  static const double fleeSpdFactor = 0.01;   // +1% per SPD delta
  static const double fleeMin = 0.10;
  static const double fleeMax = 0.90;

  // Costs
  static const int healCpCost = 10;

  // Action Point system
  static const int defaultAPMax = 100;
  static const int costMove = 20;
  static const int costPunch = 20;
  static const int costHeal = 20;
  static const int costFlee = 100;

  // Safety clamps
  static const int minDamage = 1;
  static const int minHeal = 5;
}

/// Smooth, monotonic 0..1 curve with knee + exponent:
/// eff = x^exp / (x^exp + knee^exp)
/// As x >> knee, eff -> 1; as x -> 0, eff -> 0.
double _saturatingRatio(num x, {required double knee, required double exp}) {
  final xx = math.pow(x.toDouble().clamp(0, double.infinity), exp);
  final kk = math.pow(knee.clamp(1e-9, double.infinity), exp);
  return (xx / (xx + kk)).toDouble();
}

/// Convert a raw stat (0..cap) into an "effective" bounded value (0..cap),
/// but with diminishing returns after the knee.
double _effectiveStat({
  required int raw,
  required int cap,
  required double knee,
  required double exp,
}) {
  final r = raw.clamp(0, cap);
  final ratio = _saturatingRatio(r, knee: knee, exp: exp); // 0..1
  return ratio * cap; // still in the scale of the cap for intuitive tuning
}

/// Battle formulas with nonlinear curves and balance configuration
class BattleFormulas {
  // Effective stat getters (drop-in for formulas)
  
  static double effSTR(int raw) => _effectiveStat(
        raw: raw,
        cap: BalanceConfig.capSTR,
        knee: BalanceConfig.kneeSTR,
        exp: BalanceConfig.expSTR,
      );

  static double effINT(int raw) => _effectiveStat(
        raw: raw,
        cap: BalanceConfig.capINT,
        knee: BalanceConfig.kneeINT,
        exp: BalanceConfig.expINT,
      );

  static double effSPD(int raw) => _effectiveStat(
        raw: raw,
        cap: BalanceConfig.capSPD,
        knee: BalanceConfig.kneeSPD,
        exp: BalanceConfig.expSPD,
      );

  static double effWIL(int raw) => _effectiveStat(
        raw: raw,
        cap: BalanceConfig.capWIL,
        knee: BalanceConfig.kneeWIL,
        exp: BalanceConfig.expWIL,
      );

  /// Utility: average effective SPD for a group
  static double avgEffSPD(Iterable<Entity> list) {
    if (list.isEmpty) return 0;
    final sum = list.fold<double>(0, (s, e) => s + effSPD(e.spd));
    return sum / list.length;
  }

  /// Calculate damage with nonlinear scaling, mitigation, variance, and crits
  static int calcDamage({
    required Entity attacker,
    required Entity defender,
    required int Function(int min, int max) rngIntInclusive, // inject RNG
    required bool Function(double p) rngRollUnder,           // inject RNG
    bool allowCrit = true,
  }) {
    final atk = effSTR(attacker.str) * BalanceConfig.dmgPerEffSTR;
    final mit = effWIL(defender.wil) * BalanceConfig.mitPerEffWIL;

    // Base damage before variance/crit, never negative.
    double base = math.max(0.0, atk - mit);

    // Small flat variance (keeps chip at very low stats).
    final variance = rngIntInclusive(
      BalanceConfig.punchVarianceMin,
      BalanceConfig.punchVarianceMax,
    );
    base += variance;

    // Crit
    if (allowCrit && rngRollUnder(BalanceConfig.critChance)) {
      base *= BalanceConfig.critMultiplier;
    }

    // Final clamp
    return math.max(BalanceConfig.minDamage, base.floor());
  }

  /// Calculate heal amount with nonlinear INT scaling
  static int calcHeal({
    required Entity caster,
    required int Function(int min, int max) rngIntInclusive,
  }) {
    double heal = effINT(caster.intStat) * BalanceConfig.healPerEffINT;
    heal += rngIntInclusive(0, 5);
    return math.max(BalanceConfig.minHeal, heal.floor());
  }

  /// Calculate flee chance based on speed difference
  static double calcFleeChance({
    required Entity fleeEntity,
    required List<Entity> enemies,
  }) {
    final base = BalanceConfig.fleeBase;
    final self = effSPD(fleeEntity.spd);
    final avgEnemy = enemies.isEmpty ? 0.0 : avgEffSPD(enemies);
    final spdDelta = self - avgEnemy;
    final additive = spdDelta * BalanceConfig.fleeSpdFactor;
    final chance = (base + additive)
        .clamp(BalanceConfig.fleeMin, BalanceConfig.fleeMax);
    return chance;
  }

  /// Calculate turn order based on effective speed
  static List<Entity> calcTurnOrder(List<Entity> entities) {
    // Sort by effective SPD (desc), tiebreak by id asc (stable).
    final sorted = [...entities]..sort((a, b) {
        final ea = effSPD(a.spd);
        final eb = effSPD(b.spd);
        final cmp = eb.compareTo(ea);
        if (cmp != 0) return cmp;
        return a.id.compareTo(b.id);
      });
    return sorted;
  }

  /// Debug helper to show raw vs effective stats
  static Map<String, String> debugStats(Entity entity) {
    return {
      'STR': 'raw=${entity.str} eff=${effSTR(entity.str).toStringAsFixed(0)}',
      'INT': 'raw=${entity.intStat} eff=${effINT(entity.intStat).toStringAsFixed(0)}',
      'SPD': 'raw=${entity.spd} eff=${effSPD(entity.spd).toStringAsFixed(0)}',
      'WIL': 'raw=${entity.wil} eff=${effWIL(entity.wil).toStringAsFixed(0)}',
    };
  }

  /// Get effective stat breakdown for UI display
  static Map<String, double> getEffectiveStats(Entity entity) {
    return {
      'STR': effSTR(entity.str),
      'INT': effINT(entity.intStat),
      'SPD': effSPD(entity.spd),
      'WIL': effWIL(entity.wil),
    };
  }

  /// Calculate expected damage range (min/max) for UI preview
  static ({int min, int max, double critChance}) getDamageRange({
    required Entity attacker,
    required Entity defender,
  }) {
    final atk = effSTR(attacker.str) * BalanceConfig.dmgPerEffSTR;
    final mit = effWIL(defender.wil) * BalanceConfig.mitPerEffWIL;
    final base = math.max(0.0, atk - mit);
    
    final minDmg = math.max(BalanceConfig.minDamage, (base + BalanceConfig.punchVarianceMin).floor());
    final maxDmg = math.max(BalanceConfig.minDamage, (base + BalanceConfig.punchVarianceMax).floor());
    // final critMin = math.max(BalanceConfig.minDamage, (minDmg * BalanceConfig.critMultiplier).floor());
    final critMax = math.max(BalanceConfig.minDamage, (maxDmg * BalanceConfig.critMultiplier).floor());
    
    return (
      min: minDmg,
      max: math.max(critMax, maxDmg),
      critChance: BalanceConfig.critChance,
    );
  }

  /// Calculate expected heal range for UI preview
  static ({int min, int max}) getHealRange(Entity caster) {
    final base = effINT(caster.intStat) * BalanceConfig.healPerEffINT;
    final minHeal = math.max(BalanceConfig.minHeal, base.floor());
    final maxHeal = math.max(BalanceConfig.minHeal, (base + 5).floor());
    
    return (min: minHeal, max: maxHeal);
  }
}
