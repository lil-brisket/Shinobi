// lib/examples/stat_system_example.dart
import '../models/stats.dart';

/// Example demonstrating the new stat system usage
class StatSystemExample {
  static void demonstrateStatSystem() {
    // Create a new player with initial stats
    var playerStats = const PlayerStats(
      level: 1,
      str: TrainableStat(level: 1, xp: 0),
      intl: TrainableStat(level: 1, xp: 0),
      spd: TrainableStat(level: 1, xp: 0),
      wil: TrainableStat(level: 1, xp: 0),
      nin: TrainableStat(level: 1, xp: 0),
      gen: TrainableStat(level: 1, xp: 0),
      buk: TrainableStat(level: 1, xp: 0),
      tai: TrainableStat(level: 1, xp: 0),
    );

    print('=== Initial Stats ===');
    printStats(playerStats);

    // Demonstrate training XP application
    print('\n=== Training Strength ===');
    playerStats = playerStats.applyTrainingXP(playerStats.str, 100);
    print('After 100 XP training:');
    print('STR Level: ${playerStats.str.level}, XP: ${playerStats.str.xp}');

    // Demonstrate multiple level ups
    print('\n=== Heavy Training ===');
    playerStats = playerStats.applyTrainingXP(playerStats.nin, 500);
    print('After 500 XP ninjutsu training:');
    print('NIN Level: ${playerStats.nin.level}, XP: ${playerStats.nin.xp}');

    // Demonstrate soft cap effect
    print('\n=== Soft Cap Demonstration ===');
    print('Soft cap at level ${playerStats.level}: ${playerStats.softCap()}');
    
    // Train a stat beyond soft cap
    playerStats = playerStats.applyTrainingXP(playerStats.str, 1000);
    print('After 1000 XP strength training (beyond soft cap):');
    print('STR Level: ${playerStats.str.level}, XP: ${playerStats.str.xp}');

    // Show resource calculations
    print('\n=== Resource Calculations ===');
    print('Max HP: ${playerStats.maxHP}');
    print('Max SP: ${playerStats.maxSP}');
    print('Max CP: ${playerStats.maxCP}');
    print('HP Regen/min: ${playerStats.hpRegenPerMin}');
    print('SP Regen/min: ${playerStats.spRegenPerMin}');
    print('CP Regen/min: ${playerStats.cpRegenPerMin}');

    // Demonstrate damage calculations
    print('\n=== Damage Calculations ===');
    print('Ninjutsu damage (base 100): ${playerStats.damageNinjutsu(100).toStringAsFixed(1)}');
    print('Genjutsu damage (base 100): ${playerStats.damageGenjutsu(100).toStringAsFixed(1)}');
    print('Bukijutsu damage (base 100): ${playerStats.damageBukijutsu(100).toStringAsFixed(1)}');
    print('Taijutsu damage (base 100): ${playerStats.damageTaijutsu(100).toStringAsFixed(1)}');

    // Demonstrate fatigue effect
    print('\n=== Fatigue Effect ===');
    playerStats = playerStats.applyTrainingXP(playerStats.tai, 200, fatigue: 0.5);
    print('After 200 XP taijutsu training with 50% fatigue:');
    print('TAI Level: ${playerStats.tai.level}, XP: ${playerStats.tai.xp}');
  }

  static void printStats(PlayerStats stats) {
    print('Player Level: ${stats.level}');
    print('STR: Level ${stats.str.level} (${stats.str.xp} XP)');
    print('INT: Level ${stats.intl.level} (${stats.intl.xp} XP)');
    print('SPD: Level ${stats.spd.level} (${stats.spd.xp} XP)');
    print('WIL: Level ${stats.wil.level} (${stats.wil.xp} XP)');
    print('NIN: Level ${stats.nin.level} (${stats.nin.xp} XP)');
    print('GEN: Level ${stats.gen.level} (${stats.gen.xp} XP)');
    print('BUK: Level ${stats.buk.level} (${stats.buk.xp} XP)');
    print('TAI: Level ${stats.tai.level} (${stats.tai.xp} XP)');
  }
}

/// Example of how to integrate with Riverpod providers
class StatTrainingService {
  static PlayerStats trainStat(PlayerStats currentStats, String statType, int xp, {double fatigue = 1.0}) {
    switch (statType.toLowerCase()) {
      case 'str':
        return currentStats.applyTrainingXP(currentStats.str, xp, fatigue: fatigue);
      case 'int':
      case 'intl':
        return currentStats.applyTrainingXP(currentStats.intl, xp, fatigue: fatigue);
      case 'spd':
        return currentStats.applyTrainingXP(currentStats.spd, xp, fatigue: fatigue);
      case 'wil':
        return currentStats.applyTrainingXP(currentStats.wil, xp, fatigue: fatigue);
      case 'nin':
        return currentStats.applyTrainingXP(currentStats.nin, xp, fatigue: fatigue);
      case 'gen':
        return currentStats.applyTrainingXP(currentStats.gen, xp, fatigue: fatigue);
      case 'buk':
        return currentStats.applyTrainingXP(currentStats.buk, xp, fatigue: fatigue);
      case 'tai':
        return currentStats.applyTrainingXP(currentStats.tai, xp, fatigue: fatigue);
      default:
        throw ArgumentError('Invalid stat type: $statType');
    }
  }

  static int getXpToNext(PlayerStats stats, String statType) {
    switch (statType.toLowerCase()) {
      case 'str':
        return stats.xpToNext(stats.str);
      case 'int':
      case 'intl':
        return stats.xpToNext(stats.intl);
      case 'spd':
        return stats.xpToNext(stats.spd);
      case 'wil':
        return stats.xpToNext(stats.wil);
      case 'nin':
        return stats.xpToNext(stats.nin);
      case 'gen':
        return stats.xpToNext(stats.gen);
      case 'buk':
        return stats.xpToNext(stats.buk);
      case 'tai':
        return stats.xpToNext(stats.tai);
      default:
        throw ArgumentError('Invalid stat type: $statType');
    }
  }
}
