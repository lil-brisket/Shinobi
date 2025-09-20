import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

@freezed
class Stats with _$Stats {
  const factory Stats({
    required int hp,
    required int maxHp,
    required int chakra,
    required int maxChakra,
    required int stamina,
    required int maxStamina,
    required int attack,
    required int defense,
    required int speed,
  }) = _Stats;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
}