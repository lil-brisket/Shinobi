// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameTimer _$GameTimerFromJson(Map<String, dynamic> json) {
  return _GameTimer.fromJson(json);
}

/// @nodoc
mixin _$GameTimer {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  TimerType get type => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this GameTimer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameTimer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameTimerCopyWith<GameTimer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameTimerCopyWith<$Res> {
  factory $GameTimerCopyWith(GameTimer value, $Res Function(GameTimer) then) =
      _$GameTimerCopyWithImpl<$Res, GameTimer>;
  @useResult
  $Res call(
      {String id,
      String title,
      TimerType type,
      DateTime startTime,
      Duration duration,
      bool isCompleted,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$GameTimerCopyWithImpl<$Res, $Val extends GameTimer>
    implements $GameTimerCopyWith<$Res> {
  _$GameTimerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameTimer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? duration = null,
    Object? isCompleted = null,
    Object? metadata = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TimerType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameTimerImplCopyWith<$Res>
    implements $GameTimerCopyWith<$Res> {
  factory _$$GameTimerImplCopyWith(
          _$GameTimerImpl value, $Res Function(_$GameTimerImpl) then) =
      __$$GameTimerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      TimerType type,
      DateTime startTime,
      Duration duration,
      bool isCompleted,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$GameTimerImplCopyWithImpl<$Res>
    extends _$GameTimerCopyWithImpl<$Res, _$GameTimerImpl>
    implements _$$GameTimerImplCopyWith<$Res> {
  __$$GameTimerImplCopyWithImpl(
      _$GameTimerImpl _value, $Res Function(_$GameTimerImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameTimer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? duration = null,
    Object? isCompleted = null,
    Object? metadata = freezed,
  }) {
    return _then(_$GameTimerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TimerType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameTimerImpl extends _GameTimer {
  const _$GameTimerImpl(
      {required this.id,
      required this.title,
      required this.type,
      required this.startTime,
      required this.duration,
      this.isCompleted = false,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata,
        super._();

  factory _$GameTimerImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameTimerImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final TimerType type;
  @override
  final DateTime startTime;
  @override
  final Duration duration;
  @override
  @JsonKey()
  final bool isCompleted;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GameTimer(id: $id, title: $title, type: $type, startTime: $startTime, duration: $duration, isCompleted: $isCompleted, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameTimerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, type, startTime,
      duration, isCompleted, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of GameTimer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameTimerImplCopyWith<_$GameTimerImpl> get copyWith =>
      __$$GameTimerImplCopyWithImpl<_$GameTimerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameTimerImplToJson(
      this,
    );
  }
}

abstract class _GameTimer extends GameTimer {
  const factory _GameTimer(
      {required final String id,
      required final String title,
      required final TimerType type,
      required final DateTime startTime,
      required final Duration duration,
      final bool isCompleted,
      final Map<String, dynamic>? metadata}) = _$GameTimerImpl;
  const _GameTimer._() : super._();

  factory _GameTimer.fromJson(Map<String, dynamic> json) =
      _$GameTimerImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  TimerType get type;
  @override
  DateTime get startTime;
  @override
  Duration get duration;
  @override
  bool get isCompleted;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of GameTimer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameTimerImplCopyWith<_$GameTimerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
