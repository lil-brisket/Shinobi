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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: const Row(
            children: [
              Icon(Icons.shield_moon_outlined, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Equipped',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // EQUIPPED PANEL
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: const Color(0xFF101826),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(.06)),
            ),
            child: _Silhouette(
              glow: _glow,
              equipped: _getEquippedMap(equipment),
              onClear: (slot) => ref.read(equipmentProvider.notifier).unequip(slot),
              onTapSlot: (slot) => _showSlotPopup(context, ref, slot, _getSlotName(slot), _getEquippableItems(inventory, slot), _getEquippedItem(equipment, slot)),
              scale: 0.5,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // CONSUMABLE ITEMS SECTION
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF101826),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_drink_outlined, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Consumables',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildConsumablesList(context, ref, inventory),
              ],
            ),
          ),
        ),
      ],
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
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
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
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _getRarityColor(item.rarity).withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.icon,
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 1),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '×${item.quantity}',
                style: const TextStyle(
                  fontSize: 4,
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

  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.all:
        return Colors.grey;
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
      child: Center(
        child: Container(
          width: 200,
          height: 240,
          child: Stack(
            children: [
              // Human silhouette using PNG image
              Positioned(
                left: 10,
                top: 15,
                child: Container(
                  width: 170,
                  height: 210,
                  child: Image.asset(
                    'assets/images/human_outline.png',
                    width: 170,
                    height: 210,
                    fit: BoxFit.contain,
                    color: Colors.grey.withOpacity(0.3),
                    colorBlendMode: BlendMode.modulate,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to basic shapes if image fails to load
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Head
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Body (moved up)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Waist (new slot)
                          Container(
                            width: 70,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Legs (moved up)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 35,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              
              // Equipment slots positioned on top of the human silhouette
              Positioned(
                top: 30, // Head area
                left: 80, // Center on head
                child: _buildSlotButton('Head', equipped[SlotType.head]),
              ),
              Positioned(
                top: 70, // Body area
                left: 80, // Center on body
                child: _buildSlotButton('Body', equipped[SlotType.body]),
              ),
              Positioned(
                top: 110, // Waist area
                left: 80, // Center on waist
                child: _buildSlotButton('Waist', equipped[SlotType.waist]),
              ),
              Positioned(
                top: 150, // Legs area
                left: 80, // Center on legs
                child: _buildSlotButton('Legs', equipped[SlotType.legs]),
              ),
              Positioned(
                top: 190, // Feet area
                left: 80, // Center on feet
                child: _buildSlotButton('Feet', equipped[SlotType.feet]),
              ),
              Positioned(
                top: 70, // Arm level
                left: 25, // Left arm position
                child: _buildSlotButton('L Arm', equipped[SlotType.armLeft]),
              ),
              Positioned(
                top: 70, // Arm level
                left: 135, // Right arm position
                child: _buildSlotButton('R Arm', equipped[SlotType.armRight]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotButton(String label, Item? item) {
    return GestureDetector(
      onTap: () => onTapSlot(_getSlotTypeFromLabel(label)),
      onLongPress: item != null ? () => onClear(_getSlotTypeFromLabel(label)) : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1B2332),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item != null ? Icons.check : Icons.add,
              color: item != null ? Colors.green : Colors.white54,
              size: 16,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 7,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SlotType _getSlotTypeFromLabel(String label) {
    switch (label) {
      case 'Head': return SlotType.head;
      case 'Body': return SlotType.body;
      case 'Waist': return SlotType.waist;
      case 'Legs': return SlotType.legs;
      case 'Feet': return SlotType.feet;
      case 'Hands': return SlotType.armLeft; // Default to left arm for hands
      case 'L Arm': return SlotType.armLeft;
      case 'R Arm': return SlotType.armRight;
      default: return SlotType.head;
    }
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