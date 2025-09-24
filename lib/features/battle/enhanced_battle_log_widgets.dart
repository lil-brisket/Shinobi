import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';

/// Enhanced battle log with rounds view
class EnhancedBattleLog extends StatefulWidget {
  final List<String> log;
  final List<RoundLog> rounds;
  final int maxLines;

  const EnhancedBattleLog({
    super.key,
    required this.log,
    required this.rounds,
    this.maxLines = 6,
  });

  @override
  State<EnhancedBattleLog> createState() => _EnhancedBattleLogState();
}

class _EnhancedBattleLogState extends State<EnhancedBattleLog> {
  bool _showRounds = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with toggle
        Row(
          children: [
            Text(
              'Battle Log',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(_showRounds ? Icons.list : Icons.view_list),
              onPressed: () {
                setState(() {
                  _showRounds = !_showRounds;
                });
              },
              tooltip: _showRounds ? 'Show Compact Log' : 'Show Rounds View',
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        // Content
        Expanded(
          child: _showRounds ? _buildRoundsView() : _buildCompactView(),
        ),
      ],
    );
  }

  Widget _buildCompactView() {
    final recentLog = widget.log.length > widget.maxLines 
        ? widget.log.sublist(widget.log.length - widget.maxLines)
        : widget.log;

    return ListView.builder(
      itemCount: recentLog.length,
      itemBuilder: (context, index) {
        final message = recentLog[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildRoundsView() {
    if (widget.rounds.isEmpty) {
      return const Center(
        child: Text('No rounds recorded yet'),
      );
    }

    // Show newest rounds first
    final sortedRounds = List<RoundLog>.from(widget.rounds)
      ..sort((a, b) => b.round.compareTo(a.round));

    return ListView.builder(
      itemCount: sortedRounds.length,
      itemBuilder: (context, index) {
        final round = sortedRounds[index];
        return RoundCard(round: round);
      },
    );
  }
}

/// Individual round card widget
class RoundCard extends StatefulWidget {
  final RoundLog round;

  const RoundCard({super.key, required this.round});

  @override
  State<RoundCard> createState() => _RoundCardState();
}

class _RoundCardState extends State<RoundCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = widget.round.summary;
    final duration = widget.round.duration;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          // Header
          ListTile(
            title: Text(
              'Round ${widget.round.round}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _formatRoundSubtitle(duration, summary),
              style: theme.textTheme.bodySmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'copy_summary',
                      child: Text('Copy Round Summary'),
                    ),
                    const PopupMenuItem(
                      value: 'copy_log',
                      child: Text('Copy Full Battle Log'),
                    ),
                    const PopupMenuItem(
                      value: 'clear_log',
                      child: Text('Clear Log (Debug)'),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          
          // Expanded content
          if (_isExpanded) _buildRoundDetails(),
        ],
      ),
    );
  }

  String _formatRoundSubtitle(Duration? duration, RoundSummary summary) {
    final timeStr = duration != null 
        ? '${duration.inSeconds}s' 
        : 'In Progress';
    return 'Actions: ${summary.actionsCount} • Total DMG: ${summary.totalDamage} • Total Heal: ${summary.totalHealing} • KOs: ${summary.defeatedEntities.length} • $timeStr';
  }

  Widget _buildRoundDetails() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Round Details',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Summary stats
          _buildSummaryStats(),
          
          const SizedBox(height: 12),
          
          // Action entries
          Text(
            'Actions:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          ...widget.round.entries
              .where((entry) => entry.action != BattleAction.startRound && entry.action != BattleAction.endRound)
              .map((entry) => _buildLogEntry(entry)),
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    final theme = Theme.of(context);
    final summary = widget.round.summary;
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (summary.damageDoneByEntity.isNotEmpty) ...[
          Text(
            'Damage: ${summary.damageDoneByEntity.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (summary.healingDoneByEntity.isNotEmpty) ...[
          Text(
            'Healing: ${summary.healingDoneByEntity.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (summary.defeatedEntities.isNotEmpty) ...[
          Text(
            'Defeated: ${summary.defeatedEntities.join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLogEntry(BattleLogEntry entry) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 60,
            child: Text(
              '${entry.ts.hour.toString().padLeft(2, '0')}:${entry.ts.minute.toString().padLeft(2, '0')}:${entry.ts.second.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
          
          // Actor chip
          if (entry.actorId.isNotEmpty) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: _getActorColor(entry.actorId),
                child: Text(
                  entry.actorId.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Action label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getActionColor(entry.action),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _getActionLabel(entry.action),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Message
          Expanded(
            child: Text(
              entry.message,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActorColor(String actorId) {
    if (actorId.startsWith('P')) return Colors.blue;
    if (actorId.startsWith('E')) return Colors.red;
    return Colors.grey;
  }

  Color _getActionColor(BattleAction action) {
    switch (action) {
      case BattleAction.punch:
        return Colors.red;
      case BattleAction.heal:
        return Colors.green;
      case BattleAction.move:
        return Colors.blue;
      case BattleAction.flee:
        return Colors.orange;
      case BattleAction.jutsu:
        return Colors.purple;
      case BattleAction.endTurn:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getActionLabel(BattleAction action) {
    switch (action) {
      case BattleAction.punch:
        return 'PUNCH';
      case BattleAction.heal:
        return 'HEAL';
      case BattleAction.move:
        return 'MOVE';
      case BattleAction.flee:
        return 'FLEE';
      case BattleAction.jutsu:
        return 'JUTSU';
      case BattleAction.endTurn:
        return 'END';
      default:
        return action.name.toUpperCase();
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'copy_summary':
        _copyRoundSummary();
        break;
      case 'copy_log':
        _copyFullBattleLog();
        break;
      case 'clear_log':
        _clearLog();
        break;
    }
  }

  void _copyRoundSummary() {
    final summary = widget.round.summary;
    final text = '''
Round ${widget.round.round} Summary
Actions: ${summary.actionsCount}
Total Damage: ${summary.totalDamage}
Total Healing: ${summary.totalHealing}
Defeated: ${summary.defeatedEntities.join(', ')}
Duration: ${widget.round.duration?.inSeconds ?? 0}s
''';
    
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Round summary copied to clipboard')),
    );
  }

  void _copyFullBattleLog() {
    final text = widget.round.entries
        .map((entry) => '${entry.ts.hour.toString().padLeft(2, '0')}:${entry.ts.minute.toString().padLeft(2, '0')}:${entry.ts.second.toString().padLeft(2, '0')} - ${entry.message}')
        .join('\n');
    
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Battle log copied to clipboard')),
    );
  }

  void _clearLog() {
    // This would need to be implemented in the controller
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clear log feature not implemented yet')),
    );
  }
}
