import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer.freezed.dart';
part 'timer.g.dart';

enum TimerType {
  @JsonValue('training')
  training,
  @JsonValue('mission')
  mission,
  @JsonValue('healing')
  healing,
  @JsonValue('other')
  other,
}

@freezed
class GameTimer with _$GameTimer {
  const factory GameTimer({
    required String id,
    required String title,
    required TimerType type,
    required DateTime startTime,
    required Duration duration,
    @Default(false) bool isCompleted,
    Map<String, dynamic>? metadata,
  }) = _GameTimer;

  factory GameTimer.fromJson(Map<String, dynamic> json) => _$GameTimerFromJson(json);

  const GameTimer._();

  // Helper getter to get remaining time
  Duration get remainingTime {
    if (isCompleted) return Duration.zero;
    
    final elapsed = DateTime.now().difference(startTime);
    final remaining = duration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Helper getter to check if timer is finished
  bool get isFinished => remainingTime == Duration.zero && !isCompleted;
}
