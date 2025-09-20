import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class VillageHubScreen extends StatelessWidget {
  const VillageHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Village Hub'),
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
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildHubIcon(context, 'Training Dojo', Icons.fitness_center, () => context.go('/village/training-dojo'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      Expanded(child: _buildHubIcon(context, 'Item Shop', Icons.store, () => context.go('/village/item-shop'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      Expanded(child: _buildHubIcon(context, 'Hospital', Icons.local_hospital, () => context.go('/village/hospital'))),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.white24),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildHubIcon(context, 'Clan Hall', Icons.groups, () => context.go('/village/clan-hall'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      Expanded(child: _buildHubIcon(context, 'Bank', Icons.account_balance, () => context.go('/village/bank'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      Expanded(child: _buildHubIcon(context, 'Battle Grounds', Icons.sports_martial_arts, () => context.go('/village/battle-grounds'))),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.white24),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildHubIcon(context, 'Mission Centre', Icons.assignment, () => context.go('/village/mission-centre'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      Expanded(child: _buildHubIcon(context, 'Dueling Academy', Icons.sports_kabaddi, () => context.go('/village/dueling-academy'))),
                      const VerticalDivider(thickness: 1, color: Colors.white24),
                      const Expanded(child: SizedBox()), // Empty space for the third column
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

  Widget _buildHubIcon(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppTheme.accentColor),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
