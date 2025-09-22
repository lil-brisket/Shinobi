import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/stat_bar.dart';
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
                ref.read(playerProvider.notifier).state = updatedPlayer;
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
              '• Turn-based combat\n• Jutsu mastery system\n• Clan system\n• Mission system\n• Player dueling\n• Village exploration',
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
              ref.read(playerProvider.notifier).state = updatedPlayer;
              
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
}
