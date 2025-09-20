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
  }) = _Jutsu;

  factory Jutsu.fromJson(Map<String, dynamic> json) => _$JutsuFromJson(json);
}