import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../controllers/clan_providers.dart';

class RankingsTab extends ConsumerStatefulWidget {
  final Clan clan;

  const RankingsTab({super.key, required this.clan});

  @override
  ConsumerState<RankingsTab> createState() => _RankingsTabState();
}

class _RankingsTabState extends ConsumerState<RankingsTab> {
  String _sortBy = 'score';
  bool _showGlobal = false;

  @override
  Widget build(BuildContext context) {
    final rankings = ref.watch(clanRankingsProvider((
      villageId: _showGlobal ? null : widget.clan.villageId,
      sortBy: _sortBy,
    )));

    return Column(
      children: [
        // Controls
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Scope toggle
              Row(
                children: [
                  Text(
                    'Scope:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: false,
                          label: Text('Village'),
                        ),
                        ButtonSegment<bool>(
                          value: true,
                          label: Text('Global'),
                        ),
                      ],
                      selected: {_showGlobal},
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() {
                          _showGlobal = selection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sort options
              Row(
                children: [
                  Text(
                    'Sort by:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'score',
                          label: Text('Score'),
                        ),
                        ButtonSegment<String>(
                          value: 'wins',
                          label: Text('Wins'),
                        ),
                        ButtonSegment<String>(
                          value: 'losses',
                          label: Text('Losses'),
                        ),
                      ],
                      selected: {_sortBy},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() {
                          _sortBy = selection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Rankings list
        Expanded(
          child: rankings.when(
            data: (rankingsList) {
              if (rankingsList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.white54,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No rankings available',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rankingsList.length,
                itemBuilder: (context, index) {
                  final clan = rankingsList[index];
                  final rank = index + 1;
                  return _buildRankingCard(context, clan, rank);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.hpColor,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading rankings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingCard(BuildContext context, ClanWithDetails clan, int rank) {
    final isCurrentClan = clan.clan.id == widget.clan.id;
    final rankColor = _getRankColor(rank);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentClan 
            ? AppTheme.accentColor.withValues(alpha: 0.1)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentClan
            ? Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Clan emblem
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: clan.clan.emblemUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      clan.clan.emblemUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.groups,
                        color: AppTheme.accentColor,
                        size: 24,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.groups,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          // Clan info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      clan.clan.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrentClan ? AppTheme.accentColor : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    if (isCurrentClan) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Your Clan',
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Leader: ${clan.leaderName}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatChip('${clan.clan.score}', 'Score', AppTheme.accentColor),
                    const SizedBox(width: 8),
                    _buildStatChip('${clan.clan.wins}', 'Wins', AppTheme.staminaColor),
                    const SizedBox(width: 8),
                    _buildStatChip('${clan.clan.losses}', 'Losses', AppTheme.hpColor),
                    const SizedBox(width: 8),
                    _buildStatChip('${clan.memberCount}', 'Members', Colors.white70),
                  ],
                ),
              ],
            ),
          ),
          // Trophy icon for top 3
          if (rank <= 3)
            Icon(
              _getTrophyIcon(rank),
              color: rankColor,
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.white70;
    }
  }

  IconData _getTrophyIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.emoji_events;
    }
  }
}
