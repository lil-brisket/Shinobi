// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthRequestDtoImpl _$$AuthRequestDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthRequestDtoImpl(
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String?,
      villageId: json['villageId'] as String?,
    );

Map<String, dynamic> _$$AuthRequestDtoImplToJson(
        _$AuthRequestDtoImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'villageId': instance.villageId,
    };

_$AuthResponseDtoImpl _$$AuthResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseDtoImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      sessionToken: json['sessionToken'] as String,
      villageId: json['villageId'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$AuthResponseDtoImplToJson(
        _$AuthResponseDtoImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'sessionToken': instance.sessionToken,
      'villageId': instance.villageId,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_$UserProfileDtoImpl _$$UserProfileDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileDtoImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      villageId: json['villageId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$$UserProfileDtoImplToJson(
        _$UserProfileDtoImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'villageId': instance.villageId,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };
