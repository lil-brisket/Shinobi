import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/player.dart';
import '../../models/stats.dart';
import '../../services/supabase_service.dart';
import '../../config/supabase_config.dart';
import '../failures.dart';

/// Supabase implementation of AuthRepository
class SupabaseAuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final _uuid = const Uuid();

  /// Login with email and password
  Future<({Player? player, String? error})> login(String email, String password) async {
    try {
      final result = await _supabaseService.signIn(email: email, password: password);
      
      if (result.userId != null) {
        // Get player data
        final playerResult = await _supabaseService.getPlayerByAuthId(result.userId!);
        
        if (playerResult.player != null) {
          return (player: playerResult.player, error: null);
        } else {
          return (player: null, error: 'Failed to load player data');
        }
      }
      
      return (player: null, error: result.error ?? 'Login failed');
    } catch (e) {
      return (player: null, error: 'Login failed: $e');
    }
  }

  /// Register new player
  Future<({Player? player, String? error})> register({
    required String username,
    required String email,
    required String password,
    required String villageId,
  }) async {
    try {
      // Create auth user
      final authResult = await _supabaseService.signUp(
        email: email,
        password: password,
        username: username,
        villageId: villageId,
      );
      
      if (authResult.userId != null) {
        // Create player record
        final player = _createNewPlayer(authResult.userId!, username, villageId);
        
        // Save player to database
        final saveResult = await _supabaseService.updatePlayer(player);
        
        if (saveResult.player != null) {
          // Add default items and jutsus
          await _addDefaultPlayerData(player.id);
          
          return (player: saveResult.player, error: null);
        } else {
          return (player: null, error: 'Failed to create player profile');
        }
      }
      
      return (player: null, error: authResult.error ?? 'Registration failed');
    } catch (e) {
      return (player: null, error: 'Registration failed: $e');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    await _supabaseService.signOut();
  }

  /// Continue as guest (create temporary player)
  Future<({Player? player, String? error})> continueAsGuest() async {
    try {
      final guestId = _uuid.v4();
      const defaultVillageId = '550e8400-e29b-41d4-a716-446655440001'; // Willowshade Village
      
      final player = _createGuestPlayer(guestId, defaultVillageId);
      
      // Note: Guest players are not saved to database
      return (player: player, error: null);
    } catch (e) {
      return (player: null, error: 'Guest login failed: $e');
    }
  }

  /// Get current authenticated user
  Future<Player?> getCurrentUser() async {
    try {
      final currentUser = _supabaseService.currentUser;
      if (currentUser != null) {
        final result = await _supabaseService.getPlayerByAuthId(currentUser.id);
        return result.player;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return _supabaseService.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Create new player with starting stats
  Player _createNewPlayer(String userId, String username, String villageId) {
    return Player(
      id: userId,
      name: username,
      avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=${username[0].toUpperCase()}',
      village: 'Willowshade Village', // Will be updated from database
      ryo: 10000, // Starting ryo for new players
      stats: const PlayerStats(
        level: 1,
        str: 1000,
        intl: 1000,
        spd: 1000,
        wil: 1000,
        nin: 1000,
        gen: 1000,
        buk: 1000,
        tai: 1000,
        currentHP: 600,
        currentSP: 600,
        currentCP: 600,
      ),
      jutsuIds: ['basic_punch'],
      itemIds: ['kunai'],
      rank: PlayerRank.genin,
      medNinja: const MedicalNinjaProfession(
        level: 1,
        xp: 0,
      ),
    );
  }

  /// Create guest player
  Player _createGuestPlayer(String guestId, String villageId) {
    return Player(
      id: guestId,
      name: 'Guest Player',
      avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=G',
      village: 'Willowshade Village',
      ryo: 5000, // Limited ryo for guests
      stats: const PlayerStats(
        level: 15,
        str: 50000,
        intl: 50000,
        spd: 50000,
        wil: 50000,
        nin: 50000,
        gen: 50000,
        buk: 50000,
        tai: 50000,
        currentHP: 2000,
        currentSP: 2000,
        currentCP: 2000,
      ),
      jutsuIds: ['basic_punch', 'basic_heal'],
      itemIds: ['kunai'],
      rank: PlayerRank.genin,
      medNinja: const MedicalNinjaProfession(
        level: 1,
        xp: 0,
      ),
    );
  }

  /// Add default items and jutsus to new player
  Future<void> _addDefaultPlayerData(String playerId) async {
    try {
      // Add default items
      await _supabaseService.client
          .from(SupabaseConfig.playerItemsTable)
          .insert([
            {
              'player_id': playerId,
              'item_id': 'kunai',
              'quantity': 5,
            },
          ]);

      // Add default jutsus
      await _supabaseService.client
          .from(SupabaseConfig.playerJutsusTable)
          .insert([
            {
              'player_id': playerId,
              'jutsu_id': 'basic_punch',
              'is_equipped': true,
              'mastery_level': 1,
              'mastery_xp': 0,
            },
          ]);

      // Create default banking account
      await _supabaseService.client
          .from(SupabaseConfig.bankingTable)
          .insert([
            {
              'player_id': playerId,
              'account_type': 'savings',
              'balance': 0,
              'interest_rate': 0.0005, // 0.05% per day
            },
          ]);
    } catch (e) {
      // Log error but don't fail registration
      print('Failed to add default player data: $e');
    }
  }
}

/// Provider for SupabaseAuthRepository
final supabaseAuthRepositoryProvider = Provider<SupabaseAuthRepository>((ref) {
  return SupabaseAuthRepository();
});
