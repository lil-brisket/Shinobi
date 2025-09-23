// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clan_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClanMember _$ClanMemberFromJson(Map<String, dynamic> json) {
  return _ClanMember.fromJson(json);
}

/// @nodoc
mixin _$ClanMember {
  String get id => throw _privateConstructorUsedError;
  String get clanId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ClanRole get role => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this ClanMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClanMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClanMemberCopyWith<ClanMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClanMemberCopyWith<$Res> {
  factory $ClanMemberCopyWith(
          ClanMember value, $Res Function(ClanMember) then) =
      _$ClanMemberCopyWithImpl<$Res, ClanMember>;
  @useResult
  $Res call(
      {String id,
      String clanId,
      String userId,
      ClanRole role,
      String displayName,
      DateTime joinedAt});
}

/// @nodoc
class _$ClanMemberCopyWithImpl<$Res, $Val extends ClanMember>
    implements $ClanMemberCopyWith<$Res> {
  _$ClanMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClanMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? userId = null,
    Object? role = null,
    Object? displayName = null,
    Object? joinedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clanId: null == clanId
          ? _value.clanId
          : clanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ClanRole,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClanMemberImplCopyWith<$Res>
    implements $ClanMemberCopyWith<$Res> {
  factory _$$ClanMemberImplCopyWith(
          _$ClanMemberImpl value, $Res Function(_$ClanMemberImpl) then) =
      __$$ClanMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clanId,
      String userId,
      ClanRole role,
      String displayName,
      DateTime joinedAt});
}

/// @nodoc
class __$$ClanMemberImplCopyWithImpl<$Res>
    extends _$ClanMemberCopyWithImpl<$Res, _$ClanMemberImpl>
    implements _$$ClanMemberImplCopyWith<$Res> {
  __$$ClanMemberImplCopyWithImpl(
      _$ClanMemberImpl _value, $Res Function(_$ClanMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClanMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? userId = null,
    Object? role = null,
    Object? displayName = null,
    Object? joinedAt = null,
  }) {
    return _then(_$ClanMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clanId: null == clanId
          ? _value.clanId
          : clanId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ClanRole,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClanMemberImpl implements _ClanMember {
  const _$ClanMemberImpl(
      {required this.id,
      required this.clanId,
      required this.userId,
      required this.role,
      required this.displayName,
      required this.joinedAt});

  factory _$ClanMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClanMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String clanId;
  @override
  final String userId;
  @override
  final ClanRole role;
  @override
  final String displayName;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'ClanMember(id: $id, clanId: $clanId, userId: $userId, role: $role, displayName: $displayName, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClanMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clanId, clanId) || other.clanId == clanId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, clanId, userId, role, displayName, joinedAt);

  /// Create a copy of ClanMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClanMemberImplCopyWith<_$ClanMemberImpl> get copyWith =>
      __$$ClanMemberImplCopyWithImpl<_$ClanMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClanMemberImplToJson(
      this,
    );
  }
}

abstract class _ClanMember implements ClanMember {
  const factory _ClanMember(
      {required final String id,
      required final String clanId,
      required final String userId,
      required final ClanRole role,
      required final String displayName,
      required final DateTime joinedAt}) = _$ClanMemberImpl;

  factory _ClanMember.fromJson(Map<String, dynamic> json) =
      _$ClanMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get clanId;
  @override
  String get userId;
  @override
  ClanRole get role;
  @override
  String get displayName;
  @override
  DateTime get joinedAt;

  /// Create a copy of ClanMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClanMemberImplCopyWith<_$ClanMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
