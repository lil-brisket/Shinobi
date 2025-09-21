import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/equipment_provider.dart';
import '../controllers/providers.dart';
import '../models/equipment.dart';
import '../models/item.dart';
import '../models/stats.dart';
import '../app/theme.dart';
import '../utils/snackbar_utils.dart';

class HumanEquipmentLayout extends ConsumerWidget {
  const HumanEquipmentLayout({super.key});

  // Theme colors
  final _glow = const Color(0xFF7C5CFF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipment = ref.watch(equipmentProvider);
    final inventory = ref.watch(inventoryProvider);

    return Column(
      children: [
        // Title
        Container(
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Icon(Icons.shield_moon_outlined, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Equipped',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // EQUIPPED PANEL
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          constraints: const BoxConstraints(minHeight: 420),
          decoration: BoxDecoration(
            color: const Color(0xFF101826),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),
          child: _Silhouette(
            glow: _glow,
            equipped: _getEquippedMap(equipment),
            onClear: (slot) => ref.read(equipmentProvider.notifier).unequip(slot),
            onTapSlot: (slot) => _showSlotPopup(context, ref, slot, _getSlotName(slot), _getEquippableItems(inventory, slot), _getEquippedItem(equipment, slot)),
            scale: 0.95,
          ),
        ),
      ],
    );
  }

  Widget _buildHumanShape(BuildContext context, WidgetRef ref, EquipmentState equipment, List<Item> inventory) {
    return Column(
      children: [
        // Title with improved styling
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_moon_outlined,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Equipped',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // EQUIPPED PANEL
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          constraints: const BoxConstraints(minHeight: 420), // <- more room
          decoration: BoxDecoration(
            color: const Color(0xFF101826),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),
          child: _Silhouette(
            glow: _glow,
            equipped: _getEquippedMap(equipment),
            onClear: (slot) => ref.read(equipmentProvider.notifier).unequip(slot),
            onTapSlot: (slot) => _showSlotPopup(context, ref, slot, _getSlotName(slot), _getEquippableItems(inventory, slot), _getEquippedItem(equipment, slot)),
            scale: 0.95, // use most of the available height
          ),
        ),
      ],
    );
  }

  Widget _slotButton(BuildContext context, WidgetRef ref, {
    required SlotType slot,
    required double left,
    required double top,
    bool alignCenter = false,
    required EquipmentState equipment,
    required List<Item> inventory,
  }) {
    Item? item;
    switch (slot) {
      case SlotType.head:
        item = equipment.head;
        break;
      case SlotType.body:
        item = equipment.body;
        break;
      case SlotType.waist:
        item = equipment.waist;
        break;
      case SlotType.legs:
        item = equipment.legs;
        break;
      case SlotType.feet:
        item = equipment.feet;
        break;
      case SlotType.armLeft:
        item = equipment.armLeft;
        break;
      case SlotType.armRight:
        item = equipment.armRight;
        break;
    }

    final hasItem = item != null;
    final label = {
      SlotType.head: 'Head',
      SlotType.body: 'Body',
      SlotType.waist: 'Waist',
      SlotType.legs: 'Legs',
      SlotType.feet: 'Feet',
      SlotType.armLeft: 'Left',
      SlotType.armRight: 'Right',
    }[slot]!;

    final icon = {
      SlotType.head: Icons.face_retouching_natural_outlined,
      SlotType.body: Icons.checkroom_outlined,
      SlotType.waist: Icons.fitness_center_outlined,
      SlotType.legs: Icons.directions_walk_outlined,
      SlotType.feet: Icons.hiking_outlined,
      SlotType.armLeft: Icons.pan_tool_outlined,
      SlotType.armRight: Icons.pan_tool_outlined,
    }[slot]!;

    final equippableItems = inventory.where((i) => 
      i.isEquippable && i.equip!.allowedSlots.contains(slot)
    ).toList();

    final btn = GestureDetector(
      onTap: () => _showSlotPopup(context, ref, slot, label, equippableItems, item),
      onLongPress: hasItem ? () {
        ref.read(equipmentProvider.notifier).unequip(slot);
        SnackbarUtils.showInfo(context, 'Unequipped ${item!.name}');
      } : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2332),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasItem
                    ? Colors.white.withOpacity(.18)
                    : Colors.white.withOpacity(.08),
              ),
              boxShadow: [
                if (hasItem)
                  BoxShadow(
                    color: Colors.white.withOpacity(.06),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(.25),
                  blurRadius: 18,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: hasItem
                ? _ItemIcon(item!.icon, size: 36)
                : Icon(
                    icon,
                    size: 28,
                    color: Colors.white.withOpacity(.6),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );

    return Positioned(
      left: alignCenter ? null : null,
      right: null,
      top: null,
      bottom: null,
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5),
        child: Align(
          alignment: Alignment(top * 2 - 1, left * 2 - 1),
          child: btn,
        ),
      ),
    );
  }

  Widget _buildConsumablesList(BuildContext context, WidgetRef ref, List<Item> inventory) {
    final consumables = inventory.where((item) => 
      item.kind == ItemKind.consumable && item.quantity > 0
    ).toList();

    if (consumables.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No consumables available',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: consumables.length,
      itemBuilder: (context, index) {
        final item = consumables[index];
        return _buildConsumableCard(context, ref, item);
      },
    );
  }

  Widget _buildConsumableCard(BuildContext context, WidgetRef ref, Item item) {
    return GestureDetector(
      onTap: () => _showItemDetails(context, ref, item),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getRarityColor(item.rarity).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '×${item.quantity}',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlotPopup(BuildContext context, WidgetRef ref, SlotType slotType, String slotName, List<Item> equippableItems, Item? currentItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.checkroom,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$slotName Slot',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (currentItem != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currently Equipped:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          currentItem.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentItem.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                currentItem.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(equipmentProvider.notifier).unequip(slotType);
                            Navigator.pop(context);
                            SnackbarUtils.showInfo(
                              context,
                              'Unequipped ${currentItem.name}',
                            );
                          },
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (equippableItems.isNotEmpty) ...[
              Text(
                'Available Items:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...equippableItems.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        item.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    item.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ref.read(equipmentProvider.notifier).equip(item, preferredSlot: slotType);
                      Navigator.pop(context);
                      SnackbarUtils.showSuccess(
                        context,
                        'Equipped ${item.name}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text('Equip'),
                  ),
                ),
              )),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No items available for this slot',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, WidgetRef ref, Item item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${item.rarity.name.toUpperCase()} ITEM',
                          style: TextStyle(
                            color: _getRarityColor(item.rarity),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Effects',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ...item.effect.entries.map((entry) => Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '${entry.key}: ',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _useItem(context, ref, item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.staminaColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Use'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _useItem(BuildContext context, WidgetRef ref, Item item) {
    final player = ref.read(playerProvider);
    final inventory = ref.read(inventoryProvider);
    
    final itemIndex = inventory.indexWhere((i) => i.id == item.id);
    if (itemIndex != -1 && inventory[itemIndex].quantity > 0) {
      final updatedInventory = List<Item>.from(inventory);
      updatedInventory[itemIndex] = updatedInventory[itemIndex].copyWith(
        quantity: updatedInventory[itemIndex].quantity - 1,
      );
      ref.read(inventoryProvider.notifier).state = updatedInventory;

      PlayerStats newStats = player.stats;
      
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
        'Used ${item.name}!',
        backgroundColor: AppTheme.staminaColor,
      );
    }
  }

  Widget _buildAccessorySlot(BuildContext context, WidgetRef ref, List<Item> inventory) {
    // Placeholder for accessory items
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.white54,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            'Accessory',
            style: const TextStyle(
              fontSize: 8,
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
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

  // Helper methods for the _Silhouette widget
  Map<SlotType, Item?> _getEquippedMap(EquipmentState equipment) {
    return {
      SlotType.head: equipment.head,
      SlotType.body: equipment.body,
      SlotType.waist: equipment.waist,
      SlotType.legs: equipment.legs,
      SlotType.feet: equipment.feet,
      SlotType.armLeft: equipment.armLeft,
      SlotType.armRight: equipment.armRight,
    };
  }

  String _getSlotName(SlotType slot) {
    switch (slot) {
      case SlotType.head: return 'Head';
      case SlotType.body: return 'Body';
      case SlotType.waist: return 'Waist';
      case SlotType.legs: return 'Legs';
      case SlotType.feet: return 'Feet';
      case SlotType.armLeft: return 'Left Arm';
      case SlotType.armRight: return 'Right Arm';
    }
  }

  List<Item> _getEquippableItems(List<Item> inventory, SlotType slot) {
    return inventory.where((i) => 
      i.isEquippable && i.equip!.allowedSlots.contains(slot)
    ).toList();
  }

  Item? _getEquippedItem(EquipmentState equipment, SlotType slot) {
    switch (slot) {
      case SlotType.head: return equipment.head;
      case SlotType.body: return equipment.body;
      case SlotType.waist: return equipment.waist;
      case SlotType.legs: return equipment.legs;
      case SlotType.feet: return equipment.feet;
      case SlotType.armLeft: return equipment.armLeft;
      case SlotType.armRight: return equipment.armRight;
    }
  }
}

class _Silhouette extends StatelessWidget {
  final Color glow;
  final Map<SlotType, Item?> equipped;
  final void Function(SlotType) onClear;
  final void Function(SlotType) onTapSlot;
  final double scale;

  const _Silhouette({
    required this.glow,
    required this.equipped,
    required this.onClear,
    required this.onTapSlot,
    this.scale = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Stack(
        children: [
          // Simple human silhouette using basic shapes
          Center(
            child: Container(
              width: 150,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Head
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Body
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Legs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 25,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Equipment slots - simple positioned containers
          Positioned(
            top: 50,
            left: 100,
            child: _buildSlotButton('Head', equipped[SlotType.head]),
          ),
          Positioned(
            top: 150,
            left: 100,
            child: _buildSlotButton('Body', equipped[SlotType.body]),
          ),
          Positioned(
            top: 250,
            left: 100,
            child: _buildSlotButton('Legs', equipped[SlotType.legs]),
          ),
          Positioned(
            top: 320,
            left: 100,
            child: _buildSlotButton('Feet', equipped[SlotType.feet]),
          ),
          Positioned(
            top: 150,
            left: 50,
            child: _buildSlotButton('L Arm', equipped[SlotType.armLeft]),
          ),
          Positioned(
            top: 150,
            left: 150,
            child: _buildSlotButton('R Arm', equipped[SlotType.armRight]),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotButton(String label, Item? item) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1B2332),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item != null ? Icons.check : Icons.add,
            color: item != null ? Colors.green : Colors.white54,
            size: 20,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotButton extends StatelessWidget {
  final Color glow;
  final Item? item;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _SlotButton({
    required this.glow,
    required this.item,
    required this.label,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onClear,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2332),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: item == null ? Colors.white.withOpacity(.08)
                                    : Colors.white.withOpacity(.18),
              ),
              boxShadow: [
                if (item != null)
                  BoxShadow(
                    color: Colors.white.withOpacity(.06),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                BoxShadow(color: glow.withOpacity(.22), blurRadius: 18),
              ],
            ),
            alignment: Alignment.center,
            child: item == null
                ? Icon(Icons.inventory_2_outlined,
                    size: 26, color: Colors.white.withOpacity(.6))
                : _ItemIcon(item!.icon, size: 36),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.white70)),
        ],
      ),
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

// Custom painter for human silhouette
class HumanSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Compact human silhouette to match equipment slots
    // Head (circle at top)
    path.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.15),
      width: size.width * 0.15,
      height: size.width * 0.15,
    ));
    
    // Neck (small rectangle)
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.25),
      width: size.width * 0.05,
      height: size.height * 0.05,
    ));
    
    // Torso (main body)
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.4),
      width: size.width * 0.2,
      height: size.height * 0.3,
    ));
    
    // Left Arm (positioned correctly)
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.2, size.height * 0.45),
      width: size.width * 0.08,
      height: size.height * 0.25,
    ));
    
    // Right Arm (positioned correctly)
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.8, size.height * 0.45),
      width: size.width * 0.08,
      height: size.height * 0.25,
    ));
    
    // Left Leg
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.42, size.height * 0.7),
      width: size.width * 0.08,
      height: size.height * 0.25,
    ));
    
    // Right Leg
    path.addRect(Rect.fromCenter(
      center: Offset(size.width * 0.58, size.height * 0.7),
      width: size.width * 0.08,
      height: size.height * 0.25,
    ));
    
    // Left Foot
    path.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.42, size.height * 0.9),
      width: size.width * 0.1,
      height: size.width * 0.05,
    ));
    
    // Right Foot
    path.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.58, size.height * 0.9),
      width: size.width * 0.1,
      height: size.width * 0.05,
    ));
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
