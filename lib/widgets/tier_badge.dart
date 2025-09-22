import 'package:flutter/material.dart';

class TierBadge extends StatelessWidget {
  final int tier;
  final double? size;

  const TierBadge({
    super.key,
    required this.tier,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final tierStyles = _getTierStyles(tier);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size! * 0.8,
        vertical: size! * 0.3,
      ),
      decoration: BoxDecoration(
        color: tierStyles['backgroundColor'],
        borderRadius: BorderRadius.circular(size! * 0.5),
        border: tierStyles['border'] != null
            ? Border.all(
                color: tierStyles['border']!,
                width: 1.5,
              )
            : null,
        boxShadow: tierStyles['boxShadow'],
      ),
      child: Text(
        'Tier $tier',
        style: TextStyle(
          color: tierStyles['textColor'],
          fontSize: size! * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<String, dynamic> _getTierStyles(int tier) {
    switch (tier) {
      case 1:
        return {
          'backgroundColor': Colors.grey[700],
          'textColor': Colors.grey[200],
          'border': null,
          'boxShadow': null,
        };
      case 2:
        return {
          'backgroundColor': Colors.blue[700],
          'textColor': Colors.blue[100],
          'border': null,
          'boxShadow': null,
        };
      case 3:
        return {
          'backgroundColor': Colors.green[700],
          'textColor': Colors.green[100],
          'border': null,
          'boxShadow': null,
        };
      case 4:
        return {
          'backgroundColor': Colors.purple[700],
          'textColor': Colors.purple[100],
          'border': null,
          'boxShadow': null,
        };
      case 5:
        return {
          'backgroundColor': Colors.amber[500],
          'textColor': Colors.grey[900],
          'border': Colors.amber[300],
          'boxShadow': [
            BoxShadow(
              color: Colors.amber[300]!.withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        };
      default:
        return {
          'backgroundColor': Colors.grey[700],
          'textColor': Colors.grey[200],
          'border': null,
          'boxShadow': null,
        };
    }
  }
}
