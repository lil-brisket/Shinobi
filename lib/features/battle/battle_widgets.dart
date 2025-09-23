import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_controller.dart';

/// HP/CP bar widget
class StatBar extends StatelessWidget {
  final int current;
  final int max;
  final Color color;
  final String label;
  final double width;
  final double height;

  const StatBar({
    super.key,
    required this.current,
    required this.max,
    required this.color,
    required this.label,
    this.width = 100,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = max > 0 ? current / max : 0.0;
    
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: $current/$max',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Container(
            width: width,
            height: height - 16,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entity chip widget showing entity info
class EntityChip extends StatelessWidget {
  final Entity entity;
  final bool isActive;
  final VoidCallback? onTap;

  const EntityChip({
    super.key,
    required this.entity,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlayer = entity.isPlayerControlled;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPlayer ? Colors.blue : Colors.red,
          border: Border.all(
            color: isActive ? Colors.yellow : Colors.white,
            width: isActive ? 3 : 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.yellow.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Center(
          child: Text(
            entity.name.substring(0, 1).toUpperCase(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Battle log widget
class BattleLog extends StatelessWidget {
  final List<String> log;
  final int maxLines;

  const BattleLog({
    super.key,
    required this.log,
    this.maxLines = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recentLog = log.length > maxLines 
        ? log.sublist(log.length - maxLines)
        : log;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Battle Log',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: recentLog.length,
              itemBuilder: (context, index) {
                final message = recentLog[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    message,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Turn indicator widget
class TurnIndicator extends ConsumerWidget {
  const TurnIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider);
    final activeEntity = battleState.activeEntity;
    final theme = Theme.of(context);

    if (activeEntity == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: activeEntity.isPlayerControlled 
            ? Colors.blue.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: activeEntity.isPlayerControlled ? Colors.blue : Colors.red,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            activeEntity.isPlayerControlled ? Icons.person : Icons.computer,
            size: 16,
            color: activeEntity.isPlayerControlled ? Colors.blue : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            activeEntity.isPlayerControlled 
                ? BattleStrings.yourTurn
                : '${BattleStrings.enemyTurn}: ${activeEntity.name}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: activeEntity.isPlayerControlled ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile widget for the battle grid
class BattleTile extends ConsumerWidget {
  final int row;
  final int col;
  final Tile tile;
  final VoidCallback? onTap;
  final bool showDebugCoords;

  const BattleTile({
    super.key,
    required this.row,
    required this.col,
    required this.tile,
    this.onTap,
    this.showDebugCoords = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final battleState = ref.watch(battleProvider);
    
    // Get entity on this tile
    final entity = tile.entityId != null
        ? battleState.allEntities.where((e) => e.id == tile.entityId).firstOrNull
        : null;

    // Determine tile color based on highlight
    Color tileColor = theme.cardColor;
    Color borderColor = theme.dividerColor;
    double borderWidth = 0.5;

    switch (tile.highlight) {
      case TileHighlight.move:
        tileColor = Colors.green.withOpacity(0.3);
        borderColor = Colors.green;
        borderWidth = 2;
        break;
      case TileHighlight.target:
        tileColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
        borderWidth = 2;
        break;
      case TileHighlight.blocked:
        tileColor = Colors.grey.withOpacity(0.5);
        borderColor = Colors.grey;
        borderWidth = 1;
        break;
      case TileHighlight.none:
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Stack(
          children: [
            // Debug coordinates
            if (showDebugCoords)
              Positioned(
                top: 2,
                left: 2,
                child: Text(
                  '$row,$col',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                ),
              ),
            // Entity
            if (entity != null)
              Center(
                child: EntityChip(
                  entity: entity,
                  isActive: entity.id == battleState.activeEntityId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Action button widget
class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color? color;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.enabled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}

/// Entity status widget showing HP/CP bars
class EntityStatus extends ConsumerWidget {
  final String entityId;

  const EntityStatus({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider);
    final entity = battleState.allEntities.where((e) => e.id == entityId).firstOrNull;
    
    if (entity == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StatBar(
            current: entity.hp,
            max: entity.hpMax,
            color: Colors.red,
            label: BattleStrings.hp,
            width: 120,
          ),
          const SizedBox(height: 4),
          StatBar(
            current: entity.cp,
            max: entity.cpMax,
            color: Colors.blue,
            label: BattleStrings.cp,
            width: 120,
          ),
        ],
      ),
    );
  }
}

/// Battle grid widget
class BattleGrid extends ConsumerWidget {
  final bool showDebugCoords;

  const BattleGrid({
    super.key,
    this.showDebugCoords = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider);
    final battleController = ref.read(battleProvider.notifier);
    
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Grid
          Expanded(
            child: AspectRatio(
              aspectRatio: battleState.cols / battleState.rows,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: battleState.cols,
                  childAspectRatio: 1,
                ),
                itemCount: battleState.rows * battleState.cols,
                itemBuilder: (context, index) {
                  final row = index ~/ battleState.cols;
                  final col = index % battleState.cols;
                  final tile = battleState.tiles[row][col];
                  
                  return BattleTile(
                    row: row,
                    col: col,
                    tile: tile,
                    showDebugCoords: showDebugCoords,
                    onTap: () => battleController.selectTile(row, col),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action panel widget
class ActionPanel extends ConsumerWidget {
  const ActionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider);
    final battleController = ref.read(battleProvider.notifier);
    final activeEntity = battleState.activeEntity;
    
    if (activeEntity == null) {
      return const SizedBox.shrink();
    }

    final isPlayerTurn = battleState.isPlayersTurn;
    final canMove = isPlayerTurn && battleState.phase == BattlePhase.selectingAction;
    final canPunch = isPlayerTurn && 
        battleState.phase == BattlePhase.selectingAction &&
        battleController.adjacentEnemies(activeEntity.id).isNotEmpty;
    final canHeal = isPlayerTurn && 
        battleState.phase == BattlePhase.selectingAction &&
        activeEntity.cp >= 10;
    final canFlee = isPlayerTurn && battleState.phase == BattlePhase.selectingAction;
    final canEndTurn = isPlayerTurn && battleState.phase == BattlePhase.selectingAction;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active entity status
          if (activeEntity != null)
            EntityStatus(entityId: activeEntity.id),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: BattleStrings.move,
                  icon: Icons.directions_run,
                  onPressed: canMove ? () => battleController.toggleMoveMode() : null,
                  enabled: canMove,
                  color: battleState.isMoveMode ? Colors.green : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
                  text: BattleStrings.punch,
                  icon: Icons.sports_mma,
                  onPressed: canPunch ? () => battleController.togglePunchMode() : null,
                  enabled: canPunch,
                  color: battleState.isPunchMode ? Colors.red : null,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: BattleStrings.heal,
                  icon: Icons.healing,
                  onPressed: canHeal ? () => battleController.actHeal() : null,
                  enabled: canHeal,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
                  text: BattleStrings.flee,
                  icon: Icons.exit_to_app,
                  onPressed: canFlee ? () => battleController.actFlee() : null,
                  enabled: canFlee,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          ActionButton(
            text: BattleStrings.endTurn,
            icon: Icons.skip_next,
            onPressed: canEndTurn ? () => battleController.endTurn() : null,
            enabled: canEndTurn,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
