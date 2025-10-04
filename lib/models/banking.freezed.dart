// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return _Wallet.fromJson(json);
}

/// @nodoc
mixin _$Wallet {
  String get playerId => throw _privateConstructorUsedError;
  int get pocketBalance => throw _privateConstructorUsedError;
  int get bankBalance => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call(
      {String playerId,
      int pocketBalance,
      int bankBalance,
      DateTime updatedAt});
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$WalletImplCopyWith(
          _$WalletImpl value, $Res Function(_$WalletImpl) then) =
      __$$WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String playerId,
      int pocketBalance,
      int bankBalance,
      DateTime updatedAt});
}

/// @nodoc
class __$$WalletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$WalletImpl>
    implements _$$WalletImplCopyWith<$Res> {
  __$$WalletImplCopyWithImpl(
      _$WalletImpl _value, $Res Function(_$WalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WalletImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletImpl implements _Wallet {
  const _$WalletImpl(
      {required this.playerId,
      required this.pocketBalance,
      required this.bankBalance,
      required this.updatedAt});

  factory _$WalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletImplFromJson(json);

  @override
  final String playerId;
  @override
  final int pocketBalance;
  @override
  final int bankBalance;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Wallet(playerId: $playerId, pocketBalance: $pocketBalance, bankBalance: $bankBalance, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.pocketBalance, pocketBalance) ||
                other.pocketBalance == pocketBalance) &&
            (identical(other.bankBalance, bankBalance) ||
                other.bankBalance == bankBalance) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, playerId, pocketBalance, bankBalance, updatedAt);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      __$$WalletImplCopyWithImpl<_$WalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletImplToJson(
      this,
    );
  }
}

abstract class _Wallet implements Wallet {
  const factory _Wallet(
      {required final String playerId,
      required final int pocketBalance,
      required final int bankBalance,
      required final DateTime updatedAt}) = _$WalletImpl;

  factory _Wallet.fromJson(Map<String, dynamic> json) = _$WalletImpl.fromJson;

  @override
  String get playerId;
  @override
  int get pocketBalance;
  @override
  int get bankBalance;
  @override
  DateTime get updatedAt;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get actorId => throw _privateConstructorUsedError;
  String? get senderId => throw _privateConstructorUsedError;
  String? get receiverId => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  String? get idempotencyKey => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String? actorId,
      String? senderId,
      String? receiverId,
      String source,
      String destination,
      int amount,
      String kind,
      String? memo,
      String? idempotencyKey});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? actorId = freezed,
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? source = null,
    Object? destination = null,
    Object? amount = null,
    Object? kind = null,
    Object? memo = freezed,
    Object? idempotencyKey = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      idempotencyKey: freezed == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String? actorId,
      String? senderId,
      String? receiverId,
      String source,
      String destination,
      int amount,
      String kind,
      String? memo,
      String? idempotencyKey});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? actorId = freezed,
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? source = null,
    Object? destination = null,
    Object? amount = null,
    Object? kind = null,
    Object? memo = freezed,
    Object? idempotencyKey = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      idempotencyKey: freezed == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.id,
      required this.createdAt,
      this.actorId,
      this.senderId,
      this.receiverId,
      required this.source,
      required this.destination,
      required this.amount,
      required this.kind,
      this.memo,
      this.idempotencyKey});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final String? actorId;
  @override
  final String? senderId;
  @override
  final String? receiverId;
  @override
  final String source;
  @override
  final String destination;
  @override
  final int amount;
  @override
  final String kind;
  @override
  final String? memo;
  @override
  final String? idempotencyKey;

  @override
  String toString() {
    return 'Transaction(id: $id, createdAt: $createdAt, actorId: $actorId, senderId: $senderId, receiverId: $receiverId, source: $source, destination: $destination, amount: $amount, kind: $kind, memo: $memo, idempotencyKey: $idempotencyKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, actorId, senderId,
      receiverId, source, destination, amount, kind, memo, idempotencyKey);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {required final int id,
      required final DateTime createdAt,
      final String? actorId,
      final String? senderId,
      final String? receiverId,
      required final String source,
      required final String destination,
      required final int amount,
      required final String kind,
      final String? memo,
      final String? idempotencyKey}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get createdAt;
  @override
  String? get actorId;
  @override
  String? get senderId;
  @override
  String? get receiverId;
  @override
  String get source;
  @override
  String get destination;
  @override
  int get amount;
  @override
  String get kind;
  @override
  String? get memo;
  @override
  String? get idempotencyKey;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InterestOffer _$InterestOfferFromJson(Map<String, dynamic> json) {
  return _InterestOffer.fromJson(json);
}

/// @nodoc
mixin _$InterestOffer {
  int get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get forDate => throw _privateConstructorUsedError;
  int get bankBalanceSnapshot => throw _privateConstructorUsedError;
  int get rateBps => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  DateTime get claimDeadline => throw _privateConstructorUsedError;
  DateTime? get claimedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InterestOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InterestOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InterestOfferCopyWith<InterestOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestOfferCopyWith<$Res> {
  factory $InterestOfferCopyWith(
          InterestOffer value, $Res Function(InterestOffer) then) =
      _$InterestOfferCopyWithImpl<$Res, InterestOffer>;
  @useResult
  $Res call(
      {int id,
      String playerId,
      String forDate,
      int bankBalanceSnapshot,
      int rateBps,
      int amount,
      DateTime claimDeadline,
      DateTime? claimedAt,
      DateTime createdAt});
}

/// @nodoc
class _$InterestOfferCopyWithImpl<$Res, $Val extends InterestOffer>
    implements $InterestOfferCopyWith<$Res> {
  _$InterestOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterestOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? forDate = null,
    Object? bankBalanceSnapshot = null,
    Object? rateBps = null,
    Object? amount = null,
    Object? claimDeadline = null,
    Object? claimedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      forDate: null == forDate
          ? _value.forDate
          : forDate // ignore: cast_nullable_to_non_nullable
              as String,
      bankBalanceSnapshot: null == bankBalanceSnapshot
          ? _value.bankBalanceSnapshot
          : bankBalanceSnapshot // ignore: cast_nullable_to_non_nullable
              as int,
      rateBps: null == rateBps
          ? _value.rateBps
          : rateBps // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      claimDeadline: null == claimDeadline
          ? _value.claimDeadline
          : claimDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterestOfferImplCopyWith<$Res>
    implements $InterestOfferCopyWith<$Res> {
  factory _$$InterestOfferImplCopyWith(
          _$InterestOfferImpl value, $Res Function(_$InterestOfferImpl) then) =
      __$$InterestOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String playerId,
      String forDate,
      int bankBalanceSnapshot,
      int rateBps,
      int amount,
      DateTime claimDeadline,
      DateTime? claimedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$InterestOfferImplCopyWithImpl<$Res>
    extends _$InterestOfferCopyWithImpl<$Res, _$InterestOfferImpl>
    implements _$$InterestOfferImplCopyWith<$Res> {
  __$$InterestOfferImplCopyWithImpl(
      _$InterestOfferImpl _value, $Res Function(_$InterestOfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of InterestOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? forDate = null,
    Object? bankBalanceSnapshot = null,
    Object? rateBps = null,
    Object? amount = null,
    Object? claimDeadline = null,
    Object? claimedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$InterestOfferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      forDate: null == forDate
          ? _value.forDate
          : forDate // ignore: cast_nullable_to_non_nullable
              as String,
      bankBalanceSnapshot: null == bankBalanceSnapshot
          ? _value.bankBalanceSnapshot
          : bankBalanceSnapshot // ignore: cast_nullable_to_non_nullable
              as int,
      rateBps: null == rateBps
          ? _value.rateBps
          : rateBps // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      claimDeadline: null == claimDeadline
          ? _value.claimDeadline
          : claimDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InterestOfferImpl implements _InterestOffer {
  const _$InterestOfferImpl(
      {required this.id,
      required this.playerId,
      required this.forDate,
      required this.bankBalanceSnapshot,
      required this.rateBps,
      required this.amount,
      required this.claimDeadline,
      this.claimedAt,
      required this.createdAt});

  factory _$InterestOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterestOfferImplFromJson(json);

  @override
  final int id;
  @override
  final String playerId;
  @override
  final String forDate;
  @override
  final int bankBalanceSnapshot;
  @override
  final int rateBps;
  @override
  final int amount;
  @override
  final DateTime claimDeadline;
  @override
  final DateTime? claimedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'InterestOffer(id: $id, playerId: $playerId, forDate: $forDate, bankBalanceSnapshot: $bankBalanceSnapshot, rateBps: $rateBps, amount: $amount, claimDeadline: $claimDeadline, claimedAt: $claimedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.forDate, forDate) || other.forDate == forDate) &&
            (identical(other.bankBalanceSnapshot, bankBalanceSnapshot) ||
                other.bankBalanceSnapshot == bankBalanceSnapshot) &&
            (identical(other.rateBps, rateBps) || other.rateBps == rateBps) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.claimDeadline, claimDeadline) ||
                other.claimDeadline == claimDeadline) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      playerId,
      forDate,
      bankBalanceSnapshot,
      rateBps,
      amount,
      claimDeadline,
      claimedAt,
      createdAt);

  /// Create a copy of InterestOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestOfferImplCopyWith<_$InterestOfferImpl> get copyWith =>
      __$$InterestOfferImplCopyWithImpl<_$InterestOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterestOfferImplToJson(
      this,
    );
  }
}

abstract class _InterestOffer implements InterestOffer {
  const factory _InterestOffer(
      {required final int id,
      required final String playerId,
      required final String forDate,
      required final int bankBalanceSnapshot,
      required final int rateBps,
      required final int amount,
      required final DateTime claimDeadline,
      final DateTime? claimedAt,
      required final DateTime createdAt}) = _$InterestOfferImpl;

  factory _InterestOffer.fromJson(Map<String, dynamic> json) =
      _$InterestOfferImpl.fromJson;

  @override
  int get id;
  @override
  String get playerId;
  @override
  String get forDate;
  @override
  int get bankBalanceSnapshot;
  @override
  int get rateBps;
  @override
  int get amount;
  @override
  DateTime get claimDeadline;
  @override
  DateTime? get claimedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of InterestOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InterestOfferImplCopyWith<_$InterestOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

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
  $Res call({String id, String username, DateTime createdAt});
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
    Object? username = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
          _$PlayerImpl value, $Res Function(_$PlayerImpl) then) =
      __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String username, DateTime createdAt});
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
    Object? username = null,
    Object? createdAt = null,
  }) {
    return _then(_$PlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl implements _Player {
  const _$PlayerImpl(
      {required this.id, required this.username, required this.createdAt});

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Player(id: $id, username: $username, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, createdAt);

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
      required final String username,
      required final DateTime createdAt}) = _$PlayerImpl;

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  DateTime get createdAt;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LedgerEntry _$LedgerEntryFromJson(Map<String, dynamic> json) {
  return _LedgerEntry.fromJson(json);
}

/// @nodoc
mixin _$LedgerEntry {
  int get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get delta => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  String? get counterpartyUsername => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;

  /// Serializes this LedgerEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerEntryCopyWith<LedgerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerEntryCopyWith<$Res> {
  factory $LedgerEntryCopyWith(
          LedgerEntry value, $Res Function(LedgerEntry) then) =
      _$LedgerEntryCopyWithImpl<$Res, LedgerEntry>;
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String kind,
      int amount,
      int delta,
      String source,
      String destination,
      String? counterpartyUsername,
      String? memo});
}

/// @nodoc
class _$LedgerEntryCopyWithImpl<$Res, $Val extends LedgerEntry>
    implements $LedgerEntryCopyWith<$Res> {
  _$LedgerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? kind = null,
    Object? amount = null,
    Object? delta = null,
    Object? source = null,
    Object? destination = null,
    Object? counterpartyUsername = freezed,
    Object? memo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyUsername: freezed == counterpartyUsername
          ? _value.counterpartyUsername
          : counterpartyUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerEntryImplCopyWith<$Res>
    implements $LedgerEntryCopyWith<$Res> {
  factory _$$LedgerEntryImplCopyWith(
          _$LedgerEntryImpl value, $Res Function(_$LedgerEntryImpl) then) =
      __$$LedgerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime createdAt,
      String kind,
      int amount,
      int delta,
      String source,
      String destination,
      String? counterpartyUsername,
      String? memo});
}

/// @nodoc
class __$$LedgerEntryImplCopyWithImpl<$Res>
    extends _$LedgerEntryCopyWithImpl<$Res, _$LedgerEntryImpl>
    implements _$$LedgerEntryImplCopyWith<$Res> {
  __$$LedgerEntryImplCopyWithImpl(
      _$LedgerEntryImpl _value, $Res Function(_$LedgerEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? kind = null,
    Object? amount = null,
    Object? delta = null,
    Object? source = null,
    Object? destination = null,
    Object? counterpartyUsername = freezed,
    Object? memo = freezed,
  }) {
    return _then(_$LedgerEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyUsername: freezed == counterpartyUsername
          ? _value.counterpartyUsername
          : counterpartyUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerEntryImpl implements _LedgerEntry {
  const _$LedgerEntryImpl(
      {required this.id,
      required this.createdAt,
      required this.kind,
      required this.amount,
      required this.delta,
      required this.source,
      required this.destination,
      this.counterpartyUsername,
      this.memo});

  factory _$LedgerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerEntryImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final String kind;
  @override
  final int amount;
  @override
  final int delta;
  @override
  final String source;
  @override
  final String destination;
  @override
  final String? counterpartyUsername;
  @override
  final String? memo;

  @override
  String toString() {
    return 'LedgerEntry(id: $id, createdAt: $createdAt, kind: $kind, amount: $amount, delta: $delta, source: $source, destination: $destination, counterpartyUsername: $counterpartyUsername, memo: $memo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.counterpartyUsername, counterpartyUsername) ||
                other.counterpartyUsername == counterpartyUsername) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, kind, amount,
      delta, source, destination, counterpartyUsername, memo);

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      __$$LedgerEntryImplCopyWithImpl<_$LedgerEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerEntryImplToJson(
      this,
    );
  }
}

abstract class _LedgerEntry implements LedgerEntry {
  const factory _LedgerEntry(
      {required final int id,
      required final DateTime createdAt,
      required final String kind,
      required final int amount,
      required final int delta,
      required final String source,
      required final String destination,
      final String? counterpartyUsername,
      final String? memo}) = _$LedgerEntryImpl;

  factory _LedgerEntry.fromJson(Map<String, dynamic> json) =
      _$LedgerEntryImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get createdAt;
  @override
  String get kind;
  @override
  int get amount;
  @override
  int get delta;
  @override
  String get source;
  @override
  String get destination;
  @override
  String? get counterpartyUsername;
  @override
  String? get memo;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse.fromJson(json);
}

/// @nodoc
mixin _$ApiResponse {
  bool get success => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ApiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponseCopyWith<ApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<$Res> {
  factory $ApiResponseCopyWith(
          ApiResponse value, $Res Function(ApiResponse) then) =
      _$ApiResponseCopyWithImpl<$Res, ApiResponse>;
  @useResult
  $Res call(
      {bool success,
      Map<String, dynamic>? data,
      String? error,
      String? message});
}

/// @nodoc
class _$ApiResponseCopyWithImpl<$Res, $Val extends ApiResponse>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseImplCopyWith<$Res>
    implements $ApiResponseCopyWith<$Res> {
  factory _$$ApiResponseImplCopyWith(
          _$ApiResponseImpl value, $Res Function(_$ApiResponseImpl) then) =
      __$$ApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      Map<String, dynamic>? data,
      String? error,
      String? message});
}

/// @nodoc
class __$$ApiResponseImplCopyWithImpl<$Res>
    extends _$ApiResponseCopyWithImpl<$Res, _$ApiResponseImpl>
    implements _$$ApiResponseImplCopyWith<$Res> {
  __$$ApiResponseImplCopyWithImpl(
      _$ApiResponseImpl _value, $Res Function(_$ApiResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_$ApiResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseImpl implements _ApiResponse {
  const _$ApiResponseImpl(
      {required this.success,
      final Map<String, dynamic>? data,
      this.error,
      this.message})
      : _data = data;

  factory _$ApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseImplFromJson(json);

  @override
  final bool success;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? error;
  @override
  final String? message;

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success,
      const DeepCollectionEquality().hash(_data), error, message);

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      __$$ApiResponseImplCopyWithImpl<_$ApiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseImplToJson(
      this,
    );
  }
}

abstract class _ApiResponse implements ApiResponse {
  const factory _ApiResponse(
      {required final bool success,
      final Map<String, dynamic>? data,
      final String? error,
      final String? message}) = _$ApiResponseImpl;

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =
      _$ApiResponseImpl.fromJson;

  @override
  bool get success;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get error;
  @override
  String? get message;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BalanceResponse _$BalanceResponseFromJson(Map<String, dynamic> json) {
  return _BalanceResponse.fromJson(json);
}

/// @nodoc
mixin _$BalanceResponse {
  int get pocketBalance => throw _privateConstructorUsedError;
  int get bankBalance => throw _privateConstructorUsedError;
  int get txId => throw _privateConstructorUsedError;

  /// Serializes this BalanceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BalanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BalanceResponseCopyWith<BalanceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceResponseCopyWith<$Res> {
  factory $BalanceResponseCopyWith(
          BalanceResponse value, $Res Function(BalanceResponse) then) =
      _$BalanceResponseCopyWithImpl<$Res, BalanceResponse>;
  @useResult
  $Res call({int pocketBalance, int bankBalance, int txId});
}

/// @nodoc
class _$BalanceResponseCopyWithImpl<$Res, $Val extends BalanceResponse>
    implements $BalanceResponseCopyWith<$Res> {
  _$BalanceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BalanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? txId = null,
  }) {
    return _then(_value.copyWith(
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      txId: null == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceResponseImplCopyWith<$Res>
    implements $BalanceResponseCopyWith<$Res> {
  factory _$$BalanceResponseImplCopyWith(_$BalanceResponseImpl value,
          $Res Function(_$BalanceResponseImpl) then) =
      __$$BalanceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pocketBalance, int bankBalance, int txId});
}

/// @nodoc
class __$$BalanceResponseImplCopyWithImpl<$Res>
    extends _$BalanceResponseCopyWithImpl<$Res, _$BalanceResponseImpl>
    implements _$$BalanceResponseImplCopyWith<$Res> {
  __$$BalanceResponseImplCopyWithImpl(
      _$BalanceResponseImpl _value, $Res Function(_$BalanceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BalanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? txId = null,
  }) {
    return _then(_$BalanceResponseImpl(
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      txId: null == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceResponseImpl implements _BalanceResponse {
  const _$BalanceResponseImpl(
      {required this.pocketBalance,
      required this.bankBalance,
      required this.txId});

  factory _$BalanceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceResponseImplFromJson(json);

  @override
  final int pocketBalance;
  @override
  final int bankBalance;
  @override
  final int txId;

  @override
  String toString() {
    return 'BalanceResponse(pocketBalance: $pocketBalance, bankBalance: $bankBalance, txId: $txId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceResponseImpl &&
            (identical(other.pocketBalance, pocketBalance) ||
                other.pocketBalance == pocketBalance) &&
            (identical(other.bankBalance, bankBalance) ||
                other.bankBalance == bankBalance) &&
            (identical(other.txId, txId) || other.txId == txId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pocketBalance, bankBalance, txId);

  /// Create a copy of BalanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceResponseImplCopyWith<_$BalanceResponseImpl> get copyWith =>
      __$$BalanceResponseImplCopyWithImpl<_$BalanceResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceResponseImplToJson(
      this,
    );
  }
}

abstract class _BalanceResponse implements BalanceResponse {
  const factory _BalanceResponse(
      {required final int pocketBalance,
      required final int bankBalance,
      required final int txId}) = _$BalanceResponseImpl;

  factory _BalanceResponse.fromJson(Map<String, dynamic> json) =
      _$BalanceResponseImpl.fromJson;

  @override
  int get pocketBalance;
  @override
  int get bankBalance;
  @override
  int get txId;

  /// Create a copy of BalanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BalanceResponseImplCopyWith<_$BalanceResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferResponse _$TransferResponseFromJson(Map<String, dynamic> json) {
  return _TransferResponse.fromJson(json);
}

/// @nodoc
mixin _$TransferResponse {
  int get pocketBalance => throw _privateConstructorUsedError;
  int get bankBalance => throw _privateConstructorUsedError;
  TransferReceipt get receipt => throw _privateConstructorUsedError;

  /// Serializes this TransferResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferResponseCopyWith<TransferResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferResponseCopyWith<$Res> {
  factory $TransferResponseCopyWith(
          TransferResponse value, $Res Function(TransferResponse) then) =
      _$TransferResponseCopyWithImpl<$Res, TransferResponse>;
  @useResult
  $Res call({int pocketBalance, int bankBalance, TransferReceipt receipt});

  $TransferReceiptCopyWith<$Res> get receipt;
}

/// @nodoc
class _$TransferResponseCopyWithImpl<$Res, $Val extends TransferResponse>
    implements $TransferResponseCopyWith<$Res> {
  _$TransferResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? receipt = null,
  }) {
    return _then(_value.copyWith(
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      receipt: null == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as TransferReceipt,
    ) as $Val);
  }

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferReceiptCopyWith<$Res> get receipt {
    return $TransferReceiptCopyWith<$Res>(_value.receipt, (value) {
      return _then(_value.copyWith(receipt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferResponseImplCopyWith<$Res>
    implements $TransferResponseCopyWith<$Res> {
  factory _$$TransferResponseImplCopyWith(_$TransferResponseImpl value,
          $Res Function(_$TransferResponseImpl) then) =
      __$$TransferResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pocketBalance, int bankBalance, TransferReceipt receipt});

  @override
  $TransferReceiptCopyWith<$Res> get receipt;
}

/// @nodoc
class __$$TransferResponseImplCopyWithImpl<$Res>
    extends _$TransferResponseCopyWithImpl<$Res, _$TransferResponseImpl>
    implements _$$TransferResponseImplCopyWith<$Res> {
  __$$TransferResponseImplCopyWithImpl(_$TransferResponseImpl _value,
      $Res Function(_$TransferResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketBalance = null,
    Object? bankBalance = null,
    Object? receipt = null,
  }) {
    return _then(_$TransferResponseImpl(
      pocketBalance: null == pocketBalance
          ? _value.pocketBalance
          : pocketBalance // ignore: cast_nullable_to_non_nullable
              as int,
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      receipt: null == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as TransferReceipt,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferResponseImpl implements _TransferResponse {
  const _$TransferResponseImpl(
      {required this.pocketBalance,
      required this.bankBalance,
      required this.receipt});

  factory _$TransferResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferResponseImplFromJson(json);

  @override
  final int pocketBalance;
  @override
  final int bankBalance;
  @override
  final TransferReceipt receipt;

  @override
  String toString() {
    return 'TransferResponse(pocketBalance: $pocketBalance, bankBalance: $bankBalance, receipt: $receipt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferResponseImpl &&
            (identical(other.pocketBalance, pocketBalance) ||
                other.pocketBalance == pocketBalance) &&
            (identical(other.bankBalance, bankBalance) ||
                other.bankBalance == bankBalance) &&
            (identical(other.receipt, receipt) || other.receipt == receipt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pocketBalance, bankBalance, receipt);

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferResponseImplCopyWith<_$TransferResponseImpl> get copyWith =>
      __$$TransferResponseImplCopyWithImpl<_$TransferResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferResponseImplToJson(
      this,
    );
  }
}

abstract class _TransferResponse implements TransferResponse {
  const factory _TransferResponse(
      {required final int pocketBalance,
      required final int bankBalance,
      required final TransferReceipt receipt}) = _$TransferResponseImpl;

  factory _TransferResponse.fromJson(Map<String, dynamic> json) =
      _$TransferResponseImpl.fromJson;

  @override
  int get pocketBalance;
  @override
  int get bankBalance;
  @override
  TransferReceipt get receipt;

  /// Create a copy of TransferResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferResponseImplCopyWith<_$TransferResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferReceipt _$TransferReceiptFromJson(Map<String, dynamic> json) {
  return _TransferReceipt.fromJson(json);
}

/// @nodoc
mixin _$TransferReceipt {
  String get counterparty => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;

  /// Serializes this TransferReceipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferReceiptCopyWith<TransferReceipt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferReceiptCopyWith<$Res> {
  factory $TransferReceiptCopyWith(
          TransferReceipt value, $Res Function(TransferReceipt) then) =
      _$TransferReceiptCopyWithImpl<$Res, TransferReceipt>;
  @useResult
  $Res call(
      {String counterparty, int amount, String source, String destination});
}

/// @nodoc
class _$TransferReceiptCopyWithImpl<$Res, $Val extends TransferReceipt>
    implements $TransferReceiptCopyWith<$Res> {
  _$TransferReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterparty = null,
    Object? amount = null,
    Object? source = null,
    Object? destination = null,
  }) {
    return _then(_value.copyWith(
      counterparty: null == counterparty
          ? _value.counterparty
          : counterparty // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferReceiptImplCopyWith<$Res>
    implements $TransferReceiptCopyWith<$Res> {
  factory _$$TransferReceiptImplCopyWith(_$TransferReceiptImpl value,
          $Res Function(_$TransferReceiptImpl) then) =
      __$$TransferReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterparty, int amount, String source, String destination});
}

/// @nodoc
class __$$TransferReceiptImplCopyWithImpl<$Res>
    extends _$TransferReceiptCopyWithImpl<$Res, _$TransferReceiptImpl>
    implements _$$TransferReceiptImplCopyWith<$Res> {
  __$$TransferReceiptImplCopyWithImpl(
      _$TransferReceiptImpl _value, $Res Function(_$TransferReceiptImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterparty = null,
    Object? amount = null,
    Object? source = null,
    Object? destination = null,
  }) {
    return _then(_$TransferReceiptImpl(
      counterparty: null == counterparty
          ? _value.counterparty
          : counterparty // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferReceiptImpl implements _TransferReceipt {
  const _$TransferReceiptImpl(
      {required this.counterparty,
      required this.amount,
      required this.source,
      required this.destination});

  factory _$TransferReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferReceiptImplFromJson(json);

  @override
  final String counterparty;
  @override
  final int amount;
  @override
  final String source;
  @override
  final String destination;

  @override
  String toString() {
    return 'TransferReceipt(counterparty: $counterparty, amount: $amount, source: $source, destination: $destination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferReceiptImpl &&
            (identical(other.counterparty, counterparty) ||
                other.counterparty == counterparty) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, counterparty, amount, source, destination);

  /// Create a copy of TransferReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferReceiptImplCopyWith<_$TransferReceiptImpl> get copyWith =>
      __$$TransferReceiptImplCopyWithImpl<_$TransferReceiptImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferReceiptImplToJson(
      this,
    );
  }
}

abstract class _TransferReceipt implements TransferReceipt {
  const factory _TransferReceipt(
      {required final String counterparty,
      required final int amount,
      required final String source,
      required final String destination}) = _$TransferReceiptImpl;

  factory _TransferReceipt.fromJson(Map<String, dynamic> json) =
      _$TransferReceiptImpl.fromJson;

  @override
  String get counterparty;
  @override
  int get amount;
  @override
  String get source;
  @override
  String get destination;

  /// Create a copy of TransferReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferReceiptImplCopyWith<_$TransferReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InterestClaimResponse _$InterestClaimResponseFromJson(
    Map<String, dynamic> json) {
  return _InterestClaimResponse.fromJson(json);
}

/// @nodoc
mixin _$InterestClaimResponse {
  int get bankBalance => throw _privateConstructorUsedError;
  int get claimedAmount => throw _privateConstructorUsedError;

  /// Serializes this InterestClaimResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InterestClaimResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InterestClaimResponseCopyWith<InterestClaimResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestClaimResponseCopyWith<$Res> {
  factory $InterestClaimResponseCopyWith(InterestClaimResponse value,
          $Res Function(InterestClaimResponse) then) =
      _$InterestClaimResponseCopyWithImpl<$Res, InterestClaimResponse>;
  @useResult
  $Res call({int bankBalance, int claimedAmount});
}

/// @nodoc
class _$InterestClaimResponseCopyWithImpl<$Res,
        $Val extends InterestClaimResponse>
    implements $InterestClaimResponseCopyWith<$Res> {
  _$InterestClaimResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterestClaimResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankBalance = null,
    Object? claimedAmount = null,
  }) {
    return _then(_value.copyWith(
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      claimedAmount: null == claimedAmount
          ? _value.claimedAmount
          : claimedAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterestClaimResponseImplCopyWith<$Res>
    implements $InterestClaimResponseCopyWith<$Res> {
  factory _$$InterestClaimResponseImplCopyWith(
          _$InterestClaimResponseImpl value,
          $Res Function(_$InterestClaimResponseImpl) then) =
      __$$InterestClaimResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bankBalance, int claimedAmount});
}

/// @nodoc
class __$$InterestClaimResponseImplCopyWithImpl<$Res>
    extends _$InterestClaimResponseCopyWithImpl<$Res,
        _$InterestClaimResponseImpl>
    implements _$$InterestClaimResponseImplCopyWith<$Res> {
  __$$InterestClaimResponseImplCopyWithImpl(_$InterestClaimResponseImpl _value,
      $Res Function(_$InterestClaimResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of InterestClaimResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankBalance = null,
    Object? claimedAmount = null,
  }) {
    return _then(_$InterestClaimResponseImpl(
      bankBalance: null == bankBalance
          ? _value.bankBalance
          : bankBalance // ignore: cast_nullable_to_non_nullable
              as int,
      claimedAmount: null == claimedAmount
          ? _value.claimedAmount
          : claimedAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InterestClaimResponseImpl implements _InterestClaimResponse {
  const _$InterestClaimResponseImpl(
      {required this.bankBalance, required this.claimedAmount});

  factory _$InterestClaimResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterestClaimResponseImplFromJson(json);

  @override
  final int bankBalance;
  @override
  final int claimedAmount;

  @override
  String toString() {
    return 'InterestClaimResponse(bankBalance: $bankBalance, claimedAmount: $claimedAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestClaimResponseImpl &&
            (identical(other.bankBalance, bankBalance) ||
                other.bankBalance == bankBalance) &&
            (identical(other.claimedAmount, claimedAmount) ||
                other.claimedAmount == claimedAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bankBalance, claimedAmount);

  /// Create a copy of InterestClaimResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestClaimResponseImplCopyWith<_$InterestClaimResponseImpl>
      get copyWith => __$$InterestClaimResponseImplCopyWithImpl<
          _$InterestClaimResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterestClaimResponseImplToJson(
      this,
    );
  }
}

abstract class _InterestClaimResponse implements InterestClaimResponse {
  const factory _InterestClaimResponse(
      {required final int bankBalance,
      required final int claimedAmount}) = _$InterestClaimResponseImpl;

  factory _InterestClaimResponse.fromJson(Map<String, dynamic> json) =
      _$InterestClaimResponseImpl.fromJson;

  @override
  int get bankBalance;
  @override
  int get claimedAmount;

  /// Create a copy of InterestClaimResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InterestClaimResponseImplCopyWith<_$InterestClaimResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
