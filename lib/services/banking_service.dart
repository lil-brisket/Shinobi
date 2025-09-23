import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/banking.dart';

class BankingService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String authToken = 'player-token'; // Mock token
  
  final http.Client _client = http.Client();
  final Uuid _uuid = const Uuid();
  
  // Mock state to persist balances across operations
  static int _mockPocketBalance = 5000;
  static int _mockBankBalance = 25000;
  static final List<LedgerEntry> _mockLedger = [];

  // Helper method to make authenticated requests
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['error'] ?? 'Request failed');
    }
  }

  // Get wallet balances
  Future<Wallet> getWallet() async {
    try {
      // Try to call the real API first
      final response = await _makeRequest('GET', '/wallet');
      return Wallet.fromJson(response['data']);
    } catch (e) {
      // Fallback to mock data if API is not available
      print('API not available, using mock data: $e');
      return Wallet(
        playerId: 'player-123',
        pocketBalance: _mockPocketBalance,
        bankBalance: _mockBankBalance,
        updatedAt: DateTime.now(),
      );
    }
  }

  // Deposit from pocket to bank
  Future<BalanceResponse> deposit({
    required int amount,
  }) async {
    try {
      final response = await _makeRequest('POST', '/deposit', body: {
        'amount': amount,
        'idempotencyKey': _uuid.v4(),
      });
      return BalanceResponse.fromJson(response['data']);
    } catch (e) {
      // Mock successful deposit - update persistent state
      _mockPocketBalance -= amount;
      _mockBankBalance += amount;
      
      // Add to ledger
      _mockLedger.insert(0, LedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now(),
        kind: 'DEPOSIT',
        amount: amount,
        delta: -amount,
        source: 'POCKET',
        destination: 'BANK',
        memo: null,
      ));
      
      // Match notification timing (0.7 seconds)
      await Future.delayed(const Duration(milliseconds: 700));
      
      return BalanceResponse(
        pocketBalance: _mockPocketBalance,
        bankBalance: _mockBankBalance,
        txId: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  // Withdraw from bank to pocket
  Future<BalanceResponse> withdraw({
    required int amount,
  }) async {
    try {
      final response = await _makeRequest('POST', '/withdraw', body: {
        'amount': amount,
        'idempotencyKey': _uuid.v4(),
      });
      return BalanceResponse.fromJson(response['data']);
    } catch (e) {
      // Mock successful withdraw - update persistent state
      _mockPocketBalance += amount;
      _mockBankBalance -= amount;
      
      // Add to ledger
      _mockLedger.insert(0, LedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now(),
        kind: 'WITHDRAW',
        amount: amount,
        delta: amount,
        source: 'BANK',
        destination: 'POCKET',
        memo: null,
      ));
      
      // Match notification timing (0.7 seconds)
      await Future.delayed(const Duration(milliseconds: 700));
      
      return BalanceResponse(
        pocketBalance: _mockPocketBalance,
        bankBalance: _mockBankBalance,
        txId: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  // Search users by username
  Future<List<Player>> searchUsers(String query) async {
    try {
      final response = await _makeRequest('GET', '/users/search', queryParams: {
        'q': query,
      });
      final List<dynamic> usersJson = response['data'];
      return usersJson.map((json) => Player.fromJson(json)).toList();
    } catch (e) {
      // Mock user search results
      print('API not available, using mock user search: $e');
      return [
        Player(id: '1', username: 'testuser1', createdAt: DateTime.now()),
        Player(id: '2', username: 'testuser2', createdAt: DateTime.now()),
        Player(id: '3', username: 'testuser3', createdAt: DateTime.now()),
      ].where((player) => player.username.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  // Transfer to another player
  Future<TransferResponse> transfer({
    required String source,
    required String toUsername,
    required int amount,
  }) async {
    try {
      final response = await _makeRequest('POST', '/transfer', body: {
        'source': source,
        'toUsername': toUsername,
        'amount': amount,
        'idempotencyKey': _uuid.v4(),
      });
      return TransferResponse.fromJson(response['data']);
    } catch (e) {
      // Mock successful transfer - update persistent state (always bank to bank)
      _mockBankBalance -= amount;
      
      // Add to ledger
      _mockLedger.insert(0, LedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now(),
        kind: 'TRANSFER_SEND',
        amount: amount,
        delta: -amount,
        source: 'BANK',
        destination: 'BANK',
        counterpartyUsername: toUsername,
        memo: null,
      ));
      
      // Match notification timing (0.7 seconds)
      await Future.delayed(const Duration(milliseconds: 700));
      
      return TransferResponse(
        pocketBalance: _mockPocketBalance, // Pocket balance unchanged
        bankBalance: _mockBankBalance,     // Bank balance reduced by transfer amount
        receipt: TransferReceipt(
          counterparty: toUsername,
          amount: amount,
          source: 'BANK',
          destination: 'BANK',
        ),
      );
    }
  }

  // Get today's interest offer
  Future<InterestOffer?> getTodaysInterestOffer() async {
    try {
      final response = await _makeRequest('GET', '/interest/offer');
      final data = response['data'];
      return data != null ? InterestOffer.fromJson(data) : null;
    } catch (e) {
      return null;
    }
  }

  // Claim interest
  Future<InterestClaimResponse> claimInterest({
    required int offerId,
  }) async {
    final response = await _makeRequest('POST', '/interest/claim', body: {
      'offerId': offerId,
      'idempotencyKey': _uuid.v4(),
    });

    return InterestClaimResponse.fromJson(response['data']);
  }

  // Get player ledger
  Future<List<LedgerEntry>> getPlayerLedger({
    int limit = 50,
    String? cursor,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (cursor != null) {
        queryParams['cursor'] = cursor;
      }

      final response = await _makeRequest('GET', '/ledger', queryParams: queryParams);
      final List<dynamic> ledgerJson = response['data'];
      return ledgerJson.map((json) => LedgerEntry.fromJson(json)).toList();
    } catch (e) {
      // Return mock ledger data (includes both static and dynamic entries)
      print('API not available, using mock ledger: $e');
      
      // Combine static mock data with dynamic entries
      final staticEntries = [
        LedgerEntry(
          id: 1,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          kind: 'INTEREST_CLAIM',
          amount: 250,
          delta: 250,
          source: 'BANK',
          destination: 'BANK',
          memo: null,
        ),
      ];
      
      // Return dynamic entries first (most recent), then static ones
      return [..._mockLedger, ...staticEntries];
    }
  }

  // Get admin ledger (mock implementation)
  Future<List<LedgerEntry>> getAdminLedger({
    String? sender,
    String? receiver,
    String? from,
    String? to,
    String? kind,
    int? min,
    int? max,
    int limit = 100,
    String? cursor,
  }) async {
    // Mock implementation - in real app, this would call the admin API
    return [];
  }

  void dispose() {
    _client.close();
  }
}
