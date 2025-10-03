// lib/examples/stat_system_example.dart
import '../models/stats.dart';

/// Example demonstrating the new stat system usage
class StatSystemExample {
  static void demonstrateStatSystem() {
    // Create a new player with initial stats
    var playerStats = const PlayerStats(
      level: 1,
      str: 1000,
      intl: 1000,
      spd: 1000,
      wil: 1000,
      nin: 1000,
      gen: 1000,
      buk: 1000,
      tai: 1000,
    );

    print('=== Initial Stats ===');
    printStats(playerStats);

    // Demonstrate stat training (simplified system)
    print('\n=== Training Strength ===');
    playerStats = playerStats.copyWith(str: playerStats.str + 100);
    print('After 100 stat points training:');
    print('STR: ${playerStats.str}');

    // Demonstrate multiple stat increases
    print('\n=== Heavy Training ===');
    playerStats = playerStats.copyWith(nin: playerStats.nin + 500);
    print('After 500 ninjutsu training:');
    print('NIN: ${playerStats.nin}');

    // Demonstrate soft cap effect
    print('\n=== Soft Cap Demonstration ===');
    print('Soft cap at level ${playerStats.level}: ${playerStats.softCap()}');
    
    // Train a stat beyond soft cap
    playerStats = playerStats.copyWith(str: playerStats.str + 1000);
    print('After 1000 strength training (beyond soft cap):');
    print('STR: ${playerStats.str}');

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

    // Demonstrate level up
    print('\n=== Level Up ===');
    playerStats = playerStats.copyWith(level: playerStats.level + 1);
    print('After level up:');
    print('Level: ${playerStats.level}');
    print('New Max HP: ${playerStats.maxHP}');
  }

  static void printStats(PlayerStats stats) {
    print('Player Level: ${stats.level}');
    print('STR: ${stats.str}');
    print('INT: ${stats.intl}');
    print('SPD: ${stats.spd}');
    print('WIL: ${stats.wil}');
    print('NIN: ${stats.nin}');
    print('GEN: ${stats.gen}');
    print('BUK: ${stats.buk}');
    print('TAI: ${stats.tai}');
  }
}

/// Example of how to integrate with Riverpod providers
class StatTrainingService {
  static PlayerStats trainStat(PlayerStats currentStats, String statType, int points) {
    switch (statType.toLowerCase()) {
      case 'str':
        return currentStats.copyWith(str: currentStats.str + points);
      case 'int':
      case 'intl':
        return currentStats.copyWith(intl: currentStats.intl + points);
      case 'spd':
        return currentStats.copyWith(spd: currentStats.spd + points);
      case 'wil':
        return currentStats.copyWith(wil: currentStats.wil + points);
      case 'nin':
        return currentStats.copyWith(nin: currentStats.nin + points);
      case 'gen':
        return currentStats.copyWith(gen: currentStats.gen + points);
      case 'buk':
        return currentStats.copyWith(buk: currentStats.buk + points);
      case 'tai':
        return currentStats.copyWith(tai: currentStats.tai + points);
      default:
        throw ArgumentError('Invalid stat type: $statType');
    }
  }

  static int getStatValue(PlayerStats stats, String statType) {
    switch (statType.toLowerCase()) {
      case 'str':
        return stats.str;
      case 'int':
      case 'intl':
        return stats.intl;
      case 'spd':
        return stats.spd;
      case 'wil':
        return stats.wil;
      case 'nin':
        return stats.nin;
      case 'gen':
        return stats.gen;
      case 'buk':
        return stats.buk;
      case 'tai':
        return stats.tai;
      default:
        throw ArgumentError('Invalid stat type: $statType');
    }
  }
}