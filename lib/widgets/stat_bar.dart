import 'package:flutter/material.dart';
import '../app/theme.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color accentColor;
  final bool showNumbers;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.accentColor,
    this.showNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = maxValue > 0 ? value / maxValue : 0.0;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.statLabelStyle,
              ),
              if (showNumbers)
                Text(
                  '$value / $maxValue',
                  style: AppTheme.statValueStyle.copyWith(
                    color: accentColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.textSecondary.withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: AppTheme.progressBarGlow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
