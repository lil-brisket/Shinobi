import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/player.dart';
import '../models/stats.dart';
import '../models/item.dart';
import '../models/jutsu.dart';
import '../models/equipment.dart';
import '../models/battle_history.dart';
import '../models/mission.dart';
import '../models/banking.dart';
import '../models/timer.dart';
import '../models/village.dart';
import '../data/failures.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  SupabaseClient get client => Supabase.instance.client;
  
  // Authentication methods
  Future<({String? userId, String? error})> signUp({
    required String email,
    required String password,
    required String username,
    required String villageId,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'village_id': villageId,
        },
      );
      
      if (response.user != null) {
        return (userId: response.user!.id, error: null);
      }
      return (userId: null, error: 'Failed to create user');
    } catch (e) {
      return (userId: null, error: e.toString());
    }
  }
  
  Future<({String? userId, String? error})> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return (userId: response.user!.id, error: null);
      }
      return (userId: null, error: 'Invalid credentials');
    } catch (e) {
      return (userId: null, error: e.toString());
    }
  }
  
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  User? get currentUser => client.auth.currentUser;
  
  // Player methods
  Future<({Player? player, Failure? failure})> getPlayer(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .select('''
            *,
            villages:${SupabaseConfig.villagesTable}(name, element)
          ''')
          .eq('id', playerId)
          .single();
      
      final player = _mapPlayerFromJson(response);
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to fetch player: $e'));
    }
  }
  
  Future<({Player? player, Failure? failure})> getPlayerByAuthId(String authUserId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .select('''
            *,
            villages:${SupabaseConfig.villagesTable}(name, element)
          ''')
          .eq('auth_user_id', authUserId)
          .single();
      
      final player = _mapPlayerFromJson(response);
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to fetch player: $e'));
    }
  }
  
  Future<({Player? player, Failure? failure})> updatePlayer(Player player) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .update(_mapPlayerToJson(player))
          .eq('id', player.id)
          .select()
          .single();
      
      final updatedPlayer = _mapPlayerFromJson(response);
      return (player: updatedPlayer, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to update player: $e'));
    }
  }
  
  Future<({List<Item>? items, Failure? failure})> getPlayerItems(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playerItemsTable)
          .select('''
            quantity,
            items:${SupabaseConfig.itemsTable}(*)
          ''')
          .eq('player_id', playerId);
      
      final items = response.map<Item>((item) {
        final itemData = item['items'] as Map<String, dynamic>;
        return _mapItemFromJson(itemData).copyWith(quantity: item['quantity']);
      }).toList();
      
      return (items: items, failure: null);
    } catch (e) {
      return (items: null, failure: ServerFailure('Failed to fetch items: $e'));
    }
  }
  
  Future<({List<Jutsu>? jutsus, Failure? failure})> getPlayerJutsus(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playerJutsusTable)
          .select('''
            is_equipped,
            mastery_level,
            mastery_xp,
            jutsus:${SupabaseConfig.jutsusTable}(*)
          ''')
          .eq('player_id', playerId);
      
      final jutsus = response.map<Jutsu>((jutsu) {
        final jutsuData = jutsu['jutsus'] as Map<String, dynamic>;
        return _mapJutsuFromJson(jutsuData).copyWith(
          isEquipped: jutsu['is_equipped'],
          masteryLevel: jutsu['mastery_level'],
          masteryXp: jutsu['mastery_xp'],
        );
      }).toList();
      
      return (jutsus: jutsus, failure: null);
    } catch (e) {
      return (jutsus: null, failure: ServerFailure('Failed to fetch jutsus: $e'));
    }
  }
  
  Future<({List<Village>? villages, Failure? failure})> getVillages() async {
    try {
      final response = await client
          .from(SupabaseConfig.villagesTable)
          .select('*')
          .order('name');
      
      final villages = response.map<Village>((village) => _mapVillageFromJson(village)).toList();
      return (villages: villages, failure: null);
    } catch (e) {
      return (villages: null, failure: ServerFailure('Failed to fetch villages: $e'));
    }
  }
  
  Future<({List<BattleHistory>? battles, Failure? failure})> getBattleHistory(String playerId, {int limit = 50}) async {
    try {
      final response = await client
          .from(SupabaseConfig.battleHistoryTable)
          .select('*')
          .eq('player_id', playerId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      final battles = response.map<BattleHistory>((battle) => _mapBattleHistoryFromJson(battle)).toList();
      return (battles: battles, failure: null);
    } catch (e) {
      return (battles: null, failure: ServerFailure('Failed to fetch battle history: $e'));
    }
  }
  
  Future<({bool success, Failure? failure})> addBattleHistory(BattleHistory battle) async {
    try {
      await client
          .from(SupabaseConfig.battleHistoryTable)
          .insert(_mapBattleHistoryToJson(battle));
      
      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to save battle history: $e'));
    }
  }
  
  // Banking methods
  Future<({List<Banking>? accounts, Failure? failure})> getBankingAccounts(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.bankingTable)
          .select('*')
          .eq('player_id', playerId);
      
      final accounts = response.map<Banking>((account) => _mapBankingFromJson(account)).toList();
      return (accounts: accounts, failure: null);
    } catch (e) {
      return (accounts: null, failure: ServerFailure('Failed to fetch banking accounts: $e'));
    }
  }
  
  Future<({bool success, Failure? failure})> updateBankingAccount(Banking account) async {
    try {
      await client
          .from(SupabaseConfig.bankingTable)
          .upsert(_mapBankingToJson(account));
      
      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to update banking account: $e'));
    }
  }
  
  // Timer methods
  Future<({List<Timer>? timers, Failure? failure})> getPlayerTimers(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.timersTable)
          .select('*')
          .eq('player_id', playerId)
          .eq('is_active', true);
      
      final timers = response.map<Timer>((timer) => _mapTimerFromJson(timer)).toList();
      return (timers: timers, failure: null);
    } catch (e) {
      return (timers: null, failure: ServerFailure('Failed to fetch timers: $e'));
    }
  }
  
  Future<({bool success, Failure? failure})> addTimer(Timer timer) async {
    try {
      await client
          .from(SupabaseConfig.timersTable)
          .insert(_mapTimerToJson(timer));
      
      return (success: true, failure: null);
    } catch (e) {
      return (success: false, failure: ServerFailure('Failed to add timer: $e'));
    }
  }
  
  // Helper methods for mapping data
  Player _mapPlayerFromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['username'],
      avatarUrl: json['avatar_url'] ?? '',
      village: json['villages']?['name'] ?? 'Unknown Village',
      ryo: json['ryo'],
      stats: PlayerStats(
        level: json['level'],
        str: json['str'],
        intl: json['intl'],
        spd: json['spd'],
        wil: json['wil'],
        nin: json['nin'],
        gen: json['gen'],
        buk: json['buk'],
        tai: json['tai'],
        currentHP: json['current_hp'],
        currentSP: json['current_sp'],
        currentCP: json['current_cp'],
      ),
      jutsuIds: [], // Will be loaded separately
      itemIds: [], // Will be loaded separately
      rank: PlayerRank.values.firstWhere(
        (rank) => rank.name == json['rank'],
        orElse: () => PlayerRank.genin,
      ),
      medNinja: MedicalNinjaProfession(
        level: json['med_ninja_level'],
        xp: json['med_ninja_xp'],
      ),
    );
  }
  
  Map<String, dynamic> _mapPlayerToJson(Player player) {
    return {
      'id': player.id,
      'username': player.name,
      'avatar_url': player.avatarUrl,
      'ryo': player.ryo,
      'level': player.stats.level,
      'str': player.stats.str,
      'intl': player.stats.intl,
      'spd': player.stats.spd,
      'wil': player.stats.wil,
      'nin': player.stats.nin,
      'gen': player.stats.gen,
      'buk': player.stats.buk,
      'tai': player.stats.tai,
      'current_hp': player.stats.currentHP,
      'current_sp': player.stats.currentSP,
      'current_cp': player.stats.currentCP,
      'rank': player.rank.name,
      'med_ninja_level': player.medNinja.level,
      'med_ninja_xp': player.medNinja.xp,
    };
  }
  
  Item _mapItemFromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      quantity: 1, // Will be set from player_items
      rarity: ItemRarity.values.firstWhere(
        (rarity) => rarity.name == json['rarity'],
        orElse: () => ItemRarity.common,
      ),
      effect: Map<String, dynamic>.from(json['effect'] ?? {}),
      kind: ItemKind.values.firstWhere(
        (kind) => kind.name == json['kind'],
        orElse: () => ItemKind.material,
      ),
      size: ItemSize.values.firstWhere(
        (size) => size.name == json['size'],
        orElse: () => ItemSize.small,
      ),
    );
  }
  
  Jutsu _mapJutsuFromJson(Map<String, dynamic> json) {
    return Jutsu(
      id: json['id'],
      name: json['name'],
      type: JutsuType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => JutsuType.ninjutsu,
      ),
      chakraCost: json['chakra_cost'],
      power: json['power'],
      description: json['description'],
      isEquipped: false, // Will be set from player_jutsus
      range: json['range'],
      targeting: JutsuTargeting.values.firstWhere(
        (targeting) => targeting.name == json['targeting'],
        orElse: () => JutsuTargeting.singleTarget,
      ),
      apCost: json['ap_cost'],
    );
  }
  
  Village _mapVillageFromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      element: json['element'],
    );
  }
  
  BattleHistory _mapBattleHistoryFromJson(Map<String, dynamic> json) {
    return BattleHistory(
      id: json['id'],
      playerId: json['player_id'],
      opponentName: json['opponent_name'],
      opponentType: json['opponent_type'],
      result: json['result'],
      damageDealt: json['damage_dealt'],
      damageTaken: json['damage_taken'],
      jutsusUsed: List<String>.from(json['jutsus_used'] ?? []),
      ryoEarned: json['ryo_earned'],
      xpEarned: json['xp_earned'],
      battleDuration: json['battle_duration'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> _mapBattleHistoryToJson(BattleHistory battle) {
    return {
      'id': battle.id,
      'player_id': battle.playerId,
      'opponent_name': battle.opponentName,
      'opponent_type': battle.opponentType,
      'result': battle.result,
      'damage_dealt': battle.damageDealt,
      'damage_taken': battle.damageTaken,
      'jutsus_used': battle.jutsusUsed,
      'ryo_earned': battle.ryoEarned,
      'xp_earned': battle.xpEarned,
      'battle_duration': battle.battleDuration,
    };
  }
  
  Banking _mapBankingFromJson(Map<String, dynamic> json) {
    return Banking(
      id: json['id'],
      playerId: json['player_id'],
      accountType: json['account_type'],
      balance: json['balance'],
      interestRate: (json['interest_rate'] as num).toDouble(),
      lastInterest: DateTime.parse(json['last_interest']),
    );
  }
  
  Map<String, dynamic> _mapBankingToJson(Banking banking) {
    return {
      'id': banking.id,
      'player_id': banking.playerId,
      'account_type': banking.accountType,
      'balance': banking.balance,
      'interest_rate': banking.interestRate,
      'last_interest': banking.lastInterest.toIso8601String(),
    };
  }
  
  Timer _mapTimerFromJson(Map<String, dynamic> json) {
    return Timer(
      id: json['id'],
      playerId: json['player_id'],
      timerType: json['timer_type'],
      duration: json['duration'],
      startedAt: DateTime.parse(json['started_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      isActive: json['is_active'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
  
  Map<String, dynamic> _mapTimerToJson(Timer timer) {
    return {
      'id': timer.id,
      'player_id': timer.playerId,
      'timer_type': timer.timerType,
      'duration': timer.duration,
      'started_at': timer.startedAt.toIso8601String(),
      'expires_at': timer.expiresAt.toIso8601String(),
      'is_active': timer.isActive,
      'metadata': timer.metadata,
    };
  }
}
