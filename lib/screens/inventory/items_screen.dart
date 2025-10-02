import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../models/item.dart';
import '../../models/equipment.dart';
import '../../models/stats.dart';
import '../../app/theme.dart';
import '../../utils/snackbar_utils.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  // ----------------- THEME COLORS -----------------
  final _panel = const Color(0xFF101826);
  final _panelDark = const Color(0xFF0B111B);
  final _textDim = const Color(0xFF9AA4B2);

  // Rarity colors matching the existing system
  final Map<ItemRarity, Color> _rarityColors = const {
    ItemRarity.common: Color(0xFF2C3A4B),
    ItemRarity.uncommon: Color(0xFF1E5F43),
    ItemRarity.rare: Color(0xFF1B4D7A),
    ItemRarity.epic: Color(0xFF4B2C66),
    ItemRarity.legendary: Color(0xFF6E4B1B),
  };

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(inventoryProvider);
    final consumables = inventory.where((item) => 
      item.kind == ItemKind.consumable && item.quantity > 0
    ).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: Column(
        children: [
          // DIVIDER
          const SizedBox(height: 16),
          _DividerBar(label: 'Consumables'),

          // CONSUMABLES SECTION
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: .05)),
              ),
              child: _ConsumablesGrid(
                items: consumables,
                rarityColors: _rarityColors,
                textDim: _textDim,
                onInspect: _inspect,
                onUse: _useConsumable,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _inspect(Item item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _panelDark,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ItemRow(icon: item.icon, name: item.name),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  backgroundColor: _rarityColors[item.rarity]!.withValues(alpha: .25),
                  side: BorderSide(color: _rarityColors[item.rarity]!.withValues(alpha: .6)),
                  label: Text(
                    item.rarity.name.toUpperCase(),
                    style: const TextStyle(letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Qty: ${item.quantity}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Use this item from your consumables.',
              style: TextStyle(color: _textDim),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _useConsumable(item),
              child: const Text('Use'),
            ),
          ],
        ),
      ),
    );
  }

  void _useConsumable(Item item) {
    Navigator.of(context).pop();
    
    final player = ref.read(playerProvider);
    final inventory = ref.read(inventoryProvider);
    
    final itemIndex = inventory.indexWhere((i) => i.id == item.id);
    if (itemIndex != -1 && inventory[itemIndex].quantity > 0) {
      final updatedInventory = List<Item>.from(inventory);
      final currentItem = updatedInventory[itemIndex];
      final newQty = currentItem.quantity - 1;
      
      if (newQty <= 0) {
        updatedInventory.removeAt(itemIndex);
      } else {
        updatedInventory[itemIndex] = currentItem.copyWith(quantity: newQty);
      }
      
      ref.read(inventoryProvider.notifier).state = updatedInventory;

      // Apply item effects
      var newStats = player.stats;
      
      if (item.effect.containsKey('heal')) {
        newStats = newStats.healHP(item.effect['heal'] as int);
      }
      if (item.effect.containsKey('chakra')) {
        newStats = newStats.restoreCP(item.effect['chakra'] as int);
      }
      if (item.effect.containsKey('stamina')) {
        newStats = newStats.restoreSP(item.effect['stamina'] as int);
      }

      final newPlayer = player.copyWith(stats: newStats);
      ref.read(playerProvider.notifier).updatePlayer(newPlayer);

      SnackbarUtils.showSuccess(
        context,
        '${item.name} used',
        backgroundColor: AppTheme.staminaColor,
      );
    }
  }
}

// ----------------- WIDGETS -----------------

class _DividerBar extends StatelessWidget {
  final String label;
  const _DividerBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        const Expanded(child: Divider(height: 24, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(label,
              style:
                  Theme.of(context).textTheme.labelLarge?.copyWith(height: 1)),
        ),
        const Expanded(child: Divider(height: 24, thickness: 1)),
      ]),
    );
  }
}

class _ConsumablesGrid extends StatelessWidget {
  final List<Item> items;
  final Map<ItemRarity, Color> rarityColors;
  final Color textDim;
  final void Function(Item) onInspect;
  final void Function(Item) onUse;

  const _ConsumablesGrid({
    required this.items,
    required this.rarityColors,
    required this.textDim,
    required this.onInspect,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: textDim,
            ),
            const SizedBox(height: 16),
            Text(
              'No consumables available',
              style: TextStyle(
                color: textDim,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final base = rarityColors[it.rarity]!;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onUse(it),
          onLongPress: () => onInspect(it),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  base.withValues(alpha: .25),
                  base.withValues(alpha: .12),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: .06)),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2332),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .35),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: _ItemIcon(it.icon, size: 36),
                    ),
                    Positioned(
                      right: -4,
                      top: -6,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .65),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: .12)),
                        ),
                        child: Text(
                          '×${it.quantity}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  it.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  it.rarity.name.toUpperCase(),
                  style:
                      TextStyle(fontSize: 11, color: textDim, letterSpacing: .5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ItemIcon extends StatelessWidget {
  final String asset;
  final double size;
  const _ItemIcon(this.asset, {this.size = 28});

  @override
  Widget build(BuildContext context) {
    // Check if it's an emoji or asset path
    if (asset.length <= 4 && !asset.contains('/')) {
      // Treat as emoji
      return Text(
        asset,
        style: TextStyle(fontSize: size),
      );
    }
    
    // Treat as asset path
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(Icons.inventory_2_outlined, size: size),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String icon;
  final String name;
  const _ItemRow({required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ItemIcon(icon, size: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}