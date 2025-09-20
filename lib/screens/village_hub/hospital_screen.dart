import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/info_card.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/item.dart';

class HospitalScreen extends ConsumerWidget {
  const HospitalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital'),
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
                  'Current Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      StatBar(
                        label: 'HP',
                        value: player.stats.hp,
                        maxValue: player.stats.maxHp,
                        accentColor: AppTheme.hpColor,
                      ),
                      StatBar(
                        label: 'Chakra',
                        value: player.stats.chakra,
                        maxValue: player.stats.maxChakra,
                        accentColor: AppTheme.chakraColor,
                      ),
                      StatBar(
                        label: 'Stamina',
                        value: player.stats.stamina,
                        maxValue: player.stats.maxStamina,
                        accentColor: AppTheme.staminaColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Treatment Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Rest & Recover',
                  subtitle: 'Instantly restore all HP, Chakra, and Stamina',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.staminaColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.bed,
                      color: AppTheme.staminaColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: ElevatedButton(
                    onPressed: () => _rest(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.staminaColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Rest'),
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Use Healing Item',
                  subtitle: 'Use items from your inventory',
                  leadingWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.hpColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.healing,
                      color: AppTheme.hpColor,
                      size: 24,
                    ),
                  ),
                  trailingWidget: ElevatedButton(
                    onPressed: () => _showInventory(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.hpColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Use Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _rest(BuildContext context, WidgetRef ref) {
    final player = ref.read(playerProvider);
    final newPlayer = player.copyWith(
      stats: player.stats.copyWith(
        hp: player.stats.maxHp,
        chakra: player.stats.maxChakra,
        stamina: player.stats.maxStamina,
      ),
    );
    ref.read(playerProvider.notifier).state = newPlayer;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fully rested! All stats restored!'),
        backgroundColor: AppTheme.staminaColor,
      ),
    );
  }

  void _showInventory(BuildContext context, WidgetRef ref) {
    final inventory = ref.read(inventoryProvider);
    final healingItems = inventory.where((item) => 
      item.effect.containsKey('heal') || item.effect.containsKey('chakra')).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Healing Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            if (healingItems.isEmpty)
              const Text(
                'No healing items in inventory',
                style: TextStyle(color: Colors.white70),
              )
            else
              ...healingItems.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      item.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Quantity: ${item.quantity}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _useItem(context, ref, item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Use'),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  void _useItem(BuildContext context, WidgetRef ref, item) {
    final player = ref.read(playerProvider);
    final inventory = ref.read(inventoryProvider);
    
    // Find item in inventory
    final itemIndex = inventory.indexWhere((i) => i.id == item.id);
    if (itemIndex != -1 && inventory[itemIndex].quantity > 0) {
      // Update inventory
      final updatedInventory = List<Item>.from(inventory);
      updatedInventory[itemIndex] = updatedInventory[itemIndex].copyWith(
        quantity: updatedInventory[itemIndex].quantity - 1,
      );
      ref.read(inventoryProvider.notifier).state = updatedInventory;

      // Apply healing effects
      int newHp = player.stats.hp;
      int newChakra = player.stats.chakra;
      
      if (item.effect.containsKey('heal')) {
        newHp = (player.stats.hp + (item.effect['heal'] as int)).clamp(0, player.stats.maxHp);
      }
      if (item.effect.containsKey('chakra')) {
        newChakra = (player.stats.chakra + (item.effect['chakra'] as int)).clamp(0, player.stats.maxChakra);
      }

      final newPlayer = player.copyWith(
        stats: player.stats.copyWith(
          hp: newHp,
          chakra: newChakra,
        ),
      );
      ref.read(playerProvider.notifier).state = newPlayer;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Used ${item.name}!'),
          backgroundColor: AppTheme.staminaColor,
        ),
      );
    }
  }
}
