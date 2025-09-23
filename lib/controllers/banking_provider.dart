import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/banking.dart';
import '../services/banking_service.dart';

// Banking service provider
final bankingServiceProvider = Provider<BankingService>((ref) {
  final service = BankingService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Wallet state provider
final walletProvider = StateNotifierProvider<WalletNotifier, AsyncValue<Wallet>>((ref) {
  final bankingService = ref.watch(bankingServiceProvider);
  return WalletNotifier(bankingService, ref);
});

class WalletNotifier extends StateNotifier<AsyncValue<Wallet>> {
  final BankingService _bankingService;
  final Ref _ref;

  WalletNotifier(this._bankingService, this._ref) : super(const AsyncValue.loading()) {
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    try {
      final wallet = await _bankingService.getWallet();
      state = AsyncValue.data(wallet);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadWallet();
  }

  void _refreshLedger() {
    // Refresh the ledger after operations
    _ref.read(ledgerProvider.notifier).refresh();
  }

  Future<void> deposit(int amount) async {
    // Optimistically update the UI immediately
    state.whenData((wallet) {
      if (wallet.pocketBalance >= amount) {
        state = AsyncValue.data(wallet.copyWith(
          pocketBalance: wallet.pocketBalance - amount,
          bankBalance: wallet.bankBalance + amount,
        ));
      }
    });

    // Handle API call in background
    try {
      final result = await _bankingService.deposit(amount: amount);
      // Update with actual server response
      state.whenData((wallet) {
        state = AsyncValue.data(wallet.copyWith(
          pocketBalance: result.pocketBalance,
          bankBalance: result.bankBalance,
        ));
      });
    } catch (error, stackTrace) {
      // Don't revert - the service handles persistent state
      // Just update with the service's current state
      final wallet = await _bankingService.getWallet();
      state = AsyncValue.data(wallet);
    }
    
    // Refresh ledger to show new transaction
    _refreshLedger();
  }

  Future<void> withdraw(int amount) async {
    // Optimistically update the UI immediately
    state.whenData((wallet) {
      if (wallet.bankBalance >= amount) {
        state = AsyncValue.data(wallet.copyWith(
          pocketBalance: wallet.pocketBalance + amount,
          bankBalance: wallet.bankBalance - amount,
        ));
      }
    });

    // Handle API call in background
    try {
      final result = await _bankingService.withdraw(amount: amount);
      // Update with actual server response
      state.whenData((wallet) {
        state = AsyncValue.data(wallet.copyWith(
          pocketBalance: result.pocketBalance,
          bankBalance: result.bankBalance,
        ));
      });
    } catch (error, stackTrace) {
      // Don't revert - the service handles persistent state
      // Just update with the service's current state
      final wallet = await _bankingService.getWallet();
      state = AsyncValue.data(wallet);
    }
    
    // Refresh ledger to show new transaction
    _refreshLedger();
  }

  Future<void> transfer({
    required String source,
    required String toUsername,
    required int amount,
  }) async {
    // Optimistically update the UI immediately (always from bank)
    state.whenData((wallet) {
      if (wallet.bankBalance >= amount) {
        state = AsyncValue.data(wallet.copyWith(
          bankBalance: wallet.bankBalance - amount,
        ));
      }
    });

    // Handle API call in background
    try {
      final result = await _bankingService.transfer(
        source: source,
        toUsername: toUsername,
        amount: amount,
      );
      // Update with actual server response
      state.whenData((wallet) {
        state = AsyncValue.data(wallet.copyWith(
          pocketBalance: result.pocketBalance,
          bankBalance: result.bankBalance,
        ));
      });
    } catch (error, stackTrace) {
      // Don't revert - the service handles persistent state
      // Just update with the service's current state
      final wallet = await _bankingService.getWallet();
      state = AsyncValue.data(wallet);
    }
    
    // Refresh ledger to show new transaction
    _refreshLedger();
  }
}

// Interest offer provider
final interestOfferProvider = FutureProvider<InterestOffer?>((ref) async {
  final bankingService = ref.watch(bankingServiceProvider);
  return await bankingService.getTodaysInterestOffer();
});

// User search provider
final userSearchProvider = StateNotifierProvider<UserSearchNotifier, AsyncValue<List<Player>>>((ref) {
  final bankingService = ref.watch(bankingServiceProvider);
  return UserSearchNotifier(bankingService);
});

class UserSearchNotifier extends StateNotifier<AsyncValue<List<Player>>> {
  final BankingService _bankingService;

  UserSearchNotifier(this._bankingService) : super(const AsyncValue.data([]));

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final users = await _bankingService.searchUsers(query);
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

// Ledger provider
final ledgerProvider = StateNotifierProvider<LedgerNotifier, AsyncValue<List<LedgerEntry>>>((ref) {
  final bankingService = ref.watch(bankingServiceProvider);
  return LedgerNotifier(bankingService);
});

class LedgerNotifier extends StateNotifier<AsyncValue<List<LedgerEntry>>> {
  final BankingService _bankingService;

  LedgerNotifier(this._bankingService) : super(const AsyncValue.loading()) {
    _loadLedger();
  }

  Future<void> _loadLedger() async {
    try {
      final ledger = await _bankingService.getPlayerLedger();
      state = AsyncValue.data(ledger);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadLedger();
  }
}
