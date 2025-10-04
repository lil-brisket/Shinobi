import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../failures.dart';
import '../../models/timer.dart';
import '../../services/supabase_service.dart';

abstract class TimerRepository {
  Future<({List<GameTimer>? timers, Failure? failure})> getPlayerTimers(String playerId);
  Future<({GameTimer? timer, Failure? failure})> createTimer(GameTimer timer, String playerId);
  Future<({GameTimer? timer, Failure? failure})> updateTimer(GameTimer timer, String playerId);
  Future<({bool success, Failure? failure})> deleteTimer(String timerId);
  Future<({bool success, Failure? failure})> completeTimer(String timerId);
}

class TimerRepositoryImpl implements TimerRepository {
  final SupabaseService _supabaseService;

  TimerRepositoryImpl(this._supabaseService);

  @override
  Future<({List<GameTimer>? timers, Failure? failure})> getPlayerTimers(String playerId) async {
    try {
      final response = await _supabaseService.client
          .from('timers')
          .select('*')
          .eq('player_id', playerId)
          .eq('is_active', true)
          .order('started_at', ascending: false);

      final timers = response.map<GameTimer>((json) => _mapTimerFromJson(json)).toList();
      return (timers: timers, failure: null);
    } catch (e) {
      return (timers: null, failure: ServerFailure('Failed to fetch timers: $e'));
    }
  }

  @override
  Future<({GameTimer? timer, Failure? failure})> createTimer(GameTimer timer, String playerId) async {
    try {
      final json = _mapTimerToJson(timer, playerId);
      final response = await _supabaseService.client
          .from('timers')
          .insert(json)
          .select()
          .single();

      final createdTimer = _mapTimerFromJson(response);
      return (timer: createdTimer, failure: null);
    } catch (e) {
      return (timer: null, failure: ServerFailure('Failed to create timer: $e'));
    }
  }

  @override
  Future<({GameTimer? timer, Failure? failure})> updateTimer(GameTimer timer, String playerId) async {
    try {
      final json = _mapTimerToJson(timer, playerId);
      final response = await _supabaseService.client
          .from('timers')
          .update(json)
          .eq('id', timer.id)
          .select()
          .single();

      final updatedTimer = _mapTimerFromJson(response);
      return (timer: updatedTimer, failure: null);
    } catch (e) {
      return (timer: null, failure: ServerFailure('Failed to update timer: $e'));
    }
  }

  @override
  Future<({bool success, Failure? failure})> deleteTimer(String timerId) async {
    try {
      await _supabaseService.client
          .from('timers')
          .delete()
          .eq('id', timerId);

      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to delete timer: $e'));
    }
  }

  @override
  Future<({bool success, Failure? failure})> completeTimer(String timerId) async {
    try {
      await _supabaseService.client
          .from('timers')
          .update({'is_active': false})
          .eq('id', timerId);

      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to complete timer: $e'));
    }
  }

  GameTimer _mapTimerFromJson(Map<String, dynamic> json) {
    return GameTimer(
      id: json['id'],
      title: json['title'] ?? 'Unknown Timer',
      type: _mapTimerTypeFromString(json['timer_type']),
      startTime: DateTime.parse(json['started_at']),
      duration: Duration(seconds: json['duration']),
      isCompleted: !json['is_active'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> _mapTimerToJson(GameTimer timer, String playerId) {
    return {
      'id': timer.id,
      'player_id': playerId,
      'timer_type': _mapTimerTypeToString(timer.type),
      'title': timer.title,
      'duration': timer.duration.inSeconds,
      'started_at': timer.startTime.toIso8601String(),
      'expires_at': timer.startTime.add(timer.duration).toIso8601String(),
      'is_active': !timer.isCompleted,
      'metadata': timer.metadata ?? {},
    };
  }

  TimerType _mapTimerTypeFromString(String type) {
    switch (type) {
      case 'training':
        return TimerType.training;
      case 'mission':
        return TimerType.mission;
      case 'healing':
        return TimerType.healing;
      default:
        return TimerType.other;
    }
  }

  String _mapTimerTypeToString(TimerType type) {
    switch (type) {
      case TimerType.training:
        return 'training';
      case TimerType.mission:
        return 'mission';
      case TimerType.healing:
        return 'healing';
      case TimerType.other:
        return 'custom';
    }
  }
}

// Provider for the timer repository
final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return TimerRepositoryImpl(SupabaseService.instance);
});
