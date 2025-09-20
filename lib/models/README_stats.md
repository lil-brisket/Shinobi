# Stat System Documentation

## Overview

The stat system implements a comprehensive character progression system with both level-tied and trainable stats. This system is designed for a Naruto-inspired mobile MMORPG with ninja/fantasy themes.

## Architecture

### Core Classes

#### `TrainableStat`
Represents individual trainable statistics with level and XP tracking.

```dart
class TrainableStat {
  int level;  // Current level (starts at 1)
  int xp;     // Current XP progress toward next level
}
```

#### `PlayerStats`
Main container for all player statistics, including both trainable and auto-derived stats.

```dart
class PlayerStats {
  int level;                    // Player's overall level
  
  // Trainable Core Attributes
  TrainableStat str;           // Strength
  TrainableStat intl;          // Intelligence  
  TrainableStat spd;           // Speed
  TrainableStat wil;           // Willpower
  
  // Trainable Combat Offenses
  TrainableStat nin;           // Ninjutsu
  TrainableStat gen;           // Genjutsu
  TrainableStat buk;           // Bukijutsu
  TrainableStat tai;           // Taijutsu
}
```

## Stat Categories

### Level-Tied Stats (Auto-Scale)
These stats automatically scale with the player's level and cannot be directly trained:

- **HP (Health Points)**: `80 + 20*level + 6*str.level + 2*wil.level`
- **SP (Stamina Points)**: `60 + 12*level + 4*spd.level + 3*wil.level`
- **CP (Chakra Points)**: `60 + 15*level + 6*intl.level + 2*wil.level`

### Trainable Stats
These stats can be improved through training and have individual XP progression:

#### Core Attributes
- **STR (Strength)**: Affects physical damage and HP scaling
- **INT (Intelligence)**: Affects ninjutsu damage and CP scaling
- **SPD (Speed)**: Affects taijutsu damage and SP scaling
- **WIL (Willpower)**: Affects genjutsu damage and resource regeneration

#### Combat Offenses
- **NIN (Ninjutsu)**: Primary ninjutsu technique power
- **GEN (Genjutsu)**: Primary genjutsu technique power
- **BUK (Bukijutsu)**: Primary weapon technique power
- **TAI (Taijutsu)**: Primary hand-to-hand technique power

## XP and Leveling System

### XP Formula
The XP required to reach the next level follows this formula:
```
XP Required = 50 + 10*L + 2*(L*L)
```
Where L is the current level.

### Soft Cap System
Stats have a soft cap that reduces XP gain efficiency:
- **Soft Cap**: `10 + 2*playerLevel`
- **Above Soft Cap**: XP gain is reduced by 50%

### Training Mechanics
- **Base XP Gain**: Raw XP from training activities
- **Fatigue Modifier**: Multiplier for training efficiency (0.0 to 1.0)
- **Soft Cap Penalty**: 50% reduction when above soft cap
- **Final XP**: `rawXP * capMultiplier * fatigue`

## Resource Regeneration

Resources regenerate automatically over time:

- **HP Regen**: `0.2 * wil.level` per minute
- **SP Regen**: `0.3 * spd.level + 0.1 * wil.level` per minute  
- **CP Regen**: `0.35 * intl.level + 0.1 * wil.level` per minute

## Damage Calculations

Each combat style has its own damage formula:

### Ninjutsu Damage
```
damage = base * (1 + nin.level/100.0) * (1 + intl.level/120.0)
```

### Genjutsu Damage
```
damage = base * (1 + gen.level/100.0) * (1 + wil.level/120.0)
```

### Bukijutsu Damage
```
damage = base * (1 + buk.level/100.0) * (1 + str.level/120.0)
```

### Taijutsu Damage
```
damage = base * (1 + tai.level/100.0) * (1 + spd.level/120.0)
```

## Usage Examples

### Basic Training
```dart
// Train strength with 100 XP
playerStats = playerStats.applyTrainingXP(playerStats.str, 100);

// Train with fatigue penalty
playerStats = playerStats.applyTrainingXP(
  playerStats.nin, 
  200, 
  fatigue: 0.5  // 50% efficiency
);
```

### Resource Calculations
```dart
// Get current resource maximums
int maxHP = playerStats.maxHP;
int maxSP = playerStats.maxSP;
int maxCP = playerStats.maxCP;

// Get regeneration rates
double hpRegen = playerStats.hpRegenPerMin;
double spRegen = playerStats.spRegenPerMin;
double cpRegen = playerStats.cpRegenPerMin;
```

### Damage Calculations
```dart
// Calculate damage for different techniques
double ninjutsuDamage = playerStats.damageNinjutsu(100.0);
double genjutsuDamage = playerStats.damageGenjutsu(100.0);
double bukijutsuDamage = playerStats.damageBukijutsu(100.0);
double taijutsuDamage = playerStats.damageTaijutsu(100.0);
```

### XP Progress Tracking
```dart
// Check XP needed for next level
int xpNeeded = playerStats.xpToNext(playerStats.str);

// Check if stat is above soft cap
bool aboveSoftCap = playerStats.str.level > playerStats.softCap();
```

## Integration with Riverpod

The stat system integrates seamlessly with Riverpod state management:

```dart
// Provider for player stats
final playerStatsProvider = StateProvider<PlayerStats>((ref) {
  return PlayerStats(level: 1, /* ... other stats ... */);
});

// Training service
class StatTrainingService {
  static PlayerStats trainStat(
    PlayerStats currentStats, 
    String statType, 
    int xp, 
    {double fatigue = 1.0}
  ) {
    // Implementation handles stat type mapping and training
  }
}
```

## Testing

The stat system includes comprehensive unit tests covering:
- Resource calculations
- XP progression
- Soft cap mechanics
- Damage formulas
- Regeneration rates
- Level-up mechanics

Run tests with:
```bash
flutter test test/stat_system_test.dart
```

## Performance Considerations

- All calculations are performed using getters for optimal performance
- Stat updates return new instances (immutable design)
- XP calculations are cached during training sessions
- Damage calculations are optimized for real-time combat

## Future Enhancements

Potential areas for expansion:
- Stat bonuses from equipment
- Temporary stat boosts from consumables
- Stat decay over time
- Prestige/rebirth systems
- Stat caps and diminishing returns
- Specialization trees
