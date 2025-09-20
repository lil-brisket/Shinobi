import 'package:flutter/material.dart';
import '../app/theme.dart';

class CurrencyPill extends StatelessWidget {
  final int amount;
  final IconData icon;
  final Color? color;

  const CurrencyPill({
    super.key,
    required this.amount,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color pillColor = color ?? AppTheme.ryoColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: pillColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: pillColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: pillColor,
          ),
          const SizedBox(width: 4),
          Text(
            _formatAmount(amount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: pillColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toString();
    }
  }
}
