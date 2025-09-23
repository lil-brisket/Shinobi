import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_screen.dart';
import 'battle_models.dart';

/// Example of how to integrate the battle system into your app
/// This shows how to navigate to the battle screen and configure battles
class BattleExample extends ConsumerWidget {
  const BattleExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle System Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Battle System Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BattleScreen(),
                  ),
                );
              },
              child: const Text('Start Battle'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Features:\n'
                '• 5×12 grid combat\n'
                '• Turn-based gameplay\n'
                '• Movement (3 tiles max)\n'
                '• Punch adjacent enemies\n'
                '• Heal with CP cost\n'
                '• Flee with chance calculation\n'
                '• Enemy AI\n'
                '• Battle log\n'
                '• Responsive UI',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of custom battle configuration
class CustomBattleConfig {
  static BattleConfig createEasyBattle() {
    return BattleConfig(
      players: [
        Entity(
          id: 'P1',
          name: 'Hero',
          isPlayerControlled: true,
          pos: const Position(row: 2, col: 2),
          hp: 150,
          hpMax: 150,
          cp: 50,
          cpMax: 50,
          sp: 60,
          spMax: 60,
          str: 8,
          spd: 10,
          intStat: 7,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
      ],
      enemies: [
        Entity(
          id: 'E1',
          name: 'Goblin',
          isPlayerControlled: false,
          pos: const Position(row: 2, col: 8),
          hp: 60,
          hpMax: 60,
          cp: 0,
          cpMax: 0,
          sp: 20,
          spMax: 20,
          str: 4,
          spd: 6,
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
      ],
      rows: 5,
      cols: 12,
      rngSeed: 123,
    );
  }

  static BattleConfig createHardBattle() {
    return BattleConfig(
      players: [
        Entity(
          id: 'P1',
          name: 'Warrior',
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
          name: 'Orc',
          isPlayerControlled: false,
          pos: const Position(row: 1, col: 9),
          hp: 120,
          hpMax: 120,
          cp: 0,
          cpMax: 0,
          sp: 40,
          spMax: 40,
          str: 8,
          spd: 5,
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
        Entity(
          id: 'E2',
          name: 'Goblin',
          isPlayerControlled: false,
          pos: const Position(row: 3, col: 8),
          hp: 80,
          hpMax: 80,
          cp: 0,
          cpMax: 0,
          sp: 25,
          spMax: 25,
          str: 5,
          spd: 8,
          intStat: 0,
          wil: 4,
          ap: 100,
          apMax: 100,
        ),
      ],
      rows: 5,
      cols: 12,
      rngSeed: 456,
    );
  }
}
