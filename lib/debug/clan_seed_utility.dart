import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/clan_seeder.dart';
import '../utils/snackbar_utils.dart';

class ClanSeedUtility extends ConsumerWidget {
  const ClanSeedUtility({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clan Seed Utility'),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Database Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Warning: These operations will modify your database. Use with caution!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _seedClans(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Seed Clans (Create 3 clans per village)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _clearClans(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Clear All Clans (DANGER)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This will create 3 distinct clans for each village:\n'
              '• Willowshade Village: Willow Guardians, Leaf Shadows, Root Warriors\n'
              '• Ashpeak Village: Volcano Vanguard, Ember Strikers, Ash Storm\n'
              '• Stormvale Village: Thunder Lords, Wind Riders, Storm Callers\n'
              '• Snowhollow Village: Ice Guardians, Frost Wolves, Crystal Shards\n'
              '• Shadowfen Village: Shadow Assassins, Mist Walkers, Bog Spirits',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seedClans(BuildContext context) async {
    try {
      final seeder = ClanSeeder();
      await seeder.seedClans();
      
      if (context.mounted) {
        SnackbarUtils.showSuccess(
          context,
          'Clans seeded successfully! 15 clans created across 5 villages.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showError(
          context,
          'Failed to seed clans: $e',
        );
      }
    }
  }

  Future<void> _clearClans(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'This will delete ALL clans, clan members, applications, and board posts. '
          'This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final seeder = ClanSeeder();
      await seeder.clearAllClans();
      
      if (context.mounted) {
        SnackbarUtils.showSuccess(
          context,
          'All clans cleared successfully!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showError(
          context,
          'Failed to clear clans: $e',
        );
      }
    }
  }
}
