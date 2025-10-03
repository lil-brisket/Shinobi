// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CombatState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  List<BattleHistoryEntry> get battleHistory =>
      throw _privateConstructorUsedError;

  /// Create a copy of CombatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CombatStateCopyWith<CombatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombatStateCopyWith<$Res> {
  factory $CombatStateCopyWith(
          CombatState value, $Res Function(CombatState) then) =
      _$CombatStateCopyWithImpl<$Res, CombatState>;
  @useResult
  $Res call(
      {bool isLoading, String? error, List<BattleHistoryEntry> battleHistory});
}

/// @nodoc
class _$CombatStateCopyWithImpl<$Res, $Val extends CombatState>
    implements $CombatStateCopyWith<$Res> {
  _$CombatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CombatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? battleHistory = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      battleHistory: null == battleHistory
          ? _value.battleHistory
          : battleHistory // ignore: cast_nullable_to_non_nullable
              as List<BattleHistoryEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CombatStateImplCopyWith<$Res>
    implements $CombatStateCopyWith<$Res> {
  factory _$$CombatStateImplCopyWith(
          _$CombatStateImpl value, $Res Function(_$CombatStateImpl) then) =
      __$$CombatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, String? error, List<BattleHistoryEntry> battleHistory});
}

/// @nodoc
class __$$CombatStateImplCopyWithImpl<$Res>
    extends _$CombatStateCopyWithImpl<$Res, _$CombatStateImpl>
    implements _$$CombatStateImplCopyWith<$Res> {
  __$$CombatStateImplCopyWithImpl(
      _$CombatStateImpl _value, $Res Function(_$CombatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CombatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? battleHistory = null,
  }) {
    return _then(_$CombatStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      battleHistory: null == battleHistory
          ? _value._battleHistory
          : battleHistory // ignore: cast_nullable_to_non_nullable
              as List<BattleHistoryEntry>,
    ));
  }
}

/// @nodoc

class _$CombatStateImpl implements _CombatState {
  const _$CombatStateImpl(
      {this.isLoading = false,
      this.error,
      final List<BattleHistoryEntry> battleHistory = const []})
      : _battleHistory = battleHistory;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  final List<BattleHistoryEntry> _battleHistory;
  @override
  @JsonKey()
  List<BattleHistoryEntry> get battleHistory {
    if (_battleHistory is EqualUnmodifiableListView) return _battleHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_battleHistory);
  }

  @override
  String toString() {
    return 'CombatState(isLoading: $isLoading, error: $error, battleHistory: $battleHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CombatStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._battleHistory, _battleHistory));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, error,
      const DeepCollectionEquality().hash(_battleHistory));

  /// Create a copy of CombatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CombatStateImplCopyWith<_$CombatStateImpl> get copyWith =>
      __$$CombatStateImplCopyWithImpl<_$CombatStateImpl>(this, _$identity);
}

abstract class _CombatState implements CombatState {
  const factory _CombatState(
      {final bool isLoading,
      final String? error,
      final List<BattleHistoryEntry> battleHistory}) = _$CombatStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  List<BattleHistoryEntry> get battleHistory;

  /// Create a copy of CombatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CombatStateImplCopyWith<_$CombatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
