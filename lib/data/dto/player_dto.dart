import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_dto.freezed.dart';
part 'player_dto.g.dart';

/// Data Transfer Object for player data from server
@freezed
class PlayerDto with _$PlayerDto {
  const factory PlayerDto({
    required String id,
    required String name,
    required String avatarUrl,
    required String village,
    required int ryo,
    required PlayerStatsDto stats,
    required List<String> jutsuIds,
    required List<String> itemIds,
    required String rank,
  }) = _PlayerDto;

  factory PlayerDto.fromJson(Map<String, dynamic> json) => _$PlayerDtoFromJson(json);
}

/// Data Transfer Object for player stats
@freezed
class PlayerStatsDto with _$PlayerStatsDto {
  const factory PlayerStatsDto({
    required int level,
    @Default(0) int str,
    @Default(0) int intl,
    @Default(0) int spd,
    @Default(0) int wil,
    @Default(0) int nin,
    @Default(0) int gen,
    @Default(0) int buk,
    @Default(0) int tai,
    int? currentHP,
    int? currentSP,
    int? currentCP,
  }) = _PlayerStatsDto;

  factory PlayerStatsDto.fromJson(Map<String, dynamic> json) => _$PlayerStatsDtoFromJson(json);
}

/// Data Transfer Object for inventory items
@freezed
class ItemDto with _$ItemDto {
  const factory ItemDto({
    required String id,
    required String name,
    required String description,
    required String icon,
    required int quantity,
    required String rarity,
    required Map<String, dynamic> effect,
    required String kind,
    String? size,
    Map<String, dynamic>? equip,
  }) = _ItemDto;

  factory ItemDto.fromJson(Map<String, dynamic> json) => _$ItemDtoFromJson(json);
}

/// Data Transfer Object for jutsu data
@freezed
class JutsuDto with _$JutsuDto {
  const factory JutsuDto({
    required String id,
    required String name,
    required String type,
    required int chakraCost,
    required int power,
    required String description,
    required bool isEquipped,
    required int range,
    required String targeting,
    required int apCost,
    int? areaRadius,
  }) = _JutsuDto;

  factory JutsuDto.fromJson(Map<String, dynamic> json) => _$JutsuDtoFromJson(json);
}
