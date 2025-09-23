import 'package:freezed_annotation/freezed_annotation.dart';

part 'clan.freezed.dart';
part 'clan.g.dart';

@freezed
class Clan with _$Clan {
  const factory Clan({
    required String id,
    required String name,
    required String villageId,
    required String leaderId,
    String? emblemUrl,
    String? description,
    @Default(0) int score,
    @Default(0) int wins,
    @Default(0) int losses,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Clan;

  factory Clan.fromJson(Map<String, dynamic> json) => _$ClanFromJson(json);
}

@freezed
class ClanWithDetails with _$ClanWithDetails {
  const factory ClanWithDetails({
    required Clan clan,
    required String leaderName,
    required int memberCount,
    required int advisorCount,
  }) = _ClanWithDetails;

  factory ClanWithDetails.fromJson(Map<String, dynamic> json) => _$ClanWithDetailsFromJson(json);
}