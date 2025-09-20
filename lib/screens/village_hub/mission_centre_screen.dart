import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/timer_chip.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/mission.dart';

class MissionCentreScreen extends ConsumerWidget {
  const MissionCentreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Centre'),
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
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.assignment,
                          color: AppTheme.accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mission Board',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Take on missions to earn rewards and experience',
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
                  'Available Missions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildMissionCard(context, ref, mission),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, WidgetRef ref, Mission mission) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRankColor(mission.rank).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getRankColor(mission.rank).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.assignment,
                  color: _getRankColor(mission.rank),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      mission.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRankColor(mission.rank).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${mission.rank.name.toUpperCase()}-Rank',
                  style: TextStyle(
                    color: _getRankColor(mission.rank),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppTheme.staminaColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Level ${mission.requiredLevel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.staminaColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.schedule,
                color: AppTheme.chakraColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDuration(mission.durationSeconds),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.chakraColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (mission.status == MissionStatus.available)
                ElevatedButton(
                  onPressed: () => _startMission(context, ref, mission),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Start'),
                )
              else if (mission.status == MissionStatus.inProgress)
                _buildMissionTimer(context, ref, mission)
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.staminaColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    mission.status.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.staminaColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (mission.status == MissionStatus.available) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: AppTheme.ryoColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rewards: ${mission.reward.xp} XP, ${mission.reward.ryo} Ryo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMissionTimer(BuildContext context, WidgetRef ref, Mission mission) {
    final now = DateTime.now();
    final endTime = mission.endTime ?? now;
    final remaining = endTime.difference(now);

    return TimerChip(
      remaining: remaining,
      label: mission.title,
      onCollect: () => _completeMission(context, ref, mission),
    );
  }

  Color _getRankColor(MissionRank rank) {
    switch (rank) {
      case MissionRank.d:
        return Colors.green;
      case MissionRank.c:
        return Colors.blue;
      case MissionRank.b:
        return Colors.orange;
      case MissionRank.a:
        return Colors.red;
      case MissionRank.s:
        return Colors.purple;
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _startMission(BuildContext context, WidgetRef ref, Mission mission) {
    final now = DateTime.now();
    final endTime = now.add(Duration(seconds: mission.durationSeconds));
    
    final updatedMission = mission.copyWith(
      status: MissionStatus.inProgress,
      startTime: now,
      endTime: endTime,
    );

    final missions = ref.read(missionsProvider);
    final missionIndex = missions.indexWhere((m) => m.id == mission.id);
    if (missionIndex != -1) {
      final updatedMissions = List<Mission>.from(missions);
      updatedMissions[missionIndex] = updatedMission;
      ref.read(missionsProvider.notifier).state = updatedMissions;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started mission: ${mission.title}'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }

  void _completeMission(BuildContext context, WidgetRef ref, Mission mission) {
    final player = ref.read(playerProvider);
    final missions = ref.read(missionsProvider);
    
    // Update player with rewards
    final newPlayer = player.copyWith(
      ryo: player.ryo + mission.reward.ryo,
    );
    ref.read(playerProvider.notifier).state = newPlayer;

    // Update mission status
    final missionIndex = missions.indexWhere((m) => m.id == mission.id);
    if (missionIndex != -1) {
      final updatedMissions = List<Mission>.from(missions);
      updatedMissions[missionIndex] = mission.copyWith(
        status: MissionStatus.completed,
      );
      ref.read(missionsProvider.notifier).state = updatedMissions;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mission completed! Earned ${mission.reward.ryo} Ryo!'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }
}
