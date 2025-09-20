import 'package:freezed_annotation/freezed_annotation.dart';
import 'stats.dart';

part 'player.freezed.dart';
part 'player.g.dart';

enum PlayerRank {
  genin,
  chunin,
  jonin,
  anbu,
  kage,
}

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    required String avatarUrl,
    required String village,
    required int ryo,
    required Stats stats,
    @Default([]) List<String> jutsuIds,
    @Default([]) List<String> itemIds,
    @Default(PlayerRank.genin) PlayerRank rank,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}