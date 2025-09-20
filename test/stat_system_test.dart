import 'package:flutter_test/flutter_test.dart';
import 'package:shogunx/models/stats.dart';

void main() {
  group('TrainableStat Tests', () {
    test('should create TrainableStat with default values', () {
      const stat = TrainableStat();
      expect(stat.level, 1);
      expect(stat.xp, 0);
    });

    test('should create TrainableStat with custom values', () {
      const stat = TrainableStat(level: 5, xp: 100);
      expect(stat.level, 5);
      expect(stat.xp, 100);
    });
  });

  group('PlayerStats Tests', () {
    late PlayerStats playerStats;

    setUp(() {
      playerStats = const PlayerStats(
        level: 10,
        str: TrainableStat(level: 8, xp: 50),
        intl: TrainableStat(level: 12, xp: 75),
        spd: TrainableStat(level: 10, xp: 25),
        wil: TrainableStat(level: 6, xp: 100),
        nin: TrainableStat(level: 15, xp: 30),
        gen: TrainableStat(level: 4, xp: 80),
        buk: TrainableStat(level: 9, xp: 60),
        tai: TrainableStat(level: 11, xp: 40),
      );
    });

    test('should calculate max HP correctly', () {
      // maxHP = 80 + 20*level + 6*str.level + 2*wil.level
      // = 80 + 20*10 + 6*8 + 2*6 = 80 + 200 + 48 + 12 = 340
      expect(playerStats.maxHP, 340);
    });

    test('should calculate max SP correctly', () {
      // maxSP = 60 + 12*level + 4*spd.level + 3*wil.level
      // = 60 + 12*10 + 4*10 + 3*6 = 60 + 120 + 40 + 18 = 238
      expect(playerStats.maxSP, 238);
    });

    test('should calculate max CP correctly', () {
      // maxCP = 60 + 15*level + 6*intl.level + 2*wil.level
      // = 60 + 15*10 + 6*12 + 2*6 = 60 + 150 + 72 + 12 = 294
      expect(playerStats.maxCP, 294);
    });

    test('should calculate regeneration rates correctly', () {
      expect(playerStats.hpRegenPerMin, closeTo(1.2, 0.01)); // 0.2 * 6 = 1.2
      expect(playerStats.spRegenPerMin, closeTo(3.6, 0.01)); // 0.3 * 10 + 0.1 * 6 = 3.6
      expect(playerStats.cpRegenPerMin, closeTo(4.8, 0.01)); // 0.35 * 12 + 0.1 * 6 = 4.8
    });

    test('should calculate soft cap correctly', () {
      // softCap = 10 + 2*level = 10 + 2*10 = 30
      expect(playerStats.softCap(), 30);
    });

    test('should calculate XP to next level correctly', () {
      // xpToNext = 50 + 10*L + 2*(L*L)
      // For level 8: 50 + 10*8 + 2*(8*8) = 50 + 80 + 128 = 258
      expect(playerStats.xpToNext(playerStats.str), 258);
    });

    test('should apply training XP correctly', () {
      final updatedStats = playerStats.applyTrainingXP(playerStats.str, 100);
      expect(updatedStats.str.xp, greaterThan(playerStats.str.xp));
    });

    test('should level up when XP threshold is reached', () {
      // Give enough XP to level up (258 XP needed for level 8 -> 9)
      final updatedStats = playerStats.applyTrainingXP(playerStats.str, 300);
      expect(updatedStats.str.level, greaterThan(playerStats.str.level));
    });

    test('should apply soft cap penalty correctly', () {
      // Create a stat above soft cap
      final highLevelStats = playerStats.copyWith(
        str: const TrainableStat(level: 35, xp: 0), // Above soft cap of 30
      );
      
      final updatedStats = highLevelStats.applyTrainingXP(highLevelStats.str, 100);
      // Should gain less XP due to soft cap penalty
      expect(updatedStats.str.xp, lessThan(100));
    });

    test('should apply fatigue penalty correctly', () {
      final updatedStats = playerStats.applyTrainingXP(
        playerStats.str, 
        100, 
        fatigue: 0.5,
      );
      // Should gain 50 XP due to 50% fatigue
      expect(updatedStats.str.xp, playerStats.str.xp + 50);
    });

    test('should calculate damage correctly', () {
      // Test ninjutsu damage: base * (1 + nin.level/100.0) * (1 + intl.level/120.0)
      // = 100 * (1 + 15/100.0) * (1 + 12/120.0) = 100 * 1.15 * 1.1 = 126.5
      expect(playerStats.damageNinjutsu(100), closeTo(126.5, 0.1));
      
      // Test genjutsu damage: base * (1 + gen.level/100.0) * (1 + wil.level/120.0)
      // = 100 * (1 + 4/100.0) * (1 + 6/120.0) = 100 * 1.04 * 1.05 = 109.2
      expect(playerStats.damageGenjutsu(100), closeTo(109.2, 0.1));
      
      // Test bukijutsu damage: base * (1 + buk.level/100.0) * (1 + str.level/120.0)
      // = 100 * (1 + 9/100.0) * (1 + 8/120.0) = 100 * 1.09 * 1.067 = 116.3
      expect(playerStats.damageBukijutsu(100), closeTo(116.3, 0.1));
      
      // Test taijutsu damage: base * (1 + tai.level/100.0) * (1 + spd.level/120.0)
      // = 100 * (1 + 11/100.0) * (1 + 10/120.0) = 100 * 1.11 * 1.083 = 120.2
      expect(playerStats.damageTaijutsu(100), closeTo(120.2, 0.1));
    });

    test('should handle multiple level ups in single training', () {
      // Give enough XP for multiple level ups
      final updatedStats = playerStats.applyTrainingXP(playerStats.str, 1000);
      expect(updatedStats.str.level, greaterThan(playerStats.str.level + 1));
    });
  });
}
