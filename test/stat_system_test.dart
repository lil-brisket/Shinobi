import 'package:flutter_test/flutter_test.dart';
import 'package:shogunx/models/stats.dart';
import 'package:shogunx/examples/stat_system_example.dart';

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
        str: 8000,
        intl: 12000,
        spd: 10000,
        wil: 6000,
        nin: 15000,
        gen: 4000,
        buk: 9000,
        tai: 11000,
      );
    });

    test('should create PlayerStats with correct values', () {
      expect(playerStats.level, 10);
      expect(playerStats.str, 8000);
      expect(playerStats.intl, 12000);
      expect(playerStats.spd, 10000);
      expect(playerStats.wil, 6000);
      expect(playerStats.nin, 15000);
      expect(playerStats.gen, 4000);
      expect(playerStats.buk, 9000);
      expect(playerStats.tai, 11000);
    });

    test('should calculate max resources correctly', () {
      expect(playerStats.maxHP, 1500); // 500 + 100 * 10
      expect(playerStats.maxSP, 1500); // 500 + 100 * 10
      expect(playerStats.maxCP, 1500); // 500 + 100 * 10
    });

    test('should calculate current resources correctly', () {
      expect(playerStats.hp, 1500); // Defaults to max
      expect(playerStats.sp, 1500); // Defaults to max
      expect(playerStats.cp, 1500); // Defaults to max
    });

    test('should calculate soft cap correctly', () {
      expect(playerStats.softCap(), 10); // level + 0
    });

    test('should calculate damage correctly', () {
      expect(playerStats.damageNinjutsu(100), greaterThan(100));
      expect(playerStats.damageGenjutsu(100), greaterThan(100));
      expect(playerStats.damageBukijutsu(100), greaterThan(100));
      expect(playerStats.damageTaijutsu(100), greaterThan(100));
    });

    test('should calculate regeneration correctly', () {
      expect(playerStats.hpRegenPerMin, greaterThan(0));
      expect(playerStats.spRegenPerMin, greaterThan(0));
      expect(playerStats.cpRegenPerMin, greaterThan(0));
    });

    test('should copy with new values', () {
      final newStats = playerStats.copyWith(level: 15, str: 10000);
      expect(newStats.level, 15);
      expect(newStats.str, 10000);
      expect(newStats.intl, 12000); // Unchanged
    });

    test('should handle resource changes', () {
      final newStats = playerStats.copyWith(
        currentHP: 1000,
        currentSP: 1200,
        currentCP: 800,
      );
      expect(newStats.hp, 1000);
      expect(newStats.sp, 1200);
      expect(newStats.cp, 800);
    });
  });

  group('Stat Training Service Tests', () {
    test('should train strength stat', () {
      const initialStats = PlayerStats(level: 1, str: 1000);
      final trainedStats = StatTrainingService.trainStat(initialStats, 'str', 500);
      expect(trainedStats.str, 1500);
    });

    test('should train multiple stats', () {
      const initialStats = PlayerStats(level: 1, str: 1000, nin: 1000);
      final trainedStats = StatTrainingService.trainStat(initialStats, 'nin', 300);
      expect(trainedStats.str, 1000); // Unchanged
      expect(trainedStats.nin, 1300); // Increased
    });

    test('should get stat values', () {
      const stats = PlayerStats(level: 1, str: 1500, intl: 2000);
      expect(StatTrainingService.getStatValue(stats, 'str'), 1500);
      expect(StatTrainingService.getStatValue(stats, 'int'), 2000);
      expect(StatTrainingService.getStatValue(stats, 'intl'), 2000);
    });

    test('should throw error for invalid stat type', () {
      const stats = PlayerStats(level: 1);
      expect(
        () => StatTrainingService.trainStat(stats, 'invalid', 100),
        throwsArgumentError,
      );
    });
  });
}