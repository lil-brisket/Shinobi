// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      playerId: json['playerId'] as String,
      pocketBalance: (json['pocketBalance'] as num).toInt(),
      bankBalance: (json['bankBalance'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'pocketBalance': instance.pocketBalance,
      'bankBalance': instance.bankBalance,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      actorId: json['actorId'] as String?,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      source: json['source'] as String,
      destination: json['destination'] as String,
      amount: (json['amount'] as num).toInt(),
      kind: json['kind'] as String,
      memo: json['memo'] as String?,
      idempotencyKey: json['idempotencyKey'] as String?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'actorId': instance.actorId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'source': instance.source,
      'destination': instance.destination,
      'amount': instance.amount,
      'kind': instance.kind,
      'memo': instance.memo,
      'idempotencyKey': instance.idempotencyKey,
    };

_$InterestOfferImpl _$$InterestOfferImplFromJson(Map<String, dynamic> json) =>
    _$InterestOfferImpl(
      id: (json['id'] as num).toInt(),
      playerId: json['playerId'] as String,
      forDate: json['forDate'] as String,
      bankBalanceSnapshot: (json['bankBalanceSnapshot'] as num).toInt(),
      rateBps: (json['rateBps'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      claimDeadline: DateTime.parse(json['claimDeadline'] as String),
      claimedAt: json['claimedAt'] == null
          ? null
          : DateTime.parse(json['claimedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InterestOfferImplToJson(_$InterestOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'forDate': instance.forDate,
      'bankBalanceSnapshot': instance.bankBalanceSnapshot,
      'rateBps': instance.rateBps,
      'amount': instance.amount,
      'claimDeadline': instance.claimDeadline.toIso8601String(),
      'claimedAt': instance.claimedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$LedgerEntryImpl _$$LedgerEntryImplFromJson(Map<String, dynamic> json) =>
    _$LedgerEntryImpl(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      kind: json['kind'] as String,
      amount: (json['amount'] as num).toInt(),
      delta: (json['delta'] as num).toInt(),
      source: json['source'] as String,
      destination: json['destination'] as String,
      counterpartyUsername: json['counterpartyUsername'] as String?,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$$LedgerEntryImplToJson(_$LedgerEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'kind': instance.kind,
      'amount': instance.amount,
      'delta': instance.delta,
      'source': instance.source,
      'destination': instance.destination,
      'counterpartyUsername': instance.counterpartyUsername,
      'memo': instance.memo,
    };

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
      'message': instance.message,
    };

_$BalanceResponseImpl _$$BalanceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceResponseImpl(
      pocketBalance: (json['pocketBalance'] as num).toInt(),
      bankBalance: (json['bankBalance'] as num).toInt(),
      txId: (json['txId'] as num).toInt(),
    );

Map<String, dynamic> _$$BalanceResponseImplToJson(
        _$BalanceResponseImpl instance) =>
    <String, dynamic>{
      'pocketBalance': instance.pocketBalance,
      'bankBalance': instance.bankBalance,
      'txId': instance.txId,
    };

_$TransferResponseImpl _$$TransferResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferResponseImpl(
      pocketBalance: (json['pocketBalance'] as num).toInt(),
      bankBalance: (json['bankBalance'] as num).toInt(),
      receipt:
          TransferReceipt.fromJson(json['receipt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransferResponseImplToJson(
        _$TransferResponseImpl instance) =>
    <String, dynamic>{
      'pocketBalance': instance.pocketBalance,
      'bankBalance': instance.bankBalance,
      'receipt': instance.receipt,
    };

_$TransferReceiptImpl _$$TransferReceiptImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferReceiptImpl(
      counterparty: json['counterparty'] as String,
      amount: (json['amount'] as num).toInt(),
      source: json['source'] as String,
      destination: json['destination'] as String,
    );

Map<String, dynamic> _$$TransferReceiptImplToJson(
        _$TransferReceiptImpl instance) =>
    <String, dynamic>{
      'counterparty': instance.counterparty,
      'amount': instance.amount,
      'source': instance.source,
      'destination': instance.destination,
    };

_$InterestClaimResponseImpl _$$InterestClaimResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InterestClaimResponseImpl(
      bankBalance: (json['bankBalance'] as num).toInt(),
      claimedAmount: (json['claimedAmount'] as num).toInt(),
    );

Map<String, dynamic> _$$InterestClaimResponseImplToJson(
        _$InterestClaimResponseImpl instance) =>
    <String, dynamic>{
      'bankBalance': instance.bankBalance,
      'claimedAmount': instance.claimedAmount,
    };
