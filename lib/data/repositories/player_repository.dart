import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../failures.dart';
import '../../models/player.dart';
import '../../models/stats.dart';
import '../../models/item.dart';
import '../../models/jutsu.dart';
import '../../models/equipment.dart';

/// Repository interface for player data operations
abstract class PlayerRepository {
  Future<({Player? player, Failure? failure})> getPlayer(String playerId);
  Future<({Player? player, Failure? failure})> updatePlayer(Player player);
  Future<({List<Item>? items, Failure? failure})> getPlayerItems(String playerId);
  Future<({List<Jutsu>? jutsus, Failure? failure})> getPlayerJutsus(String playerId);
  Future<({bool success, Failure? failure})> updatePlayerStats(String playerId, PlayerStats stats);
}

/// Concrete implementation of PlayerRepository
class PlayerRepositoryImpl implements PlayerRepository {
  @override
  Future<({Player? player, Failure? failure})> getPlayer(String playerId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock player data - in real implementation, this would fetch from server
      final player = Player(
        id: playerId,
        name: 'Guest Player',
        avatarUrl: 'https://ui-avatars.com/api/?name=G&background=FF6B35&color=FFFFFF&size=100',
        village: 'Willowshade Village',
        ryo: 500, // Minimal starting ryo
        stats: const PlayerStats(
          level: 1, // Start at level 1
          str: 100,    // Minimal starting stats
          intl: 100,
          spd: 100,
          wil: 100,
          nin: 100,
          gen: 100,
          buk: 100,
          tai: 100,
          currentHP: 600,  // Level 1: 500 + 100*1 = 600
          currentSP: 600,
          currentCP: 600,
        ),
        jutsuIds: ['basic_punch'], // Only basic jutsu for new players
        itemIds: ['kunai'], // Only basic items for new players
        rank: PlayerRank.genin, // Start as genin
      );
      
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to fetch player: $e'));
    }
  }

  @override
  Future<({Player? player, Failure? failure})> updatePlayer(Player player) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In real implementation, this would update the server
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to update player: $e'));
    }
  }

  @override
  Future<({List<Item>? items, Failure? failure})> getPlayerItems(String playerId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock items data
      final items = [
        Item(
          id: 'kunai',
          name: 'Kunai',
          description: 'A versatile throwing weapon',
          icon: '🗡️',
          quantity: 15,
          rarity: ItemRarity.common,
          effect: {'damage': 25},
          kind: ItemKind.material,
          size: ItemSize.small,
        ),
        Item(
          id: 'shuriken',
          name: 'Shuriken',
          description: 'Sharp throwing star',
          icon: '⭐',
          quantity: 8,
          rarity: ItemRarity.common,
          effect: {'damage': 20},
          kind: ItemKind.material,
          size: ItemSize.small,
        ),
        Item(
          id: 'health_potion',
          name: 'Health Potion',
          description: 'Restores HP',
          icon: '🧪',
          quantity: 3,
          rarity: ItemRarity.uncommon,
          effect: {'heal': 100},
        ),
      ];
      
      return (items: items, failure: null);
    } catch (e) {
      return (items: null, failure: ServerFailure('Failed to fetch items: $e'));
    }
  }

  @override
  Future<({List<Jutsu>? jutsus, Failure? failure})> getPlayerJutsus(String playerId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock jutsus data
      final jutsus = [
        const Jutsu(
          id: 'rasengan',
          name: 'Rasengan',
          type: JutsuType.ninjutsu,
          chakraCost: 80,
          power: 450,
          description: 'A powerful spinning chakra attack in a straight line',
          isEquipped: true,
          range: 4,
          targeting: JutsuTargeting.straightLine,
          apCost: 60,
        ),
        const Jutsu(
          id: 'shadow_clone',
          name: 'Shadow Clone Jutsu',
          type: JutsuType.ninjutsu,
          chakraCost: 60,
          power: 300,
          description: 'Teleport and damage enemies around you',
          apCost: 60,
          isEquipped: true,
          range: 3,
          targeting: JutsuTargeting.movementAbility,
          areaRadius: 1,
        ),
        const Jutsu(
          id: 'wind_style',
          name: 'Wind Style: Great Breakthrough',
          type: JutsuType.ninjutsu,
          chakraCost: 100,
          power: 380,
          description: 'Powerful wind attack',
          isEquipped: false,
          range: 2,
          targeting: JutsuTargeting.singleTarget,
        ),
      ];
      
      return (jutsus: jutsus, failure: null);
    } catch (e) {
      return (jutsus: null, failure: ServerFailure('Failed to fetch jutsus: $e'));
    }
  }

  @override
  Future<({bool success, Failure? failure})> updatePlayerStats(String playerId, PlayerStats stats) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In real implementation, this would update the server
      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to update stats: $e'));
    }
  }
}

/// Provider for PlayerRepository
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl();
});
