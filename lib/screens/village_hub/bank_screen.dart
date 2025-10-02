import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../../controllers/banking_provider.dart';
import '../../models/banking.dart';

// Toast controller for managing toast state
class ToastController {
  final OverlayEntry overlayEntry;
  final AnimationController animationController;
  final ValueNotifier<String> messageNotifier;
  final ValueNotifier<Color> colorNotifier;
  Timer? _autoCloseTimer;

  ToastController({
    required this.overlayEntry,
    required this.animationController,
    required this.messageNotifier,
    required this.colorNotifier,
  });

  void updateMessage(String message) {
    messageNotifier.value = message;
  }

  void updateColor(Color color) {
    colorNotifier.value = color;
  }

  void updateMessageAndColor(String message, Color color) {
    messageNotifier.value = message;
    colorNotifier.value = color;
  }

  void close({Duration? delay}) {
    if (delay != null) {
      _autoCloseTimer?.cancel();
      _autoCloseTimer = Timer(delay, () {
        _closeNow();
      });
    } else {
      _closeNow();
    }
  }

  void _closeNow() {
    _autoCloseTimer?.cancel();
    animationController.reverse().then((_) {
      overlayEntry.remove();
      animationController.dispose();
    });
  }

  void dispose() {
    _autoCloseTimer?.cancel();
    animationController.dispose();
  }
}

class BankScreen extends ConsumerStatefulWidget {
  const BankScreen({super.key});

  @override
  ConsumerState<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends ConsumerState<BankScreen> with TickerProviderStateMixin {
  // Form controllers
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();
  final TextEditingController _transferAmountController = TextEditingController();
  final TextEditingController _transferRecipientController = TextEditingController();

  // Transfer is always bank to bank
  static const String _transferSource = 'BANK';

  // User search debounce
  Timer? _searchTimer;

  // Tab controller
  late TabController _tabController;

  // Toast helper function
  ToastController _showToast(String message, Color color, {Duration? autoClose}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    final messageNotifier = ValueNotifier<String>(message);
    final colorNotifier = ValueNotifier<Color>(color);
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -20 * (1 - animationController.value)),
              child: Opacity(
                opacity: animationController.value,
                child: Material(
                  color: Colors.transparent,
                  child: ValueListenableBuilder<String>(
                    valueListenable: messageNotifier,
                    builder: (context, message, child) {
                      return ValueListenableBuilder<Color>(
                        valueListenable: colorNotifier,
                        builder: (context, color, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    animationController.forward();

    final controller = ToastController(
      overlayEntry: overlayEntry,
      animationController: animationController,
      messageNotifier: messageNotifier,
      colorNotifier: colorNotifier,
    );

    // Auto close if specified
    if (autoClose != null) {
      controller.close(delay: autoClose);
    }

    return controller;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to update FAB visibility
    });
  }

  @override
  void dispose() {
    _depositController.dispose();
    _withdrawController.dispose();
    _transferAmountController.dispose();
    _transferRecipientController.dispose();
    _searchTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final interestOfferAsync = ref.watch(interestOfferProvider);
    final userSearchAsync = ref.watch(userSearchProvider);
    final ledgerAsync = ref.watch(ledgerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Banking', icon: Icon(Icons.account_balance)),
            Tab(text: 'Ledger', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Banking Tab
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A) Balances Section
                    _buildBalancesSection(walletAsync),
                    const SizedBox(height: 16),

                    // B) Deposit Section
                    _buildDepositSection(walletAsync),
                    const SizedBox(height: 16),

                    // C) Withdraw Section
                    _buildWithdrawSection(walletAsync),
                    const SizedBox(height: 16),

                    // D) Transfer Section
                    _buildTransferSection(walletAsync, userSearchAsync),
                    const SizedBox(height: 16),

                    // E) Interest Section
                    _buildInterestSection(interestOfferAsync),
                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
            // Ledger Tab
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildLedgerSection(ledgerAsync),
                    const SizedBox(height: 16),
                    // Only show admin ledger for admin users (mock check)
                    if (_isAdminUser()) _buildAdminLedgerSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalancesSection(AsyncValue<Wallet> walletAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Balances',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            walletAsync.when(
              data: (wallet) => Column(
                children: [
                  _buildBalanceRow(
                    'Pocket',
                    wallet.pocketBalance,
                    Icons.wallet,
                    AppTheme.ryoColor,
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceRow(
                    'Bank',
                    wallet.bankBalance,
                    Icons.account_balance,
                    AppTheme.chakraColor,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(String label, int amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  NumberFormat('#,###').format(amount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepositSection(AsyncValue<Wallet> walletAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deposit (Pocket → Bank)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _depositController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount to deposit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleDeposit(walletAsync),
                child: const Text('Deposit'),
              ),
            ),
            const SizedBox(height: 12),
            // Quick deposit all button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _quickDepositAll(walletAsync),
                icon: const Icon(Icons.account_balance_wallet, size: 16),
                label: const Text('Deposit All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawSection(AsyncValue<Wallet> walletAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw (Bank → Pocket)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _withdrawController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount to withdraw',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleWithdraw(walletAsync),
                child: const Text('Withdraw'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferSection(AsyncValue<Wallet> walletAsync, AsyncValue<List<Player>> userSearchAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Ryo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Info text about bank-to-bank transfer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.chakraColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.chakraColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.chakraColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Transfers are sent from your bank to the recipient\'s bank',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.chakraColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recipient search
            TextFormField(
              controller: _transferRecipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient Username',
                hintText: 'Search for a player',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _debounceUserSearch,
            ),
            
            // User search results
            if (userSearchAsync.hasValue && userSearchAsync.value!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: userSearchAsync.value!.map((player) => ListTile(
                    title: Text(player.username),
                    onTap: () {
                      _transferRecipientController.text = player.username;
                      ref.read(userSearchProvider.notifier).clear();
                    },
                  )).toList(),
                ),
              ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _transferAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount to transfer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleTransfer(walletAsync),
                child: const Text('Send Transfer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestSection(AsyncValue<InterestOffer?> interestOfferAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Interest',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            interestOfferAsync.when(
              data: (offer) {
                if (offer == null) {
                  return const Text('No interest offer available today');
                }

                final now = DateTime.now();
                final deadline = offer.claimDeadline;
                final isExpired = now.isAfter(deadline);
                final isClaimed = offer.claimedAt != null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${NumberFormat('#,###').format(offer.amount)} ryo'),
                    Text('Rate: ${(offer.rateBps / 100).toStringAsFixed(1)}%'),
                    const SizedBox(height: 8),
                    if (isClaimed)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Claimed at: ${DateFormat('MMM dd, yyyy HH:mm').format(offer.claimedAt!)}'),
                      )
                    else if (isExpired)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Expired'),
                      )
                    else
                      Column(
                        children: [
                          Text('Claim deadline: ${DateFormat('MMM dd, yyyy HH:mm').format(deadline)}'),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _handleClaimInterest(offer),
                              child: const Text('Claim Interest'),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerSection(AsyncValue<List<LedgerEntry>> ledgerAsync) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Ledger',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => ref.read(ledgerProvider.notifier).refresh(),
                child: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ledgerAsync.when(
              data: (ledger) => ListView.builder(
                itemCount: ledger.length,
                itemBuilder: (context, index) {
                  final entry = ledger[index];
                  return _buildLedgerEntry(entry);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerEntry(LedgerEntry entry) {
    final isPositive = entry.delta > 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.kind,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (entry.counterpartyUsername != null)
                  Text(
                    'To/From: ${entry.counterpartyUsername}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                Text(
                  '${entry.source} → ${entry.destination}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (entry.memo != null)
                  Text(
                    entry.memo!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}${NumberFormat('#,###').format(entry.delta)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                DateFormat('MMM dd, HH:mm').format(entry.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminLedgerSection() {
    // Mock admin section - in real app, check user.isAdmin
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Ledger',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text('Admin features would be available here for authorized users.'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Admin features not implemented in demo')),
                  );
                },
                child: const Text('Export CSV'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock admin check - in real app, this would check user.isAdmin
  bool _isAdminUser() {
    // For demo purposes, return false to hide admin features
    // In real implementation, this would check the user's role/permissions
    return false;
  }

  void _quickDepositAll(AsyncValue<Wallet> walletAsync) {
    walletAsync.whenData((wallet) async {
      if (wallet.pocketBalance <= 0) {
        _showToast('No ryo in pocket to deposit', Colors.red, autoClose: const Duration(seconds: 1));
        return;
      }

      // Show loading toast immediately
      final toast = _showToast('Submitting...', Colors.grey.shade800);

      try {
        await ref.read(walletProvider.notifier).deposit(wallet.pocketBalance);
        // Update toast with success message
        toast.updateMessageAndColor(
          'Deposited all ${NumberFormat('#,###').format(wallet.pocketBalance)} ryo to bank',
          AppTheme.staminaColor,
        );
        toast.close(delay: const Duration(seconds: 1));
      } catch (e) {
        // Update toast with error message
        toast.updateMessageAndColor('Deposit failed: $e', AppTheme.hpColor);
        toast.close(delay: const Duration(seconds: 1));
      }
    });
  }

  void _debounceUserSearch(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        ref.read(userSearchProvider.notifier).searchUsers(query);
      } else {
        ref.read(userSearchProvider.notifier).clear();
      }
    });
  }

  Future<void> _handleDeposit(AsyncValue<Wallet> walletAsync) async {
    final amount = int.tryParse(_depositController.text);
    if (amount == null || amount <= 0) {
      _showToast('Please enter a valid amount', Colors.red, autoClose: const Duration(seconds: 1));
      return;
    }

    walletAsync.whenData((wallet) async {
      if (amount > wallet.pocketBalance) {
        _showToast('Insufficient pocket balance', Colors.red, autoClose: const Duration(seconds: 1));
        return;
      }

      // Show loading toast immediately
      final toast = _showToast('Submitting...', Colors.grey.shade800);

      try {
        await ref.read(walletProvider.notifier).deposit(amount);
        _depositController.clear();
        // Update toast with success message
        toast.updateMessageAndColor(
          'Deposited ${NumberFormat('#,###').format(amount)} ryo to bank',
          AppTheme.staminaColor,
        );
        toast.close(delay: const Duration(seconds: 1));
      } catch (e) {
        // Update toast with error message
        toast.updateMessageAndColor('Deposit failed: $e', AppTheme.hpColor);
        toast.close(delay: const Duration(seconds: 1));
      }
    });
  }

  Future<void> _handleWithdraw(AsyncValue<Wallet> walletAsync) async {
    final amount = int.tryParse(_withdrawController.text);
    if (amount == null || amount <= 0) {
      _showToast('Please enter a valid amount', Colors.red, autoClose: const Duration(seconds: 1));
      return;
    }

    walletAsync.whenData((wallet) async {
      if (amount > wallet.bankBalance) {
        _showToast('Insufficient bank balance', Colors.red, autoClose: const Duration(seconds: 1));
        return;
      }

      // Show loading toast immediately
      final toast = _showToast('Submitting...', Colors.grey.shade800);

      try {
        await ref.read(walletProvider.notifier).withdraw(amount);
        _withdrawController.clear();
        // Update toast with success message
        toast.updateMessageAndColor(
          'Withdrew ${NumberFormat('#,###').format(amount)} ryo from bank',
          AppTheme.staminaColor,
        );
        toast.close(delay: const Duration(seconds: 1));
      } catch (e) {
        // Update toast with error message
        toast.updateMessageAndColor('Withdraw failed: $e', AppTheme.hpColor);
        toast.close(delay: const Duration(seconds: 1));
      }
    });
  }

  Future<void> _handleTransfer(AsyncValue<Wallet> walletAsync) async {
    final amount = int.tryParse(_transferAmountController.text);
    final recipient = _transferRecipientController.text.trim();

    if (amount == null || amount <= 0) {
      _showToast('Please enter a valid amount', Colors.red, autoClose: const Duration(seconds: 1));
      return;
    }

    if (recipient.isEmpty) {
      _showToast('Please enter a recipient username', Colors.red, autoClose: const Duration(seconds: 1));
      return;
    }

    if (amount < 10) {
      _showToast('Minimum transfer amount is 10 ryo', Colors.red, autoClose: const Duration(seconds: 1));
      return;
    }

    walletAsync.whenData((wallet) async {
      if (amount > wallet.bankBalance) {
        _showToast('Insufficient bank balance', Colors.red, autoClose: const Duration(seconds: 1));
        return;
      }

      // Show loading toast immediately
      final toast = _showToast('Submitting...', Colors.grey.shade800);

      try {
        await ref.read(walletProvider.notifier).transfer(
          source: _transferSource,
          toUsername: recipient,
          amount: amount,
        );
        _transferAmountController.clear();
        _transferRecipientController.clear();
        // Update toast with success message
        toast.updateMessageAndColor(
          'Transferred ${NumberFormat('#,###').format(amount)} ryo to $recipient',
          AppTheme.staminaColor,
        );
        toast.close(delay: const Duration(seconds: 1));
      } catch (e) {
        // Update toast with error message
        toast.updateMessageAndColor('Transfer failed: $e', AppTheme.hpColor);
        toast.close(delay: const Duration(seconds: 1));
      }
    });
  }

  Future<void> _handleClaimInterest(InterestOffer offer) async {
    // Show loading toast immediately
    final toast = _showToast('Submitting...', Colors.grey.shade800);

    try {
      final result = await ref.read(bankingServiceProvider).claimInterest(offerId: offer.id);
      ref.invalidate(interestOfferProvider);
      ref.invalidate(walletProvider);
      // Update toast with success message
      toast.updateMessageAndColor(
        'Claimed ${NumberFormat('#,###').format(result.claimedAmount)} ryo interest',
        AppTheme.staminaColor,
      );
      toast.close(delay: const Duration(seconds: 1));
    } catch (e) {
      // Update toast with error message
      toast.updateMessageAndColor('Interest claim failed: $e', AppTheme.hpColor);
      toast.close(delay: const Duration(seconds: 1));
    }
  }

}
