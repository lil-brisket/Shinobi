import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Reusable stat bar widget for HP, CP, SP, AP display
class StatBar extends StatelessWidget {
  const StatBar({
    super.key,
    required this.current,
    required this.max,
    required this.color,
    required this.label,
    this.height = 8.0,
    this.showValues = true,
    this.animationDuration = AppTokens.animationFast,
  });

  final int current;
  final int max;
  final Color color;
  final String label;
  final double height;
  final bool showValues;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final percentage = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showValues)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                '$current/$max',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        if (showValues) const SizedBox(height: AppTokens.spacingXs),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppTokens.radiusS),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTokens.radiusS),
            child: TweenAnimationBuilder<double>(
              duration: animationDuration,
              tween: Tween(begin: 0.0, end: percentage),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact stat bar for use in smaller spaces
class CompactStatBar extends StatelessWidget {
  const CompactStatBar({
    super.key,
    required this.current,
    required this.max,
    required this.color,
    this.height = 6.0,
  });

  final int current;
  final int max;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final percentage = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTokens.radiusS),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTokens.radiusS),
        child: TweenAnimationBuilder<double>(
          duration: AppTokens.animationFast,
          tween: Tween(begin: 0.0, end: percentage),
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            );
          },
        ),
      ),
    );
  }
}

/// Multi-stat bar widget for displaying multiple stats at once
class MultiStatBar extends StatelessWidget {
  const MultiStatBar({
    super.key,
    required this.stats,
    this.spacing = AppTokens.spacingS,
  });

  final List<StatBarData> stats;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stats.map((stat) {
        final isLast = stats.last == stat;
        return Column(
          children: [
            StatBar(
              current: stat.current,
              max: stat.max,
              color: stat.color,
              label: stat.label,
              showValues: stat.showValues,
            ),
            if (!isLast) SizedBox(height: spacing),
          ],
        );
      }).toList(),
    );
  }
}

/// Data class for stat bar information
class StatBarData {
  const StatBarData({
    required this.current,
    required this.max,
    required this.color,
    required this.label,
    this.showValues = true,
  });

  final int current;
  final int max;
  final Color color;
  final String label;
  final bool showValues;
}
