// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerDto _$PlayerDtoFromJson(Map<String, dynamic> json) {
  return _PlayerDto.fromJson(json);
}

/// @nodoc
mixin _$PlayerDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get village => throw _privateConstructorUsedError;
  int get ryo => throw _privateConstructorUsedError;
  PlayerStatsDto get stats => throw _privateConstructorUsedError;
  List<String> get jutsuIds => throw _privateConstructorUsedError;
  List<String> get itemIds => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;

  /// Serializes this PlayerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerDtoCopyWith<PlayerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerDtoCopyWith<$Res> {
  factory $PlayerDtoCopyWith(PlayerDto value, $Res Function(PlayerDto) then) =
      _$PlayerDtoCopyWithImpl<$Res, PlayerDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String avatarUrl,
      String village,
      int ryo,
      PlayerStatsDto stats,
      List<String> jutsuIds,
      List<String> itemIds,
      String rank});

  $PlayerStatsDtoCopyWith<$Res> get stats;
}

/// @nodoc
class _$PlayerDtoCopyWithImpl<$Res, $Val extends PlayerDto>
    implements $PlayerDtoCopyWith<$Res> {
  _$PlayerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerDto
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
              as PlayerStatsDto,
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
              as String,
    ) as $Val);
  }

  /// Create a copy of PlayerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerStatsDtoCopyWith<$Res> get stats {
    return $PlayerStatsDtoCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerDtoImplCopyWith<$Res>
    implements $PlayerDtoCopyWith<$Res> {
  factory _$$PlayerDtoImplCopyWith(
          _$PlayerDtoImpl value, $Res Function(_$PlayerDtoImpl) then) =
      __$$PlayerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String avatarUrl,
      String village,
      int ryo,
      PlayerStatsDto stats,
      List<String> jutsuIds,
      List<String> itemIds,
      String rank});

  @override
  $PlayerStatsDtoCopyWith<$Res> get stats;
}

/// @nodoc
class __$$PlayerDtoImplCopyWithImpl<$Res>
    extends _$PlayerDtoCopyWithImpl<$Res, _$PlayerDtoImpl>
    implements _$$PlayerDtoImplCopyWith<$Res> {
  __$$PlayerDtoImplCopyWithImpl(
      _$PlayerDtoImpl _value, $Res Function(_$PlayerDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerDto
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
  }) {
    return _then(_$PlayerDtoImpl(
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
              as PlayerStatsDto,
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
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerDtoImpl implements _PlayerDto {
  const _$PlayerDtoImpl(
      {required this.id,
      required this.name,
      required this.avatarUrl,
      required this.village,
      required this.ryo,
      required this.stats,
      required final List<String> jutsuIds,
      required final List<String> itemIds,
      required this.rank})
      : _jutsuIds = jutsuIds,
        _itemIds = itemIds;

  factory _$PlayerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerDtoImplFromJson(json);

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
  final PlayerStatsDto stats;
  final List<String> _jutsuIds;
  @override
  List<String> get jutsuIds {
    if (_jutsuIds is EqualUnmodifiableListView) return _jutsuIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jutsuIds);
  }

  final List<String> _itemIds;
  @override
  List<String> get itemIds {
    if (_itemIds is EqualUnmodifiableListView) return _itemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemIds);
  }

  @override
  final String rank;

  @override
  String toString() {
    return 'PlayerDto(id: $id, name: $name, avatarUrl: $avatarUrl, village: $village, ryo: $ryo, stats: $stats, jutsuIds: $jutsuIds, itemIds: $itemIds, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.village, village) || other.village == village) &&
            (identical(other.ryo, ryo) || other.ryo == ryo) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality().equals(other._jutsuIds, _jutsuIds) &&
            const DeepCollectionEquality().equals(other._itemIds, _itemIds) &&
            (identical(other.rank, rank) || other.rank == rank));
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
      rank);

  /// Create a copy of PlayerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerDtoImplCopyWith<_$PlayerDtoImpl> get copyWith =>
      __$$PlayerDtoImplCopyWithImpl<_$PlayerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerDtoImplToJson(
      this,
    );
  }
}

abstract class _PlayerDto implements PlayerDto {
  const factory _PlayerDto(
      {required final String id,
      required final String name,
      required final String avatarUrl,
      required final String village,
      required final int ryo,
      required final PlayerStatsDto stats,
      required final List<String> jutsuIds,
      required final List<String> itemIds,
      required final String rank}) = _$PlayerDtoImpl;

  factory _PlayerDto.fromJson(Map<String, dynamic> json) =
      _$PlayerDtoImpl.fromJson;

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
  PlayerStatsDto get stats;
  @override
  List<String> get jutsuIds;
  @override
  List<String> get itemIds;
  @override
  String get rank;

  /// Create a copy of PlayerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerDtoImplCopyWith<_$PlayerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerStatsDto _$PlayerStatsDtoFromJson(Map<String, dynamic> json) {
  return _PlayerStatsDto.fromJson(json);
}

/// @nodoc
mixin _$PlayerStatsDto {
  int get level => throw _privateConstructorUsedError;
  int get str => throw _privateConstructorUsedError;
  int get intl => throw _privateConstructorUsedError;
  int get spd => throw _privateConstructorUsedError;
  int get wil => throw _privateConstructorUsedError;
  int get nin => throw _privateConstructorUsedError;
  int get gen => throw _privateConstructorUsedError;
  int get buk => throw _privateConstructorUsedError;
  int get tai => throw _privateConstructorUsedError;
  int? get currentHP => throw _privateConstructorUsedError;
  int? get currentSP => throw _privateConstructorUsedError;
  int? get currentCP => throw _privateConstructorUsedError;

  /// Serializes this PlayerStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStatsDtoCopyWith<PlayerStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatsDtoCopyWith<$Res> {
  factory $PlayerStatsDtoCopyWith(
          PlayerStatsDto value, $Res Function(PlayerStatsDto) then) =
      _$PlayerStatsDtoCopyWithImpl<$Res, PlayerStatsDto>;
  @useResult
  $Res call(
      {int level,
      int str,
      int intl,
      int spd,
      int wil,
      int nin,
      int gen,
      int buk,
      int tai,
      int? currentHP,
      int? currentSP,
      int? currentCP});
}

/// @nodoc
class _$PlayerStatsDtoCopyWithImpl<$Res, $Val extends PlayerStatsDto>
    implements $PlayerStatsDtoCopyWith<$Res> {
  _$PlayerStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerStatsDto
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
              as int,
      intl: null == intl
          ? _value.intl
          : intl // ignore: cast_nullable_to_non_nullable
              as int,
      spd: null == spd
          ? _value.spd
          : spd // ignore: cast_nullable_to_non_nullable
              as int,
      wil: null == wil
          ? _value.wil
          : wil // ignore: cast_nullable_to_non_nullable
              as int,
      nin: null == nin
          ? _value.nin
          : nin // ignore: cast_nullable_to_non_nullable
              as int,
      gen: null == gen
          ? _value.gen
          : gen // ignore: cast_nullable_to_non_nullable
              as int,
      buk: null == buk
          ? _value.buk
          : buk // ignore: cast_nullable_to_non_nullable
              as int,
      tai: null == tai
          ? _value.tai
          : tai // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$PlayerStatsDtoImplCopyWith<$Res>
    implements $PlayerStatsDtoCopyWith<$Res> {
  factory _$$PlayerStatsDtoImplCopyWith(_$PlayerStatsDtoImpl value,
          $Res Function(_$PlayerStatsDtoImpl) then) =
      __$$PlayerStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int level,
      int str,
      int intl,
      int spd,
      int wil,
      int nin,
      int gen,
      int buk,
      int tai,
      int? currentHP,
      int? currentSP,
      int? currentCP});
}

/// @nodoc
class __$$PlayerStatsDtoImplCopyWithImpl<$Res>
    extends _$PlayerStatsDtoCopyWithImpl<$Res, _$PlayerStatsDtoImpl>
    implements _$$PlayerStatsDtoImplCopyWith<$Res> {
  __$$PlayerStatsDtoImplCopyWithImpl(
      _$PlayerStatsDtoImpl _value, $Res Function(_$PlayerStatsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerStatsDto
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
    return _then(_$PlayerStatsDtoImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      str: null == str
          ? _value.str
          : str // ignore: cast_nullable_to_non_nullable
              as int,
      intl: null == intl
          ? _value.intl
          : intl // ignore: cast_nullable_to_non_nullable
              as int,
      spd: null == spd
          ? _value.spd
          : spd // ignore: cast_nullable_to_non_nullable
              as int,
      wil: null == wil
          ? _value.wil
          : wil // ignore: cast_nullable_to_non_nullable
              as int,
      nin: null == nin
          ? _value.nin
          : nin // ignore: cast_nullable_to_non_nullable
              as int,
      gen: null == gen
          ? _value.gen
          : gen // ignore: cast_nullable_to_non_nullable
              as int,
      buk: null == buk
          ? _value.buk
          : buk // ignore: cast_nullable_to_non_nullable
              as int,
      tai: null == tai
          ? _value.tai
          : tai // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$PlayerStatsDtoImpl implements _PlayerStatsDto {
  const _$PlayerStatsDtoImpl(
      {required this.level,
      this.str = 0,
      this.intl = 0,
      this.spd = 0,
      this.wil = 0,
      this.nin = 0,
      this.gen = 0,
      this.buk = 0,
      this.tai = 0,
      this.currentHP,
      this.currentSP,
      this.currentCP});

  factory _$PlayerStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStatsDtoImplFromJson(json);

  @override
  final int level;
  @override
  @JsonKey()
  final int str;
  @override
  @JsonKey()
  final int intl;
  @override
  @JsonKey()
  final int spd;
  @override
  @JsonKey()
  final int wil;
  @override
  @JsonKey()
  final int nin;
  @override
  @JsonKey()
  final int gen;
  @override
  @JsonKey()
  final int buk;
  @override
  @JsonKey()
  final int tai;
  @override
  final int? currentHP;
  @override
  final int? currentSP;
  @override
  final int? currentCP;

  @override
  String toString() {
    return 'PlayerStatsDto(level: $level, str: $str, intl: $intl, spd: $spd, wil: $wil, nin: $nin, gen: $gen, buk: $buk, tai: $tai, currentHP: $currentHP, currentSP: $currentSP, currentCP: $currentCP)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatsDtoImpl &&
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

  /// Create a copy of PlayerStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatsDtoImplCopyWith<_$PlayerStatsDtoImpl> get copyWith =>
      __$$PlayerStatsDtoImplCopyWithImpl<_$PlayerStatsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _PlayerStatsDto implements PlayerStatsDto {
  const factory _PlayerStatsDto(
      {required final int level,
      final int str,
      final int intl,
      final int spd,
      final int wil,
      final int nin,
      final int gen,
      final int buk,
      final int tai,
      final int? currentHP,
      final int? currentSP,
      final int? currentCP}) = _$PlayerStatsDtoImpl;

  factory _PlayerStatsDto.fromJson(Map<String, dynamic> json) =
      _$PlayerStatsDtoImpl.fromJson;

  @override
  int get level;
  @override
  int get str;
  @override
  int get intl;
  @override
  int get spd;
  @override
  int get wil;
  @override
  int get nin;
  @override
  int get gen;
  @override
  int get buk;
  @override
  int get tai;
  @override
  int? get currentHP;
  @override
  int? get currentSP;
  @override
  int? get currentCP;

  /// Create a copy of PlayerStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStatsDtoImplCopyWith<_$PlayerStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItemDto _$ItemDtoFromJson(Map<String, dynamic> json) {
  return _ItemDto.fromJson(json);
}

/// @nodoc
mixin _$ItemDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  Map<String, dynamic> get effect => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  Map<String, dynamic>? get equip => throw _privateConstructorUsedError;

  /// Serializes this ItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemDtoCopyWith<ItemDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDtoCopyWith<$Res> {
  factory $ItemDtoCopyWith(ItemDto value, $Res Function(ItemDto) then) =
      _$ItemDtoCopyWithImpl<$Res, ItemDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      int quantity,
      String rarity,
      Map<String, dynamic> effect,
      String kind,
      String? size,
      Map<String, dynamic>? equip});
}

/// @nodoc
class _$ItemDtoCopyWithImpl<$Res, $Val extends ItemDto>
    implements $ItemDtoCopyWith<$Res> {
  _$ItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? quantity = null,
    Object? rarity = null,
    Object? effect = null,
    Object? kind = null,
    Object? size = freezed,
    Object? equip = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String,
      effect: null == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      equip: freezed == equip
          ? _value.equip
          : equip // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemDtoImplCopyWith<$Res> implements $ItemDtoCopyWith<$Res> {
  factory _$$ItemDtoImplCopyWith(
          _$ItemDtoImpl value, $Res Function(_$ItemDtoImpl) then) =
      __$$ItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      int quantity,
      String rarity,
      Map<String, dynamic> effect,
      String kind,
      String? size,
      Map<String, dynamic>? equip});
}

/// @nodoc
class __$$ItemDtoImplCopyWithImpl<$Res>
    extends _$ItemDtoCopyWithImpl<$Res, _$ItemDtoImpl>
    implements _$$ItemDtoImplCopyWith<$Res> {
  __$$ItemDtoImplCopyWithImpl(
      _$ItemDtoImpl _value, $Res Function(_$ItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? quantity = null,
    Object? rarity = null,
    Object? effect = null,
    Object? kind = null,
    Object? size = freezed,
    Object? equip = freezed,
  }) {
    return _then(_$ItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String,
      effect: null == effect
          ? _value._effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      equip: freezed == equip
          ? _value._equip
          : equip // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemDtoImpl implements _ItemDto {
  const _$ItemDtoImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.quantity,
      required this.rarity,
      required final Map<String, dynamic> effect,
      required this.kind,
      this.size,
      final Map<String, dynamic>? equip})
      : _effect = effect,
        _equip = equip;

  factory _$ItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String icon;
  @override
  final int quantity;
  @override
  final String rarity;
  final Map<String, dynamic> _effect;
  @override
  Map<String, dynamic> get effect {
    if (_effect is EqualUnmodifiableMapView) return _effect;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_effect);
  }

  @override
  final String kind;
  @override
  final String? size;
  final Map<String, dynamic>? _equip;
  @override
  Map<String, dynamic>? get equip {
    final value = _equip;
    if (value == null) return null;
    if (_equip is EqualUnmodifiableMapView) return _equip;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ItemDto(id: $id, name: $name, description: $description, icon: $icon, quantity: $quantity, rarity: $rarity, effect: $effect, kind: $kind, size: $size, equip: $equip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            const DeepCollectionEquality().equals(other._effect, _effect) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality().equals(other._equip, _equip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      icon,
      quantity,
      rarity,
      const DeepCollectionEquality().hash(_effect),
      kind,
      size,
      const DeepCollectionEquality().hash(_equip));

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDtoImplCopyWith<_$ItemDtoImpl> get copyWith =>
      __$$ItemDtoImplCopyWithImpl<_$ItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ItemDto implements ItemDto {
  const factory _ItemDto(
      {required final String id,
      required final String name,
      required final String description,
      required final String icon,
      required final int quantity,
      required final String rarity,
      required final Map<String, dynamic> effect,
      required final String kind,
      final String? size,
      final Map<String, dynamic>? equip}) = _$ItemDtoImpl;

  factory _ItemDto.fromJson(Map<String, dynamic> json) = _$ItemDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get icon;
  @override
  int get quantity;
  @override
  String get rarity;
  @override
  Map<String, dynamic> get effect;
  @override
  String get kind;
  @override
  String? get size;
  @override
  Map<String, dynamic>? get equip;

  /// Create a copy of ItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemDtoImplCopyWith<_$ItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JutsuDto _$JutsuDtoFromJson(Map<String, dynamic> json) {
  return _JutsuDto.fromJson(json);
}

/// @nodoc
mixin _$JutsuDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get chakraCost => throw _privateConstructorUsedError;
  int get power => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isEquipped => throw _privateConstructorUsedError;
  int get range => throw _privateConstructorUsedError;
  String get targeting => throw _privateConstructorUsedError;
  int get apCost => throw _privateConstructorUsedError;
  int? get areaRadius => throw _privateConstructorUsedError;

  /// Serializes this JutsuDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JutsuDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JutsuDtoCopyWith<JutsuDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JutsuDtoCopyWith<$Res> {
  factory $JutsuDtoCopyWith(JutsuDto value, $Res Function(JutsuDto) then) =
      _$JutsuDtoCopyWithImpl<$Res, JutsuDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      int chakraCost,
      int power,
      String description,
      bool isEquipped,
      int range,
      String targeting,
      int apCost,
      int? areaRadius});
}

/// @nodoc
class _$JutsuDtoCopyWithImpl<$Res, $Val extends JutsuDto>
    implements $JutsuDtoCopyWith<$Res> {
  _$JutsuDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JutsuDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? chakraCost = null,
    Object? power = null,
    Object? description = null,
    Object? isEquipped = null,
    Object? range = null,
    Object? targeting = null,
    Object? apCost = null,
    Object? areaRadius = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      chakraCost: null == chakraCost
          ? _value.chakraCost
          : chakraCost // ignore: cast_nullable_to_non_nullable
              as int,
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isEquipped: null == isEquipped
          ? _value.isEquipped
          : isEquipped // ignore: cast_nullable_to_non_nullable
              as bool,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as int,
      targeting: null == targeting
          ? _value.targeting
          : targeting // ignore: cast_nullable_to_non_nullable
              as String,
      apCost: null == apCost
          ? _value.apCost
          : apCost // ignore: cast_nullable_to_non_nullable
              as int,
      areaRadius: freezed == areaRadius
          ? _value.areaRadius
          : areaRadius // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JutsuDtoImplCopyWith<$Res>
    implements $JutsuDtoCopyWith<$Res> {
  factory _$$JutsuDtoImplCopyWith(
          _$JutsuDtoImpl value, $Res Function(_$JutsuDtoImpl) then) =
      __$$JutsuDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      int chakraCost,
      int power,
      String description,
      bool isEquipped,
      int range,
      String targeting,
      int apCost,
      int? areaRadius});
}

/// @nodoc
class __$$JutsuDtoImplCopyWithImpl<$Res>
    extends _$JutsuDtoCopyWithImpl<$Res, _$JutsuDtoImpl>
    implements _$$JutsuDtoImplCopyWith<$Res> {
  __$$JutsuDtoImplCopyWithImpl(
      _$JutsuDtoImpl _value, $Res Function(_$JutsuDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of JutsuDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? chakraCost = null,
    Object? power = null,
    Object? description = null,
    Object? isEquipped = null,
    Object? range = null,
    Object? targeting = null,
    Object? apCost = null,
    Object? areaRadius = freezed,
  }) {
    return _then(_$JutsuDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      chakraCost: null == chakraCost
          ? _value.chakraCost
          : chakraCost // ignore: cast_nullable_to_non_nullable
              as int,
      power: null == power
          ? _value.power
          : power // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isEquipped: null == isEquipped
          ? _value.isEquipped
          : isEquipped // ignore: cast_nullable_to_non_nullable
              as bool,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as int,
      targeting: null == targeting
          ? _value.targeting
          : targeting // ignore: cast_nullable_to_non_nullable
              as String,
      apCost: null == apCost
          ? _value.apCost
          : apCost // ignore: cast_nullable_to_non_nullable
              as int,
      areaRadius: freezed == areaRadius
          ? _value.areaRadius
          : areaRadius // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JutsuDtoImpl implements _JutsuDto {
  const _$JutsuDtoImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.chakraCost,
      required this.power,
      required this.description,
      required this.isEquipped,
      required this.range,
      required this.targeting,
      required this.apCost,
      this.areaRadius});

  factory _$JutsuDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JutsuDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final int chakraCost;
  @override
  final int power;
  @override
  final String description;
  @override
  final bool isEquipped;
  @override
  final int range;
  @override
  final String targeting;
  @override
  final int apCost;
  @override
  final int? areaRadius;

  @override
  String toString() {
    return 'JutsuDto(id: $id, name: $name, type: $type, chakraCost: $chakraCost, power: $power, description: $description, isEquipped: $isEquipped, range: $range, targeting: $targeting, apCost: $apCost, areaRadius: $areaRadius)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JutsuDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.chakraCost, chakraCost) ||
                other.chakraCost == chakraCost) &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isEquipped, isEquipped) ||
                other.isEquipped == isEquipped) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.targeting, targeting) ||
                other.targeting == targeting) &&
            (identical(other.apCost, apCost) || other.apCost == apCost) &&
            (identical(other.areaRadius, areaRadius) ||
                other.areaRadius == areaRadius));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, chakraCost,
      power, description, isEquipped, range, targeting, apCost, areaRadius);

  /// Create a copy of JutsuDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JutsuDtoImplCopyWith<_$JutsuDtoImpl> get copyWith =>
      __$$JutsuDtoImplCopyWithImpl<_$JutsuDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JutsuDtoImplToJson(
      this,
    );
  }
}

abstract class _JutsuDto implements JutsuDto {
  const factory _JutsuDto(
      {required final String id,
      required final String name,
      required final String type,
      required final int chakraCost,
      required final int power,
      required final String description,
      required final bool isEquipped,
      required final int range,
      required final String targeting,
      required final int apCost,
      final int? areaRadius}) = _$JutsuDtoImpl;

  factory _JutsuDto.fromJson(Map<String, dynamic> json) =
      _$JutsuDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  int get chakraCost;
  @override
  int get power;
  @override
  String get description;
  @override
  bool get isEquipped;
  @override
  int get range;
  @override
  String get targeting;
  @override
  int get apCost;
  @override
  int? get areaRadius;

  /// Create a copy of JutsuDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JutsuDtoImplCopyWith<_$JutsuDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
