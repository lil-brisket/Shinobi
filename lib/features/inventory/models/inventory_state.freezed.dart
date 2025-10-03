// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryState {
  List<Item> get items => throw _privateConstructorUsedError;
  List<Jutsu> get jutsus => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryStateCopyWith<InventoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStateCopyWith<$Res> {
  factory $InventoryStateCopyWith(
          InventoryState value, $Res Function(InventoryState) then) =
      _$InventoryStateCopyWithImpl<$Res, InventoryState>;
  @useResult
  $Res call(
      {List<Item> items, List<Jutsu> jutsus, bool isLoading, String? error});
}

/// @nodoc
class _$InventoryStateCopyWithImpl<$Res, $Val extends InventoryState>
    implements $InventoryStateCopyWith<$Res> {
  _$InventoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? jutsus = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      jutsus: null == jutsus
          ? _value.jutsus
          : jutsus // ignore: cast_nullable_to_non_nullable
              as List<Jutsu>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryStateImplCopyWith<$Res>
    implements $InventoryStateCopyWith<$Res> {
  factory _$$InventoryStateImplCopyWith(_$InventoryStateImpl value,
          $Res Function(_$InventoryStateImpl) then) =
      __$$InventoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Item> items, List<Jutsu> jutsus, bool isLoading, String? error});
}

/// @nodoc
class __$$InventoryStateImplCopyWithImpl<$Res>
    extends _$InventoryStateCopyWithImpl<$Res, _$InventoryStateImpl>
    implements _$$InventoryStateImplCopyWith<$Res> {
  __$$InventoryStateImplCopyWithImpl(
      _$InventoryStateImpl _value, $Res Function(_$InventoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? jutsus = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$InventoryStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      jutsus: null == jutsus
          ? _value._jutsus
          : jutsus // ignore: cast_nullable_to_non_nullable
              as List<Jutsu>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InventoryStateImpl implements _InventoryState {
  const _$InventoryStateImpl(
      {final List<Item> items = const [],
      final List<Jutsu> jutsus = const [],
      this.isLoading = false,
      this.error})
      : _items = items,
        _jutsus = jutsus;

  final List<Item> _items;
  @override
  @JsonKey()
  List<Item> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<Jutsu> _jutsus;
  @override
  @JsonKey()
  List<Jutsu> get jutsus {
    if (_jutsus is EqualUnmodifiableListView) return _jutsus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jutsus);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'InventoryState(items: $items, jutsus: $jutsus, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._jutsus, _jutsus) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_jutsus),
      isLoading,
      error);

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStateImplCopyWith<_$InventoryStateImpl> get copyWith =>
      __$$InventoryStateImplCopyWithImpl<_$InventoryStateImpl>(
          this, _$identity);
}

abstract class _InventoryState implements InventoryState {
  const factory _InventoryState(
      {final List<Item> items,
      final List<Jutsu> jutsus,
      final bool isLoading,
      final String? error}) = _$InventoryStateImpl;

  @override
  List<Item> get items;
  @override
  List<Jutsu> get jutsus;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStateImplCopyWith<_$InventoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InventoryFilter {
  ItemKind get kind => throw _privateConstructorUsedError;
  ItemRarity get rarity => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  bool get showEquippedOnly => throw _privateConstructorUsedError;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryFilterCopyWith<InventoryFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryFilterCopyWith<$Res> {
  factory $InventoryFilterCopyWith(
          InventoryFilter value, $Res Function(InventoryFilter) then) =
      _$InventoryFilterCopyWithImpl<$Res, InventoryFilter>;
  @useResult
  $Res call(
      {ItemKind kind,
      ItemRarity rarity,
      String searchQuery,
      bool showEquippedOnly});
}

/// @nodoc
class _$InventoryFilterCopyWithImpl<$Res, $Val extends InventoryFilter>
    implements $InventoryFilterCopyWith<$Res> {
  _$InventoryFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? rarity = null,
    Object? searchQuery = null,
    Object? showEquippedOnly = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ItemKind,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ItemRarity,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      showEquippedOnly: null == showEquippedOnly
          ? _value.showEquippedOnly
          : showEquippedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryFilterImplCopyWith<$Res>
    implements $InventoryFilterCopyWith<$Res> {
  factory _$$InventoryFilterImplCopyWith(_$InventoryFilterImpl value,
          $Res Function(_$InventoryFilterImpl) then) =
      __$$InventoryFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ItemKind kind,
      ItemRarity rarity,
      String searchQuery,
      bool showEquippedOnly});
}

/// @nodoc
class __$$InventoryFilterImplCopyWithImpl<$Res>
    extends _$InventoryFilterCopyWithImpl<$Res, _$InventoryFilterImpl>
    implements _$$InventoryFilterImplCopyWith<$Res> {
  __$$InventoryFilterImplCopyWithImpl(
      _$InventoryFilterImpl _value, $Res Function(_$InventoryFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? rarity = null,
    Object? searchQuery = null,
    Object? showEquippedOnly = null,
  }) {
    return _then(_$InventoryFilterImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ItemKind,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ItemRarity,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      showEquippedOnly: null == showEquippedOnly
          ? _value.showEquippedOnly
          : showEquippedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InventoryFilterImpl implements _InventoryFilter {
  const _$InventoryFilterImpl(
      {this.kind = ItemKind.all,
      this.rarity = ItemRarity.all,
      this.searchQuery = '',
      this.showEquippedOnly = false});

  @override
  @JsonKey()
  final ItemKind kind;
  @override
  @JsonKey()
  final ItemRarity rarity;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool showEquippedOnly;

  @override
  String toString() {
    return 'InventoryFilter(kind: $kind, rarity: $rarity, searchQuery: $searchQuery, showEquippedOnly: $showEquippedOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryFilterImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.showEquippedOnly, showEquippedOnly) ||
                other.showEquippedOnly == showEquippedOnly));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, kind, rarity, searchQuery, showEquippedOnly);

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryFilterImplCopyWith<_$InventoryFilterImpl> get copyWith =>
      __$$InventoryFilterImplCopyWithImpl<_$InventoryFilterImpl>(
          this, _$identity);
}

abstract class _InventoryFilter implements InventoryFilter {
  const factory _InventoryFilter(
      {final ItemKind kind,
      final ItemRarity rarity,
      final String searchQuery,
      final bool showEquippedOnly}) = _$InventoryFilterImpl;

  @override
  ItemKind get kind;
  @override
  ItemRarity get rarity;
  @override
  String get searchQuery;
  @override
  bool get showEquippedOnly;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryFilterImplCopyWith<_$InventoryFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
