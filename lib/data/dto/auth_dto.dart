import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

/// Data Transfer Object for authentication requests
@freezed
class AuthRequestDto with _$AuthRequestDto {
  const factory AuthRequestDto({
    required String username,
    required String password,
    String? email,
    String? villageId,
  }) = _AuthRequestDto;

  factory AuthRequestDto.fromJson(Map<String, dynamic> json) => _$AuthRequestDtoFromJson(json);
}

/// Data Transfer Object for authentication responses
@freezed
class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String userId,
    required String username,
    required String sessionToken,
    String? villageId,
    required DateTime expiresAt,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) => _$AuthResponseDtoFromJson(json);
}

/// Data Transfer Object for user profile data
@freezed
class UserProfileDto with _$UserProfileDto {
  const factory UserProfileDto({
    required String userId,
    required String username,
    required String villageId,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => _$UserProfileDtoFromJson(json);
}
