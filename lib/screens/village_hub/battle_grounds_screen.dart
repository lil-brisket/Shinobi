import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/info_card.dart';
import '../../app/theme.dart';

class BattleGroundsScreen extends ConsumerWidget {
  const BattleGroundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Grounds'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.hpColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.sports_martial_arts,
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
                              'Battle Arena',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Challenge NPCs to test your strength',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Available Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildChallengeCard(
                        context,
                        'Bandit Thug',
                        'A common bandit with basic combat skills',
                        'Level 5',
                        'Easy',
                        AppTheme.staminaColor,
                        Icons.person,
                        () => _showBattlePreview(context, 'Bandit Thug', 'Easy'),
                      ),
                      const SizedBox(height: 12),
                      _buildChallengeCard(
                        context,
                        'Rogue Ninja',
                        'A skilled ninja who has gone rogue',
                        'Level 15',
                        'Medium',
                        AppTheme.chakraColor,
                        Icons.security,
                        () => _showBattlePreview(context, 'Rogue Ninja', 'Medium'),
                      ),
                      const SizedBox(height: 12),
                      _buildChallengeCard(
                        context,
                        'Elite Guard',
                        'A highly trained village guard',
                        'Level 25',
                        'Hard',
                        AppTheme.attackColor,
                        Icons.shield,
                        () => _showBattlePreview(context, 'Elite Guard', 'Hard'),
                      ),
                      const SizedBox(height: 12),
                      _buildChallengeCard(
                        context,
                        'Dark Ninja',
                        'A mysterious ninja with dark powers',
                        'Level 35',
                        'Expert',
                        AppTheme.hpColor,
                        Icons.dark_mode,
                        () => _showBattlePreview(context, 'Dark Ninja', 'Expert'),
                      ),
                      const SizedBox(height: 12),
                      _buildChallengeCard(
                        context,
                        'Legendary Warrior',
                        'A legendary warrior from ancient times',
                        'Level 50',
                        'Legendary',
                        AppTheme.ryoColor,
                        Icons.star,
                        () => _showBattlePreview(context, 'Legendary Warrior', 'Legendary'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    String name,
    String description,
    String level,
    String difficulty,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InfoCard(
      title: name,
      subtitle: description,
      leadingWidget: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
      trailingWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              difficulty,
              style: const TextStyle(
                color: AppTheme.accentColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showBattlePreview(BuildContext context, String enemyName, String difficulty) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.hpColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: AppTheme.hpColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              enemyName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                difficulty,
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Battle Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rewards:', style: TextStyle(color: Colors.white70)),
                      Text('XP: 100-500', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Risk:', style: TextStyle(color: Colors.white70)),
                      Text('HP Loss Possible', style: TextStyle(color: AppTheme.hpColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startBattle(context, enemyName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.hpColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Fight!'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startBattle(BuildContext context, String enemyName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Battle system coming soon! Prepare to fight $enemyName!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }
}
