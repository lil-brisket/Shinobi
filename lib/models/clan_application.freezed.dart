// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clan_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClanApplication _$ClanApplicationFromJson(Map<String, dynamic> json) {
  return _ClanApplication.fromJson(json);
}

/// @nodoc
mixin _$ClanApplication {
  String get id => throw _privateConstructorUsedError;
  String get clanId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ClanApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClanApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClanApplicationCopyWith<ClanApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClanApplicationCopyWith<$Res> {
  factory $ClanApplicationCopyWith(
          ClanApplication value, $Res Function(ClanApplication) then) =
      _$ClanApplicationCopyWithImpl<$Res, ClanApplication>;
  @useResult
  $Res call(
      {String id,
      String clanId,
      String userId,
      ApplicationStatus status,
      String? message,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ClanApplicationCopyWithImpl<$Res, $Val extends ClanApplication>
    implements $ClanApplicationCopyWith<$Res> {
  _$ClanApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClanApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? userId = null,
    Object? status = null,
    Object? message = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClanApplicationImplCopyWith<$Res>
    implements $ClanApplicationCopyWith<$Res> {
  factory _$$ClanApplicationImplCopyWith(_$ClanApplicationImpl value,
          $Res Function(_$ClanApplicationImpl) then) =
      __$$ClanApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clanId,
      String userId,
      ApplicationStatus status,
      String? message,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ClanApplicationImplCopyWithImpl<$Res>
    extends _$ClanApplicationCopyWithImpl<$Res, _$ClanApplicationImpl>
    implements _$$ClanApplicationImplCopyWith<$Res> {
  __$$ClanApplicationImplCopyWithImpl(
      _$ClanApplicationImpl _value, $Res Function(_$ClanApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClanApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? userId = null,
    Object? status = null,
    Object? message = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ClanApplicationImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClanApplicationImpl implements _ClanApplication {
  const _$ClanApplicationImpl(
      {required this.id,
      required this.clanId,
      required this.userId,
      required this.status,
      this.message,
      required this.createdAt,
      this.updatedAt});

  factory _$ClanApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClanApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String clanId;
  @override
  final String userId;
  @override
  final ApplicationStatus status;
  @override
  final String? message;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ClanApplication(id: $id, clanId: $clanId, userId: $userId, status: $status, message: $message, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClanApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clanId, clanId) || other.clanId == clanId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, clanId, userId, status, message, createdAt, updatedAt);

  /// Create a copy of ClanApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClanApplicationImplCopyWith<_$ClanApplicationImpl> get copyWith =>
      __$$ClanApplicationImplCopyWithImpl<_$ClanApplicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClanApplicationImplToJson(
      this,
    );
  }
}

abstract class _ClanApplication implements ClanApplication {
  const factory _ClanApplication(
      {required final String id,
      required final String clanId,
      required final String userId,
      required final ApplicationStatus status,
      final String? message,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ClanApplicationImpl;

  factory _ClanApplication.fromJson(Map<String, dynamic> json) =
      _$ClanApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get clanId;
  @override
  String get userId;
  @override
  ApplicationStatus get status;
  @override
  String? get message;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ClanApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClanApplicationImplCopyWith<_$ClanApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClanApplicationWithDetails _$ClanApplicationWithDetailsFromJson(
    Map<String, dynamic> json) {
  return _ClanApplicationWithDetails.fromJson(json);
}

/// @nodoc
mixin _$ClanApplicationWithDetails {
  ClanApplication get application => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get clanName => throw _privateConstructorUsedError;

  /// Serializes this ClanApplicationWithDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClanApplicationWithDetailsCopyWith<ClanApplicationWithDetails>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClanApplicationWithDetailsCopyWith<$Res> {
  factory $ClanApplicationWithDetailsCopyWith(ClanApplicationWithDetails value,
          $Res Function(ClanApplicationWithDetails) then) =
      _$ClanApplicationWithDetailsCopyWithImpl<$Res,
          ClanApplicationWithDetails>;
  @useResult
  $Res call({ClanApplication application, String userName, String clanName});

  $ClanApplicationCopyWith<$Res> get application;
}

/// @nodoc
class _$ClanApplicationWithDetailsCopyWithImpl<$Res,
        $Val extends ClanApplicationWithDetails>
    implements $ClanApplicationWithDetailsCopyWith<$Res> {
  _$ClanApplicationWithDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? application = null,
    Object? userName = null,
    Object? clanName = null,
  }) {
    return _then(_value.copyWith(
      application: null == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as ClanApplication,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      clanName: null == clanName
          ? _value.clanName
          : clanName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClanApplicationCopyWith<$Res> get application {
    return $ClanApplicationCopyWith<$Res>(_value.application, (value) {
      return _then(_value.copyWith(application: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClanApplicationWithDetailsImplCopyWith<$Res>
    implements $ClanApplicationWithDetailsCopyWith<$Res> {
  factory _$$ClanApplicationWithDetailsImplCopyWith(
          _$ClanApplicationWithDetailsImpl value,
          $Res Function(_$ClanApplicationWithDetailsImpl) then) =
      __$$ClanApplicationWithDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ClanApplication application, String userName, String clanName});

  @override
  $ClanApplicationCopyWith<$Res> get application;
}

/// @nodoc
class __$$ClanApplicationWithDetailsImplCopyWithImpl<$Res>
    extends _$ClanApplicationWithDetailsCopyWithImpl<$Res,
        _$ClanApplicationWithDetailsImpl>
    implements _$$ClanApplicationWithDetailsImplCopyWith<$Res> {
  __$$ClanApplicationWithDetailsImplCopyWithImpl(
      _$ClanApplicationWithDetailsImpl _value,
      $Res Function(_$ClanApplicationWithDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? application = null,
    Object? userName = null,
    Object? clanName = null,
  }) {
    return _then(_$ClanApplicationWithDetailsImpl(
      application: null == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as ClanApplication,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      clanName: null == clanName
          ? _value.clanName
          : clanName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClanApplicationWithDetailsImpl implements _ClanApplicationWithDetails {
  const _$ClanApplicationWithDetailsImpl(
      {required this.application,
      required this.userName,
      required this.clanName});

  factory _$ClanApplicationWithDetailsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ClanApplicationWithDetailsImplFromJson(json);

  @override
  final ClanApplication application;
  @override
  final String userName;
  @override
  final String clanName;

  @override
  String toString() {
    return 'ClanApplicationWithDetails(application: $application, userName: $userName, clanName: $clanName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClanApplicationWithDetailsImpl &&
            (identical(other.application, application) ||
                other.application == application) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.clanName, clanName) ||
                other.clanName == clanName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, application, userName, clanName);

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClanApplicationWithDetailsImplCopyWith<_$ClanApplicationWithDetailsImpl>
      get copyWith => __$$ClanApplicationWithDetailsImplCopyWithImpl<
          _$ClanApplicationWithDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClanApplicationWithDetailsImplToJson(
      this,
    );
  }
}

abstract class _ClanApplicationWithDetails
    implements ClanApplicationWithDetails {
  const factory _ClanApplicationWithDetails(
      {required final ClanApplication application,
      required final String userName,
      required final String clanName}) = _$ClanApplicationWithDetailsImpl;

  factory _ClanApplicationWithDetails.fromJson(Map<String, dynamic> json) =
      _$ClanApplicationWithDetailsImpl.fromJson;

  @override
  ClanApplication get application;
  @override
  String get userName;
  @override
  String get clanName;

  /// Create a copy of ClanApplicationWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClanApplicationWithDetailsImplCopyWith<_$ClanApplicationWithDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
