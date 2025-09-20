import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/currency_pill.dart';
import '../../widgets/info_card.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';

class BankScreen extends ConsumerStatefulWidget {
  const BankScreen({super.key});

  @override
  ConsumerState<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends ConsumerState<BankScreen> {
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();
  int _bankBalance = 50000; // Mock bank balance

  @override
  void dispose() {
    _depositController.dispose();
    _withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Balance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Bank Account',
                  subtitle: 'Secure storage for your Ryo',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.ryoColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: AppTheme.ryoColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: CurrencyPill(
                    amount: _bankBalance,
                    icon: Icons.monetization_on,
                    color: AppTheme.ryoColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Wallet Balance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Pocket Money',
                  subtitle: 'Ryo you carry with you',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.ryoColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.wallet,
                      color: AppTheme.ryoColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: CurrencyPill(
                    amount: player.ryo,
                    icon: Icons.monetization_on,
                    color: AppTheme.ryoColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bank Operations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildTransactionCard(
                        context,
                        'Deposit',
                        'Move Ryo from wallet to bank',
                        Icons.arrow_upward,
                        AppTheme.staminaColor,
                        _depositController,
                        () => _deposit(player.ryo),
                      ),
                      const SizedBox(height: 12),
                      _buildTransactionCard(
                        context,
                        'Withdraw',
                        'Move Ryo from bank to wallet',
                        Icons.arrow_downward,
                        AppTheme.hpColor,
                        _withdrawController,
                        () => _withdraw(_bankBalance),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    TextEditingController controller,
    VoidCallback onConfirm,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter amount',
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(title),
            ),
          ),
        ],
      ),
    );
  }

  void _deposit(int maxAmount) {
    final amount = int.tryParse(_depositController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    if (amount > maxAmount) {
      _showError('Not enough Ryo in wallet');
      return;
    }

    final player = ref.read(playerProvider);
    final newPlayer = player.copyWith(ryo: player.ryo - amount);
    ref.read(playerProvider.notifier).state = newPlayer;
    
    setState(() {
      _bankBalance += amount;
    });
    
    _depositController.clear();
    _showSuccess('Deposited $amount Ryo to bank');
  }

  void _withdraw(int maxAmount) {
    final amount = int.tryParse(_withdrawController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    if (amount > maxAmount) {
      _showError('Not enough Ryo in bank');
      return;
    }

    final player = ref.read(playerProvider);
    final newPlayer = player.copyWith(ryo: player.ryo + amount);
    ref.read(playerProvider.notifier).state = newPlayer;
    
    setState(() {
      _bankBalance -= amount;
    });
    
    _withdrawController.clear();
    _showSuccess('Withdrew $amount Ryo from bank');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.hpColor,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }
}
