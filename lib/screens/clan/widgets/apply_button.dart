import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../controllers/clan_providers.dart';

class ApplyButton extends ConsumerWidget {
  final Clan clan;

  const ApplyButton({super.key, required this.clan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myApplication = ref.watch(myApplicationProvider);

    return myApplication.when(
      data: (application) {
        // If user has a pending application to this clan
        if (application?.clanId == clan.id) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'Applied',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        
        // If user has a pending application to another clan
        if (application != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Applied Elsewhere',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        // User can apply
        return ElevatedButton(
          onPressed: () => _showApplyDialog(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Apply'),
        );
      },
      loading: () => const SizedBox(
        width: 60,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      error: (error, stack) => ElevatedButton(
        onPressed: () => _showApplyDialog(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text('Apply'),
      ),
    );
  }

  void _showApplyDialog(BuildContext context, WidgetRef ref) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Apply to ${clan.name}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to the clan leaders (optional):',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 3,
              maxLength: 280,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Tell them why you want to join...',
                hintStyle: TextStyle(color: Colors.white60),
                border: OutlineInputBorder(),
                counterStyle: TextStyle(color: Colors.white60),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(clanNotifierProvider.notifier).applyToClan(
                clan.id,
                message: messageController.text.trim().isNotEmpty 
                    ? messageController.text.trim() 
                    : null,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
