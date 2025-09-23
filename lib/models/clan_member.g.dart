// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClanMemberImpl _$$ClanMemberImplFromJson(Map<String, dynamic> json) =>
    _$ClanMemberImpl(
      id: json['id'] as String,
      clanId: json['clanId'] as String,
      userId: json['userId'] as String,
      role: $enumDecode(_$ClanRoleEnumMap, json['role']),
      displayName: json['displayName'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$ClanMemberImplToJson(_$ClanMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clanId': instance.clanId,
      'userId': instance.userId,
      'role': _$ClanRoleEnumMap[instance.role]!,
      'displayName': instance.displayName,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

const _$ClanRoleEnumMap = {
  ClanRole.leader: 'LEADER',
  ClanRole.advisor: 'ADVISOR',
  ClanRole.member: 'MEMBER',
};
