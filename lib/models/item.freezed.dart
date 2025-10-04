// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  ItemRarity get rarity => throw _privateConstructorUsedError;
  Map<String, dynamic> get effect => throw _privateConstructorUsedError;
  ItemKind get kind => throw _privateConstructorUsedError;
  EquippableMeta? get equip => throw _privateConstructorUsedError;
  ItemSize get size => throw _privateConstructorUsedError;

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      int quantity,
      ItemRarity rarity,
      Map<String, dynamic> effect,
      ItemKind kind,
      EquippableMeta? equip,
      ItemSize size});

  $EquippableMetaCopyWith<$Res>? get equip;
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Item
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
    Object? equip = freezed,
    Object? size = null,
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
              as ItemRarity,
      effect: null == effect
          ? _value.effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ItemKind,
      equip: freezed == equip
          ? _value.equip
          : equip // ignore: cast_nullable_to_non_nullable
              as EquippableMeta?,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as ItemSize,
    ) as $Val);
  }

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EquippableMetaCopyWith<$Res>? get equip {
    if (_value.equip == null) {
      return null;
    }

    return $EquippableMetaCopyWith<$Res>(_value.equip!, (value) {
      return _then(_value.copyWith(equip: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
          _$ItemImpl value, $Res Function(_$ItemImpl) then) =
      __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      int quantity,
      ItemRarity rarity,
      Map<String, dynamic> effect,
      ItemKind kind,
      EquippableMeta? equip,
      ItemSize size});

  @override
  $EquippableMetaCopyWith<$Res>? get equip;
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of Item
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
    Object? equip = freezed,
    Object? size = null,
  }) {
    return _then(_$ItemImpl(
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
              as ItemRarity,
      effect: null == effect
          ? _value._effect
          : effect // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ItemKind,
      equip: freezed == equip
          ? _value.equip
          : equip // ignore: cast_nullable_to_non_nullable
              as EquippableMeta?,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as ItemSize,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemImpl implements _Item {
  const _$ItemImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.quantity,
      required this.rarity,
      final Map<String, dynamic> effect = const {},
      this.kind = ItemKind.consumable,
      this.equip,
      this.size = ItemSize.normal})
      : _effect = effect;

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

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
  final ItemRarity rarity;
  final Map<String, dynamic> _effect;
  @override
  @JsonKey()
  Map<String, dynamic> get effect {
    if (_effect is EqualUnmodifiableMapView) return _effect;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_effect);
  }

  @override
  @JsonKey()
  final ItemKind kind;
  @override
  final EquippableMeta? equip;
  @override
  @JsonKey()
  final ItemSize size;

  @override
  String toString() {
    return 'Item(id: $id, name: $name, description: $description, icon: $icon, quantity: $quantity, rarity: $rarity, effect: $effect, kind: $kind, equip: $equip, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
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
            (identical(other.equip, equip) || other.equip == equip) &&
            (identical(other.size, size) || other.size == size));
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
      equip,
      size);

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(
      this,
    );
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {required final String id,
      required final String name,
      required final String description,
      required final String icon,
      required final int quantity,
      required final ItemRarity rarity,
      final Map<String, dynamic> effect,
      final ItemKind kind,
      final EquippableMeta? equip,
      final ItemSize size}) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

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
  ItemRarity get rarity;
  @override
  Map<String, dynamic> get effect;
  @override
  ItemKind get kind;
  @override
  EquippableMeta? get equip;
  @override
  ItemSize get size;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
