// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicalNinjaProfession _$MedicalNinjaProfessionFromJson(
    Map<String, dynamic> json) {
  return _MedicalNinjaProfession.fromJson(json);
}

/// @nodoc
mixin _$MedicalNinjaProfession {
  int get level => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;

  /// Serializes this MedicalNinjaProfession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalNinjaProfession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalNinjaProfessionCopyWith<MedicalNinjaProfession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalNinjaProfessionCopyWith<$Res> {
  factory $MedicalNinjaProfessionCopyWith(MedicalNinjaProfession value,
          $Res Function(MedicalNinjaProfession) then) =
      _$MedicalNinjaProfessionCopyWithImpl<$Res, MedicalNinjaProfession>;
  @useResult
  $Res call({int level, int xp});
}

/// @nodoc
class _$MedicalNinjaProfessionCopyWithImpl<$Res,
        $Val extends MedicalNinjaProfession>
    implements $MedicalNinjaProfessionCopyWith<$Res> {
  _$MedicalNinjaProfessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalNinjaProfession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? xp = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicalNinjaProfessionImplCopyWith<$Res>
    implements $MedicalNinjaProfessionCopyWith<$Res> {
  factory _$$MedicalNinjaProfessionImplCopyWith(
          _$MedicalNinjaProfessionImpl value,
          $Res Function(_$MedicalNinjaProfessionImpl) then) =
      __$$MedicalNinjaProfessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int level, int xp});
}

/// @nodoc
class __$$MedicalNinjaProfessionImplCopyWithImpl<$Res>
    extends _$MedicalNinjaProfessionCopyWithImpl<$Res,
        _$MedicalNinjaProfessionImpl>
    implements _$$MedicalNinjaProfessionImplCopyWith<$Res> {
  __$$MedicalNinjaProfessionImplCopyWithImpl(
      _$MedicalNinjaProfessionImpl _value,
      $Res Function(_$MedicalNinjaProfessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicalNinjaProfession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? xp = null,
  }) {
    return _then(_$MedicalNinjaProfessionImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalNinjaProfessionImpl implements _MedicalNinjaProfession {
  const _$MedicalNinjaProfessionImpl({this.level = 1, this.xp = 0});

  factory _$MedicalNinjaProfessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalNinjaProfessionImplFromJson(json);

  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int xp;

  @override
  String toString() {
    return 'MedicalNinjaProfession(level: $level, xp: $xp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalNinjaProfessionImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.xp, xp) || other.xp == xp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, xp);

  /// Create a copy of MedicalNinjaProfession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalNinjaProfessionImplCopyWith<_$MedicalNinjaProfessionImpl>
      get copyWith => __$$MedicalNinjaProfessionImplCopyWithImpl<
          _$MedicalNinjaProfessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalNinjaProfessionImplToJson(
      this,
    );
  }
}

abstract class _MedicalNinjaProfession implements MedicalNinjaProfession {
  const factory _MedicalNinjaProfession({final int level, final int xp}) =
      _$MedicalNinjaProfessionImpl;

  factory _MedicalNinjaProfession.fromJson(Map<String, dynamic> json) =
      _$MedicalNinjaProfessionImpl.fromJson;

  @override
  int get level;
  @override
  int get xp;

  /// Create a copy of MedicalNinjaProfession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalNinjaProfessionImplCopyWith<_$MedicalNinjaProfessionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get village => throw _privateConstructorUsedError;
  int get ryo => throw _privateConstructorUsedError;
  PlayerStats get stats => throw _privateConstructorUsedError;
  List<String> get jutsuIds => throw _privateConstructorUsedError;
  List<String> get itemIds => throw _privateConstructorUsedError;
  PlayerRank get rank => throw _privateConstructorUsedError;
  MedicalNinjaProfession get medNinja => throw _privateConstructorUsedError;

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call(
      {String id,
      String name,
      String avatarUrl,
      String village,
      int ryo,
      PlayerStats stats,
      List<String> jutsuIds,
      List<String> itemIds,
      PlayerRank rank,
      MedicalNinjaProfession medNinja});

  $PlayerStatsCopyWith<$Res> get stats;
  $MedicalNinjaProfessionCopyWith<$Res> get medNinja;
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? village = null,
    Object? ryo = null,
    Object? stats = null,
    Object? jutsuIds = null,
    Object? itemIds = null,
    Object? rank = null,
    Object? medNinja = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      village: null == village
          ? _value.village
          : village // ignore: cast_nullable_to_non_nullable
              as String,
      ryo: null == ryo
          ? _value.ryo
          : ryo // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as PlayerStats,
      jutsuIds: null == jutsuIds
          ? _value.jutsuIds
          : jutsuIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      itemIds: null == itemIds
          ? _value.itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as PlayerRank,
      medNinja: null == medNinja
          ? _value.medNinja
          : medNinja // ignore: cast_nullable_to_non_nullable
              as MedicalNinjaProfession,
    ) as $Val);
  }

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerStatsCopyWith<$Res> get stats {
    return $PlayerStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicalNinjaProfessionCopyWith<$Res> get medNinja {
    return $MedicalNinjaProfessionCopyWith<$Res>(_value.medNinja, (value) {
      return _then(_value.copyWith(medNinja: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
          _$PlayerImpl value, $Res Function(_$PlayerImpl) then) =
      __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String avatarUrl,
      String village,
      int ryo,
      PlayerStats stats,
      List<String> jutsuIds,
      List<String> itemIds,
      PlayerRank rank,
      MedicalNinjaProfession medNinja});

  @override
  $PlayerStatsCopyWith<$Res> get stats;
  @override
  $MedicalNinjaProfessionCopyWith<$Res> get medNinja;
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
      _$PlayerImpl _value, $Res Function(_$PlayerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = null,
    Object? village = null,
    Object? ryo = null,
    Object? stats = null,
    Object? jutsuIds = null,
    Object? itemIds = null,
    Object? rank = null,
    Object? medNinja = null,
  }) {
    return _then(_$PlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      village: null == village
          ? _value.village
          : village // ignore: cast_nullable_to_non_nullable
              as String,
      ryo: null == ryo
          ? _value.ryo
          : ryo // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as PlayerStats,
      jutsuIds: null == jutsuIds
          ? _value._jutsuIds
          : jutsuIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      itemIds: null == itemIds
          ? _value._itemIds
          : itemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as PlayerRank,
      medNinja: null == medNinja
          ? _value.medNinja
          : medNinja // ignore: cast_nullable_to_non_nullable
              as MedicalNinjaProfession,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl implements _Player {
  const _$PlayerImpl(
      {required this.id,
      required this.name,
      required this.avatarUrl,
      required this.village,
      required this.ryo,
      required this.stats,
      final List<String> jutsuIds = const [],
      final List<String> itemIds = const [],
      this.rank = PlayerRank.genin,
      this.medNinja = const MedicalNinjaProfession()})
      : _jutsuIds = jutsuIds,
        _itemIds = itemIds;

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String avatarUrl;
  @override
  final String village;
  @override
  final int ryo;
  @override
  final PlayerStats stats;
  final List<String> _jutsuIds;
  @override
  @JsonKey()
  List<String> get jutsuIds {
    if (_jutsuIds is EqualUnmodifiableListView) return _jutsuIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jutsuIds);
  }

  final List<String> _itemIds;
  @override
  @JsonKey()
  List<String> get itemIds {
    if (_itemIds is EqualUnmodifiableListView) return _itemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemIds);
  }

  @override
  @JsonKey()
  final PlayerRank rank;
  @override
  @JsonKey()
  final MedicalNinjaProfession medNinja;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, avatarUrl: $avatarUrl, village: $village, ryo: $ryo, stats: $stats, jutsuIds: $jutsuIds, itemIds: $itemIds, rank: $rank, medNinja: $medNinja)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.village, village) || other.village == village) &&
            (identical(other.ryo, ryo) || other.ryo == ryo) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality().equals(other._jutsuIds, _jutsuIds) &&
            const DeepCollectionEquality().equals(other._itemIds, _itemIds) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.medNinja, medNinja) ||
                other.medNinja == medNinja));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      avatarUrl,
      village,
      ryo,
      stats,
      const DeepCollectionEquality().hash(_jutsuIds),
      const DeepCollectionEquality().hash(_itemIds),
      rank,
      medNinja);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(
      this,
    );
  }
}

abstract class _Player implements Player {
  const factory _Player(
      {required final String id,
      required final String name,
      required final String avatarUrl,
      required final String village,
      required final int ryo,
      required final PlayerStats stats,
      final List<String> jutsuIds,
      final List<String> itemIds,
      final PlayerRank rank,
      final MedicalNinjaProfession medNinja}) = _$PlayerImpl;

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get avatarUrl;
  @override
  String get village;
  @override
  int get ryo;
  @override
  PlayerStats get stats;
  @override
  List<String> get jutsuIds;
  @override
  List<String> get itemIds;
  @override
  PlayerRank get rank;
  @override
  MedicalNinjaProfession get medNinja;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
