// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainableStat _$TrainableStatFromJson(Map<String, dynamic> json) {
  return _TrainableStat.fromJson(json);
}

/// @nodoc
mixin _$TrainableStat {
  int get level => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;

  /// Serializes this TrainableStat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainableStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainableStatCopyWith<TrainableStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainableStatCopyWith<$Res> {
  factory $TrainableStatCopyWith(
          TrainableStat value, $Res Function(TrainableStat) then) =
      _$TrainableStatCopyWithImpl<$Res, TrainableStat>;
  @useResult
  $Res call({int level, int xp});
}

/// @nodoc
class _$TrainableStatCopyWithImpl<$Res, $Val extends TrainableStat>
    implements $TrainableStatCopyWith<$Res> {
  _$TrainableStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainableStat
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
abstract class _$$TrainableStatImplCopyWith<$Res>
    implements $TrainableStatCopyWith<$Res> {
  factory _$$TrainableStatImplCopyWith(
          _$TrainableStatImpl value, $Res Function(_$TrainableStatImpl) then) =
      __$$TrainableStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int level, int xp});
}

/// @nodoc
class __$$TrainableStatImplCopyWithImpl<$Res>
    extends _$TrainableStatCopyWithImpl<$Res, _$TrainableStatImpl>
    implements _$$TrainableStatImplCopyWith<$Res> {
  __$$TrainableStatImplCopyWithImpl(
      _$TrainableStatImpl _value, $Res Function(_$TrainableStatImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainableStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? xp = null,
  }) {
    return _then(_$TrainableStatImpl(
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
class _$TrainableStatImpl implements _TrainableStat {
  const _$TrainableStatImpl({this.level = 1, this.xp = 0});

  factory _$TrainableStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainableStatImplFromJson(json);

  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int xp;

  @override
  String toString() {
    return 'TrainableStat(level: $level, xp: $xp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainableStatImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.xp, xp) || other.xp == xp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, xp);

  /// Create a copy of TrainableStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainableStatImplCopyWith<_$TrainableStatImpl> get copyWith =>
      __$$TrainableStatImplCopyWithImpl<_$TrainableStatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainableStatImplToJson(
      this,
    );
  }
}

abstract class _TrainableStat implements TrainableStat {
  const factory _TrainableStat({final int level, final int xp}) =
      _$TrainableStatImpl;

  factory _TrainableStat.fromJson(Map<String, dynamic> json) =
      _$TrainableStatImpl.fromJson;

  @override
  int get level;
  @override
  int get xp;

  /// Create a copy of TrainableStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainableStatImplCopyWith<_$TrainableStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) {
  return _PlayerStats.fromJson(json);
}

/// @nodoc
mixin _$PlayerStats {
  int get level => throw _privateConstructorUsedError;
  TrainableStat get str => throw _privateConstructorUsedError;
  TrainableStat get intl => throw _privateConstructorUsedError;
  TrainableStat get spd => throw _privateConstructorUsedError;
  TrainableStat get wil => throw _privateConstructorUsedError;
  TrainableStat get nin => throw _privateConstructorUsedError;
  TrainableStat get gen => throw _privateConstructorUsedError;
  TrainableStat get buk => throw _privateConstructorUsedError;
  TrainableStat get tai =>
      throw _privateConstructorUsedError; // Current resource values (for UI display)
  int? get currentHP => throw _privateConstructorUsedError;
  int? get currentSP => throw _privateConstructorUsedError;
  int? get currentCP => throw _privateConstructorUsedError;

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStatsCopyWith<PlayerStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatsCopyWith<$Res> {
  factory $PlayerStatsCopyWith(
          PlayerStats value, $Res Function(PlayerStats) then) =
      _$PlayerStatsCopyWithImpl<$Res, PlayerStats>;
  @useResult
  $Res call(
      {int level,
      TrainableStat str,
      TrainableStat intl,
      TrainableStat spd,
      TrainableStat wil,
      TrainableStat nin,
      TrainableStat gen,
      TrainableStat buk,
      TrainableStat tai,
      int? currentHP,
      int? currentSP,
      int? currentCP});

  $TrainableStatCopyWith<$Res> get str;
  $TrainableStatCopyWith<$Res> get intl;
  $TrainableStatCopyWith<$Res> get spd;
  $TrainableStatCopyWith<$Res> get wil;
  $TrainableStatCopyWith<$Res> get nin;
  $TrainableStatCopyWith<$Res> get gen;
  $TrainableStatCopyWith<$Res> get buk;
  $TrainableStatCopyWith<$Res> get tai;
}

/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res, $Val extends PlayerStats>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? str = null,
    Object? intl = null,
    Object? spd = null,
    Object? wil = null,
    Object? nin = null,
    Object? gen = null,
    Object? buk = null,
    Object? tai = null,
    Object? currentHP = freezed,
    Object? currentSP = freezed,
    Object? currentCP = freezed,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      str: null == str
          ? _value.str
          : str // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      intl: null == intl
          ? _value.intl
          : intl // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      spd: null == spd
          ? _value.spd
          : spd // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      wil: null == wil
          ? _value.wil
          : wil // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      nin: null == nin
          ? _value.nin
          : nin // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      gen: null == gen
          ? _value.gen
          : gen // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      buk: null == buk
          ? _value.buk
          : buk // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      tai: null == tai
          ? _value.tai
          : tai // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      currentHP: freezed == currentHP
          ? _value.currentHP
          : currentHP // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSP: freezed == currentSP
          ? _value.currentSP
          : currentSP // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCP: freezed == currentCP
          ? _value.currentCP
          : currentCP // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get str {
    return $TrainableStatCopyWith<$Res>(_value.str, (value) {
      return _then(_value.copyWith(str: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get intl {
    return $TrainableStatCopyWith<$Res>(_value.intl, (value) {
      return _then(_value.copyWith(intl: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get spd {
    return $TrainableStatCopyWith<$Res>(_value.spd, (value) {
      return _then(_value.copyWith(spd: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get wil {
    return $TrainableStatCopyWith<$Res>(_value.wil, (value) {
      return _then(_value.copyWith(wil: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get nin {
    return $TrainableStatCopyWith<$Res>(_value.nin, (value) {
      return _then(_value.copyWith(nin: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get gen {
    return $TrainableStatCopyWith<$Res>(_value.gen, (value) {
      return _then(_value.copyWith(gen: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get buk {
    return $TrainableStatCopyWith<$Res>(_value.buk, (value) {
      return _then(_value.copyWith(buk: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainableStatCopyWith<$Res> get tai {
    return $TrainableStatCopyWith<$Res>(_value.tai, (value) {
      return _then(_value.copyWith(tai: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerStatsImplCopyWith<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  factory _$$PlayerStatsImplCopyWith(
          _$PlayerStatsImpl value, $Res Function(_$PlayerStatsImpl) then) =
      __$$PlayerStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int level,
      TrainableStat str,
      TrainableStat intl,
      TrainableStat spd,
      TrainableStat wil,
      TrainableStat nin,
      TrainableStat gen,
      TrainableStat buk,
      TrainableStat tai,
      int? currentHP,
      int? currentSP,
      int? currentCP});

  @override
  $TrainableStatCopyWith<$Res> get str;
  @override
  $TrainableStatCopyWith<$Res> get intl;
  @override
  $TrainableStatCopyWith<$Res> get spd;
  @override
  $TrainableStatCopyWith<$Res> get wil;
  @override
  $TrainableStatCopyWith<$Res> get nin;
  @override
  $TrainableStatCopyWith<$Res> get gen;
  @override
  $TrainableStatCopyWith<$Res> get buk;
  @override
  $TrainableStatCopyWith<$Res> get tai;
}

/// @nodoc
class __$$PlayerStatsImplCopyWithImpl<$Res>
    extends _$PlayerStatsCopyWithImpl<$Res, _$PlayerStatsImpl>
    implements _$$PlayerStatsImplCopyWith<$Res> {
  __$$PlayerStatsImplCopyWithImpl(
      _$PlayerStatsImpl _value, $Res Function(_$PlayerStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? str = null,
    Object? intl = null,
    Object? spd = null,
    Object? wil = null,
    Object? nin = null,
    Object? gen = null,
    Object? buk = null,
    Object? tai = null,
    Object? currentHP = freezed,
    Object? currentSP = freezed,
    Object? currentCP = freezed,
  }) {
    return _then(_$PlayerStatsImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      str: null == str
          ? _value.str
          : str // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      intl: null == intl
          ? _value.intl
          : intl // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      spd: null == spd
          ? _value.spd
          : spd // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      wil: null == wil
          ? _value.wil
          : wil // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      nin: null == nin
          ? _value.nin
          : nin // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      gen: null == gen
          ? _value.gen
          : gen // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      buk: null == buk
          ? _value.buk
          : buk // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      tai: null == tai
          ? _value.tai
          : tai // ignore: cast_nullable_to_non_nullable
              as TrainableStat,
      currentHP: freezed == currentHP
          ? _value.currentHP
          : currentHP // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSP: freezed == currentSP
          ? _value.currentSP
          : currentSP // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCP: freezed == currentCP
          ? _value.currentCP
          : currentCP // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStatsImpl implements _PlayerStats {
  const _$PlayerStatsImpl(
      {required this.level,
      this.str = const TrainableStat(),
      this.intl = const TrainableStat(),
      this.spd = const TrainableStat(),
      this.wil = const TrainableStat(),
      this.nin = const TrainableStat(),
      this.gen = const TrainableStat(),
      this.buk = const TrainableStat(),
      this.tai = const TrainableStat(),
      this.currentHP,
      this.currentSP,
      this.currentCP});

  factory _$PlayerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStatsImplFromJson(json);

  @override
  final int level;
  @override
  @JsonKey()
  final TrainableStat str;
  @override
  @JsonKey()
  final TrainableStat intl;
  @override
  @JsonKey()
  final TrainableStat spd;
  @override
  @JsonKey()
  final TrainableStat wil;
  @override
  @JsonKey()
  final TrainableStat nin;
  @override
  @JsonKey()
  final TrainableStat gen;
  @override
  @JsonKey()
  final TrainableStat buk;
  @override
  @JsonKey()
  final TrainableStat tai;
// Current resource values (for UI display)
  @override
  final int? currentHP;
  @override
  final int? currentSP;
  @override
  final int? currentCP;

  @override
  String toString() {
    return 'PlayerStats(level: $level, str: $str, intl: $intl, spd: $spd, wil: $wil, nin: $nin, gen: $gen, buk: $buk, tai: $tai, currentHP: $currentHP, currentSP: $currentSP, currentCP: $currentCP)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatsImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.str, str) || other.str == str) &&
            (identical(other.intl, intl) || other.intl == intl) &&
            (identical(other.spd, spd) || other.spd == spd) &&
            (identical(other.wil, wil) || other.wil == wil) &&
            (identical(other.nin, nin) || other.nin == nin) &&
            (identical(other.gen, gen) || other.gen == gen) &&
            (identical(other.buk, buk) || other.buk == buk) &&
            (identical(other.tai, tai) || other.tai == tai) &&
            (identical(other.currentHP, currentHP) ||
                other.currentHP == currentHP) &&
            (identical(other.currentSP, currentSP) ||
                other.currentSP == currentSP) &&
            (identical(other.currentCP, currentCP) ||
                other.currentCP == currentCP));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, str, intl, spd, wil, nin,
      gen, buk, tai, currentHP, currentSP, currentCP);

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      __$$PlayerStatsImplCopyWithImpl<_$PlayerStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStatsImplToJson(
      this,
    );
  }
}

abstract class _PlayerStats implements PlayerStats {
  const factory _PlayerStats(
      {required final int level,
      final TrainableStat str,
      final TrainableStat intl,
      final TrainableStat spd,
      final TrainableStat wil,
      final TrainableStat nin,
      final TrainableStat gen,
      final TrainableStat buk,
      final TrainableStat tai,
      final int? currentHP,
      final int? currentSP,
      final int? currentCP}) = _$PlayerStatsImpl;

  factory _PlayerStats.fromJson(Map<String, dynamic> json) =
      _$PlayerStatsImpl.fromJson;

  @override
  int get level;
  @override
  TrainableStat get str;
  @override
  TrainableStat get intl;
  @override
  TrainableStat get spd;
  @override
  TrainableStat get wil;
  @override
  TrainableStat get nin;
  @override
  TrainableStat get gen;
  @override
  TrainableStat get buk;
  @override
  TrainableStat get tai; // Current resource values (for UI display)
  @override
  int? get currentHP;
  @override
  int? get currentSP;
  @override
  int? get currentCP;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
