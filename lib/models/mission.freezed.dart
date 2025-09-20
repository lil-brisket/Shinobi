// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MissionReward _$MissionRewardFromJson(Map<String, dynamic> json) {
  return _MissionReward.fromJson(json);
}

/// @nodoc
mixin _$MissionReward {
  int get xp => throw _privateConstructorUsedError;
  int get ryo => throw _privateConstructorUsedError;
  List<String> get itemIds => throw _privateConstructorUsedError;

  /// Serializes this MissionReward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionRewardCopyWith<MissionReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionRewardCopyWith<$Res> {
  factory $MissionRewardCopyWith(
          MissionReward value, $Res Function(MissionReward) then) =
      _$MissionRewardCopyWithImpl<$Res, MissionReward>;
  @useResult
  $Res call({int xp, int ryo, List<String> itemIds});
}

/// @nodoc
class _$MissionRewardCopyWithImpl<$Res, $Val extends MissionReward>
    implements $MissionRewardCopyWith<$Res> {
  _$MissionRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xp = null,
    Object? ryo = null,
    Object? itemIds = null,
  }) {
    return _then(_value.copyWith(
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      ryo: null == ryo
          ? _value.ryo
          : ryo // ignore: cast_nullable_to_non_nullable
              as int,
      itemIds: null == itemIds
          ? _value.itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionRewardImplCopyWith<$Res>
    implements $MissionRewardCopyWith<$Res> {
  factory _$$MissionRewardImplCopyWith(
          _$MissionRewardImpl value, $Res Function(_$MissionRewardImpl) then) =
      __$$MissionRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int xp, int ryo, List<String> itemIds});
}

/// @nodoc
class __$$MissionRewardImplCopyWithImpl<$Res>
    extends _$MissionRewardCopyWithImpl<$Res, _$MissionRewardImpl>
    implements _$$MissionRewardImplCopyWith<$Res> {
  __$$MissionRewardImplCopyWithImpl(
      _$MissionRewardImpl _value, $Res Function(_$MissionRewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of MissionReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? xp = null,
    Object? ryo = null,
    Object? itemIds = null,
  }) {
    return _then(_$MissionRewardImpl(
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      ryo: null == ryo
          ? _value.ryo
          : ryo // ignore: cast_nullable_to_non_nullable
              as int,
      itemIds: null == itemIds
          ? _value._itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionRewardImpl implements _MissionReward {
  const _$MissionRewardImpl(
      {required this.xp,
      required this.ryo,
      final List<String> itemIds = const []})
      : _itemIds = itemIds;

  factory _$MissionRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionRewardImplFromJson(json);

  @override
  final int xp;
  @override
  final int ryo;
  final List<String> _itemIds;
  @override
  @JsonKey()
  List<String> get itemIds {
    if (_itemIds is EqualUnmodifiableListView) return _itemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemIds);
  }

  @override
  String toString() {
    return 'MissionReward(xp: $xp, ryo: $ryo, itemIds: $itemIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionRewardImpl &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.ryo, ryo) || other.ryo == ryo) &&
            const DeepCollectionEquality().equals(other._itemIds, _itemIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, xp, ryo, const DeepCollectionEquality().hash(_itemIds));

  /// Create a copy of MissionReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionRewardImplCopyWith<_$MissionRewardImpl> get copyWith =>
      __$$MissionRewardImplCopyWithImpl<_$MissionRewardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionRewardImplToJson(
      this,
    );
  }
}

abstract class _MissionReward implements MissionReward {
  const factory _MissionReward(
      {required final int xp,
      required final int ryo,
      final List<String> itemIds}) = _$MissionRewardImpl;

  factory _MissionReward.fromJson(Map<String, dynamic> json) =
      _$MissionRewardImpl.fromJson;

  @override
  int get xp;
  @override
  int get ryo;
  @override
  List<String> get itemIds;

  /// Create a copy of MissionReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionRewardImplCopyWith<_$MissionRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  MissionRank get rank => throw _privateConstructorUsedError;
  int get requiredLevel => throw _privateConstructorUsedError;
  MissionReward get reward => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  MissionStatus get status => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// Serializes this Mission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      MissionRank rank,
      int requiredLevel,
      MissionReward reward,
      int durationSeconds,
      MissionStatus status,
      DateTime? startTime,
      DateTime? endTime});

  $MissionRewardCopyWith<$Res> get reward;
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? rank = null,
    Object? requiredLevel = null,
    Object? reward = null,
    Object? durationSeconds = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as MissionRank,
      requiredLevel: null == requiredLevel
          ? _value.requiredLevel
          : requiredLevel // ignore: cast_nullable_to_non_nullable
              as int,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as MissionReward,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MissionStatus,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MissionRewardCopyWith<$Res> get reward {
    return $MissionRewardCopyWith<$Res>(_value.reward, (value) {
      return _then(_value.copyWith(reward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
          _$MissionImpl value, $Res Function(_$MissionImpl) then) =
      __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      MissionRank rank,
      int requiredLevel,
      MissionReward reward,
      int durationSeconds,
      MissionStatus status,
      DateTime? startTime,
      DateTime? endTime});

  @override
  $MissionRewardCopyWith<$Res> get reward;
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
      _$MissionImpl _value, $Res Function(_$MissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? rank = null,
    Object? requiredLevel = null,
    Object? reward = null,
    Object? durationSeconds = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_$MissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as MissionRank,
      requiredLevel: null == requiredLevel
          ? _value.requiredLevel
          : requiredLevel // ignore: cast_nullable_to_non_nullable
              as int,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as MissionReward,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MissionStatus,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl implements _Mission {
  const _$MissionImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.rank,
      required this.requiredLevel,
      required this.reward,
      required this.durationSeconds,
      this.status = MissionStatus.available,
      this.startTime,
      this.endTime});

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final MissionRank rank;
  @override
  final int requiredLevel;
  @override
  final MissionReward reward;
  @override
  final int durationSeconds;
  @override
  @JsonKey()
  final MissionStatus status;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'Mission(id: $id, title: $title, description: $description, rank: $rank, requiredLevel: $requiredLevel, reward: $reward, durationSeconds: $durationSeconds, status: $status, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.requiredLevel, requiredLevel) ||
                other.requiredLevel == requiredLevel) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, rank,
      requiredLevel, reward, durationSeconds, status, startTime, endTime);

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(
      this,
    );
  }
}

abstract class _Mission implements Mission {
  const factory _Mission(
      {required final String id,
      required final String title,
      required final String description,
      required final MissionRank rank,
      required final int requiredLevel,
      required final MissionReward reward,
      required final int durationSeconds,
      final MissionStatus status,
      final DateTime? startTime,
      final DateTime? endTime}) = _$MissionImpl;

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  MissionRank get rank;
  @override
  int get requiredLevel;
  @override
  MissionReward get reward;
  @override
  int get durationSeconds;
  @override
  MissionStatus get status;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
