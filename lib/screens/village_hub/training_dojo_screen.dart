import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/timer_chip.dart';
import '../../widgets/section_header.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/timer.dart';

class TrainingDojoScreen extends ConsumerStatefulWidget {
  const TrainingDojoScreen({super.key});

  @override
  ConsumerState<TrainingDojoScreen> createState() => _TrainingDojoScreenState();
}

class _TrainingDojoScreenState extends ConsumerState<TrainingDojoScreen> {

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Dojo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                const SectionHeader(title: 'Current Stats'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      StatBar(
                        label: 'Attack',
                        value: player.stats.attack,
                        maxValue: 1000,
                        accentColor: AppTheme.attackColor,
                      ),
                      StatBar(
                        label: 'Defense',
                        value: player.stats.defense,
                        maxValue: 1000,
                        accentColor: AppTheme.defenseColor,
                      ),
                      StatBar(
                        label: 'Chakra',
                        value: player.stats.chakra,
                        maxValue: player.stats.maxChakra,
                        accentColor: AppTheme.chakraColor,
                      ),
                      StatBar(
                        label: 'Stamina',
                        value: player.stats.stamina,
                        maxValue: player.stats.maxStamina,
                        accentColor: AppTheme.staminaColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Training Options'),
                const SizedBox(height: 16),
                _buildTrainingCard(
                  context,
                  'Attack Training',
                  'Increases your attack power',
                  Icons.sports_martial_arts,
                  AppTheme.attackColor,
                  'attack',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Defense Training',
                  'Increases your defense power',
                  Icons.shield,
                  AppTheme.defenseColor,
                  'defense',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Chakra Training',
                  'Increases your chakra capacity',
                  Icons.bolt,
                  AppTheme.chakraColor,
                  'chakra',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Stamina Training',
                  'Increases your stamina capacity',
                  Icons.directions_run,
                  AppTheme.staminaColor,
                  'stamina',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String statType,
  ) {
    final timers = ref.watch(timersProvider);
    final trainingTimer = timers.where((timer) => 
        timer.type == TimerType.training && 
        timer.metadata?['statType'] == statType &&
        !timer.isCompleted
    ).firstOrNull;
    
    final isTraining = trainingTimer != null;
    final remaining = trainingTimer?.remainingTime ?? Duration.zero;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (isTraining)
            TimerChip(
              remaining: remaining,
              label: title,
              onCollect: () => _collectTraining(trainingTimer.id, statType),
            )
          else
            ElevatedButton(
              onPressed: () => _startTraining(statType),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }

  void _startTraining(String statType) {
    ref.read(timersProvider.notifier).startTrainingTimer(statType, const Duration(minutes: 5));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started $statType training!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _collectTraining(String timerId, String statType) {
    ref.read(timersProvider.notifier).completeTimer(timerId);

    // Update player stats (mock)
    final player = ref.read(playerProvider);
    final newPlayer = player.copyWith(
      stats: player.stats.copyWith(
        attack: statType == 'attack' ? player.stats.attack + 10 : player.stats.attack,
        defense: statType == 'defense' ? player.stats.defense + 10 : player.stats.defense,
        maxChakra: statType == 'chakra' ? player.stats.maxChakra + 20 : player.stats.maxChakra,
        maxStamina: statType == 'stamina' ? player.stats.maxStamina + 20 : player.stats.maxStamina,
      ),
    );
    ref.read(playerProvider.notifier).state = newPlayer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Training completed! $statType increased!'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }
}
