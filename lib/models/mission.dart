import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

enum MissionRank {
  @JsonValue('d')
  d,
  @JsonValue('c')
  c,
  @JsonValue('b')
  b,
  @JsonValue('a')
  a,
  @JsonValue('s')
  s,
}

enum MissionStatus {
  @JsonValue('available')
  available,
  @JsonValue('inProgress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

@freezed
class MissionReward with _$MissionReward {
  const factory MissionReward({
    required int xp,
    required int ryo,
    @Default([]) List<String> itemIds,
  }) = _MissionReward;

  factory MissionReward.fromJson(Map<String, dynamic> json) => _$MissionRewardFromJson(json);
}

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String title,
    required String description,
    required MissionRank rank,
    required int requiredLevel,
    required MissionReward reward,
    required int durationSeconds,
    @Default(MissionStatus.available) MissionStatus status,
    DateTime? startTime,
    DateTime? endTime,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
}