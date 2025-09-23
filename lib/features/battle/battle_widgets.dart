import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_controller.dart';
import '../../models/battle_costs.dart';

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
            height: 12, // Fixed height for progress bar
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
  final int? apCost;
  final int? cpCost;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.enabled = true,
    this.color,
    this.apCost,
    this.cpCost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: enabled ? buttonColor : Colors.grey,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Main button content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Cost badges
              if (apCost != null || cpCost != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Column(
                    children: [
                      if (apCost != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${apCost}AP',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (cpCost != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${cpCost}CP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Jutsu card widget for displaying jutsu abilities
class JutsuCard extends StatelessWidget {
  final String name;
  final int cpCost;
  final int apCost;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final String? description;

  const JutsuCard({
    super.key,
    required this.name,
    required this.cpCost,
    required this.apCost,
    this.icon = Icons.auto_awesome,
    this.onPressed,
    this.enabled = true,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.8),
            Colors.blue.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 4),
                
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const Spacer(),
                
                // Cost badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (cpCost > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${cpCost}CP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (apCost > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${apCost}AP',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Collapsible battle log panel
class BattleLogPanel extends StatefulWidget {
  final List<String> log;
  final List<RoundLog> rounds;

  const BattleLogPanel({
    super.key,
    required this.log,
    required this.rounds,
  });

  @override
  State<BattleLogPanel> createState() => _BattleLogPanelState();
}

class _BattleLogPanelState extends State<BattleLogPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with toggle
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Battle Log',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (widget.log.isNotEmpty)
                    Text(
                      widget.log.last,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded content
          if (_isExpanded)
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: widget.log.length,
                itemBuilder: (context, index) {
                  final message = widget.log[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
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

/// AP bar widget
class APBar extends StatelessWidget {
  final int current;
  final int max;
  final double width;
  final double height;

  const APBar({
    super.key,
    required this.current,
    required this.max,
    this.width = 100,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? current / max : 0.0;
    
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AP: $current/$max',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: Colors.grey.shade800,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated stat bar with gradient and text overlay
class AnimatedStatBar extends StatefulWidget {
  final int current;
  final int max;
  final Color color;
  final String label;
  final double width;
  final double height;
  final Duration animationDuration;

  const AnimatedStatBar({
    super.key,
    required this.current,
    required this.max,
    required this.color,
    required this.label,
    this.width = 200,
    this.height = 24,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedStatBar> createState() => _AnimatedStatBarState();
}

class _AnimatedStatBarState extends State<AnimatedStatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.max > 0 ? widget.current / widget.max : 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    _previousValue = widget.current;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedStatBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current || oldWidget.max != widget.max) {
      _animation = Tween<double>(
        begin: _previousValue / (oldWidget.max > 0 ? oldWidget.max : 1),
        end: widget.max > 0 ? widget.current / widget.max : 0.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      
      _previousValue = widget.current;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          children: [
            // Background
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.black.withOpacity(0.3),
            ),
            // Animated fill
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: widget.width * _animation.value,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color,
                        widget.color.withOpacity(0.8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                );
              },
            ),
            // Text overlay
            Center(
              child: Text(
                '${widget.label} ${widget.current}/${widget.max}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: Offset(1, 1),
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
}

/// Player HUD with all stat bars
class PlayerHudBars extends ConsumerWidget {
  final String entityId;

  const PlayerHudBars({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Entity name
          Text(
            entity.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // HP Bar
          AnimatedStatBar(
            current: entity.hp,
            max: entity.hpMax,
            color: Colors.red,
            label: 'HP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // CP Bar
          AnimatedStatBar(
            current: entity.cp,
            max: entity.cpMax,
            color: Colors.blue,
            label: 'CP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // SP Bar
          AnimatedStatBar(
            current: entity.sp,
            max: entity.spMax,
            color: Colors.green,
            label: 'SP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // AP Bar
          AnimatedStatBar(
            current: entity.ap,
            max: entity.apMax,
            color: Colors.amber,
            label: 'AP',
            width: 200,
            height: 20,
          ),
        ],
      ),
    );
  }
}

/// Enemy HUD with all stat bars
class EnemyHudBars extends ConsumerWidget {
  final String entityId;

  const EnemyHudBars({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Entity name
          Text(
            entity.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // HP Bar
          AnimatedStatBar(
            current: entity.hp,
            max: entity.hpMax,
            color: Colors.red,
            label: 'HP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // CP Bar
          AnimatedStatBar(
            current: entity.cp,
            max: entity.cpMax,
            color: Colors.blue,
            label: 'CP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // SP Bar
          AnimatedStatBar(
            current: entity.sp,
            max: entity.spMax,
            color: Colors.green,
            label: 'SP',
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          
          // AP Bar
          AnimatedStatBar(
            current: entity.ap,
            max: entity.apMax,
            color: Colors.amber,
            label: 'AP',
            width: 200,
            height: 20,
          ),
        ],
      ),
    );
  }
}

/// Entity status widget showing HP/CP/AP bars
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entity.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          StatBar(
            current: entity.hp,
            max: entity.hpMax,
            color: Colors.red,
            label: BattleStrings.hp,
            width: 120,
          ),
          const SizedBox(height: 2),
          StatBar(
            current: entity.cp,
            max: entity.cpMax,
            color: Colors.blue,
            label: BattleStrings.cp,
            width: 120,
          ),
          const SizedBox(height: 2),
          APBar(
            current: entity.ap,
            max: entity.apMax,
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
    final canMove = isPlayerTurn && 
        battleState.phase == BattlePhase.selectingAction &&
        activeEntity.canAfford(BattleCosts.move.ap, BattleCosts.move.cp, BattleCosts.move.sp);
    final canPunch = isPlayerTurn && 
        battleState.phase == BattlePhase.selectingAction &&
        battleController.adjacentEnemies(activeEntity.id).isNotEmpty &&
        activeEntity.canAfford(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp);
    final canHeal = isPlayerTurn && 
        battleState.phase == BattlePhase.selectingAction &&
        activeEntity.canAfford(BattleCosts.heal.ap, BattleCosts.heal.cp, BattleCosts.heal.sp);
    final canEndTurn = isPlayerTurn && battleState.phase == BattlePhase.selectingAction;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, 
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141824), Color(0xFF0E0F18)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0D14),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player stats
            Text(
              activeEntity.name, 
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            
            // Stat bars
            _buildStatBar("HP", activeEntity.hp, activeEntity.hpMax, Icons.favorite, Colors.redAccent),
            const SizedBox(height: 8),
            _buildStatBar("CP", activeEntity.cp, activeEntity.cpMax, Icons.bolt, Colors.lightBlueAccent),
            const SizedBox(height: 8),
            _buildStatBar("SP", activeEntity.sp, activeEntity.spMax, Icons.run_circle, Colors.lightGreenAccent),
            const SizedBox(height: 8),
            _buildStatBar("AP", activeEntity.ap, 100, Icons.timelapse, Colors.amberAccent),

            const SizedBox(height: 12),
            
            // Basics section
            Text(
              "Basics", 
              style: TextStyle(
                color: Colors.white.withOpacity(.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            // Basic action buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: "Move",
                    icon: Icons.open_with,
                    costs: BattleCosts.move,
                    onTap: canMove ? () => battleController.toggleMoveMode() : null,
                    canAfford: canMove,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    label: "Punch",
                    icon: Icons.front_hand,
                    costs: BattleCosts.punch,
                    onTap: canPunch ? () {
                      final adjacentEnemies = battleController.adjacentEnemies(activeEntity.id);
                      if (adjacentEnemies.length == 1) {
                        battleController.actPunch(adjacentEnemies.first.id);
                      } else {
                        battleController.togglePunchMode();
                      }
                    } : null,
                    canAfford: canPunch,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    label: "Heal",
                    icon: Icons.healing,
                    costs: BattleCosts.heal,
                    onTap: canHeal ? () => battleController.actHeal() : null,
                    canAfford: canHeal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            
            // Jutsu section
            Text(
              "Jutsu", 
              style: TextStyle(
                color: Colors.white.withOpacity(.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            // Jutsu grid
            SizedBox(
              height: 90,
              child: Row(
                children: [
                  Expanded(
                    child: _buildJutsuCard(
                      label: "Fireball", 
                      ap: 15, 
                      cp: 40,
                      icon: Icons.local_fire_department,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJutsuCard(
                      label: "Shadow Clone", 
                      ap: 20, 
                      cp: 50,
                      icon: Icons.person_add,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJutsuCard(
                      label: "Lightning Bolt", 
                      ap: 20, 
                      cp: 60,
                      icon: Icons.flash_on,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJutsuCard(
                      label: "Earth Wall", 
                      ap: 20, 
                      cp: 55,
                      icon: Icons.wallpaper,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // End turn button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canEndTurn ? () => battleController.endTurn() : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("End Turn"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int cur, int max, IconData icon, Color color) {
    final pct = cur / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text("$label $cur/$max", style: const TextStyle(fontSize: 12, color: Colors.white))
        ]),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onTap,
    required ActionCosts costs,
    required IconData icon,
    required bool canAfford,
  }) {
    return InkWell(
      onTap: canAfford ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: canAfford ? Colors.blueGrey.shade700 : Colors.blueGrey.shade900,
          boxShadow: [
            if (canAfford)
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(.25),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label, 
                style: const TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              if (costs.ap > 0) _buildCostBadge("AP ${costs.ap}"),
              if (costs.cp > 0) _buildCostBadge("CP ${costs.cp}"),
              if (costs.sp > 0) _buildCostBadge("SP ${costs.sp}"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: Colors.black.withOpacity(.25),
    ),
    child: Text(
      text, 
      style: const TextStyle(fontSize: 11, color: Colors.white),
    ),
  );

  Widget _buildJutsuCard({
    required String label,
    required int ap,
    required int cp,
    required IconData icon,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF141A24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  label, 
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Wrap(spacing: 6, children: [
              _buildCostBadge('AP $ap'),
              _buildCostBadge('CP $cp'),
            ]),
          ],
        ),
      ),
    );
  }
}
