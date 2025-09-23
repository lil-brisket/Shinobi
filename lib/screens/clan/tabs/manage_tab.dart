import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../models/clan_member.dart';
import '../../../controllers/clan_providers.dart';

class ManageTab extends ConsumerStatefulWidget {
  final Clan clan;

  const ManageTab({super.key, required this.clan});

  @override
  ConsumerState<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends ConsumerState<ManageTab> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emblemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.clan.name;
    _descriptionController.text = widget.clan.description ?? '';
    _emblemController.text = widget.clan.emblemUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emblemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(clanMembersProvider(widget.clan.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clan settings
          _buildClanSettingsCard(context),
          const SizedBox(height: 16),
          
          // Leadership management
          _buildLeadershipCard(context, members),
          const SizedBox(height: 16),
          
          // Danger zone
          _buildDangerZoneCard(context),
        ],
      ),
    );
  }

  Widget _buildClanSettingsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clan Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Clan name
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Clan Name',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.accentColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.accentColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Emblem URL
          TextField(
            controller: _emblemController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Emblem URL (optional)',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.accentColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveClanSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadershipCard(BuildContext context, AsyncValue<List<ClanMember>> members) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leadership Management',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          members.when(
            data: (membersList) {
              final eligibleMembers = membersList.where(
                (member) => member.role == ClanRole.advisor || member.role == ClanRole.member,
              ).toList();

              if (eligibleMembers.isEmpty) {
                return const Text(
                  'No eligible members for leadership transfer',
                  style: TextStyle(color: Colors.white70),
                );
              }

              return Column(
                children: [
                  const Text(
                    'Transfer Leadership To:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...eligibleMembers.map((member) => _buildTransferOption(context, member)),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
            ),
            error: (error, stack) => Text(
              'Error loading members: $error',
              style: const TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferOption(BuildContext context, ClanMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.accentColor.withValues(alpha: 0.2),
            child: Text(
              member.displayName[0].toUpperCase(),
              style: const TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  member.role.displayName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showTransferDialog(member),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.ryoColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.hpColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.hpColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.hpColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          const Text(
            'These actions are permanent and cannot be undone.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          
          // Disband clan button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showDisbandDialog(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.hpColor,
                side: const BorderSide(color: AppTheme.hpColor),
              ),
              child: const Text('Disband Clan'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveClanSettings() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final emblemUrl = _emblemController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clan name cannot be empty'),
          backgroundColor: AppTheme.hpColor,
        ),
      );
      return;
    }

    ref.read(clanNotifierProvider.notifier).updateClan(
      widget.clan.id,
      name: name,
      description: description.isNotEmpty ? description : null,
      emblemUrl: emblemUrl.isNotEmpty ? emblemUrl : null,
    );
  }

  void _showTransferDialog(ClanMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Transfer Leadership',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to transfer leadership to ${member.displayName}? This action cannot be undone and you will become a regular member.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(clanNotifierProvider.notifier).transferLeadership(
                widget.clan.id,
                member.userId,
              );
            },
            child: const Text(
              'Transfer',
              style: TextStyle(color: AppTheme.ryoColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisbandDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Disband Clan',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to disband the clan? This will remove all members and cannot be undone.',
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
              ref.read(clanNotifierProvider.notifier).disbandClan(widget.clan.id);
            },
            child: const Text(
              'Disband',
              style: TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
    );
  }
}
