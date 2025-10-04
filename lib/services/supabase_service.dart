import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/player.dart' as player_model;
import '../models/stats.dart';
import '../models/item.dart';
import '../models/jutsu.dart';
import '../models/equipment.dart';
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
      print('Supabase signUp called with email: $email, username: $username, villageId: $villageId');
      
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'village_id': villageId,
          'display_name': username, // Set display name in user metadata
        },
        emailRedirectTo: null, // Disable email confirmation for development
      );
      
      print('Supabase signUp response: user=${response.user?.id}, session=${response.session?.accessToken}, emailConfirmed=${response.user?.emailConfirmedAt}');
      
      if (response.user != null) {
        // Check if email confirmation is required
        if (response.user!.emailConfirmedAt == null) {
          print('Email confirmation required for user: ${response.user!.id}');
          // For development, we'll still proceed with user creation
          // In production, you might want to handle this differently
        }
        return (userId: response.user!.id, error: null);
      }
      return (userId: null, error: 'Failed to create user');
    } catch (e) {
      print('Supabase signUp error: $e');
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
  Future<({player_model.Player? player, Failure? failure})> getPlayer(String playerId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .select('''
            *,
            villages:${SupabaseConfig.villagesTable}(name, element)
          ''')
          .eq('id', playerId)
          .single();
      
      final player = mapPlayerFromJson(response);
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to fetch player: $e'));
    }
  }
  
  Future<({player_model.Player? player, Failure? failure})> getPlayerByAuthId(String authUserId) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .select('''
            *,
            villages:${SupabaseConfig.villagesTable}(name, element)
          ''')
          .eq('auth_user_id', authUserId)
          .single();
      
      final player = mapPlayerFromJson(response);
      return (player: player, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to fetch player: $e'));
    }
  }
  
  Future<({player_model.Player? player, Failure? failure})> updatePlayer(player_model.Player player) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .update(mapPlayerToJson(player))
          .eq('id', player.id)
          .select()
          .single();
      
      final updatedPlayer = mapPlayerFromJson(response);
      return (player: updatedPlayer, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to update player: $e'));
    }
  }

  Future<({player_model.Player? player, Failure? failure})> createPlayer(player_model.Player player) async {
    try {
      final response = await client
          .from(SupabaseConfig.playersTable)
          .insert(mapPlayerToJson(player))
          .select()
          .single();
      
      final createdPlayer = mapPlayerFromJson(response);
      return (player: createdPlayer, failure: null);
    } catch (e) {
      return (player: null, failure: ServerFailure('Failed to create player: $e'));
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
  
  // TODO: Implement battle history methods when models are properly defined
  // Future<({List<battle_history.BattleHistory>? battles, Failure? failure})> getBattleHistory(String playerId, {int limit = 50}) async {
  //   // Implementation pending
  // }
  
  // TODO: Implement banking methods when models are properly defined
  // Future<({List<banking.Banking>? accounts, Failure? failure})> getBankingAccounts(String playerId) async {
  //   // Implementation pending
  // }
  
  // TODO: Implement timer methods when models are properly defined
  // Future<({List<timer.Timer>? timers, Failure? failure})> getPlayerTimers(String playerId) async {
  //   // Implementation pending
  // }
  
  // Helper methods for mapping data
  player_model.Player mapPlayerFromJson(Map<String, dynamic> json) {
    return player_model.Player(
      id: json['id'], // Use the database-generated player ID
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
      rank: player_model.PlayerRank.values.firstWhere(
        (rank) => rank.name == json['rank'],
        orElse: () => player_model.PlayerRank.genin,
      ),
      medNinja: player_model.MedicalNinjaProfession(
        level: json['med_ninja_level'],
        xp: json['med_ninja_xp'],
      ),
    );
  }
  
  Map<String, dynamic> mapPlayerToJson(player_model.Player player) {
    return {
      // Don't set 'id' - let the database generate it
      'auth_user_id': player.id, // This should be the Supabase auth user ID
      'username': player.name,
      'email': '', // Will be set from auth user data
      'avatar_url': player.avatarUrl,
      'village_id': '550e8400-e29b-41d4-a716-446655440001', // Default to Willowshade Village
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
      emblem: json['emblem'] ?? '🏘️',
      tileX: json['tileX'] ?? 0,
      tileY: json['tileY'] ?? 0,
    );
  }
  
  // TODO: Implement mapping methods when models are properly defined
  // battle_history.BattleHistory _mapBattleHistoryFromJson(Map<String, dynamic> json) {
  //   // Implementation pending
  // }
  
  // banking.Banking _mapBankingFromJson(Map<String, dynamic> json) {
  //   // Implementation pending
  // }
  
  // timer.Timer _mapTimerFromJson(Map<String, dynamic> json) {
  //   // Implementation pending
  // }
}
