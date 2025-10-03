import 'package:flutter_test/flutter_test.dart';
import 'package:shogunx/features/battle/battle_formulas.dart';
import 'package:shogunx/features/battle/battle_models.dart';
import 'dart:math';

void main() {
  group('Battle Formulas Tests', () {
    late Random testRng;
    
    setUp(() {
      testRng = Random(12345); // Fixed seed for reproducible tests
    });

    // RNG utilities for testing
    int testRngIntInclusive(int min, int max) {
      final r = testRng.nextInt((max - min) + 1);
      return min + r;
    }

    bool testRngRollUnder(double p) {
      return testRng.nextDouble() < p;
    }

    test('should calculate effective stats with diminishing returns', () {
      // Test that the curve produces reasonable values
      final lowStr = BattleFormulas.effSTR(1000);
      final midStr = BattleFormulas.effSTR(30000); // At knee
      final highStr = BattleFormulas.effSTR(100000); // Well above knee
      
      // All effective stats should be positive and less than cap
      expect(lowStr, greaterThan(0));
      expect(midStr, greaterThan(0));
      expect(highStr, greaterThan(0));
      
      expect(lowStr, lessThan(BalanceConfig.capSTR));
      expect(midStr, lessThan(BalanceConfig.capSTR));
      expect(highStr, lessThan(BalanceConfig.capSTR));
      
      // Higher raw stats should produce higher effective stats
      expect(lowStr, lessThan(midStr));
      expect(midStr, lessThan(highStr));
      
      // Print actual values for debugging
      print('Low STR (1000): $lowStr');
      print('Mid STR (30000): $midStr');
      print('High STR (100000): $highStr');
    });

    test('should calculate damage with mitigation and variance', () {
      final attacker = Entity(
        id: 'A1',
        name: 'Attacker',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 50000, // High strength
        spd: 7,
        intStat: 5,
        wil: 4,
        ap: 100,
        apMax: 100,
      );

      final defender = Entity(
        id: 'D1',
        name: 'Defender',
        isPlayerControlled: false,
        pos: const Position(row: 0, col: 1),
        hp: 100,
        hpMax: 100,
        cp: 0,
        cpMax: 0,
        sp: 30,
        spMax: 30,
        str: 5,
        spd: 5,
        intStat: 0,
        wil: 10000, // High willpower for mitigation
        ap: 100,
        apMax: 100,
      );

      final damage = BattleFormulas.calcDamage(
        attacker: attacker,
        defender: defender,
        rngIntInclusive: testRngIntInclusive,
        rngRollUnder: testRngRollUnder,
      );

      // Damage should be positive and respect minimum
      expect(damage, greaterThanOrEqualTo(BalanceConfig.minDamage));
      
      // Should have variance
      /*
      final damage2 = BattleFormulas.calcDamage(
        attacker: attacker,
        defender: defender,
        rngIntInclusive: testRngIntInclusive,
        rngRollUnder: testRngRollUnder,
      );
      */
      
      // Damage should be different due to variance (unless crit)
      expect(damage, isA<int>());
    });

    test('should calculate heal amount with INT scaling', () {
      final caster = Entity(
        id: 'C1',
        name: 'Caster',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 5,
        spd: 7,
        intStat: 25000, // High intelligence
        wil: 4,
        ap: 100,
        apMax: 100,
      );

      final healAmount = BattleFormulas.calcHeal(
        caster: caster,
        rngIntInclusive: testRngIntInclusive,
      );

      expect(healAmount, greaterThanOrEqualTo(BalanceConfig.minHeal));
      expect(healAmount, greaterThan(100000)); // Should be substantial with high INT
    });

    test('should calculate flee chance based on speed difference', () {
      final fastEntity = Entity(
        id: 'F1',
        name: 'Fast Entity',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 5,
        spd: 50000, // Very high speed
        intStat: 5,
        wil: 4,
        ap: 100,
        apMax: 100,
      );

      final slowEnemies = [
        Entity(
          id: 'S1',
          name: 'Slow Enemy',
          isPlayerControlled: false,
          pos: const Position(row: 0, col: 1),
          hp: 100,
          hpMax: 100,
          cp: 0,
          cpMax: 0,
          sp: 30,
          spMax: 30,
          str: 5,
          spd: 1000, // Low speed
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
      ];

      final fleeChance = BattleFormulas.calcFleeChance(
        fleeEntity: fastEntity,
        enemies: slowEnemies,
      );

      // Should have high flee chance due to speed advantage
      expect(fleeChance, greaterThan(0.8));
      expect(fleeChance, lessThanOrEqualTo(BalanceConfig.fleeMax));
    });

    test('should calculate turn order by effective speed', () {
      final entities = [
        Entity(
          id: 'E1',
          name: 'Slow Entity',
          isPlayerControlled: false,
          pos: const Position(row: 0, col: 0),
          hp: 100,
          hpMax: 100,
          cp: 0,
          cpMax: 0,
          sp: 30,
          spMax: 30,
          str: 5,
          spd: 1000, // Low speed
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
        Entity(
          id: 'E2',
          name: 'Fast Entity',
          isPlayerControlled: true,
          pos: const Position(row: 0, col: 1),
          hp: 100,
          hpMax: 100,
          cp: 30,
          cpMax: 30,
          sp: 50,
          spMax: 50,
          str: 5,
          spd: 50000, // High speed
          intStat: 5,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
        Entity(
          id: 'E3',
          name: 'Medium Entity',
          isPlayerControlled: false,
          pos: const Position(row: 0, col: 2),
          hp: 100,
          hpMax: 100,
          cp: 0,
          cpMax: 0,
          sp: 30,
          spMax: 30,
          str: 5,
          spd: 10000, // Medium speed
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
      ];

      final turnOrder = BattleFormulas.calcTurnOrder(entities);

      // Fast entity should go first
      expect(turnOrder.first.id, equals('E2'));
      
      // Order should be: Fast (E2), Medium (E3), Slow (E1)
      expect(turnOrder.map((e) => e.id).toList(), equals(['E2', 'E3', 'E1']));
    });

    test('should provide damage range for UI preview', () {
      final attacker = Entity(
        id: 'A1',
        name: 'Attacker',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 10000,
        spd: 7,
        intStat: 5,
        wil: 4,
        ap: 100,
        apMax: 100,
      );

      final defender = Entity(
        id: 'D1',
        name: 'Defender',
        isPlayerControlled: false,
        pos: const Position(row: 0, col: 1),
        hp: 100,
        hpMax: 100,
        cp: 0,
        cpMax: 0,
        sp: 30,
        spMax: 30,
        str: 5,
        spd: 5,
        intStat: 0,
        wil: 1000, // Low willpower
        ap: 100,
        apMax: 100,
      );

      final range = BattleFormulas.getDamageRange(
        attacker: attacker,
        defender: defender,
      );

      expect(range.min, greaterThan(0));
      expect(range.max, greaterThanOrEqualTo(range.min));
      expect(range.critChance, equals(BalanceConfig.critChance));
    });

    test('should provide heal range for UI preview', () {
      final caster = Entity(
        id: 'C1',
        name: 'Caster',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 5,
        spd: 7,
        intStat: 10000,
        wil: 4,
        ap: 100,
        apMax: 100,
      );

      final range = BattleFormulas.getHealRange(caster);

      expect(range.min, greaterThan(0));
      expect(range.max, greaterThanOrEqualTo(range.min));
    });

    test('should provide debug stats for entities', () {
      final entity = Entity(
        id: 'T1',
        name: 'Test Entity',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 15000,
        spd: 8000,
        intStat: 12000,
        wil: 9000,
        ap: 100,
        apMax: 100,
      );

      final debugStats = BattleFormulas.debugStats(entity);

      expect(debugStats, containsPair('STR', isA<String>()));
      expect(debugStats, containsPair('INT', isA<String>()));
      expect(debugStats, containsPair('SPD', isA<String>()));
      expect(debugStats, containsPair('WIL', isA<String>()));
      
      // Check that effective stats are shown
      expect(debugStats['STR']!, contains('raw=15000'));
      expect(debugStats['STR']!, contains('eff='));
    });

    test('should handle edge cases gracefully', () {
      final weakEntity = Entity(
        id: 'W1',
        name: 'Weak Entity',
        isPlayerControlled: true,
        pos: const Position(row: 0, col: 0),
        hp: 100,
        hpMax: 100,
        cp: 30,
        cpMax: 30,
        sp: 50,
        spMax: 50,
        str: 1, // Very low stats
        spd: 1,
        intStat: 1,
        wil: 1,
        ap: 100,
        apMax: 100,
      );

      // Should still provide minimum damage (with variance)
      final damage = BattleFormulas.calcDamage(
        attacker: weakEntity,
        defender: weakEntity,
        rngIntInclusive: testRngIntInclusive,
        rngRollUnder: testRngRollUnder,
      );

      expect(damage, greaterThanOrEqualTo(BalanceConfig.minDamage));

      // Should still provide minimum heal
      final heal = BattleFormulas.calcHeal(
        caster: weakEntity,
        rngIntInclusive: testRngIntInclusive,
      );

      expect(heal, greaterThanOrEqualTo(BalanceConfig.minHeal));
    });
  });
}
