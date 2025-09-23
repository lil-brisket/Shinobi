// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClanApplicationImpl _$$ClanApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$ClanApplicationImpl(
      id: json['id'] as String,
      clanId: json['clanId'] as String,
      userId: json['userId'] as String,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ClanApplicationImplToJson(
        _$ClanApplicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clanId': instance.clanId,
      'userId': instance.userId,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'PENDING',
  ApplicationStatus.approved: 'APPROVED',
  ApplicationStatus.rejected: 'REJECTED',
  ApplicationStatus.withdrawn: 'WITHDRAWN',
};

_$ClanApplicationWithDetailsImpl _$$ClanApplicationWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$ClanApplicationWithDetailsImpl(
      application:
          ClanApplication.fromJson(json['application'] as Map<String, dynamic>),
      userName: json['userName'] as String,
      clanName: json['clanName'] as String,
    );

Map<String, dynamic> _$$ClanApplicationWithDetailsImplToJson(
        _$ClanApplicationWithDetailsImpl instance) =>
    <String, dynamic>{
      'application': instance.application,
      'userName': instance.userName,
      'clanName': instance.clanName,
    };
