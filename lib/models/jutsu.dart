import 'package:freezed_annotation/freezed_annotation.dart';

part 'jutsu.freezed.dart';
part 'jutsu.g.dart';

enum JutsuType {
  @JsonValue('ninjutsu')
  ninjutsu,
  @JsonValue('taijutsu')
  taijutsu,
  @JsonValue('genjutsu')
  genjutsu,
  @JsonValue('kekkeiGenkai')
  kekkeiGenkai,
}

enum JutsuTargeting {
  @JsonValue('straight_line')
  straightLine,
  @JsonValue('area_around_player')
  areaAroundPlayer,
  @JsonValue('single_target')
  singleTarget,
  @JsonValue('movement_ability')
  movementAbility,
}

@freezed
class Jutsu with _$Jutsu {
  const factory Jutsu({
    required String id,
    required String name,
    required JutsuType type,
    required int chakraCost,
    required int power,
    required String description,
    @Default(false) bool isEquipped,
    @Default(1) int range,
    @Default(JutsuTargeting.singleTarget) JutsuTargeting targeting,
    @Default(0) int areaRadius, // For area effects around target or player
    @Default(0) int apCost, // Action Points cost for using the jutsu
  }) = _Jutsu;

  factory Jutsu.fromJson(Map<String, dynamic> json) => _$JutsuFromJson(json);
}