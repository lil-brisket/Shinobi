import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/stats.dart';
import '../models/item.dart';
import '../models/jutsu.dart';
import '../models/mission.dart';
import '../models/clan.dart';
import '../models/village.dart';
import '../models/news.dart';
import '../models/chat.dart';
import '../models/timer.dart';
import '../constants/villages.dart';

// Player Provider
final playerProvider = StateProvider<Player>((ref) {
  return Player(
    id: 'player_001',
    name: 'Naruto_Uzumaki',
    avatarUrl: 'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=N',
    village: 'Hidden Leaf',
    ryo: 15000,
    stats: const Stats(
      hp: 850,
      maxHp: 1000,
      chakra: 920,
      maxChakra: 1200,
      stamina: 780,
      maxStamina: 900,
      attack: 450,
      defense: 380,
      speed: 520,
    ),
    jutsuIds: ['rasengan', 'shadow_clone', 'wind_style'],
    itemIds: ['kunai', 'shuriken', 'health_potion'],
    rank: PlayerRank.chunin, // Set to chunin to test village change functionality
  );
});

// Inventory Provider
final inventoryProvider = StateProvider<List<Item>>((ref) {
  return [
    const Item(
      id: 'kunai',
      name: 'Kunai',
      description: 'A versatile throwing weapon',
      icon: '🗡️',
      quantity: 15,
      rarity: ItemRarity.common,
      effect: {'damage': 25},
    ),
    const Item(
      id: 'shuriken',
      name: 'Shuriken',
      description: 'Sharp throwing star',
      icon: '⭐',
      quantity: 8,
      rarity: ItemRarity.common,
      effect: {'damage': 20},
    ),
    const Item(
      id: 'health_potion',
      name: 'Health Potion',
      description: 'Restores HP',
      icon: '🧪',
      quantity: 3,
      rarity: ItemRarity.uncommon,
      effect: {'heal': 100},
    ),
    const Item(
      id: 'chakra_pill',
      name: 'Chakra Pill',
      description: 'Restores Chakra',
      icon: '💊',
      quantity: 2,
      rarity: ItemRarity.rare,
      effect: {'chakra': 150},
    ),
    const Item(
      id: 'rare_scroll',
      name: 'Rare Scroll',
      description: 'Contains ancient knowledge',
      icon: '📜',
      quantity: 1,
      rarity: ItemRarity.epic,
      effect: {'xp': 500},
    ),
  ];
});

// Jutsus Provider
final jutsusProvider = StateProvider<List<Jutsu>>((ref) {
  return [
    const Jutsu(
      id: 'rasengan',
      name: 'Rasengan',
      type: JutsuType.ninjutsu,
      chakraCost: 80,
      power: 450,
      description: 'A powerful spinning chakra attack',
      isEquipped: true,
    ),
    const Jutsu(
      id: 'shadow_clone',
      name: 'Shadow Clone Jutsu',
      type: JutsuType.ninjutsu,
      chakraCost: 60,
      power: 300,
      description: 'Creates clones to confuse enemies',
      isEquipped: true,
    ),
    const Jutsu(
      id: 'wind_style',
      name: 'Wind Style: Great Breakthrough',
      type: JutsuType.ninjutsu,
      chakraCost: 100,
      power: 380,
      description: 'Powerful wind attack',
      isEquipped: false,
    ),
    const Jutsu(
      id: 'fireball',
      name: 'Fireball Jutsu',
      type: JutsuType.ninjutsu,
      chakraCost: 70,
      power: 320,
      description: 'Launches a ball of fire',
      isEquipped: false,
    ),
    const Jutsu(
      id: 'lightning_blade',
      name: 'Lightning Blade',
      type: JutsuType.ninjutsu,
      chakraCost: 120,
      power: 520,
      description: 'High-speed lightning attack',
      isEquipped: false,
    ),
  ];
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

// Clan Provider
final clanProvider = StateProvider<Clan?>((ref) {
  return Clan(
    id: 'clan_001',
    name: 'Uzumaki Clan',
    description: 'Ancient clan known for their sealing techniques',
    rank: 'A',
    leaderId: 'player_001',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    members: [
      ClanMember(
        id: 'player_001',
        name: 'Naruto_Uzumaki',
        rank: 'Leader',
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ClanMember(
        id: 'player_002',
        name: 'Kushina_Uzumaki',
        rank: 'Vice Leader',
        joinedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      ClanMember(
        id: 'player_003',
        name: 'Karin_Uzumaki',
        rank: 'Member',
        joinedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ],
  );
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
      avatarUrl: 'https://via.placeholder.com/40x40/FF6B35/FFFFFF?text=S',
      message: 'Anyone up for a training session?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: ChatType.global,
    ),
    ChatMessage(
      id: 'msg_002',
      senderId: 'player_003',
      senderName: 'Sakura_Haruno',
      avatarUrl: 'https://via.placeholder.com/40x40/FF6B35/FFFFFF?text=S',
      message: 'I need help with the bandit mission!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      type: ChatType.global,
    ),
    ChatMessage(
      id: 'msg_003',
      senderId: 'player_004',
      senderName: 'Kakashi_Hatake',
      avatarUrl: 'https://via.placeholder.com/40x40/FF6B35/FFFFFF?text=K',
      message: 'Great work on today\'s missions, team!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: ChatType.clan,
    ),
  ];
});

// Timer Provider for active timers with countdown functionality
final timersProvider = StateNotifierProvider<TimersNotifier, List<GameTimer>>((ref) {
  return TimersNotifier();
});

// Timer countdown provider that updates every second
final timerCountdownProvider = StreamProvider<List<GameTimer>>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return ref.read(timersProvider);
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
  TimersNotifier() : super([]);

  void addTimer(GameTimer timer) {
    state = [...state, timer];
  }

  void removeTimer(String timerId) {
    state = state.where((timer) => timer.id != timerId).toList();
  }

  void completeTimer(String timerId) {
    state = state.map((timer) {
      if (timer.id == timerId) {
        return timer.copyWith(isCompleted: true);
      }
      return timer;
    }).toList();
  }

  void updateTimer(String timerId, GameTimer updatedTimer) {
    state = state.map((timer) {
      if (timer.id == timerId) {
        return updatedTimer;
      }
      return timer;
    }).toList();
  }

  // Helper method to start a training timer
  void startTrainingTimer(String statType, Duration duration) {
    final timer = GameTimer(
      id: 'training_${statType}_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Training $statType',
      type: TimerType.training,
      startTime: DateTime.now(),
      duration: duration,
      metadata: {'statType': statType},
    );
    addTimer(timer);
  }

  // Helper method to start a mission timer
  void startMissionTimer(String missionId, String missionTitle, Duration duration) {
    final timer = GameTimer(
      id: 'mission_${missionId}_${DateTime.now().millisecondsSinceEpoch}',
      title: missionTitle,
      type: TimerType.mission,
      startTime: DateTime.now(),
      duration: duration,
      metadata: {'missionId': missionId},
    );
    addTimer(timer);
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
