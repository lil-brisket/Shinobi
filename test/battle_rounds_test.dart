import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/features/battle/battle_models.dart';
import '../lib/features/battle/battle_controller.dart';

void main() {
  group('Round-Based Battle Logging Tests', () {
    late BattleController controller;
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(battleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with first round', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [
          Entity(
            id: 'E1',
            name: 'Enemy',
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
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      final state = controller.state;

      expect(state.roundNumber, equals(1));
      expect(state.turnIndexInRound, equals(0));
      expect(state.rounds.length, equals(1));
      expect(state.rounds.first.round, equals(1));
      expect(state.rounds.first.isComplete, isFalse);
    });

    test('should record battle actions in log entries', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [
          Entity(
            id: 'E1',
            name: 'Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 2, col: 3), // Adjacent to player
            hp: 90,
            hpMax: 90,
            cp: 0,
            cpMax: 0,
            sp: 30,
            spMax: 30,
            str: 5,
            spd: 5,
            intStat: 0,
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      
      // Punch the enemy
      controller.actPunch('E1');
      
      final state = controller.state;
      final currentRound = state.rounds.last;
      
      // Should have start round entry, punch entry, and defeat entry
      expect(currentRound.entries.length, greaterThanOrEqualTo(2));
      
      final punchEntry = currentRound.entries
          .where((e) => e.action == BattleAction.punch)
          .firstOrNull;
      
      expect(punchEntry, isNotNull);
      expect(punchEntry!.actorId, equals('P1'));
      expect(punchEntry.targetId, equals('E1'));
      expect(punchEntry.damage, isNotNull);
      expect(punchEntry.message, contains('punched'));
    });

    test('should track round summaries correctly', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [
          Entity(
            id: 'E1',
            name: 'Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 2, col: 3),
            hp: 1, // Very low HP
            hpMax: 90,
            cp: 0,
            cpMax: 0,
            sp: 30,
            spMax: 30,
            str: 5,
            spd: 5,
            intStat: 0,
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      
      // Punch to defeat enemy
      controller.actPunch('E1');
      
      final state = controller.state;
      final currentRound = state.rounds.last;
      final summary = currentRound.summary;
      
      expect(summary.damageDoneByEntity.containsKey('P1'), isTrue);
      expect(summary.damageDoneByEntity['P1'], greaterThan(0));
      expect(summary.defeatedEntities.contains('E1'), isTrue);
      expect(summary.actionsCount, greaterThan(0));
    });

    test('should start new round when turn order cycles', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
            isPlayerControlled: true,
            pos: const Position(row: 2, col: 2),
            hp: 100,
            hpMax: 100,
            cp: 30,
            cpMax: 30,
            sp: 50,
            spMax: 50,
            str: 6,
            spd: 10, // Highest speed
            intStat: 5,
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [
          Entity(
            id: 'E1',
            name: 'Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 2, col: 8),
            hp: 90,
            hpMax: 90,
            cp: 0,
            cpMax: 0,
            sp: 30,
            spMax: 30,
            str: 5,
            spd: 5, // Lower speed
            intStat: 0,
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      final initialState = controller.state;
      
      // Player should go first (higher speed)
      expect(initialState.activeEntityId, equals('P1'));
      expect(initialState.roundNumber, equals(1));
      
      // End player turn (this will auto-execute enemy turn and come back to player)
      controller.endTurn();
      
      // Should now be in round 2 since the turn order cycled back to player
      final afterTurnCycle = controller.state;
      expect(afterTurnCycle.activeEntityId, equals('P1')); // Back to player
      expect(afterTurnCycle.roundNumber, equals(2));
      expect(afterTurnCycle.rounds.length, equals(2));
      expect(afterTurnCycle.rounds.first.isComplete, isTrue); // Round 1 completed
    });

    test('should record heal actions with proper data', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
            isPlayerControlled: true,
            pos: const Position(row: 2, col: 2),
            hp: 50,
            hpMax: 100,
            cp: 30, // Enough CP
            cpMax: 30,
            sp: 50,
            spMax: 50,
            str: 6,
            spd: 7,
            intStat: 5,
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [],
      );

      controller.startBattle(config);
      
      // Heal
      controller.actHeal();
      
      final state = controller.state;
      final currentRound = state.rounds.last;
      
      final healEntry = currentRound.entries
          .where((e) => e.action == BattleAction.heal)
          .firstOrNull;
      
      expect(healEntry, isNotNull);
      expect(healEntry!.actorId, equals('P1'));
      expect(healEntry.heal, isNotNull);
      expect(healEntry.heal, greaterThan(0));
      expect(healEntry.message, contains('healed'));
    });

    test('should record move actions with position data', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [],
      );

      controller.startBattle(config);
      
      // Move to adjacent tile
      controller.toggleMoveMode();
      controller.selectTile(2, 3);
      
      final state = controller.state;
      final currentRound = state.rounds.last;
      
      final moveEntry = currentRound.entries
          .where((e) => e.action == BattleAction.move)
          .firstOrNull;
      
      expect(moveEntry, isNotNull);
      expect(moveEntry!.actorId, equals('P1'));
      expect(moveEntry.fromPos, equals((row: 2, col: 2)));
      expect(moveEntry.toPos, equals((row: 2, col: 3)));
      expect(moveEntry.message, contains('moved to'));
    });

    test('should end battle with proper round closure', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [
          Entity(
            id: 'E1',
            name: 'Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 2, col: 3),
            hp: 1, // Very low HP
            hpMax: 90,
            cp: 0,
            cpMax: 0,
            sp: 30,
            spMax: 30,
            str: 5,
            spd: 5,
            intStat: 0,
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      
      // Punch to defeat enemy and end battle
      controller.actPunch('E1');
      
      final state = controller.state;
      
      expect(state.phase, equals(BattlePhase.ended));
      expect(state.rounds.length, equals(1));
      expect(state.rounds.first.isComplete, isTrue);
      expect(state.rounds.first.endedAt, isNotNull);
    });

    test('should maintain legacy log compatibility', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
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
            wil: 4,
            ap: 100,
            apMax: 100,
          ),
        ],
        enemies: [],
      );

      controller.startBattle(config);
      
      // Perform some actions
      controller.actHeal();
      
      final state = controller.state;
      
      // Legacy log should still be populated
      expect(state.log.isNotEmpty, isTrue);
      expect(state.log.any((msg) => msg.contains('healed')), isTrue);
      
      // Legacy log should be limited to 100 entries
      expect(state.log.length, lessThanOrEqualTo(100));
    });
  });
}
