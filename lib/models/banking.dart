import 'package:freezed_annotation/freezed_annotation.dart';

part 'banking.freezed.dart';
part 'banking.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required String playerId,
    required int pocketBalance,
    required int bankBalance,
    required DateTime updatedAt,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required DateTime createdAt,
    String? actorId,
    String? senderId,
    String? receiverId,
    required String source,
    required String destination,
    required int amount,
    required String kind,
    String? memo,
    String? idempotencyKey,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@freezed
class InterestOffer with _$InterestOffer {
  const factory InterestOffer({
    required int id,
    required String playerId,
    required String forDate,
    required int bankBalanceSnapshot,
    required int rateBps,
    required int amount,
    required DateTime claimDeadline,
    DateTime? claimedAt,
    required DateTime createdAt,
  }) = _InterestOffer;

  factory InterestOffer.fromJson(Map<String, dynamic> json) => _$InterestOfferFromJson(json);
}

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String username,
    required DateTime createdAt,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

@freezed
class LedgerEntry with _$LedgerEntry {
  const factory LedgerEntry({
    required int id,
    required DateTime createdAt,
    required String kind,
    required int amount,
    required int delta,
    required String source,
    required String destination,
    String? counterpartyUsername,
    String? memo,
  }) = _LedgerEntry;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => _$LedgerEntryFromJson(json);
}

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required bool success,
    Map<String, dynamic>? data,
    String? error,
    String? message,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
}

@freezed
class BalanceResponse with _$BalanceResponse {
  const factory BalanceResponse({
    required int pocketBalance,
    required int bankBalance,
    required int txId,
  }) = _BalanceResponse;

  factory BalanceResponse.fromJson(Map<String, dynamic> json) => _$BalanceResponseFromJson(json);
}

@freezed
class TransferResponse with _$TransferResponse {
  const factory TransferResponse({
    required int pocketBalance,
    required int bankBalance,
    required TransferReceipt receipt,
  }) = _TransferResponse;

  factory TransferResponse.fromJson(Map<String, dynamic> json) => _$TransferResponseFromJson(json);
}

@freezed
class TransferReceipt with _$TransferReceipt {
  const factory TransferReceipt({
    required String counterparty,
    required int amount,
    required String source,
    required String destination,
  }) = _TransferReceipt;

  factory TransferReceipt.fromJson(Map<String, dynamic> json) => _$TransferReceiptFromJson(json);
}

@freezed
class InterestClaimResponse with _$InterestClaimResponse {
  const factory InterestClaimResponse({
    required int bankBalance,
    required int claimedAmount,
  }) = _InterestClaimResponse;

  factory InterestClaimResponse.fromJson(Map<String, dynamic> json) => _$InterestClaimResponseFromJson(json);
}
