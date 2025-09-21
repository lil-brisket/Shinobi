import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/currency_pill.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/item.dart';
import '../../utils/snackbar_utils.dart';

class ItemShopScreen extends ConsumerWidget {
  const ItemShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Shop'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CurrencyPill(
              amount: player.ryo,
              icon: Icons.monetization_on,
              color: AppTheme.ryoColor,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'kunai_pack',
                  name: 'Kunai Pack',
                  description: 'A pack of 5 kunai',
                  icon: '🗡️',
                  quantity: 1,
                  rarity: ItemRarity.common,
                  effect: {'damage': 25},
                ),
                500,
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'shuriken_pack',
                  name: 'Shuriken Pack',
                  description: 'A pack of 10 shuriken',
                  icon: '⭐',
                  quantity: 1,
                  rarity: ItemRarity.common,
                  effect: {'damage': 20},
                ),
                800,
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'health_potion_large',
                  name: 'Large Health Potion',
                  description: 'Restores 200 HP',
                  icon: '🧪',
                  quantity: 1,
                  rarity: ItemRarity.uncommon,
                  effect: {'heal': 200},
                ),
                1500,
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'chakra_pill_advanced',
                  name: 'Advanced Chakra Pill',
                  description: 'Restores 300 Chakra',
                  icon: '💊',
                  quantity: 1,
                  rarity: ItemRarity.rare,
                  effect: {'chakra': 300},
                ),
                2500,
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'ninja_scroll',
                  name: 'Ninja Scroll',
                  description: 'Contains secret techniques',
                  icon: '📜',
                  quantity: 1,
                  rarity: ItemRarity.epic,
                  effect: {'xp': 1000},
                ),
                5000,
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                ref,
                const Item(
                  id: 'legendary_weapon',
                  name: 'Legendary Kunai',
                  description: 'A weapon of legend',
                  icon: '⚔️',
                  quantity: 1,
                  rarity: ItemRarity.legendary,
                  effect: {'damage': 100},
                ),
                15000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopItem(
    BuildContext context,
    WidgetRef ref,
    Item item,
    int price,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRarityColor(item.rarity).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                item.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.rarity.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getRarityColor(item.rarity),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              CurrencyPill(
                amount: price,
                icon: Icons.monetization_on,
                color: AppTheme.ryoColor,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _buyItem(context, ref, item, price),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Buy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }

  void _buyItem(BuildContext context, WidgetRef ref, Item item, int price) {
    final player = ref.read(playerProvider);
    
    if (player.ryo >= price) {
      // Update player ryo
      final newPlayer = player.copyWith(ryo: player.ryo - price);
      ref.read(playerProvider.notifier).state = newPlayer;

      // Add item to inventory
      final inventory = ref.read(inventoryProvider);
      final existingItemIndex = inventory.indexWhere((i) => i.id == item.id);
      
      if (existingItemIndex != -1) {
        final updatedInventory = List<Item>.from(inventory);
        updatedInventory[existingItemIndex] = updatedInventory[existingItemIndex].copyWith(
          quantity: updatedInventory[existingItemIndex].quantity + item.quantity,
        );
        ref.read(inventoryProvider.notifier).state = updatedInventory;
      } else {
        ref.read(inventoryProvider.notifier).state = [...inventory, item];
      }

      SnackbarUtils.showSuccess(
        context,
        'Purchased ${item.name} for $price Ryo!',
        backgroundColor: AppTheme.staminaColor,
      );
    } else {
      SnackbarUtils.showError(
        context,
        'Not enough Ryo!',
        backgroundColor: AppTheme.hpColor,
      );
    }
  }
}
