import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/equipment_provider.dart';
import '../models/equipment.dart';
import '../models/item.dart';
import '../app/theme.dart';

class EquipmentPanel extends ConsumerWidget {
  const EquipmentPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eq = ref.watch(equipmentProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Equipment', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _slotGrid(context, ref, eq),
          const SizedBox(height: 16),
          _waistBar(context, ref, eq),
        ],
      ),
    );
  }

  Widget _slotGrid(BuildContext context, WidgetRef ref, EquipmentState eq) {
    final tiles = <_SlotTileData>[
      _SlotTileData('Head', SlotType.head, eq.head),
      _SlotTileData('Body', SlotType.body, eq.body),
      _SlotTileData('Legs', SlotType.legs, eq.legs),
      _SlotTileData('Feet', SlotType.feet, eq.feet),
      _SlotTileData('Left Arm', SlotType.armLeft, eq.armLeft),
      _SlotTileData('Right Arm', SlotType.armRight, eq.armRight),
      _SlotTileData('Waist', SlotType.waist, eq.waist),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 116,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, i) => _SlotTile(data: tiles[i]),
    );
  }

  Widget _waistBar(BuildContext context, WidgetRef ref, EquipmentState eq) {
    final cap = ref.read(equipmentProvider.notifier).currentWaistCapacity;
    final used = ref.read(equipmentProvider.notifier).currentWaistUsed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, size: 18),
              const SizedBox(width: 8),
              Text('Waist Quick‑Items  ($used/$cap)'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eq.waistSmallItems.map((s) => Chip(
              label: Text('${s.itemId} ×${s.qty}'), // swap to item name/icon lookups in your project
              onDeleted: () => ref.read(equipmentProvider.notifier).removeFromWaist(s.itemId, qty: s.qty),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _SlotTileData {
  final String label; 
  final SlotType slot; 
  final Item? item;
  _SlotTileData(this.label, this.slot, this.item);
}

class _SlotTile extends ConsumerWidget {
  const _SlotTile({required this.data});
  final _SlotTileData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasItem = data.item != null;
    return InkWell(
      onLongPress: hasItem ? () => ref.read(equipmentProvider.notifier).unequip(data.slot) : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: hasItem ? AppTheme.accentColor : Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const Spacer(),
            if (hasItem) ...[
              Text(data.item!.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('Long‑press to unequip', style: TextStyle(fontSize: 11, color: Colors.white54)),
            ] else ...[
              const Text('Empty', style: TextStyle(color: Colors.white38)),
            ]
          ],
        ),
      ),
    );
  }
}
