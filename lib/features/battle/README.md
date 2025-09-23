# Battle System

A comprehensive turn-based battle system for Flutter games using Riverpod state management.

## Features

- **5×12 Grid Combat**: Responsive grid layout that fits on mobile screens
- **Turn-Based Gameplay**: Deterministic turn order based on effective speed with diminishing returns
- **Movement System**: Move up to 3 tiles per turn (Manhattan distance)
- **Combat Actions**: Punch, Heal, Flee with sophisticated damage calculations
- **Nonlinear Formulas**: Advanced stat curves with configurable diminishing returns
- **Balance Configuration**: Centralized tuning for all combat parameters and stat caps
- **Damage Mitigation**: Willpower stat provides damage reduction against attacks
- **Critical Hits**: 5% crit chance with 2x damage multiplier
- **Enemy AI**: Simple AI that moves toward players and attacks when adjacent
- **Enhanced Battle Log**: Real-time log with round-based tracking and detailed action history
- **Round Management**: Automatic round detection and comprehensive round summaries
- **Responsive UI**: Adapts to different screen sizes with toggleable log views
- **Debug Mode**: Optional coordinate display and turn/round debugging

## Quick Start

### 1. Basic Usage

```dart
import 'package:flutter/material.dart';
import 'features/battle/battle_screen.dart';

// Navigate to battle screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const BattleScreen()),
);
```

### 2. Custom Battle Configuration

```dart
import 'features/battle/battle_models.dart';
import 'features/battle/battle_controller.dart';

final customConfig = BattleConfig(
  players: [
    Entity(
      id: 'P1',
      name: 'Hero',
      isPlayerControlled: true,
      pos: const Position(row: 2, col: 2),
      hp: 100,
      hpMax: 100,
      cp: 30,
      cpMax: 30,
      sp: 50,
      spMax: 50,
      str: 6,
      spd: 7,
      intStat: 5,
    ),
  ],
  enemies: [
    Entity(
      id: 'E1',
      name: 'Goblin',
      isPlayerControlled: false,
      pos: const Position(row: 2, col: 8),
      hp: 90,
      hpMax: 90,
      cp: 0,
      cpMax: 0,
      sp: 30,
      spMax: 30,
      str: 5,
      spd: 5,
      intStat: 0,
    ),
  ],
  rows: 5,
  cols: 12,
  rngSeed: 42,
);

// Start battle with custom config
ref.read(battleProvider.notifier).startBattle(customConfig);
```

## Architecture

### Core Components

1. **BattleState**: Immutable state containing all battle data and round tracking
2. **BattleController**: StateNotifier managing game logic, state updates, and round transitions
3. **BattleScreen**: Main UI screen with grid, action panel, and enhanced battle log
4. **BattleWidgets**: Reusable UI components (HP bars, entity chips, etc.)
5. **EnhancedBattleLog**: Advanced log viewer with rounds view and detailed action tracking

### Key Models

- **Entity**: Represents players and enemies with stats and position
- **Tile**: Individual grid cell with entity and highlight information
- **Position**: Grid coordinates (row, col)
- **BattlePhase**: Current battle state (selectingAction, selectingTile, resolving, ended)
- **BattleLogEntry**: Detailed action log with actor, target, damage/heal amounts, and timestamps
- **RoundLog**: Complete round data with entries, summary, and timing
- **RoundSummary**: Statistical summary of round actions (damage, healing, defeats, action count)

## Game Rules

### Turn System
- Turn order determined by entity speed (highest first)
- Ties broken by entity ID
- Only living entities can take turns

### Movement
- Maximum 3 tiles per turn (Manhattan distance)
- No diagonal movement
- Cannot move through occupied tiles
- Movement and action are separate (can do both in one turn)

### Combat Actions

#### Punch
- Only works on orthogonally adjacent enemies
- Damage: `max(1, str * 5 + random(0-3))`
- Automatically removes defeated entities

#### Heal
- Self-target only
- Cost: 10 CP
- Heal amount: `max(5, intStat * 8 + random(0-5))`
- Blocked if insufficient CP

#### Flee
- Success chance: `50% + (player_spd - avg_enemy_spd) * 1%`
- Clamped between 10% and 90%
- Ends battle on success

### Enemy AI
- Attacks adjacent players (targets weakest by HP)
- Moves toward closest player (prefers row movement)
- 5% chance to flee if outnumbered by 2+
- Automatically executes actions on enemy turns

## Battle Formulas System

The battle system uses sophisticated nonlinear formulas for balanced and engaging combat mechanics.

### Balance Configuration

All combat parameters are centralized in `BalanceConfig` for easy tuning:

```dart
class BalanceConfig {
  // Stat caps (adjust anytime)
  static const int capSTR = 500000;
  static const int capINT = 500000;
  static const int capSPD = 500000;
  static const int capWIL = 500000;

  // Curve parameters (knee = diminishing returns start, exp = curve steepness)
  static const double kneeSTR = 30000;
  static const double kneeINT = 30000;
  static const double kneeSPD = 25000;
  static const double kneeWIL = 25000;
  static const double expSTR = 1.4;
  static const double expINT = 1.4;
  static const double expSPD = 1.3;
  static const double expWIL = 1.2;

  // Damage/heal scaling
  static const double dmgPerEffSTR = 5.0;
  static const double mitPerEffWIL = 1.6;
  static const double healPerEffINT = 8.0;

  // Combat mechanics
  static const double critChance = 0.05;      // 5%
  static const double critMultiplier = 2.0;
  static const int healCpCost = 10;
}
```

### Nonlinear Stat Curves

Stats use diminishing returns curves to prevent runaway scaling:

- **Below knee**: Growth feels linear and rewarding
- **Above knee**: Curve saturates smoothly, preventing overpowered stats
- **Formula**: `eff = raw^exp / (raw^exp + knee^exp) * cap`

### Combat Formulas

#### Damage Calculation
```dart
damage = max(1, (effSTR(attacker.str) * 5.0 - effWIL(defender.wil) * 1.6) + variance)
if (crit) damage *= 2.0
```

#### Heal Calculation
```dart
heal = max(5, effINT(caster.intStat) * 8.0 + variance)
```

#### Flee Chance
```dart
chance = clamp(0.1, 0.9, 0.5 + (effSPD(fleeEntity) - avgEnemySPD) * 0.01)
```

#### Turn Order
Entities are sorted by effective speed (descending), with ID as tiebreaker.

### Usage Examples

```dart
// Calculate damage with RNG injection
final damage = BattleFormulas.calcDamage(
  attacker: player,
  defender: enemy,
  rngIntInclusive: (min, max) => rng.nextInt(max - min + 1) + min,
  rngRollUnder: (p) => rng.nextDouble() < p,
);

// Get effective stats for UI display
final effStats = BattleFormulas.getEffectiveStats(entity);
print('Effective STR: ${effStats['STR']}');

// Calculate turn order
final orderedEntities = BattleFormulas.calcTurnOrder(allEntities);
```

### Round-Based Logging System
- **Automatic Round Detection**: New rounds begin when turn order cycles back to the first living entity
- **Detailed Action Logging**: Every action (move, punch, heal, flee) is recorded with timestamps and metadata
- **Round Summaries**: Each round tracks total damage, healing, defeated entities, and action counts
- **Dual Log Views**: Toggle between compact rolling log and detailed rounds view
- **Copy Functions**: Copy round summaries or full battle logs to clipboard
- **Legacy Compatibility**: Original simple log format maintained for backward compatibility

## API Reference

### BattleController Methods

```dart
// Battle management
startBattle(BattleConfig config)
endTurn()
nextTurn()

// Action modes
toggleMoveMode()
togglePunchMode()

// Actions
selectTile(int row, int col)
actPunch(String targetId)
actHeal()
actFlee()

// Helpers
reachableTilesFor(String entityId, int range)
adjacentEnemies(String entityId)
bool get isPlayersTurn
```

### State Properties

```dart
// Grid
int rows, cols
List<List<Tile>> tiles

// Entities
List<Entity> players, enemies
List<Entity> allEntities
Entity? activeEntity

// Turn management
List<String> turnOrder
int currentTurnIndex
String activeEntityId
bool isPlayersTurn

// Battle state
BattlePhase phase
List<String> log
bool isBattleEnded
```

## Customization

### UI Theming
The battle system respects your app's theme. Key colors used:
- Player entities: Blue
- Enemy entities: Red
- Move highlights: Green
- Target highlights: Red
- HP bars: Red
- CP bars: Blue

### Adding New Actions
1. Add action to `BattlePhase` enum if needed
2. Implement logic in `BattleController`
3. Add UI button in `ActionPanel`
4. Update validation logic

### Custom Entity Stats
The `Entity` model supports:
- Basic stats: HP, CP, SP (stamina)
- Combat stats: STR (strength), SPD (speed), INT (intelligence)
- Position and control flags

## Testing

Run the test suite:
```bash
flutter test test/battle_system_test.dart
```

Tests cover:
- Battle initialization
- Turn order calculation
- Entity placement
- Action validation
- Combat mechanics
- Battle end conditions

## Performance Notes

- Grid rendering uses `GridView.builder` for efficient scrolling
- State updates are immutable for predictable behavior
- Entity lookups are optimized with proper data structures
- Battle log limits to recent entries to prevent memory issues

## Troubleshooting

### Common Issues

1. **Grid not showing**: Ensure proper screen size constraints
2. **Actions not working**: Check if it's the player's turn
3. **Enemies not moving**: Verify AI logic in `_executeEnemyTurn()`
4. **State not updating**: Ensure proper Riverpod provider usage

### Debug Mode
Enable debug coordinates in the app bar menu to see tile positions for development.

## Future Enhancements

Potential additions:
- Pathfinding for complex movement
- Status effects (poison, buffs)
- Spell system with area effects
- Animation system for actions
- Sound effects integration
- Save/load battle states
- Multiplayer support
