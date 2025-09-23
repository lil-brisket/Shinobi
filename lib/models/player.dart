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
class MedicalNinjaProfession with _$MedicalNinjaProfession {
  const factory MedicalNinjaProfession({
    @Default(1) int level,
    @Default(0) int xp,
  }) = _MedicalNinjaProfession;

  factory MedicalNinjaProfession.fromJson(Map<String, dynamic> json) => _$MedicalNinjaProfessionFromJson(json);
}

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    required String avatarUrl,
    required String village,
    required int ryo,
    required PlayerStats stats,
    @Default([]) List<String> jutsuIds,
    @Default([]) List<String> itemIds,
    @Default(PlayerRank.genin) PlayerRank rank,
    @Default(MedicalNinjaProfession()) MedicalNinjaProfession medNinja,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

extension MedicalNinjaProfessionExtension on MedicalNinjaProfession {
  // XP required for next level (scales with level)
  int get xpToNext => level * 100;
  
  // Healing bonus percentage based on level
  double get healingBonus => level * 0.05; // 5% per level
  
  // CP/SP cost reduction percentage based on level
  // Scales to 75% reduction at level 100 (0.5 CP/SP per HP)
  double get costReduction => (level * 0.0075).clamp(0.0, 0.75); // 0.75% per level, capped at 75%
  
  // Add XP and handle leveling up
  MedicalNinjaProfession addXp(int amount) {
    int newXp = xp + amount;
    int newLevel = level;
    
    // Check for level ups
    while (newXp >= newLevel * 100) {
      newXp -= newLevel * 100;
      newLevel++;
    }
    
    return copyWith(level: newLevel, xp: newXp);
  }
}