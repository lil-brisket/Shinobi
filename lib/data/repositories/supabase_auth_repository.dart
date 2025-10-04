import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/player.dart' as player_model;
import '../../models/player.dart';
import '../../models/stats.dart';
import '../../services/supabase_service.dart';
import '../../config/supabase_config.dart';
import 'auth_repository.dart';

/// Supabase implementation of AuthRepository
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final _uuid = const Uuid();

  /// Login with email and password
  @override
  Future<({Player? player, String? error})> login(String username, String password) async {
    try {
      final result = await _supabaseService.signIn(email: username, password: password);
      
      if (result.userId != null) {
        // Get player data
        final playerResult = await _supabaseService.getPlayerByAuthId(result.userId!);
        
        if (playerResult.player != null) {
          return (player: playerResult.player as Player, error: null);
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
  @override
  Future<({Player? player, String? error})> register(String username, String email, String password, String villageId) async {
    try {
      print('Starting registration for username: $username, email: $email, villageId: $villageId');
      
      // Create auth user
      final authResult = await _supabaseService.signUp(
        email: email,
        password: password,
        username: username,
        villageId: villageId,
      );
      
      print('Auth result: userId=${authResult.userId}, error=${authResult.error}');
      
      if (authResult.userId != null) {
        // Create player record with proper email and village ID
        final player = _createNewPlayer(authResult.userId!, username, villageId);
        
        // Update the player data with email and village ID before saving
        final playerData = _supabaseService.mapPlayerToJson(player);
        playerData['email'] = email;
        playerData['village_id'] = villageId;
        
        print('Using village ID: $villageId');
        
        print('Player data to insert: $playerData');
        
        // Save player to database using direct insert
        final response = await _supabaseService.client
            .from(SupabaseConfig.playersTable)
            .insert(playerData)
            .select()
            .single();
        
        print('Player created successfully: $response');
        
        final createdPlayer = _supabaseService.mapPlayerFromJson(response);
        
        // Add default items and jutsus
        await _addDefaultPlayerData(createdPlayer.id);
        
        return (player: createdPlayer as Player, error: null);
      }
      
      return (player: null, error: authResult.error ?? 'Registration failed');
    } catch (e) {
      print('Registration error: $e');
      return (player: null, error: 'Registration failed: $e');
    }
  }

  /// Logout current user
  @override
  Future<void> logout() async {
    await _supabaseService.signOut();
  }

  /// Continue as guest (create temporary player)
  @override
  Future<({Player? player, String? error})> continueAsGuest() async {
    try {
      final guestId = _uuid.v4();
      const defaultVillageId = '550e8400-e29b-41d4-a716-446655440001'; // Willowshade Village
      
      final player = _createGuestPlayer(guestId, defaultVillageId);
      
      // Note: Guest players are not saved to database
      return (player: player as Player, error: null);
    } catch (e) {
      return (player: null, error: 'Guest login failed: $e');
    }
  }

  /// Get current authenticated user
  @override
  Future<Player?> getCurrentUser() async {
    try {
      final currentUser = _supabaseService.currentUser;
      if (currentUser != null) {
        final result = await _supabaseService.getPlayerByAuthId(currentUser.id);
        return result.player as Player?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  @override
  Future<bool> isAuthenticated() async {
    try {
      return _supabaseService.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Create new player with starting stats
  player_model.Player _createNewPlayer(String userId, String username, String villageId) {
    return player_model.Player(
      id: userId,
      name: username,
      avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=${username[0].toUpperCase()}',
      village: 'Willowshade Village', // Will be updated from database
      ryo: 500, // Starting ryo for new players (pocket money)
      stats: const PlayerStats(
        level: 1,
        str: 100,    // Minimal starting stats
        intl: 100,
        spd: 100,
        wil: 100,
        nin: 100,
        gen: 100,
        buk: 100,
        tai: 100,
        currentHP: 600,  // Level-based HP (500 + 100*1)
        currentSP: 600,  // Level-based SP (500 + 100*1)
        currentCP: 600,  // Level-based CP (500 + 100*1)
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
  player_model.Player _createGuestPlayer(String guestId, String villageId) {
    return player_model.Player(
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

      // Create default banking account with starting balance
      await _supabaseService.client
          .from(SupabaseConfig.bankingTable)
          .insert([
            {
              'player_id': playerId,
              'account_type': 'savings',
              'balance': 5000, // Starting bank balance for new players
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
