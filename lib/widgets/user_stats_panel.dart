import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../models/player.dart';
import '../models/stats.dart';
import '../utils/stats_utils.dart';
import 'tier_badge.dart';
import 'circular_progress.dart';

class UserStatsPanel extends ConsumerStatefulWidget {
  const UserStatsPanel({super.key});

  @override
  ConsumerState<UserStatsPanel> createState() => _UserStatsPanelState();
}

class _UserStatsPanelState extends ConsumerState<UserStatsPanel> {

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(player),
          
          // Tabs
          _buildTabs(),
          
          // Content
          _buildContent(player),
        ],
      ),
    );
  }

  Widget _buildHeader(Player player) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[700]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const                 Text(
                  'User Stats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Strengths & Weaknesses',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildRankBadge(player.stats.rank, player.stats.rankColor),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Show help dialog
              _showHelpDialog();
            },
            icon: Icon(
              Icons.help_outline,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildTab('Stats', 'stats'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String tabId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(Player player) {
    return _buildStatsContent(player);
  }


  Widget _buildStatsContent(Player player) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Pools Row
          _buildPoolsRow(player.stats),
          const SizedBox(height: 24),
          
          // Stats Grid
          _buildStatsGrid(player.stats),
          const SizedBox(height: 24),
          
          // Elemental Proficiency
          _buildElementalProficiency(),
        ],
      ),
    );
  }

  Widget _buildPoolsRow(PlayerStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resource Pools',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[300],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPoolBar(
                'HP',
                stats.hp,
                stats.maxHP,
                Colors.red[400]!,
                Icons.favorite,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPoolBar(
                'CP',
                stats.cp,
                stats.maxCP,
                Colors.blue[400]!,
                Icons.auto_awesome,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPoolBar(
                'SP',
                stats.sp,
                stats.maxSP,
                Colors.green[400]!,
                Icons.directions_run,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPoolBar(String label, int current, int max, Color color, IconData icon) {
    final percentage = max > 0 ? current / max : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 16),
              Flexible(
                child: Text(
                  '$current / $max',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: color.withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(PlayerStats stats) {
    return Column(
      children: [
        // Offences
        _buildStatSection(
          'Offences',
          [
            _buildStatRow('NIN', stats.nin, Colors.cyan[400]!, 'Ninjutsu Offence', 'combat', null, stats),
            _buildStatRow('GEN', stats.gen, Colors.purple[400]!, 'Genjutsu Offence', 'combat', null, stats),
            _buildStatRow('TAI', stats.tai, Colors.green[400]!, 'Taijutsu Offence', 'combat', null, stats),
            _buildStatRow('BKI', stats.buk, Colors.red[400]!, 'Bukijutsu Offence', 'combat', null, stats),
          ],
        ),
        const SizedBox(height: 16),
        
        // Defences
        _buildStatSection(
          'Defences',
          [
            _buildStatRow('NIN', stats.nin, Colors.cyan[400]!, 'Ninjutsu Defence', 'defence', null, stats),
            _buildStatRow('GEN', stats.gen, Colors.purple[400]!, 'Genjutsu Defence', 'defence', null, stats),
            _buildStatRow('TAI', stats.tai, Colors.green[400]!, 'Taijutsu Defence', 'defence', null, stats),
            _buildStatRow('BKI', stats.buk, Colors.red[400]!, 'Bukijutsu Defence', 'defence', null, stats),
          ],
        ),
        const SizedBox(height: 16),
        
        // Base Stats
        _buildStatSection(
          'Generals',
          [
            _buildStatRow('STR', stats.str, Colors.red[500]!, 'Strength', 'base'),
            _buildStatRow('INT', stats.intl, Colors.blue[400]!, 'Intelligence', 'base'),
            _buildStatRow('SPD', stats.spd, Colors.green[400]!, 'Speed', 'base'),
            _buildStatRow('WIL', stats.wil, Colors.indigo[400]!, 'Willpower', 'base'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatSection(String title, List<Widget> statRows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[300],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...statRows,
      ],
    );
  }

  Widget _buildStatRow(String label, int value, Color color, String fullName, String statType, [String? offensePriority, PlayerStats? allStats]) {
    double cap;
    int tier;
    
    double percentage;
    
    if (statType == 'combat' && allStats != null) {
      // Use the new priority-based tier calculation for offense stats
      tier = StatsUtils.tierForOffenseStat(value, label.toLowerCase(), allStats.nin, allStats.gen, allStats.buk, allStats.tai);
      // Calculate percentage progress within the current tier
      percentage = StatsUtils.percentageWithinTier(value, label.toLowerCase(), allStats.nin, allStats.gen, allStats.buk, allStats.tai);
      cap = 500000.0; // For display purposes only
      
    } else if (statType == 'defence' && allStats != null) {
      // Use the defense-specific calculation
      cap = StatsUtils.capFor(label.toLowerCase(), statType, offensePriority: offensePriority);
      tier = StatsUtils.tierFrom(value.toDouble(), cap);
      percentage = StatsUtils.percentageWithinTierDefense(value, label.toLowerCase());
      
    } else {
      // Use the old method for non-combat stats
      cap = StatsUtils.capFor(label.toLowerCase(), statType, offensePriority: offensePriority);
      tier = StatsUtils.tierFrom(value.toDouble(), cap);
      percentage = StatsUtils.pct(value.toDouble(), cap);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          // Icon with circular progress
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgress(
                percentage: percentage,
                size: 44,
                strokeWidth: 3,
                backgroundColor: color.withValues(alpha: 0.2),
                progressColor: color,
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Center(
                  child: Text(
                    StatsUtils.formatPercentage(percentage),
                    style: TextStyle(
                      color: color,
                      fontSize: percentage >= 100 ? 10 : 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          
          // Label and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  StatsUtils.formatWholeNumber(value),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          
          // Tier badge
          TierBadge(tier: tier, size: 14),
        ],
      ),
    );
  }

  Widget _buildElementalProficiency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elemental Proficiency',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[300],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildElementPill('Water', '💧', Colors.blue[400]!),
            _buildElementPill('Wind', '🌪️', Colors.green[400]!),
            _buildElementPill('Fire', '🔥', Colors.red[400]!),
            _buildElementPill('Earth', '⛰️', Colors.yellow[600]!),
            _buildElementPill('Lightning', '⚡', Colors.yellow[400]!),
            _buildElementPill('Ice', '❄️', Colors.cyan[300]!),
            _buildElementPill('None', '🚫', Colors.grey[400]!),
          ],
        ),
      ],
    );
  }

  Widget _buildElementPill(String name, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[700]?.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(String rank, String rankColor) {
    Color color;
    switch (rankColor) {
      case 'green':
        color = Colors.green[600]!;
        break;
      case 'blue':
        color = Colors.blue[600]!;
        break;
      case 'purple':
        color = Colors.purple[600]!;
        break;
      case 'amber':
        color = Colors.amber[600]!;
        break;
      default:
        color = Colors.grey[600]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        rank,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'User Stats Help',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This panel shows your character\'s statistics with tier-based progression. Higher tiers indicate better performance in that area.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
