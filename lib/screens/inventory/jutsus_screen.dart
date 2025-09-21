import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/jutsu.dart';
import '../../utils/snackbar_utils.dart';

class JutsusScreen extends ConsumerWidget {
  const JutsusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jutsus = ref.watch(jutsusProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      child: jutsus.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 50,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Jutsus',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You don\'t have any jutsus yet. Learn some techniques to expand your arsenal!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: jutsus.length,
              itemBuilder: (context, index) {
                final jutsu = jutsus[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildJutsuCard(context, ref, jutsu),
                );
              },
            ),
    );
  }

  Widget _buildJutsuCard(BuildContext context, WidgetRef ref, Jutsu jutsu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getTypeColor(jutsu.type).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getTypeColor(jutsu.type).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              _getTypeIcon(jutsu.type),
              color: _getTypeColor(jutsu.type),
              size: 24,
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
                      jutsu.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getTypeColor(jutsu.type).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        jutsu.type.name.toUpperCase(),
                        style: TextStyle(
                          color: _getTypeColor(jutsu.type),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (jutsu.isEquipped) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.staminaColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'EQUIPPED',
                          style: TextStyle(
                            color: AppTheme.staminaColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  jutsu.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.chakraColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: AppTheme.chakraColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${jutsu.chakraCost}',
                            style: const TextStyle(
                              color: AppTheme.chakraColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.attackColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.flash_on,
                            color: AppTheme.attackColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${jutsu.power}',
                            style: const TextStyle(
                              color: AppTheme.attackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              if (jutsu.isEquipped)
                OutlinedButton(
                  onPressed: () => _unequipJutsu(context, ref, jutsu),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.hpColor,
                    side: const BorderSide(color: AppTheme.hpColor),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Unequip'),
                )
              else
                ElevatedButton(
                  onPressed: () => _equipJutsu(context, ref, jutsu),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.staminaColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Equip'),
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _showJutsuDetails(context, jutsu),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(JutsuType type) {
    switch (type) {
      case JutsuType.ninjutsu:
        return AppTheme.chakraColor;
      case JutsuType.taijutsu:
        return AppTheme.attackColor;
      case JutsuType.genjutsu:
        return AppTheme.defenseColor;
      case JutsuType.kekkeiGenkai:
        return AppTheme.ryoColor;
    }
  }

  IconData _getTypeIcon(JutsuType type) {
    switch (type) {
      case JutsuType.ninjutsu:
        return Icons.auto_awesome;
      case JutsuType.taijutsu:
        return Icons.sports_martial_arts;
      case JutsuType.genjutsu:
        return Icons.visibility;
      case JutsuType.kekkeiGenkai:
        return Icons.bloodtype;
    }
  }

  void _equipJutsu(BuildContext context, WidgetRef ref, Jutsu jutsu) {
    final jutsus = ref.read(jutsusProvider);
    final jutsuIndex = jutsus.indexWhere((j) => j.id == jutsu.id);
    
    if (jutsuIndex != -1) {
      final updatedJutsus = List<Jutsu>.from(jutsus);
      updatedJutsus[jutsuIndex] = updatedJutsus[jutsuIndex].copyWith(isEquipped: true);
      ref.read(jutsusProvider.notifier).state = updatedJutsus;

      SnackbarUtils.showSuccess(
        context,
        'Equipped ${jutsu.name}!',
        backgroundColor: AppTheme.staminaColor,
      );
    }
  }

  void _unequipJutsu(BuildContext context, WidgetRef ref, Jutsu jutsu) {
    final jutsus = ref.read(jutsusProvider);
    final jutsuIndex = jutsus.indexWhere((j) => j.id == jutsu.id);
    
    if (jutsuIndex != -1) {
      final updatedJutsus = List<Jutsu>.from(jutsus);
      updatedJutsus[jutsuIndex] = updatedJutsus[jutsuIndex].copyWith(isEquipped: false);
      ref.read(jutsusProvider.notifier).state = updatedJutsus;

      SnackbarUtils.showInfo(
        context,
        'Unequipped ${jutsu.name}!',
        backgroundColor: AppTheme.hpColor,
      );
    }
  }

  void _showJutsuDetails(BuildContext context, Jutsu jutsu) {
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
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getTypeColor(jutsu.type).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    _getTypeIcon(jutsu.type),
                    color: _getTypeColor(jutsu.type),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jutsu.name,
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
                          color: _getTypeColor(jutsu.type).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${jutsu.type.name.toUpperCase()} JUTSU',
                          style: TextStyle(
                            color: _getTypeColor(jutsu.type),
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
              jutsu.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.bolt,
                          color: AppTheme.chakraColor,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chakra Cost',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${jutsu.chakraCost}',
                          style: const TextStyle(
                            color: AppTheme.chakraColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.flash_on,
                          color: AppTheme.attackColor,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Power',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${jutsu.power}',
                          style: const TextStyle(
                            color: AppTheme.attackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (jutsu.isEquipped) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.staminaColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.staminaColor,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Currently Equipped',
                      style: TextStyle(
                        color: AppTheme.staminaColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
