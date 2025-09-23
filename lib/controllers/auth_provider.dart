import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/villages.dart';
import '../models/village.dart';

// Auth state model
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? username;
  final String? sessionToken;
  final String? villageId;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.username,
    this.sessionToken,
    this.villageId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? username,
    String? sessionToken,
    String? villageId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      sessionToken: sessionToken ?? this.sessionToken,
      villageId: villageId ?? this.villageId,
    );
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadSession();
  }

  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _sessionTokenKey = 'session_token';
  static const String _villageIdKey = 'village_id';

  Future<void> _loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final username = prefs.getString(_usernameKey);
      final sessionToken = prefs.getString(_sessionTokenKey);
      final villageId = prefs.getString(_villageIdKey);

      if (userId != null && username != null && sessionToken != null) {
        state = AuthState(
          isAuthenticated: true,
          userId: userId,
          username: username,
          sessionToken: sessionToken,
          villageId: villageId,
        );
      }
    } catch (e) {
      // Handle error silently for now
      // Error loading session - handle silently
    }
  }

  Future<bool> login(String username, String password) async {
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
        final existingVillageId = prefs.getString(_villageIdKey);
        
        state = AuthState(
          isAuthenticated: true,
          userId: userId,
          username: username,
          sessionToken: sessionToken,
          villageId: existingVillageId,
        );
        
        return true;
      }
      return false;
    } catch (e) {
      // Login error - handle silently
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String villageId) async {
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
        
        state = AuthState(
          isAuthenticated: true,
          userId: userId,
          username: username,
          sessionToken: sessionToken,
          villageId: villageId,
        );
        
        return true;
      }
      return false;
    } catch (e) {
      // Registration error - handle silently
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_villageIdKey);
      
      state = const AuthState();
    } catch (e) {
      // Logout error - handle silently
    }
  }

  Future<void> continueAsGuest() async {
    try {
      final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final sessionToken = 'guest_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Assign guest player to Willowshade Village by default
      const defaultVillageId = 'willowshade';
      
      state = AuthState(
        isAuthenticated: true,
        userId: guestId,
        username: 'Guest Player',
        sessionToken: sessionToken,
        villageId: defaultVillageId,
      );
    } catch (e) {
      // Guest login error - handle silently
    }
  }
}

// Provider for current player's village
final currentVillageProvider = Provider<Village?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState.villageId != null) {
    return VillageConstants.getVillageById(authState.villageId!);
  }
  return null;
});
