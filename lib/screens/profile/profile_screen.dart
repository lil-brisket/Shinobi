import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/info_card.dart';
import '../../widgets/currency_pill.dart';
import '../../widgets/user_stats_panel.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../controllers/auth_provider.dart';
import '../../constants/villages.dart';
import '../../utils/snackbar_utils.dart';
import '../../models/stats.dart';
import '../../models/village.dart';
import '../../models/player.dart';
import '../../controllers/battle_history_provider.dart';
import '../../models/battle_history.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showEditProfile(context, ref),
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player Header with Avatar, Name, Level, and XP Bar
                _buildPlayerHeader(context, player, authState),
                const SizedBox(height: 24),

                // User Stats Panel with Tier System
                const UserStatsPanel(),
                const SizedBox(height: 24),

                // Medical Ninja Profession Card
                _buildMedicalNinjaCard(context, player),
                const SizedBox(height: 24),

                // Battle History Card
                _buildBattleHistoryCard(context),
                const SizedBox(height: 24),

                // Village Change Button (only for Chunin rank and above)
                if (player.rank.index >= PlayerRank.chunin.index)
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showVillageChangeDialog(context, ref, player),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.location_city, size: 20),
                      label: const Text('Change Village'),
                    ),
                  ),
                const SizedBox(height: 24),

                // Loadout Summary
                const Text(
                  'Loadout Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Equipped Jutsus',
                  subtitle: '${player.jutsuIds.length} jutsus equipped',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.chakraColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppTheme.chakraColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: ElevatedButton(
                    onPressed: () => _viewJutsus(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.chakraColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Inventory Items',
                  subtitle: '${player.itemIds.length} items in inventory',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.staminaColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.inventory,
                      color: AppTheme.staminaColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: ElevatedButton(
                    onPressed: () => _viewInventory(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.staminaColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showAbout(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('About ShogunX'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Player Header with Avatar, Name, Level, and XP Bar
  Widget _buildPlayerHeader(BuildContext context, Player player, AuthState authState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(player.avatarUrl),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authState.username ?? player.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.village,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CurrencyPill(
                      amount: player.ryo,
                      icon: Icons.monetization_on,
                      color: AppTheme.ryoColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Level and XP Bar
          Row(
            children: [
              Text(
                'Level ${player.stats.level}',
                style: AppTheme.statLabelStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Value: ${player.stats.str}',
                style: AppTheme.statValueStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Stat Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _calculateStatProgress(player.stats),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, AppTheme.chakraColor],
                  ),
                  boxShadow: AppTheme.progressBarGlow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Calculate stat progress for the progress bar (percentage of cap)
  double _calculateStatProgress(PlayerStats stats) {
    // Using base stat cap of 250k
    const cap = 250000.0;
    return (stats.str / cap).clamp(0.0, 1.0);
  }

  // Medical Ninja Profession Card
  Widget _buildMedicalNinjaCard(BuildContext context, Player player) {
    final medNinja = player.medNinja;
    final progress = medNinja.xp / medNinja.xpToNext;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.hpColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: AppTheme.hpColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profession • Medical Ninja',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${medNinja.level}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // XP Progress Bar
          Row(
            children: [
              Text(
                'XP: ${medNinja.xp}/${medNinja.xpToNext}',
                style: AppTheme.statLabelStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [AppTheme.hpColor, AppTheme.accentColor],
                  ),
                  boxShadow: AppTheme.progressBarGlow,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Bonus Chips
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.hpColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.hpColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '+${(medNinja.healingBonus * 100).toStringAsFixed(0)}% healing',
                  style: const TextStyle(
                    color: AppTheme.hpColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.chakraColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.chakraColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '–${(medNinja.costReduction * 100).toStringAsFixed(0)}% CP/SP cost',
                  style: const TextStyle(
                    color: AppTheme.chakraColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showEditProfile(BuildContext context, WidgetRef ref) {
    final player = ref.read(playerProvider);
    final nameController = TextEditingController(text: player.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Player Name',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.accentColor),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final updatedPlayer = player.copyWith(name: nameController.text.trim());
                ref.read(playerProvider.notifier).updatePlayer(updatedPlayer);
                Navigator.pop(context);
                SnackbarUtils.showSuccess(
                  context,
                  'Profile updated successfully!',
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _viewJutsus(BuildContext context) {
    SnackbarUtils.showInfo(
      context,
      'Navigate to Inventory > Jutsus to view equipped jutsus',
    );
  }

  void _viewInventory(BuildContext context) {
    SnackbarUtils.showInfo(
      context,
      'Navigate to Inventory to view your items',
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/start');
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'About ShogunX',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A Naruto-inspired mobile MMORPG with ninja/fantasy theme. Train your ninja, master jutsus, and become the ultimate shinobi!',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Turn-based combat\n• Jutsu mastery system\n• Mission system\n• Player dueling\n• Village exploration',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showVillageChangeDialog(BuildContext context, WidgetRef ref, Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Change Village',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a new village to transfer to:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ...VillageConstants.allVillages
                  .where((village) => village.name != player.village)
                  .map((village) => ListTile(
                        leading: Text(
                          village.emblem,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(
                          village.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          village.description,
                          style: const TextStyle(color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _confirmVillageChange(context, ref, player, village);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: Colors.white.withValues(alpha:0.05),
                      )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmVillageChange(BuildContext context, WidgetRef ref, Player player, Village newVillage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Confirm Village Change',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to transfer to ${newVillage.name}?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Current: ',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  player.village,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'New: ',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  newVillage.name,
                  style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: Village change is permanent and cannot be undone.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update player village
              final updatedPlayer = player.copyWith(village: newVillage.name);
              ref.read(playerProvider.notifier).updatePlayer(updatedPlayer);
              
              Navigator.pop(context);
              SnackbarUtils.showSuccess(
                context,
                'Successfully transferred to ${newVillage.name}!',
                backgroundColor: AppTheme.accentColor,
              );
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Battle History Card
  Widget _buildBattleHistoryCard(BuildContext context) {
    final battleHistoryAsync = ref.watch(battleHistoryNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.history,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Battle History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Recent battles and results',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref.read(battleHistoryNotifierProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: Colors.white70),
                tooltip: 'Refresh Battle History',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Battle History Content
          battleHistoryAsync.when(
            data: (history) => _buildBattleHistoryList(history),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load battle history',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(battleHistoryNotifierProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleHistoryList(List<BattleHistoryEntry> history) {
    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.sports_martial_arts, color: Colors.white54, size: 48),
              const SizedBox(height: 8),
              const Text(
                'No battles recorded yet',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 4),
              const Text(
                'Start fighting to see your battle history here!',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Show up to 5 recent battles
        ...history.take(5).map((battle) => _buildBattleHistoryItem(battle)),
        
        if (history.length > 5) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _showAllBattleHistory(history),
            child: Text(
              'View All ${history.length} Battles',
              style: const TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBattleHistoryItem(BattleHistoryEntry battle) {
    final resultColor = _getResultColor(battle.result);
    final resultIcon = _getResultIcon(battle.result);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Result icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(resultIcon, color: resultColor, size: 18),
          ),
          const SizedBox(width: 12),
          
          // Battle info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      battle.result.toUpperCase(),
                      style: TextStyle(
                        color: resultColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatBattleDate(battle.battleDate),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${battle.rounds} rounds • ${battle.totalActions} actions',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                if (battle.totalDamage > 0 || battle.totalHealing > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${battle.totalDamage > 0 ? '${battle.totalDamage} dmg' : ''}${battle.totalDamage > 0 && battle.totalHealing > 0 ? ' • ' : ''}${battle.totalHealing > 0 ? '${battle.totalHealing} heal' : ''}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // View details button
          IconButton(
            onPressed: () => _showBattleDetails(battle),
            icon: const Icon(Icons.visibility, color: Colors.white54, size: 18),
            tooltip: 'View Battle Details',
          ),
        ],
      ),
    );
  }

  Color _getResultColor(String result) {
    switch (result.toLowerCase()) {
      case 'victory':
        return Colors.green;
      case 'defeat':
        return Colors.red;
      case 'fled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getResultIcon(String result) {
    switch (result.toLowerCase()) {
      case 'victory':
        return Icons.celebration;
      case 'defeat':
        return Icons.sentiment_very_dissatisfied;
      case 'fled':
        return Icons.directions_run;
      default:
        return Icons.help_outline;
    }
  }

  String _formatBattleDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showAllBattleHistory(List<BattleHistoryEntry> history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'All Battle History',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final battle = history[index];
              return _buildBattleHistoryItem(battle);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmClearHistory();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBattleDetails(BattleHistoryEntry battle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Row(
          children: [
            Icon(_getResultIcon(battle.result), color: _getResultColor(battle.result)),
            const SizedBox(width: 8),
            Text(
              'Battle Details',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Battle Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: ${battle.result.toUpperCase()}',
                      style: TextStyle(
                        color: _getResultColor(battle.result),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${_formatBattleDate(battle.battleDate)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Rounds: ${battle.rounds} • Actions: ${battle.totalActions}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Damage: ${battle.totalDamage} • Healing: ${battle.totalHealing}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Battle Log Header
              Row(
                children: [
                  const Text(
                    'Battle Log',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _copyBattleLog(battle),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Battle Log Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: ListView.builder(
                    itemCount: battle.formattedBattleLog.length,
                    itemBuilder: (context, index) {
                      final logEntry = battle.formattedBattleLog[index];
                      
                      // Style round headers differently
                      if (logEntry.startsWith('===')) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            logEntry,
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                      
                      // Style empty lines
                      if (logEntry.isEmpty) {
                        return const SizedBox(height: 8);
                      }
                      
                      // Style regular log entries
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          logEntry,
                          style: TextStyle(
                            color: _getLogEntryColor(logEntry),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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

  Color _getLogEntryColor(String logEntry) {
    if (logEntry.contains('defeated') || logEntry.contains('was defeated')) {
      return Colors.red;
    } else if (logEntry.contains('healed') || logEntry.contains('healing')) {
      return Colors.green;
    } else if (logEntry.contains('punched') || logEntry.contains('damage')) {
      return Colors.orange;
    } else if (logEntry.contains('moved')) {
      return Colors.blue;
    } else if (logEntry.contains('fled')) {
      return Colors.purple;
    } else if (logEntry.contains('Round') && logEntry.contains('begins')) {
      return Colors.cyan;
    } else if (logEntry.contains('Round') && logEntry.contains('ends')) {
      return Colors.cyan;
    } else {
      return Colors.white70;
    }
  }

  void _copyBattleLog(BattleHistoryEntry battle) {
    final logText = battle.formattedBattleLog.join('\n');
    
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: logText));
    
    SnackbarUtils.showSuccess(
      context,
      'Battle log copied to clipboard!',
    );
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Clear Battle History',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear all battle history? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(battleHistoryNotifierProvider.notifier).clearHistory();
              SnackbarUtils.showSuccess(
                context,
                'Battle history cleared successfully!',
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
