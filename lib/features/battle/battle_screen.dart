import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_controller.dart';
import 'battle_widgets.dart';
import 'enhanced_battle_log_widgets.dart';

/// Main battle screen widget
class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  bool _showDebugCoords = false;

  @override
  void initState() {
    super.initState();
    // Battle is now started from the battle grounds screen
    // No need to auto-start here
  }

  @override
  Widget build(BuildContext context) {
    final battleState = ref.watch(battleProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(BattleStrings.battleTitle),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Turn indicator with debug info
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: TurnIndicator()),
                if (kShowTurnDebug) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Round ${battleState.roundNumber} • Turn #${battleState.turnIndexInRound + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Debug toggle
          PopupMenuButton<bool>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                _showDebugCoords = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: _showDebugCoords,
                child: Row(
                  children: [
                    Checkbox(
                      value: _showDebugCoords,
                      onChanged: (value) {
                        setState(() {
                          _showDebugCoords = value ?? false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Text(BattleStrings.debugMode),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBattleContent(battleState),
    );
  }

  Widget _buildBattleContent(BattleState battleState) {
    // Check if battle has been started
    if (battleState.players.isEmpty && battleState.enemies.isEmpty) {
      return _buildNoBattleScreen();
    }
    
    if (battleState.isBattleEnded) {
      return _buildEndGameScreen();
    }
    
    return _buildBattleScreen();
  }

  Widget _buildNoBattleScreen() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_martial_arts,
              size: 80,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'No Battle Active',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Return to the Battle Grounds to start a fight!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Battle Grounds'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleScreen() {
    final battleState = ref.watch(battleProvider);
    
    return Row(
      children: [
        // Main battle area - expanded to take most space
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: BattleGrid(showDebugCoords: _showDebugCoords),
              ),
              
              // Collapsible battle log
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: BattleLogPanel(
                  log: battleState.log,
                  rounds: battleState.rounds,
                ),
              ),
              
              // Action panel with HUD and buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: ActionPanel(),
              ),
            ],
          ),
        ),
        
        // Enemy status panel
        if (battleState.livingEnemies.isNotEmpty)
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enemies',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: battleState.livingEnemies.length,
                      itemBuilder: (context, index) {
                        final enemy = battleState.livingEnemies[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: EntityStatus(entityId: enemy.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEndGameScreen() {
    final battleState = ref.watch(battleProvider);
    final theme = Theme.of(context);
    
    String result;
    Color resultColor;
    IconData resultIcon;
    
    if (battleState.livingPlayers.isEmpty) {
      result = BattleStrings.defeat;
      resultColor = Colors.red;
      resultIcon = Icons.sentiment_very_dissatisfied;
    } else {
      result = BattleStrings.victory;
      resultColor = Colors.green;
      resultIcon = Icons.celebration;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              resultIcon,
              size: 80,
              color: resultColor,
            ),
            const SizedBox(height: 24),
            Text(
              result,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: resultColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Battle summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battle Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Survivors
                  Text(
                    'Survivors:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  ...battleState.livingEntities.map((entity) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Row(
                      children: [
                        EntityChip(
                          entity: entity,
                          isActive: false,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${entity.name} (HP: ${entity.hp}/${entity.hpMax})',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Back to battle grounds button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Battle Grounds'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Battle screen with custom routing (if needed)
class BattleScreenRoute extends StatelessWidget {
  const BattleScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const BattleScreen();
  }
}
