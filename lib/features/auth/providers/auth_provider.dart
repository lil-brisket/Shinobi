import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/failures.dart';
import '../../../models/player.dart';
import '../../../models/village.dart';
import '../../../constants/villages.dart';

/// Auth state model
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? username;
  final String? sessionToken;
  final String? villageId;
  final Player? player;
  final Failure? error;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.username,
    this.sessionToken,
    this.villageId,
    this.player,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? username,
    String? sessionToken,
    String? villageId,
    Player? player,
    Failure? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      sessionToken: sessionToken ?? this.sessionToken,
      villageId: villageId ?? this.villageId,
      player: player ?? this.player,
      error: error ?? this.error,
    );
  }

  /// Clear error state
  AuthState clearError() {
    return copyWith(error: null);
  }
}

/// Auth provider using repository pattern
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _loadSession();
  }

  final AuthRepository _authRepository;

  Future<void> _loadSession() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        final player = await _authRepository.getCurrentUser();
        if (player != null) {
          state = state.copyWith(
            isAuthenticated: true,
            userId: player.id,
            username: player.name,
            sessionToken: 'existing_token', // In real app, get from storage
            villageId: 'default_village', // In real app, get from storage
            player: player,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        error: ServerFailure('Failed to load session: $e'),
      );
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.clearError();
    
    try {
      final result = await _authRepository.login(username, password);
      
      if (result.player != null) {
        state = state.copyWith(
          isAuthenticated: true,
          userId: result.player!.id,
          username: result.player!.name,
          sessionToken: 'new_token', // In real app, get from result
          villageId: 'default_village', // In real app, get from result
          player: result.player,
        );
        return true;
      } else {
        state = state.copyWith(
          error: AuthFailure(result.error ?? 'Login failed'),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: ServerFailure('Login failed: $e'),
      );
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String villageId) async {
    state = state.clearError();
    
    try {
      final result = await _authRepository.register(username, email, password, villageId);
      
      if (result.player != null) {
        state = state.copyWith(
          isAuthenticated: true,
          userId: result.player!.id,
          username: result.player!.name,
          sessionToken: 'new_token', // In real app, get from result
          villageId: villageId,
          player: result.player,
        );
        return true;
      } else {
        state = state.copyWith(
          error: AuthFailure(result.error ?? 'Registration failed'),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: ServerFailure('Registration failed: $e'),
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        error: ServerFailure('Logout failed: $e'),
      );
    }
  }

  Future<bool> continueAsGuest() async {
    state = state.clearError();
    
    try {
      final result = await _authRepository.continueAsGuest();
      
      if (result.player != null) {
        state = state.copyWith(
          isAuthenticated: true,
          userId: result.player!.id,
          username: result.player!.name,
          sessionToken: 'guest_token',
          villageId: 'default_village',
          player: result.player,
        );
        return true;
      } else {
        state = state.copyWith(
          error: AuthFailure(result.error ?? 'Guest login failed'),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: ServerFailure('Guest login failed: $e'),
      );
      return false;
    }
  }
}

/// Provider for current player's village
final currentVillageProvider = Provider<Village?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState.villageId != null) {
    return VillageConstants.getVillageById(authState.villageId!);
  }
  return null;
});

/// Provider for current player
final currentPlayerProvider = Provider<Player?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.player;
});
