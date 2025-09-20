import 'package:flutter/material.dart';
import '../app/theme.dart';

class TimerChip extends StatefulWidget {
  final Duration remaining;
  final VoidCallback? onCollect;
  final String label;

  const TimerChip({
    super.key,
    required this.remaining,
    this.onCollect,
    required this.label,
  });

  @override
  State<TimerChip> createState() => _TimerChipState();
}

class _TimerChipState extends State<TimerChip> {
  late Duration _remaining;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _remaining = widget.remaining;
    _isCompleted = _remaining.inSeconds <= 0;
    if (!_isCompleted) {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
          _isCompleted = _remaining.inSeconds <= 0;
        });
        if (!_isCompleted) {
          _startTimer();
        }
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isCompleted ? AppTheme.staminaColor : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isCompleted ? AppTheme.staminaColor : AppTheme.accentColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isCompleted ? Icons.check_circle : Icons.timer,
            size: 16,
            color: _isCompleted ? Colors.white : AppTheme.accentColor,
          ),
          const SizedBox(width: 8),
          Text(
            _isCompleted ? 'Ready!' : _formatDuration(_remaining),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _isCompleted ? Colors.white : AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_isCompleted && widget.onCollect != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onCollect,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Collect',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
