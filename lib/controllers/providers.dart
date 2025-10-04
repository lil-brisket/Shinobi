import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/player.dart';
import '../models/stats.dart';
import '../models/item.dart';
import '../models/jutsu.dart';
import '../models/mission.dart';
import '../models/village.dart';
import '../models/news.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/repositories/player_repository.dart';
import '../models/chat.dart';
import '../models/timer.dart';
import '../constants/villages.dart';
import 'banking_provider.dart';
import '../data/repositories/timer_repository.dart';

// Player Provider - Updated to use repository pattern
final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  final playerRepository = ref.watch(playerRepositoryProvider);
  return PlayerNotifier(playerRepository);
});

// Unified currency provider that syncs Player.ryo with Wallet.pocketBalance
final unifiedCurrencyProvider = Provider<({int pocketRyo, int bankRyo})>((ref) {
  final walletAsync = ref.watch(walletProvider);
  
  return walletAsync.when(
    data: (wallet) => (pocketRyo: wallet.pocketBalance, bankRyo: wallet.bankBalance),
    loading: () => (pocketRyo: 500, bankRyo: 5000), // Default values
    error: (_, __) => (pocketRyo: 500, bankRyo: 5000), // Fallback values
  );
});

// Current player with proper village and username, synced with banking system
final syncedPlayerProvider = Provider<Player>((ref) {
  final player = ref.watch(playerProvider);
  final currentVillage = ref.watch(currentVillageProvider);
  final authState = ref.watch(authProvider);
  final currency = ref.watch(unifiedCurrencyProvider);
  
  // Update player with current village, username, and synced currency
  return player.copyWith(
    name: authState.username ?? 'Guest Player',
    village: currentVillage?.name ?? 'Willowshade Village', // Consistent default village
    ryo: currency.pocketRyo, // Always sync with wallet pocket balance
  );
});

class PlayerNotifier extends StateNotifier<Player> {
  final PlayerRepository _playerRepository;
  
  PlayerNotifier(this._playerRepository) : super(Player(
    id: 'player_001',
    name: 'Guest Player',
    avatarUrl: 'https://ui-avatars.com/api/?name=G&background=FF6B35&color=FFFFFF&size=100',
    village: 'Willowshade Village', // Consistent default village
    ryo: 500, // Starting pocket money (bank has 5000)
    stats: const PlayerStats(
      level: 1, // Start at level 1
      // Minimal starting stats for new players
      str: 100,    // Minimal starting stats
      intl: 100,
      spd: 100,
      wil: 100,
      
      // Combat stats - minimal starting values
      nin: 100,
      gen: 100,
      buk: 100,
      tai: 100,
      
      // Current values based on level 1
      currentHP: 600,  // Level 1: 500 + 100*1 = 600
      currentSP: 600,  // Level 1: 500 + 100*1 = 600
      currentCP: 600,  // Level 1: 500 + 100*1 = 600
    ),
    jutsuIds: [], // New accounts start with no jutsus
    itemIds: [], // New accounts start with no items
    rank: PlayerRank.genin, // Start as genin
  ));

  Future<void> updateStats(PlayerStats newStats) async {
    // Always update local state first for immediate UI feedback
    state = state.copyWith(stats: newStats);
    
    try {
      // Try to update stats via repository for persistence
      final result = await _playerRepository.updatePlayerStats(state.id, newStats);
      
      if (!result.success) {
        // Log error but don't revert local state
        print('Failed to persist stats update: ${result.failure?.message}');
      }
    } catch (e) {
      // Log error but don't revert local state
      print('Error updating stats in repository: $e');
    }
  }

  void updatePlayer(Player newPlayer) {
    state = newPlayer;
  }
}

// TODO: Move to lib/features/inventory/providers/inventory_provider.dart
// Inventory Provider - Legacy provider, should use feature structure
// New accounts start with empty inventory
final inventoryProvider = StateProvider<List<Item>>((ref) {
  return [];
});

// Jutsus Provider
// New accounts start with no jutsus
final jutsusProvider = StateProvider<List<Jutsu>>((ref) {
  return [];
});

// Missions Provider
final missionsProvider = StateProvider<List<Mission>>((ref) {
  return [
    Mission(
      id: 'mission_001',
      title: 'Escort Mission',
      description: 'Escort a merchant safely to the next village',
      rank: MissionRank.c,
      requiredLevel: 15,
      reward: const MissionReward(xp: 200, ryo: 1500, itemIds: ['health_potion']),
      durationSeconds: 3600, // 1 hour
      status: MissionStatus.available,
    ),
    Mission(
      id: 'mission_002',
      title: 'Bandit Elimination',
      description: 'Eliminate bandits terrorizing the trade route',
      rank: MissionRank.b,
      requiredLevel: 25,
      reward: const MissionReward(xp: 400, ryo: 3000, itemIds: ['chakra_pill']),
      durationSeconds: 7200, // 2 hours
      status: MissionStatus.inProgress,
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      endTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
    ),
    Mission(
      id: 'mission_003',
      title: 'Spy Mission',
      description: 'Gather intelligence on enemy movements',
      rank: MissionRank.a,
      requiredLevel: 35,
      reward: const MissionReward(xp: 800, ryo: 6000, itemIds: ['rare_scroll']),
      durationSeconds: 14400, // 4 hours
      status: MissionStatus.available,
    ),
  ];
});


// Villages Provider
final villagesProvider = Provider<List<Village>>((ref) {
  return VillageConstants.allVillages;
});

// News Provider
final newsProvider = StateProvider<List<NewsItem>>((ref) {
  return [
    NewsItem(
      id: 'news_001',
      title: 'New Jutsu System Released!',
      body: 'Master powerful new techniques and unlock your true potential with the updated jutsu system.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      author: 'Hokage',
    ),
    NewsItem(
      id: 'news_002',
      title: 'Clan Wars Begin Next Week',
      body: 'Prepare for epic battles as clans compete for supremacy in the upcoming clan wars event.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      author: 'Event Team',
    ),
    NewsItem(
      id: 'news_003',
      title: 'New Village Areas Unlocked',
      body: 'Explore mysterious new territories and discover hidden treasures in the expanded world.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      author: 'World Team',
    ),
  ];
});

// Chat Provider
final chatProvider = StateProvider<List<ChatMessage>>((ref) {
  return [
    ChatMessage(
      id: 'msg_001',
      senderId: 'player_002',
      senderName: 'Sasuke_Uchiha',
      avatarUrl: 'https://ui-avatars.com/api/?name=S&background=FF6B35&color=FFFFFF&size=40',
      message: 'Anyone up for a training session?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: ChatType.global,
    ),
    ChatMessage(
      id: 'msg_002',
      senderId: 'player_003',
      senderName: 'Sakura_Haruno',
      avatarUrl: 'https://ui-avatars.com/api/?name=S&background=FF6B35&color=FFFFFF&size=40',
      message: 'I need help with the bandit mission!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      type: ChatType.global,
    ),
    ChatMessage(
      id: 'msg_003',
      senderId: 'player_004',
      senderName: 'Kakashi_Hatake',
      avatarUrl: 'https://ui-avatars.com/api/?name=K&background=FF6B35&color=FFFFFF&size=40',
      message: 'Great work on today\'s missions, team!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: ChatType.clan,
    ),
  ];
});

// Timer Provider for active timers with countdown functionality
final timersProvider = StateNotifierProvider<TimersNotifier, List<GameTimer>>((ref) {
  final timerRepository = ref.watch(timerRepositoryProvider);
  final authState = ref.watch(authProvider);
  // Check if user is a guest by looking at the session token
  final isGuest = authState.sessionToken == 'guest_token';
  final notifier = TimersNotifier(timerRepository, isGuest ? null : authState.userId);
  
  // Initialize timers when provider is first created
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notifier._initializeTimers();
  });
  
  return notifier;
});

// Timer countdown provider that updates every second
final timerCountdownProvider = StreamProvider<List<GameTimer>>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    final timers = ref.read(timersProvider);
    // Only return timers that are still active (not completed and not expired)
    final activeTimers = timers.where((timer) => !timer.isCompleted && !timer.isFinished).toList();
    return activeTimers;
  });
});

// Provider to get finished timers count
final finishedTimersCountProvider = Provider<int>((ref) {
  final timers = ref.watch(timersProvider);
  return timers.where((timer) => timer.isFinished).length;
});

// Provider to get unread chat messages count
final unreadChatCountProvider = Provider<int>((ref) {
  final messages = ref.watch(chatProvider);
  final now = DateTime.now();
  // Consider messages as unread if they're from the last 5 minutes and not from the current user
  return messages.where((message) {
    final timeDiff = now.difference(message.timestamp);
    return timeDiff.inMinutes <= 5 && message.senderId != 'player_001'; // player_001 is current user
  }).length;
});

class TimersNotifier extends StateNotifier<List<GameTimer>> {
  final TimerRepository _timerRepository;
  final String? _playerId;

  TimersNotifier(this._timerRepository, this._playerId) : super([]);

  Future<void> _initializeTimers() async {
    await _loadTimers();
  }

  static const String _timersKey = 'persistent_timers';

  Future<void> _loadTimers() async {
    if (_playerId == null) {
      // For guest users, only use local storage
      await _loadTimersFromLocalStorage();
      return;
    }
    
    // For authenticated users, prioritize database with local fallback
    try {
      await _loadTimersFromDatabase();
      // If database load succeeds, sync to local storage as backup
      await _saveTimersToLocalStorage();
    } catch (e) {
      print('Database load failed, falling back to local storage: $e');
      // If database fails, fall back to local storage
      await _loadTimersFromLocalStorage();
    }
  }

  Future<void> _loadTimersFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timersJson = prefs.getString(_timersKey);
      
      if (timersJson != null) {
        final List<dynamic> timersList = json.decode(timersJson);
        final timers = timersList.map((json) => GameTimer.fromJson(json)).toList();
        
        // Filter out completed timers and expired timers
        final activeTimers = timers.where((timer) {
          if (timer.isCompleted) {
            return false;
          }
          
          // Check if timer has expired
          final now = DateTime.now();
          final endTime = timer.startTime.add(timer.duration);
          if (now.isAfter(endTime)) {
            return false;
          }
          
          return true;
        }).toList();
        
        state = activeTimers;
      } else {
        state = [];
      }
    } catch (e) {
      print('[TimersNotifier] Error loading from local storage: $e');
      // If loading from local storage fails, start with empty list
      state = [];
    }
  }

  Future<void> _loadTimersFromDatabase() async {
    final result = await _timerRepository.getPlayerTimers(_playerId!);
    if (result.timers != null) {
      // Database is the source of truth for authenticated users
      state = result.timers!;
    } else if (result.failure != null) {
      throw Exception('Database error: ${result.failure!.message}');
    }
  }

  Future<void> _saveTimersToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timersJson = json.encode(state.map((timer) => timer.toJson()).toList());
      await prefs.setString(_timersKey, timersJson);
    } catch (e) {
      print('[TimersNotifier] Failed to save timers to local storage: $e');
    }
  }

  Future<void> addTimer(GameTimer timer) async {
    if (_playerId == null) {
      // For guest users, only use local storage
      state = [...state, timer];
      await _saveTimersToLocalStorage();
      return;
    }
    
    // For authenticated users, database is primary, local storage is backup
    try {
      final result = await _timerRepository.createTimer(timer, _playerId!);
      if (result.timer != null) {
        // Database save succeeded, update state and backup to local storage
        state = [...state, result.timer!];
        await _saveTimersToLocalStorage();
      } else {
        throw Exception('Failed to create timer in database: ${result.failure?.message}');
      }
    } catch (e) {
      // Database save failed, fall back to local storage
      print('Database save failed, using local storage: $e');
      state = [...state, timer];
      await _saveTimersToLocalStorage();
    }
  }

  Future<void> removeTimer(String timerId) async {
    if (_playerId == null) {
      // For guest users, only use local storage
      state = state.where((timer) => timer.id != timerId).toList();
      await _saveTimersToLocalStorage();
      return;
    }
    
    // For authenticated users, database is primary
    try {
      final result = await _timerRepository.deleteTimer(timerId);
      if (result.success) {
        // Database delete succeeded, update state and backup to local storage
        state = state.where((timer) => timer.id != timerId).toList();
        await _saveTimersToLocalStorage();
      } else {
        throw Exception('Failed to delete timer from database: ${result.failure?.message}');
      }
    } catch (e) {
      // Database delete failed, still remove from local state and storage
      print('Database delete failed, removing from local storage: $e');
      state = state.where((timer) => timer.id != timerId).toList();
      await _saveTimersToLocalStorage();
    }
  }

  Future<void> completeTimer(String timerId) async {
    if (_playerId == null) {
      // For guest users, only use local storage
      state = state.map((timer) {
        if (timer.id == timerId) {
          return timer.copyWith(isCompleted: true);
        }
        return timer;
      }).toList();
      await _saveTimersToLocalStorage();
      return;
    }
    
    // For authenticated users, database is primary
    try {
      final result = await _timerRepository.completeTimer(timerId);
      if (result.success) {
        // Database update succeeded, update state and backup to local storage
        state = state.map((timer) {
          if (timer.id == timerId) {
            return timer.copyWith(isCompleted: true);
          }
          return timer;
        }).toList();
        await _saveTimersToLocalStorage();
      } else {
        throw Exception('Failed to complete timer in database: ${result.failure?.message}');
      }
    } catch (e) {
      // Database update failed, still update local state and storage
      print('Database update failed, updating local storage: $e');
      state = state.map((timer) {
        if (timer.id == timerId) {
          return timer.copyWith(isCompleted: true);
        }
        return timer;
      }).toList();
      await _saveTimersToLocalStorage();
    }
  }

  Future<void> updateTimer(String timerId, GameTimer updatedTimer) async {
    if (_playerId == null) {
      // For guest users, only use local storage
      state = state.map((timer) {
        if (timer.id == timerId) {
          return updatedTimer;
        }
        return timer;
      }).toList();
      await _saveTimersToLocalStorage();
      return;
    }
    
    // For authenticated users, database is primary
    try {
      final result = await _timerRepository.updateTimer(updatedTimer, _playerId!);
      if (result.timer != null) {
        // Database update succeeded, update state and backup to local storage
        state = state.map((timer) {
          if (timer.id == timerId) {
            return result.timer!;
          }
          return timer;
        }).toList();
        await _saveTimersToLocalStorage();
      } else {
        throw Exception('Failed to update timer in database: ${result.failure?.message}');
      }
    } catch (e) {
      // Database update failed, still update local state and storage
      print('Database update failed, updating local storage: $e');
      state = state.map((timer) {
        if (timer.id == timerId) {
          return updatedTimer;
        }
        return timer;
      }).toList();
      await _saveTimersToLocalStorage();
    }
  }

  // Method to sync local storage with database (useful for connectivity recovery)
  Future<void> syncWithDatabase() async {
    if (_playerId == null) return; // Only for authenticated users
    
    try {
      // Load from database (source of truth)
      await _loadTimersFromDatabase();
      // Update local storage backup
      await _saveTimersToLocalStorage();
    } catch (e) {
      print('Failed to sync with database: $e');
    }
  }

  // Helper method to start a training timer
  Future<void> startTrainingTimer(String statType, Duration duration, int statIncrease) async {
    try {
      // Generate a proper UUID for the timer
      const uuid = Uuid();
      final timerId = uuid.v4();
      
      final startTime = DateTime.now().toLocal();
      final timer = GameTimer(
        id: timerId,
        title: 'Training $statType',
        type: TimerType.training,
        startTime: startTime,
        duration: duration,
        metadata: {'statType': statType, 'statIncrease': statIncrease},
      );
      
      
      await addTimer(timer);
    } catch (e) {
      // Don't re-throw, just log the error and continue
      // This prevents the UI from showing errors
      print('Training timer creation failed, but continuing anyway: $e');
    }
  }

  // Helper method to start a mission timer
  Future<void> startMissionTimer(String missionId, String missionTitle, Duration duration) async {
    final timer = GameTimer(
      id: 'mission_${missionId}_${DateTime.now().millisecondsSinceEpoch}',
      title: missionTitle,
      type: TimerType.mission,
      startTime: DateTime.now(),
      duration: duration,
      metadata: {'missionId': missionId},
    );
    await addTimer(timer);
  }
}

// Current Village Position Provider
final currentPositionProvider = StateProvider<({int x, int y})>((ref) {
  return (x: 12, y: 12); // Start at center of 25x25 map
});

// Settings Provider
final settingsProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'soundEnabled': true,
    'notificationsEnabled': true,
    'darkTheme': true,
  };
});

// Other Players Provider (for clinic functionality)
final otherPlayersProvider = StateProvider<List<Player>>((ref) {
  return [
    Player(
      id: 'player_002',
      name: 'Sasuke_Uchiha',
      avatarUrl: 'https://ui-avatars.com/api/?name=S&background=FF6B35&color=FFFFFF&size=100',
      village: 'Willowshade Village',
      ryo: 12000,
      stats: const PlayerStats(
        level: 23,
        str: 80000,
        intl: 110000,
        spd: 180000,
        wil: 60000,
        nin: 280000,
        gen: 100000,
        buk: 85000,
        tai: 25000,
        currentHP: 2000, // Below max (2300)
        currentSP: 2300,
        currentCP: 2300,
      ),
      jutsuIds: ['chidori', 'fireball'],
      itemIds: ['kunai', 'shuriken'],
      rank: PlayerRank.genin,
    ),
    Player(
      id: 'player_003',
      name: 'Sakura_Haruno',
      avatarUrl: 'https://ui-avatars.com/api/?name=S&background=FF6B35&color=FFFFFF&size=100',
      village: 'Willowshade Village',
      ryo: 8000,
      stats: const PlayerStats(
        level: 20,
        str: 60000,
        intl: 90000,
        spd: 120000,
        wil: 80000,
        nin: 200000,
        gen: 150000,
        buk: 60000,
        tai: 30000,
        currentHP: 1500, // Below max (2000)
        currentSP: 2000,
        currentCP: 2000,
      ),
      jutsuIds: ['healing_jutsu'],
      itemIds: ['medical_kit'],
      rank: PlayerRank.genin,
    ),
    Player(
      id: 'player_004',
      name: 'Kakashi_Hatake',
      avatarUrl: 'https://ui-avatars.com/api/?name=K&background=FF6B35&color=FFFFFF&size=100',
      village: 'Willowshade Village',
      ryo: 25000,
      stats: const PlayerStats(
        level: 35,
        str: 150000,
        intl: 200000,
        spd: 250000,
        wil: 180000,
        nin: 400000,
        gen: 300000,
        buk: 200000,
        tai: 150000,
        currentHP: 3500, // Below max (4000)
        currentSP: 4000,
        currentCP: 4000,
      ),
      jutsuIds: ['lightning_blade', 'sharingan'],
      itemIds: ['kunai', 'book'],
      rank: PlayerRank.jonin,
    ),
    Player(
      id: 'player_005',
      name: 'Hinata_Hyuga',
      avatarUrl: 'https://ui-avatars.com/api/?name=H&background=FF6B35&color=FFFFFF&size=100',
      village: 'Willowshade Village',
      ryo: 10000,
      stats: const PlayerStats(
        level: 22,
        str: 70000,
        intl: 120000,
        spd: 160000,
        wil: 70000,
        nin: 250000,
        gen: 120000,
        buk: 70000,
        tai: 40000,
        currentHP: 2200, // At max (2200)
        currentSP: 2200,
        currentCP: 2200,
      ),
      jutsuIds: ['byakugan', 'gentle_fist'],
      itemIds: ['kunai'],
      rank: PlayerRank.genin,
    ),
  ];
});