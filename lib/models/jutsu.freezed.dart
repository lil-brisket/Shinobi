// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jutsu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Jutsu _$JutsuFromJson(Map<String, dynamic> json) {
  return _Jutsu.fromJson(json);
}

/// @nodoc
mixin _$Jutsu {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  JutsuType get type => throw _privateConstructorUsedError;
  int get chakraCost => throw _privateConstructorUsedError;
  int get power => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isEquipped => throw _privateConstructorUsedError;

  /// Serializes this Jutsu to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Jutsu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JutsuCopyWith<Jutsu> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JutsuCopyWith<$Res> {
  factory $JutsuCopyWith(Jutsu value, $Res Function(Jutsu) then) =
      _$JutsuCopyWithImpl<$Res, Jutsu>;
  @useResult
  $Res call(
      {String id,
      String name,
      JutsuType type,
      int chakraCost,
      int power,
      String description,
      bool isEquipped});
}

/// @nodoc
class _$JutsuCopyWithImpl<$Res, $Val extends Jutsu>
    implements $JutsuCopyWith<$Res> {
  _$JutsuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Jutsu
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
              as JutsuType,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JutsuImplCopyWith<$Res> implements $JutsuCopyWith<$Res> {
  factory _$$JutsuImplCopyWith(
          _$JutsuImpl value, $Res Function(_$JutsuImpl) then) =
      __$$JutsuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      JutsuType type,
      int chakraCost,
      int power,
      String description,
      bool isEquipped});
}

/// @nodoc
class __$$JutsuImplCopyWithImpl<$Res>
    extends _$JutsuCopyWithImpl<$Res, _$JutsuImpl>
    implements _$$JutsuImplCopyWith<$Res> {
  __$$JutsuImplCopyWithImpl(
      _$JutsuImpl _value, $Res Function(_$JutsuImpl) _then)
      : super(_value, _then);

  /// Create a copy of Jutsu
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
  }) {
    return _then(_$JutsuImpl(
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
              as JutsuType,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JutsuImpl implements _Jutsu {
  const _$JutsuImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.chakraCost,
      required this.power,
      required this.description,
      this.isEquipped = false});

  factory _$JutsuImpl.fromJson(Map<String, dynamic> json) =>
      _$$JutsuImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final JutsuType type;
  @override
  final int chakraCost;
  @override
  final int power;
  @override
  final String description;
  @override
  @JsonKey()
  final bool isEquipped;

  @override
  String toString() {
    return 'Jutsu(id: $id, name: $name, type: $type, chakraCost: $chakraCost, power: $power, description: $description, isEquipped: $isEquipped)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JutsuImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.chakraCost, chakraCost) ||
                other.chakraCost == chakraCost) &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isEquipped, isEquipped) ||
                other.isEquipped == isEquipped));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, chakraCost, power, description, isEquipped);

  /// Create a copy of Jutsu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JutsuImplCopyWith<_$JutsuImpl> get copyWith =>
      __$$JutsuImplCopyWithImpl<_$JutsuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JutsuImplToJson(
      this,
    );
  }
}

abstract class _Jutsu implements Jutsu {
  const factory _Jutsu(
      {required final String id,
      required final String name,
      required final JutsuType type,
      required final int chakraCost,
      required final int power,
      required final String description,
      final bool isEquipped}) = _$JutsuImpl;

  factory _Jutsu.fromJson(Map<String, dynamic> json) = _$JutsuImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  JutsuType get type;
  @override
  int get chakraCost;
  @override
  int get power;
  @override
  String get description;
  @override
  bool get isEquipped;

  /// Create a copy of Jutsu
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JutsuImplCopyWith<_$JutsuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
