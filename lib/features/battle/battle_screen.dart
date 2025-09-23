import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_controller.dart';
import 'battle_widgets.dart';
import 'battle_formulas.dart';
import '../../models/battle_costs.dart';
import '../../models/stats.dart';
import '../../widgets/bars.dart';
import '../../controllers/providers.dart';

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

    // Check if battle is active (has players/enemies and not ended)
    final isBattleActive = battleState.players.isNotEmpty && 
                          battleState.enemies.isNotEmpty && 
                          !battleState.isBattleEnded;

    return PopScope(
      canPop: !isBattleActive, // Prevent back navigation during active battle
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        // Show confirmation dialog if trying to leave during active battle
        if (isBattleActive) {
          _showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Battle"),
          backgroundColor: Colors.black.withOpacity(.25),
          elevation: 0,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: !isBattleActive, // Hide back button during active battle
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
    ),
    );
  }

  Widget _buildBattleContent(BattleState battleState) {
    // Check if battle has been started
    if (battleState.players.isEmpty && battleState.enemies.isEmpty) {
      return _buildNoBattleScreen();
    }
    
    // Show battle screen even when ended, but show popup
    if (battleState.isBattleEnded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBattleResultDialog(battleState);
      });
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
    final ctrl = ref.read(battleProvider.notifier);
    final p = battleState.livingPlayers.isNotEmpty ? battleState.livingPlayers.first : null;

    if (p == null) return const SizedBox.shrink();

    // Choose a focused enemy to show bars for (first alive, or your selection)
    final enemy = battleState.livingEnemies.isNotEmpty 
        ? battleState.livingEnemies.first 
        : null;

    // Sidebar width (responsive)
    final sidebarW = MediaQuery.sizeOf(context).width >= 1100 ? 320.0 : 280.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF141824), Color(0xFF0E0F18)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Battle"),
          backgroundColor: Colors.black.withOpacity(.25),
          elevation: 0,
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT: battlefield + actions (expands)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // GRID on top
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B29),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: _Battlefield(showDebugCoords: _showDebugCoords),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // STATUS STRIP (Player + Enemy) ABOVE BASIC MOVES
                    if (enemy != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: StatusCard(
                              name: p.name,
                              hp: p.hp, maxHp: p.hpMax,
                              cp: p.cp, maxCp: p.cpMax,
                              sp: p.sp, maxSp: p.spMax,
                              ap: p.ap, maxAp: p.apMax,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatusCard(
                              name: enemy.name,
                              hp: enemy.hp, maxHp: enemy.hpMax,
                              cp: enemy.cp, maxCp: enemy.cpMax,
                              sp: enemy.sp, maxSp: enemy.spMax,
                              ap: enemy.ap, maxAp: enemy.apMax,
                            ),
                          ),
                        ],
                      )
                    else
                      StatusCard(
                        name: p.name,
                        hp: p.hp, maxHp: p.hpMax,
                        cp: p.cp, maxCp: p.cpMax,
                        sp: p.sp, maxSp: p.spMax,
                        ap: p.ap, maxAp: p.apMax,
                      ),
                    const SizedBox(height: 12),

                    // BASIC MOVES
                    _BasicActions(
                      battleState: battleState,
                      canAfford: (k) => p.ap >= k.ap && p.cp >= k.cp && p.sp >= k.sp,
                      onMove: () {
                        // If already in move mode, cancel it; otherwise enter move mode
                        if (battleState.isMoveMode) {
                          ctrl.cancelCurrentMode();
                        } else {
                          ctrl.toggleMoveMode();
                        }
                      },
                      onPunch: () {
                        // If already in punch mode, cancel it; otherwise enter punch mode
                        if (battleState.isPunchMode) {
                          ctrl.cancelCurrentMode();
                        } else {
                          ctrl.togglePunchMode();
                        }
                      },
                      onHeal: () {
                        // If already in heal mode, cancel it; otherwise enter heal mode
                        if (battleState.isHealMode) {
                          ctrl.cancelCurrentMode();
                        } else {
                          ctrl.toggleHealMode();
                        }
                      },
                      onFlee: () {
                        ctrl.switchToActionMode();
                        ctrl.actFlee();
                      },
                    ),
                    const SizedBox(height: 10),

                    // JUTSU ROW (keep yours, this is a compact placeholder)
                    _JutsuRow(
                      onTap: (name) {
                        ctrl.switchToActionMode();
                        // hook into your existing jutsu logic
                      },
                    ),
                  ],
                ),
              ),
            ),

            // RIGHT: Sidebar with Enemies + Battle Log
            SizedBox(
              width: sidebarW,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF0B0D14),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Battle Log", style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F121B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: _LogList(lines: battleState.log),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Battlefield({required bool showDebugCoords}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: BattleGrid(showDebugCoords: showDebugCoords),
    );
  }

  Widget _EnemySidebar({required BattleState battleState}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enemies',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
    );
  }

  Widget _BattleLog({required BattleState battleState}) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BattleLogPanel(
        log: battleState.log,
        rounds: battleState.rounds,
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Leave Battle?'),
        content: const Text(
          'You are currently in an active battle. Leaving now will result in defeat. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay in Battle'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Exit battle screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Leave Battle'),
          ),
        ],
      ),
    );
  }

  void _showBattleResultDialog(BattleState battleState) {
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Row(
          children: [
            Icon(resultIcon, color: resultColor),
            const SizedBox(width: 12),
            Text(
              result,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: resultColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 8),
            
            ...battleState.livingEntities.map((entity) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: entity.isPlayerControlled ? Colors.blue : Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        entity.id.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entity.name} (HP: ${entity.hp}/${entity.hpMax})',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Battle stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battle Stats',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rounds: ${battleState.roundNumber}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Total Actions: ${battleState.rounds.fold(0, (sum, round) => sum + round.summary.actionsCount)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to battle grounds
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
            child: const Text('Back to Battle Grounds'),
          ),
          ElevatedButton(
            onPressed: () => _handleHealAndFightAgain(context, battleState),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
            child: const Text('Heal and Fight Again (50 Ryo)'),
          ),
        ],
      ),
    );
  }

  void _handleHealAndFightAgain(BuildContext context, BattleState battleState) async {
    final theme = Theme.of(context);
    final playerNotifier = ref.read(playerProvider.notifier);
    final battleController = ref.read(battleProvider.notifier);
    
    // Check if player has enough Ryo
    final currentPlayer = ref.read(playerProvider);
    if (currentPlayer.ryo < 50) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Insufficient Funds'),
          content: Text('You need 50 Ryo to heal and fight again. You currently have ${currentPlayer.ryo} Ryo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Close the current dialog
    Navigator.of(context).pop();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text('Healing and preparing for battle...'),
          ],
        ),
      ),
    );

    try {
      // Deduct 50 Ryo from player
      final updatedPlayer = currentPlayer.copyWith(ryo: currentPlayer.ryo - 50);
      playerNotifier.updatePlayer(updatedPlayer);

      // Heal player fully (restore all pools to maximum)
      final healedStats = currentPlayer.stats.copyWith(
        currentHP: currentPlayer.stats.maxHp,
        currentCP: currentPlayer.stats.maxChakra,
        currentSP: currentPlayer.stats.maxStamina,
      );
      final fullyHealedPlayer = updatedPlayer.copyWith(stats: healedStats);
      playerNotifier.updatePlayer(fullyHealedPlayer);

      // Create fresh battle configuration with new enemies
      final healedPlayerEntity = Entity(
        id: 'P1',
        name: fullyHealedPlayer.name,
        isPlayerControlled: true,
        pos: const Position(row: 2, col: 2),
        hp: fullyHealedPlayer.stats.currentHP ?? 3000,
        hpMax: fullyHealedPlayer.stats.maxHp,
        cp: fullyHealedPlayer.stats.currentCP ?? 3000,
        cpMax: fullyHealedPlayer.stats.maxChakra,
        sp: fullyHealedPlayer.stats.currentSP ?? 3000,
        spMax: fullyHealedPlayer.stats.maxStamina,
        str: fullyHealedPlayer.stats.str,
        spd: fullyHealedPlayer.stats.spd,
        intStat: fullyHealedPlayer.stats.intl,
        wil: fullyHealedPlayer.stats.wil,
        ap: BalanceConfig.defaultAPMax,
        apMax: BalanceConfig.defaultAPMax,
      );

      // Create fresh enemies (same as original battle config but with new IDs)
      final freshEnemies = [
        Entity(
          id: 'E1_${DateTime.now().millisecondsSinceEpoch}', // Unique ID
          name: 'Enemy 1',
          isPlayerControlled: false,
          pos: const Position(row: 2, col: 8),
          hp: 90,
          hpMax: 90,
          cp: 50,
          cpMax: 50,
          sp: 30,
          spMax: 30,
          str: 5,
          spd: 5,
          intStat: 0,
          wil: 3,
          ap: BalanceConfig.defaultAPMax,
          apMax: BalanceConfig.defaultAPMax,
        ),
        Entity(
          id: 'E2_${DateTime.now().millisecondsSinceEpoch}', // Unique ID
          name: 'Enemy 2',
          isPlayerControlled: false,
          pos: const Position(row: 1, col: 9),
          hp: 80,
          hpMax: 80,
          cp: 40,
          cpMax: 40,
          sp: 25,
          spMax: 25,
          str: 4,
          spd: 4,
          intStat: 0,
          wil: 2,
          ap: BalanceConfig.defaultAPMax,
          apMax: BalanceConfig.defaultAPMax,
        ),
      ];

      final newBattleConfig = BattleConfig(
        players: [healedPlayerEntity],
        enemies: freshEnemies, // Fresh enemies with new IDs
        rows: 5,
        cols: 12,
        rngSeed: DateTime.now().millisecondsSinceEpoch, // New seed for fresh battle
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Start new battle
      battleController.startBattle(newBattleConfig);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Healed and ready for battle! (-50 Ryo)'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class _BasicActions extends StatelessWidget {
  final BattleState battleState;
  final bool Function(ActionCosts) canAfford;
  final VoidCallback onMove;
  final VoidCallback onPunch;
  final VoidCallback onHeal;
  final VoidCallback onFlee;

  const _BasicActions({
    required this.battleState,
    required this.canAfford,
    required this.onMove,
    required this.onPunch,
    required this.onHeal,
    required this.onFlee,
  });

  Widget _btn({
    required String label,
    required IconData icon,
    required ActionCosts cost,
    required VoidCallback onTap,
    required bool enabled,
    bool isActive = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isActive 
                ? Colors.blue[700] 
                : enabled 
                    ? Colors.blueGrey.shade700 
                    : Colors.blueGrey.shade900,
            border: isActive 
                ? Border.all(color: Colors.blue[400]!, width: 2)
                : null,
            boxShadow: [
              if (enabled || isActive)
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  color: Colors.black.withOpacity(.25),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  label, 
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive ? Colors.white : null,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                if (cost.ap > 0) _chip('AP ${cost.ap}'),
                if (cost.cp > 0) _chip('CP ${cost.cp}'),
                if (cost.sp > 0) _chip('SP ${cost.sp}'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _chip(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.25),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(t, style: const TextStyle(fontSize: 11)),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(
          label: "Move",
          icon: Icons.open_with,
          cost: BattleCosts.move,
          onTap: onMove,
          enabled: canAfford(BattleCosts.move),
          isActive: battleState.isMoveMode,
        ),
        const SizedBox(width: 8),
        _btn(
          label: "Punch",
          icon: Icons.front_hand,
          cost: BattleCosts.punch,
          onTap: onPunch,
          enabled: canAfford(BattleCosts.punch),
          isActive: battleState.isPunchMode,
        ),
        const SizedBox(width: 8),
        _btn(
          label: "Heal",
          icon: Icons.healing,
          cost: BattleCosts.heal,
          onTap: onHeal,
          enabled: canAfford(BattleCosts.heal),
          isActive: battleState.isHealMode,
        ),
        const SizedBox(width: 8),
        _btn(
          label: "Flee",
          icon: Icons.directions_run,
          cost: ActionCosts(ap: BalanceConfig.costFlee, cp: 0, sp: 0),
          onTap: onFlee,
          enabled: true, // Flee is always available if you have enough AP
        ),
      ],
    );
  }
}

class _LogList extends StatefulWidget {
  final List<String> lines;
  const _LogList({required this.lines, super.key});
  @override
  State<_LogList> createState() => _LogListState();
}

class _LogListState extends State<_LogList> {
  final _ctrl = ScrollController();
  @override
  void didUpdateWidget(covariant _LogList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.hasClients) _ctrl.jumpTo(_ctrl.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _ctrl,
      itemCount: widget.lines.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(widget.lines[i]),
      ),
    );
  }
}


class _JutsuRow extends StatelessWidget {
  final void Function(String name) onTap;
  const _JutsuRow({required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final items = const ["Fireball", "Shadow Clone", "Lightning Bolt", "Earth Wall"];
    return SizedBox(
      height: 96,
      child: Row(
        children: [
          for (final name in items) ...[
            Expanded(
              child: InkWell(
                onTap: () => onTap(name),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Row(children: const [
                        _CostPill('AP 20'),
                        SizedBox(width: 6),
                        _CostPill('CP 40'),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            if (name != items.last) const SizedBox(width: 8),
          ]
        ],
      ),
    );
  }
}

class _CostPill extends StatelessWidget {
  final String text;
  const _CostPill(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.25),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
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
