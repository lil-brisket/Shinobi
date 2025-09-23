import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/clan.dart';
import '../../../models/clan_member.dart';
import '../tabs/overview_tab.dart';
import '../tabs/members_tab.dart';
import '../tabs/board_tab.dart';
import '../tabs/rankings_tab.dart';
import '../tabs/requests_tab.dart';
import '../tabs/manage_tab.dart';

class ClanTabs extends ConsumerStatefulWidget {
  final Clan clan;

  const ClanTabs({super.key, required this.clan});

  @override
  ConsumerState<ClanTabs> createState() => _ClanTabsState();
}

class _ClanTabsState extends ConsumerState<ClanTabs> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabs;
  late List<String> _tabLabels;

  @override
  void initState() {
    super.initState();
    _buildTabs();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  void _buildTabs() {
    final currentMember = ref.read(currentClanMemberProvider).value;
    
    _tabs = [
      OverviewTab(clan: widget.clan),
      MembersTab(clan: widget.clan),
      BoardTab(clan: widget.clan),
      RankingsTab(clan: widget.clan),
    ];
    
    _tabLabels = [
      'Overview',
      'Members',
      'Board',
      'Rankings',
    ];

    // Add Requests tab for Leaders and Advisors
    if (currentMember?.role == ClanRole.leader || currentMember?.role == ClanRole.advisor) {
      _tabs.insert(3, RequestsTab(clan: widget.clan));
      _tabLabels.insert(3, 'Requests');
    }

    // Add Manage tab for Leaders only
    if (currentMember?.role == ClanRole.leader) {
      _tabs.add(ManageTab(clan: widget.clan));
      _tabLabels.add('Manage');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Clan header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Clan emblem
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: widget.clan.emblemUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          widget.clan.emblemUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.groups,
                            color: AppTheme.accentColor,
                            size: 30,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.groups,
                        color: AppTheme.accentColor,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              // Clan info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.clan.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${widget.clan.score}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.clan.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.clan.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tab bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
            labelColor: AppTheme.accentColor,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppTheme.accentColor,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs,
          ),
        ),
      ],
    );
  }
}
