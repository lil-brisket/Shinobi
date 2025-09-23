import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../models/clan_member.dart';
import '../../../controllers/clan_providers.dart';

class MembersTab extends ConsumerStatefulWidget {
  final Clan clan;

  const MembersTab({super.key, required this.clan});

  @override
  ConsumerState<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<MembersTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(clanMembersProvider(widget.clan.id));
    final currentMember = ref.watch(currentClanMemberProvider).value;

    return Column(
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search members...',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white60),
            ),
          ),
        ),
        // Members list
        Expanded(
          child: members.when(
            data: (membersList) {
              final filteredMembers = membersList.where((member) {
                return member.displayName.toLowerCase().contains(_searchQuery);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return _buildMemberCard(context, member, currentMember);
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
                    'Error loading members',
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

  Widget _buildMemberCard(BuildContext context, ClanMember member, ClanMember? currentMember) {
    final canManage = currentMember?.role.canPromoteMembers == true;
    final isCurrentUser = currentMember?.userId == member.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: _getRoleColor(member.role).withValues(alpha: 0.2),
            child: Text(
              member.displayName[0].toUpperCase(),
              style: TextStyle(
                color: _getRoleColor(member.role),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'You',
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(member.role).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member.role.displayName,
                        style: TextStyle(
                          color: _getRoleColor(member.role),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Joined ${_formatDate(member.joinedAt)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action menu
          if (canManage && !isCurrentUser)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white60),
              onSelected: (value) => _handleMemberAction(value, member),
              itemBuilder: (context) => [
                if (member.role == ClanRole.member)
                  const PopupMenuItem(
                    value: 'promote',
                    child: Text('Promote to Advisor'),
                  ),
                if (member.role == ClanRole.advisor)
                  const PopupMenuItem(
                    value: 'demote',
                    child: Text('Demote to Member'),
                  ),
                if (member.role == ClanRole.advisor && currentMember?.role == ClanRole.leader)
                  const PopupMenuItem(
                    value: 'transfer',
                    child: Text('Transfer Leadership'),
                  ),
                const PopupMenuItem(
                  value: 'kick',
                  child: Text('Kick from Clan', style: TextStyle(color: AppTheme.hpColor)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getRoleColor(ClanRole role) {
    switch (role) {
      case ClanRole.leader:
        return AppTheme.ryoColor;
      case ClanRole.advisor:
        return AppTheme.accentColor;
      case ClanRole.member:
        return Colors.white70;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  void _handleMemberAction(String action, ClanMember member) {
    switch (action) {
      case 'promote':
        _showPromoteDialog(member);
        break;
      case 'demote':
        _showDemoteDialog(member);
        break;
      case 'transfer':
        _showTransferDialog(member);
        break;
      case 'kick':
        _showKickDialog(member);
        break;
    }
  }

  void _showPromoteDialog(ClanMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Promote Member',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to promote ${member.displayName} to Advisor?',
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
              ref.read(clanNotifierProvider.notifier).promoteMember(member.userId);
            },
            child: const Text(
              'Promote',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDemoteDialog(ClanMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Demote Member',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to demote ${member.displayName} to Member?',
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
              ref.read(clanNotifierProvider.notifier).demoteMember(member.userId);
            },
            child: const Text(
              'Demote',
              style: TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
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
          'Are you sure you want to transfer leadership to ${member.displayName}? This action cannot be undone.',
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

  void _showKickDialog(ClanMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Kick Member',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to kick ${member.displayName} from the clan?',
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
              // TODO: Implement kick functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kick functionality coming soon!'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            child: const Text(
              'Kick',
              style: TextStyle(color: AppTheme.hpColor),
            ),
          ),
        ],
      ),
    );
  }
}
