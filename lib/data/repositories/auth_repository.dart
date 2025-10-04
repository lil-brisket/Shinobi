import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/player.dart';
import '../../models/stats.dart';
import 'supabase_auth_repository.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  Future<({Player? player, String? error})> login(String username, String password);
  Future<({Player? player, String? error})> register(String username, String email, String password, String villageId);
  Future<void> logout();
  Future<({Player? player, String? error})> continueAsGuest();
  Future<Player?> getCurrentUser();
  Future<bool> isAuthenticated();
}

/// Concrete implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _sessionTokenKey = 'session_token';
  static const String _villageIdKey = 'village_id';

  @override
  Future<({Player? player, String? error})> login(String username, String password) async {
    try {
      // Simulate API call - replace with actual authentication
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any non-empty credentials
      if (username.isNotEmpty && password.isNotEmpty) {
        final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        final sessionToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userId);
        await prefs.setString(_usernameKey, username);
        await prefs.setString(_sessionTokenKey, sessionToken);
        
        // Load existing villageId from storage (if any)
        // final existingVillageId = prefs.getString(_villageIdKey);
        
        // Create player object
        final player = Player(
          id: userId,
          name: username,
          avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=${username[0].toUpperCase()}',
          village: 'Willowshade Village', // Default village
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
        
        return (player: player, error: null);
      }
      return (player: null, error: 'Invalid credentials');
    } catch (e) {
      return (player: null, error: 'Login failed: $e');
    }
  }

  @override
  Future<({Player? player, String? error})> register(String username, String email, String password, String villageId) async {
    try {
      // Simulate API call - replace with actual registration
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any non-empty credentials
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && villageId.isNotEmpty) {
        final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        final sessionToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userId);
        await prefs.setString(_usernameKey, username);
        await prefs.setString(_sessionTokenKey, sessionToken);
        await prefs.setString(_villageIdKey, villageId);
        
        // Create player object
        final player = Player(
          id: userId,
          name: username,
          avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=${username[0].toUpperCase()}',
          village: 'Willowshade Village', // Default village
          ryo: 500, // Minimal starting ryo for new players
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
            currentHP: 600,  // Level 1: 500 + 100*1 = 600
            currentSP: 600,
            currentCP: 600,
          ),
          jutsuIds: ['basic_punch'],
          itemIds: ['kunai'],
          rank: PlayerRank.genin,
        );
        
        return (player: player, error: null);
      }
      return (player: null, error: 'Invalid registration data');
    } catch (e) {
      return (player: null, error: 'Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_villageIdKey);
    } catch (e) {
      // Logout error - handle silently
    }
  }

  @override
  Future<({Player? player, String? error})> continueAsGuest() async {
    try {
      final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final sessionToken = 'guest_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Assign guest player to Willowshade Village by default
      const defaultVillageId = '550e8400-e29b-41d4-a716-446655440001';
      
      // Create guest player
      final player = Player(
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
      );
      
      // Save guest session to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, guestId);
      await prefs.setString(_usernameKey, 'Guest Player');
      await prefs.setString(_sessionTokenKey, sessionToken);
      await prefs.setString(_villageIdKey, defaultVillageId);
      
      return (player: player, error: null);
    } catch (e) {
      return (player: null, error: 'Guest login failed: $e');
    }
  }

  @override
  Future<Player?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final username = prefs.getString(_usernameKey);
      // final sessionToken = prefs.getString(_sessionTokenKey);
      // final villageId = prefs.getString(_villageIdKey);

      if (userId != null && username != null) {
        // Return a basic player object - in real implementation, this would fetch from server
        return Player(
          id: userId,
          name: username,
          avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=${username[0].toUpperCase()}',
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
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final sessionToken = prefs.getString(_sessionTokenKey);
      return userId != null && sessionToken != null;
    } catch (e) {
      return false;
    }
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Use Supabase implementation instead of mock implementation
  return SupabaseAuthRepository();
});
