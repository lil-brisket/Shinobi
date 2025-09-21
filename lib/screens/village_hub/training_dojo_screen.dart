import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/timer_chip.dart';
import '../../widgets/section_header.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/timer.dart';
import '../../models/stats.dart';
import '../../utils/snackbar_utils.dart';

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
                // Core Stats Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Core Stats',
                        style: AppTheme.statLabelStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatDisplay('STR', player.stats.str.level, AppTheme.attackColor, 'Strength'),
                          _buildStatDisplay('WIL', player.stats.wil.level, AppTheme.defenseColor, 'Willpower'),
                          _buildStatDisplay('INTL', player.stats.intl.level, AppTheme.chakraColor, 'Intelligence'),
                          _buildStatDisplay('SPD', player.stats.spd.level, AppTheme.staminaColor, 'Speed'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Combat Stats Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Combat Stats',
                        style: AppTheme.statLabelStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatDisplay('NIN', player.stats.nin.level, AppTheme.chakraColor, 'Ninjutsu'),
                          _buildStatDisplay('GEN', player.stats.gen.level, AppTheme.defenseColor, 'Genjutsu'),
                          _buildStatDisplay('BUK', player.stats.buk.level, AppTheme.attackColor, 'Bukijutsu'),
                          _buildStatDisplay('TAI', player.stats.tai.level, AppTheme.staminaColor, 'Taijutsu'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Training Options'),
                const SizedBox(height: 16),
                _buildTrainingCard(
                  context,
                  'Strength Training',
                  'Increases your physical strength',
                  Icons.fitness_center,
                  AppTheme.attackColor,
                  'strength',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Intelligence Training',
                  'Increases your mental prowess',
                  Icons.psychology,
                  AppTheme.chakraColor,
                  'intelligence',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Willpower Training',
                  'Increases your mental fortitude',
                  Icons.self_improvement,
                  AppTheme.defenseColor,
                  'willpower',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Speed Training',
                  'Increases your agility and reflexes',
                  Icons.directions_run,
                  AppTheme.staminaColor,
                  'speed',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Ninjutsu Training',
                  'Increases your ninjutsu combat power',
                  Icons.auto_awesome,
                  AppTheme.chakraColor,
                  'ninjutsu',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Genjutsu Training',
                  'Increases your genjutsu combat power',
                  Icons.visibility,
                  AppTheme.defenseColor,
                  'genjutsu',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Bukijutsu Training',
                  'Increases your weapon combat power',
                  Icons.sports_martial_arts,
                  AppTheme.attackColor,
                  'bukijutsu',
                ),
                const SizedBox(height: 12),
                _buildTrainingCard(
                  context,
                  'Taijutsu Training',
                  'Increases your hand-to-hand combat power',
                  Icons.fitness_center,
                  AppTheme.staminaColor,
                  'taijutsu',
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
    
    // Check if this specific training is active
    final trainingTimer = timers.where((timer) => 
        timer.type == TimerType.training && 
        timer.metadata?['statType'] == statType &&
        !timer.isCompleted
    ).firstOrNull;
    
    // Check if ANY training is currently active
    final anyTrainingActive = timers.any((timer) => 
        timer.type == TimerType.training && !timer.isCompleted);
    
    final isTraining = trainingTimer != null;
    final remaining = trainingTimer?.remainingTime ?? Duration.zero;
    final canStartTraining = !isTraining && !anyTrainingActive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: canStartTraining ? AppTheme.cardBackground : AppTheme.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canStartTraining ? color.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: canStartTraining ? AppTheme.cardShadow : [],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: canStartTraining ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: canStartTraining ? color : Colors.grey,
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
                  style: AppTheme.statLabelStyle.copyWith(
                    color: canStartTraining ? AppTheme.statLabelStyle.color : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.descriptionStyle.copyWith(
                    color: canStartTraining ? AppTheme.descriptionStyle.color : Colors.grey.withValues(alpha: 0.7),
                  ),
                ),
                if (!canStartTraining && !isTraining)
                  const SizedBox(height: 4),
                if (!canStartTraining && !isTraining)
                  Text(
                    'Complete current training first',
                    style: TextStyle(
                      color: Colors.orange.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (isTraining)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimerChip(
                      remaining: remaining,
                      label: title,
                      onCollect: () => _collectTraining(trainingTimer.id, statType),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _cancelTraining(trainingTimer.id, statType),
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      tooltip: 'Cancel Training',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTrainingProgress(trainingTimer),
              ],
            )
          else
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 150),
              child: ElevatedButton(
                onPressed: canStartTraining ? () => _showTrainingDurationDialog(statType) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canStartTraining ? color : Colors.grey,
                  foregroundColor: canStartTraining ? AppTheme.textPrimary : Colors.grey.withValues(alpha: 0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTheme.buttonStyle,
                  elevation: canStartTraining ? 4 : 0,
                ),
                child: const Text('Start'),
              ),
            ),
        ],
      ),
    );
  }

  void _startTraining(String statType, Duration duration) {
    // Calculate stat increase based on duration (1 stat point per 30 minutes)
    final totalMinutes = duration.inMinutes;
    int statIncrease = (totalMinutes / 30).round(); // 1 stat per 30 minutes
    
    ref.read(timersProvider.notifier).startTrainingTimer(statType, duration, statIncrease);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    String durationText = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    SnackbarUtils.showSuccess(
      context,
      'Started $statType training for $durationText! Only one training session allowed at a time.',
      backgroundColor: AppTheme.accentColor,
    );
  }

  void _cancelTraining(String timerId, String statType) {
    final timers = ref.read(timersProvider);
    final timer = timers.firstWhere((t) => t.id == timerId);
    
    // Calculate completion percentage and potential gains
    final elapsed = DateTime.now().difference(timer.startTime);
    final totalDuration = timer.duration;
    final completionPercentage = (elapsed.inSeconds / totalDuration.inSeconds * 100).clamp(0, 100);
    
    int partialStatIncrease = 0;
    String gainMessage = 'You will lose all progress.';
    
    if (completionPercentage >= 75) {
      partialStatIncrease = ((timer.metadata?['statIncrease'] ?? 2) * 0.75).round();
      gainMessage = 'You will gain +$partialStatIncrease ${statType.toUpperCase()} (75% of full training).';
    } else if (completionPercentage >= 50) {
      partialStatIncrease = ((timer.metadata?['statIncrease'] ?? 2) * 0.5).round();
      gainMessage = 'You will gain +$partialStatIncrease ${statType.toUpperCase()} (50% of full training).';
    } else if (completionPercentage >= 25) {
      partialStatIncrease = ((timer.metadata?['statIncrease'] ?? 2) * 0.25).round();
      gainMessage = 'You will gain +$partialStatIncrease ${statType.toUpperCase()} (25% of full training).';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Cancel Training',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your $statType training?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: partialStatIncrease > 0 ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: partialStatIncrease > 0 ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    partialStatIncrease > 0 ? Icons.check_circle : Icons.warning,
                    color: partialStatIncrease > 0 ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gainMessage,
                      style: TextStyle(
                        color: partialStatIncrease > 0 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Training Progress: ${completionPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Keep Training',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processCancelledTraining(timer, statType, partialStatIncrease);
            },
            child: Text(
              'Cancel Training',
              style: TextStyle(
                color: partialStatIncrease > 0 ? Colors.orange : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processCancelledTraining(GameTimer timer, String statType, int partialStatIncrease) {
    // Remove the timer
    ref.read(timersProvider.notifier).removeTimer(timer.id);
    
    if (partialStatIncrease > 0) {
      // Apply direct stat increases
      final player = ref.read(playerProvider);
      PlayerStats newStats = player.stats;
      
      // Apply direct stat increases based on stat type
      switch (statType) {
        case 'strength':
          newStats = newStats.copyWith(str: newStats.str.copyWith(level: newStats.str.level + partialStatIncrease));
          break;
        case 'intelligence':
          newStats = newStats.copyWith(intl: newStats.intl.copyWith(level: newStats.intl.level + partialStatIncrease));
          break;
        case 'willpower':
          newStats = newStats.copyWith(wil: newStats.wil.copyWith(level: newStats.wil.level + partialStatIncrease));
          break;
        case 'speed':
          newStats = newStats.copyWith(spd: newStats.spd.copyWith(level: newStats.spd.level + partialStatIncrease));
          break;
        case 'ninjutsu':
          newStats = newStats.copyWith(nin: newStats.nin.copyWith(level: newStats.nin.level + partialStatIncrease));
          break;
        case 'genjutsu':
          newStats = newStats.copyWith(gen: newStats.gen.copyWith(level: newStats.gen.level + partialStatIncrease));
          break;
        case 'bukijutsu':
          newStats = newStats.copyWith(buk: newStats.buk.copyWith(level: newStats.buk.level + partialStatIncrease));
          break;
        case 'taijutsu':
          newStats = newStats.copyWith(tai: newStats.tai.copyWith(level: newStats.tai.level + partialStatIncrease));
          break;
      }
      
      ref.read(playerProvider.notifier).updateStats(newStats);
      
      SnackbarUtils.showSuccess(
        context,
        '$statType training cancelled. You gained +$partialStatIncrease ${statType.toUpperCase()}!',
        backgroundColor: Colors.green,
      );
    } else {
      SnackbarUtils.showWarning(
        context,
        '$statType training cancelled. No gains (less than 25% complete).',
        backgroundColor: Colors.orange,
      );
    }
  }

  Widget _buildTrainingProgress(GameTimer timer) {
    final elapsed = DateTime.now().difference(timer.startTime);
    final totalDuration = timer.duration;
    final completionPercentage = (elapsed.inSeconds / totalDuration.inSeconds * 100).clamp(0, 100);
    
    // Determine progress color based on thresholds
    Color progressColor = Colors.grey;
    if (completionPercentage >= 75) {
      progressColor = Colors.green;
    } else if (completionPercentage >= 50) {
      progressColor = Colors.blue;
    } else if (completionPercentage >= 25) {
      progressColor = Colors.orange;
    }
    
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                '${completionPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: completionPercentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _getProgressMessage(completionPercentage.toDouble()),
            style: TextStyle(
              color: progressColor.withValues(alpha: 0.8),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressMessage(double percentage) {
    if (percentage >= 75) {
      return '75% threshold reached - Cancel for 75% gains';
    } else if (percentage >= 50) {
      return '50% threshold reached - Cancel for 50% gains';
    } else if (percentage >= 25) {
      return '25% threshold reached - Cancel for 25% gains';
    } else {
      return 'No gains if cancelled yet';
    }
  }

  void _showTrainingDurationDialog(String statType) {
    final durations = [
      {'label': '30 minutes', 'duration': const Duration(minutes: 30), 'statIncrease': 1},
      {'label': '1 hour', 'duration': const Duration(hours: 1), 'statIncrease': 2},
      {'label': '2 hours', 'duration': const Duration(hours: 2), 'statIncrease': 4},
      {'label': '4 hours', 'duration': const Duration(hours: 4), 'statIncrease': 8},
      {'label': '8 hours', 'duration': const Duration(hours: 8), 'statIncrease': 16},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Choose Training Duration',
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: durations.map((duration) => ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.timer,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
              ),
              title: Text(
                duration['label'] as String,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Gain +${duration['statIncrease']} ${statType.toUpperCase()}',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.pop(context);
                _startTraining(statType, duration['duration'] as Duration);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: Colors.white.withValues(alpha: 0.05),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void _collectTraining(String timerId, String statType) {
    final timers = ref.read(timersProvider);
    final timer = timers.firstWhere((t) => t.id == timerId);
    
    ref.read(timersProvider.notifier).completeTimer(timerId);

    // Update player stats using direct stat increases
    final player = ref.read(playerProvider);
    PlayerStats newStats = player.stats;
    
    // Get stat increase from metadata
    int statIncrease = timer.metadata?['statIncrease'] ?? 2; // Default fallback
    
    // Debug: Print current stats before training
    print('Before training - Attack: ${newStats.attack}, Defense: ${newStats.defense}, Chakra: ${newStats.chakra}, Stamina: ${newStats.stamina}');
    print('Base stats - STR: ${newStats.str.level}, WIL: ${newStats.wil.level}, INTL: ${newStats.intl.level}, SPD: ${newStats.spd.level}');
    print('Training stat increase: $statIncrease');
    
    // Apply direct stat increases based on stat type
    switch (statType) {
      case 'strength':
        newStats = newStats.copyWith(str: newStats.str.copyWith(level: newStats.str.level + statIncrease));
        break;
      case 'intelligence':
        newStats = newStats.copyWith(intl: newStats.intl.copyWith(level: newStats.intl.level + statIncrease));
        break;
      case 'willpower':
        newStats = newStats.copyWith(wil: newStats.wil.copyWith(level: newStats.wil.level + statIncrease));
        break;
      case 'speed':
        newStats = newStats.copyWith(spd: newStats.spd.copyWith(level: newStats.spd.level + statIncrease));
        break;
      case 'ninjutsu':
        newStats = newStats.copyWith(nin: newStats.nin.copyWith(level: newStats.nin.level + statIncrease));
        break;
      case 'genjutsu':
        newStats = newStats.copyWith(gen: newStats.gen.copyWith(level: newStats.gen.level + statIncrease));
        break;
      case 'bukijutsu':
        newStats = newStats.copyWith(buk: newStats.buk.copyWith(level: newStats.buk.level + statIncrease));
        break;
      case 'taijutsu':
        newStats = newStats.copyWith(tai: newStats.tai.copyWith(level: newStats.tai.level + statIncrease));
        break;
    }
    
    // Debug: Print stats after training
    print('After training - Attack: ${newStats.attack}, Defense: ${newStats.defense}, Chakra: ${newStats.chakra}, Stamina: ${newStats.stamina}');
    print('Base stats - STR: ${newStats.str.level}, WIL: ${newStats.wil.level}, INTL: ${newStats.intl.level}, SPD: ${newStats.spd.level}');
    
    ref.read(playerProvider.notifier).updateStats(newStats);

    // Force a rebuild by updating the state
    setState(() {});

    // Show specific message based on training type
    String message = 'Training completed! ';
    switch (statType) {
      case 'strength':
        message += 'Strength increased by +$statIncrease to ${newStats.str.level}!';
        break;
      case 'intelligence':
        message += 'Intelligence increased by +$statIncrease to ${newStats.intl.level}!';
        break;
      case 'willpower':
        message += 'Willpower increased by +$statIncrease to ${newStats.wil.level}!';
        break;
      case 'speed':
        message += 'Speed increased by +$statIncrease to ${newStats.spd.level}!';
        break;
      case 'ninjutsu':
        message += 'Ninjutsu increased by +$statIncrease to ${newStats.nin.level}!';
        break;
      case 'genjutsu':
        message += 'Genjutsu increased by +$statIncrease to ${newStats.gen.level}!';
        break;
      case 'bukijutsu':
        message += 'Bukijutsu increased by +$statIncrease to ${newStats.buk.level}!';
        break;
      case 'taijutsu':
        message += 'Taijutsu increased by +$statIncrease to ${newStats.tai.level}!';
        break;
      default:
        message += '$statType increased by +$statIncrease!';
    }

    SnackbarUtils.showSuccess(
      context,
      message,
      backgroundColor: AppTheme.staminaColor,
    );
  }

  Widget _buildStatDisplay(String label, int value, Color color, String fullName) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          fullName,
          style: TextStyle(
            color: color.withValues(alpha: 0.8),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
