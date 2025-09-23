import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/stat_bar.dart';
import '../../app/theme.dart';
import '../../controllers/providers.dart';
import '../../models/stats.dart';
import '../../models/player.dart';
import '../../services/heal_service.dart';
import '../../utils/snackbar_utils.dart';

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
                  'Clinic',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildClinicSection(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildClinicSection(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final otherPlayers = ref.watch(otherPlayersProvider);
    
    // Filter players from same village with HP below max (excluding KO/Waiting)
    final sameVillagePlayers = otherPlayers.where((otherPlayer) => 
      otherPlayer.village == player.village && 
      otherPlayer.stats.hp < otherPlayer.stats.maxHp &&
      otherPlayer.stats.hp > 0 // Not KO
    ).toList();

    if (sameVillagePlayers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No Shinobi currently require medical attention',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: sameVillagePlayers.map((targetPlayer) => 
          _buildPlayerHealItem(context, ref, player, targetPlayer)
        ).toList(),
      ),
    );
  }

  Widget _buildPlayerHealItem(BuildContext context, WidgetRef ref, Player healer, Player target) {
    final healingInfo = HealService.getHealingInfo(healer, target);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(target.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'HP: ${target.stats.hp}/${target.stats.maxHp}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (healingInfo.canHeal)
                      Text(
                        'Heal: +${healingInfo.healAmount}',
                        style: const TextStyle(
                          color: AppTheme.hpColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                if (!healingInfo.canHeal && healingInfo.reason != null)
                  Text(
                    healingInfo.reason!,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: healingInfo.canHeal ? () => _healPlayer(context, ref, healer, target) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: healingInfo.canHeal ? AppTheme.hpColor : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Heal'),
          ),
        ],
      ),
    );
  }

  void _healPlayer(BuildContext context, WidgetRef ref, Player healer, Player target) {
    try {
      final updatedHealer = HealService.healPlayer(healer, target);
      ref.read(playerProvider.notifier).state = updatedHealer;
      
      // Update the target player in the other players list
      final otherPlayers = ref.read(otherPlayersProvider);
      final updatedOtherPlayers = otherPlayers.map((player) {
        if (player.id == target.id) {
          final healingInfo = HealService.getHealingInfo(healer, target);
          return target.copyWith(
            stats: target.stats.healHP(healingInfo.healAmount),
          );
        }
        return player;
      }).toList();
      ref.read(otherPlayersProvider.notifier).state = updatedOtherPlayers;
      
      final xpGained = updatedHealer.medNinja.xp - healer.medNinja.xp;
      SnackbarUtils.showSuccess(
        context,
        'Successfully healed ${target.name}! +$xpGained Medical XP',
      );
    } catch (e) {
      SnackbarUtils.showError(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
