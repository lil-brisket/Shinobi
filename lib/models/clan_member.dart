import 'package:freezed_annotation/freezed_annotation.dart';

part 'clan_member.freezed.dart';
part 'clan_member.g.dart';

enum ClanRole {
  @JsonValue('LEADER')
  leader,
  @JsonValue('ADVISOR')
  advisor,
  @JsonValue('MEMBER')
  member,
}

@freezed
class ClanMember with _$ClanMember {
  const factory ClanMember({
    required String id,
    required String clanId,
    required String userId,
    required ClanRole role,
    required String displayName,
    required DateTime joinedAt,
  }) = _ClanMember;

  factory ClanMember.fromJson(Map<String, dynamic> json) => _$ClanMemberFromJson(json);
}

extension ClanRoleExtension on ClanRole {
  String get displayName {
    switch (this) {
      case ClanRole.leader:
        return 'Leader';
      case ClanRole.advisor:
        return 'Advisor';
      case ClanRole.member:
        return 'Member';
    }
  }

  bool get canApproveRequests => this == ClanRole.leader || this == ClanRole.advisor;
  bool get canPromoteMembers => this == ClanRole.leader;
  bool get canTransferLeadership => this == ClanRole.leader;
  bool get canEditClan => this == ClanRole.leader;
  bool get canDisbandClan => this == ClanRole.leader;
  bool get canPinPosts => this == ClanRole.leader || this == ClanRole.advisor;
  bool get canDeletePosts => this == ClanRole.leader;
}
