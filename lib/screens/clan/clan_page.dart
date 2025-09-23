import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../controllers/clan_providers.dart';
import '../../models/clan_member.dart';
import 'widgets/browse_clans.dart';
import 'widgets/clan_tabs.dart';

class ClanPage extends ConsumerStatefulWidget {
  const ClanPage({super.key});

  @override
  ConsumerState<ClanPage> createState() => _ClanPageState();
}

class _ClanPageState extends ConsumerState<ClanPage> {
  @override
  Widget build(BuildContext context) {
    final currentClan = ref.watch(currentClanProvider);
    final myApplication = ref.watch(myApplicationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/village'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: currentClan.when(
            data: (clan) {
              if (clan != null) {
                return _buildClanView(clan);
              } else {
                return _buildNoClanView();
              }
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
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading clan data',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(currentClanProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClanView(clan) {
    return myApplication.when(
      data: (application) {
        // Show pending application banner if user has one
        if (application != null) {
          return Column(
            children: [
              _buildPendingApplicationBanner(application),
              Expanded(child: ClanTabs(clan: clan)),
            ],
          );
        }
        return ClanTabs(clan: clan);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
        ),
      ),
      error: (error, stack) => ClanTabs(clan: clan),
    );
  }

  Widget _buildNoClanView() {
    return const BrowseClans();
  }

  Widget _buildPendingApplicationBanner(application) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.pending_actions,
            color: AppTheme.accentColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Pending',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your application is under review',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showWithdrawDialog(application.id),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.hpColor,
            ),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(String applicationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Withdraw Application',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to withdraw your application?',
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
              ref.read(clanNotifierProvider.notifier).withdrawApplication();
            },
            child: const Text(
              'Withdraw',
              style: TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
    );
  }
}
