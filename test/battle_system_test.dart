import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/features/battle/battle_models.dart';
import '../lib/features/battle/battle_controller.dart';

void main() {
  group('Battle System Tests', () {
    late BattleController controller;
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(battleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize battle state correctly', () {
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

      expect(state.rows, equals(5));
      expect(state.cols, equals(12));
      expect(state.players.length, equals(1));
      expect(state.enemies.length, equals(1));
      expect(state.turnOrder.length, equals(2));
      expect(state.activeEntityId, equals('P1')); // Player has higher speed
      expect(state.phase, equals(BattlePhase.selectingAction));
      expect(state.log.isNotEmpty, isTrue);
    });

    test('should create correct turn order based on speed', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Fast Player',
            isPlayerControlled: true,
            pos: const Position(row: 0, col: 0),
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
            name: 'Slow Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 0, col: 1),
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
      final state = controller.state;

      expect(state.turnOrder.first, equals('P1')); // Fast player goes first
      expect(state.activeEntityId, equals('P1'));
    });

    test('should place entities on correct tiles', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
            isPlayerControlled: true,
            pos: const Position(row: 2, col: 3),
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
      final state = controller.state;

      expect(state.tiles[2][3].entityId, equals('P1'));
      expect(state.tiles[0][0].entityId, isNull);
    });

    test('should calculate adjacent enemies correctly', () {
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
            name: 'Adjacent Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 2, col: 3), // Right of player
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
          Entity(
            id: 'E2',
            name: 'Distant Enemy',
            isPlayerControlled: false,
            pos: const Position(row: 0, col: 0), // Far from player
            hp: 80,
            hpMax: 80,
            cp: 0,
            cpMax: 0,
            sp: 25,
            spMax: 25,
            str: 4,
            spd: 4,
            intStat: 0,
            wil: 2,
            ap: 100,
            apMax: 100,
          ),
        ],
      );

      controller.startBattle(config);
      
      final adjacent = controller.adjacentEnemies('P1');
      expect(adjacent.length, equals(1));
      expect(adjacent.first.id, equals('E1'));
    });

    test('should validate heal action correctly', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
            isPlayerControlled: true,
            pos: const Position(row: 2, col: 2),
            hp: 50,
            hpMax: 100,
            cp: 15, // Enough CP
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
      final initialState = controller.state;
      
      controller.actHeal();
      final stateAfterHeal = controller.state;
      
      final playerAfterHeal = stateAfterHeal.players.first;
      expect(playerAfterHeal.cp, lessThan(initialState.players.first.cp)); // CP consumed
      expect(playerAfterHeal.hp, greaterThan(initialState.players.first.hp)); // HP increased
      expect(stateAfterHeal.log.length, greaterThan(initialState.log.length)); // Log entry added
    });

    test('should prevent heal with insufficient CP', () {
      final config = BattleConfig(
        players: [
          Entity(
            id: 'P1',
            name: 'Player',
            isPlayerControlled: true,
            pos: const Position(row: 2, col: 2),
            hp: 50,
            hpMax: 100,
            cp: 5, // Not enough CP
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
      final initialState = controller.state;
      
      controller.actHeal();
      final stateAfterHeal = controller.state;
      
      final playerAfterHeal = stateAfterHeal.players.first;
      expect(playerAfterHeal.cp, equals(initialState.players.first.cp)); // CP unchanged
      expect(playerAfterHeal.hp, equals(initialState.players.first.hp)); // HP unchanged
      expect(stateAfterHeal.log.last, contains('Not enough CP')); // Error message
    });

    test('should end battle when all enemies are defeated', () {
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
            name: 'Weak Enemy',
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
      
      // Punch the weak enemy
      controller.actPunch('E1');
      
      final state = controller.state;
      expect(state.phase, equals(BattlePhase.ended));
      expect(state.livingEnemies.isEmpty, isTrue);
      expect(state.log.any((msg) => msg.contains('Victory')), isTrue);
    });
  });
}
