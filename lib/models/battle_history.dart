import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Represents a complete battle history entry
class BattleHistoryEntry {
  final String id;
  final DateTime battleDate;
  final String result; // 'victory', 'defeat', 'fled'
  final int rounds;
  final int totalActions;
  final int totalDamage;
  final int totalHealing;
  final List<String> participants;
  final List<String> survivors;
  final Map<String, dynamic> battleLog; // Serialized battle data

  const BattleHistoryEntry({
    required this.id,
    required this.battleDate,
    required this.result,
    required this.rounds,
    required this.totalActions,
    required this.totalDamage,
    required this.totalHealing,
    required this.participants,
    required this.survivors,
    required this.battleLog,
  });

  /// Create from battle state
  factory BattleHistoryEntry.fromBattleState(
    String battleId,
    DateTime battleDate,
    String result,
    Map<String, dynamic> battleStateData,
  ) {
    final battleState = battleStateData;
    final rounds = battleState['rounds'] as List<dynamic>? ?? [];
    final participants = <String>[];
    final survivors = <String>[];
    int totalDamage = 0;
    int totalHealing = 0;
    int totalActions = 0;

    // Extract participants and calculate totals
    if (rounds.isNotEmpty) {
      for (final round in rounds) {
        final summary = round['summary'] as Map<String, dynamic>? ?? {};
        totalActions += summary['actionsCount'] as int? ?? 0;
        
        final damageMap = summary['damageDoneByEntity'] as Map<String, dynamic>? ?? {};
        totalDamage += damageMap.values.fold(0, (sum, dmg) => sum + (dmg as int? ?? 0));
        
        final healingMap = summary['healingDoneByEntity'] as Map<String, dynamic>? ?? {};
        totalHealing += healingMap.values.fold(0, (sum, heal) => sum + (heal as int? ?? 0));
      }
    }

    // Extract participants from players and enemies
    final players = battleState['players'] as List<dynamic>? ?? [];
    final enemies = battleState['enemies'] as List<dynamic>? ?? [];
    
    for (final player in players) {
      final playerMap = player as Map<String, dynamic>;
      participants.add(playerMap['name'] as String? ?? 'Unknown Player');
      if ((playerMap['hp'] as int? ?? 0) > 0) {
        survivors.add(playerMap['name'] as String? ?? 'Unknown Player');
      }
    }
    
    for (final enemy in enemies) {
      final enemyMap = enemy as Map<String, dynamic>;
      participants.add(enemyMap['name'] as String? ?? 'Unknown Enemy');
      if ((enemyMap['hp'] as int? ?? 0) > 0) {
        survivors.add(enemyMap['name'] as String? ?? 'Unknown Enemy');
      }
    }

    return BattleHistoryEntry(
      id: battleId,
      battleDate: battleDate,
      result: result,
      rounds: rounds.length,
      totalActions: totalActions,
      totalDamage: totalDamage,
      totalHealing: totalHealing,
      participants: participants,
      survivors: survivors,
      battleLog: battleStateData,
    );
  }

  /// Get formatted battle log entries
  List<String> get formattedBattleLog {
    final rounds = battleLog['rounds'] as List<dynamic>? ?? [];
    final log = <String>[];
    
    for (final round in rounds) {
      final roundData = round as Map<String, dynamic>;
      final roundNumber = roundData['round'] as int? ?? 0;
      final entries = roundData['entries'] as List<dynamic>? ?? [];
      
      log.add('=== Round $roundNumber ===');
      
      for (final entry in entries) {
        final entryData = entry as Map<String, dynamic>;
        final timestamp = entryData['ts'] as String? ?? '';
        final message = entryData['message'] as String? ?? '';
        final actorId = entryData['actorId'] as String? ?? '';
        
        // Format timestamp
        DateTime? entryTime;
        try {
          entryTime = DateTime.parse(timestamp);
        } catch (e) {
          entryTime = null;
        }
        
        final timeStr = entryTime != null 
            ? '${entryTime.hour.toString().padLeft(2, '0')}:${entryTime.minute.toString().padLeft(2, '0')}:${entryTime.second.toString().padLeft(2, '0')}'
            : '00:00:00';
        
        // Add actor prefix if available
        final formattedMessage = actorId.isNotEmpty 
            ? '[$timeStr] $message'
            : message;
            
        log.add(formattedMessage);
      }
      
      log.add(''); // Empty line between rounds
    }
    
    return log;
  }

  /// Get simplified battle log (just the messages)
  List<String> get simpleBattleLog {
    final rounds = battleLog['rounds'] as List<dynamic>? ?? [];
    final log = <String>[];
    
    for (final round in rounds) {
      final roundData = round as Map<String, dynamic>;
      final entries = roundData['entries'] as List<dynamic>? ?? [];
      
      for (final entry in entries) {
        final entryData = entry as Map<String, dynamic>;
        final message = entryData['message'] as String? ?? '';
        if (message.isNotEmpty) {
          log.add(message);
        }
      }
    }
    
    return log;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'battleDate': battleDate.toIso8601String(),
      'result': result,
      'rounds': rounds,
      'totalActions': totalActions,
      'totalDamage': totalDamage,
      'totalHealing': totalHealing,
      'participants': participants,
      'survivors': survivors,
      'battleLog': battleLog,
    };
  }

  factory BattleHistoryEntry.fromJson(Map<String, dynamic> json) {
    return BattleHistoryEntry(
      id: json['id'] as String,
      battleDate: DateTime.parse(json['battleDate'] as String),
      result: json['result'] as String,
      rounds: json['rounds'] as int,
      totalActions: json['totalActions'] as int,
      totalDamage: json['totalDamage'] as int,
      totalHealing: json['totalHealing'] as int,
      participants: List<String>.from(json['participants'] as List),
      survivors: List<String>.from(json['survivors'] as List),
      battleLog: json['battleLog'] as Map<String, dynamic>,
    );
  }

  @override
  String toString() {
    return 'BattleHistoryEntry(id: $id, date: $battleDate, result: $result, rounds: $rounds)';
  }
}

/// Service for managing battle history storage
class BattleHistoryService {
  static const String _storageKey = 'battle_history';
  static const int _maxHistoryEntries = 10;

  /// Save a battle to history
  static Future<void> saveBattle(BattleHistoryEntry battle) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_storageKey);
    
    List<BattleHistoryEntry> history = [];
    if (historyJson != null) {
      final List<dynamic> historyList = jsonDecode(historyJson);
      history = historyList.map((json) => BattleHistoryEntry.fromJson(json)).toList();
    }

    // Add new battle to the beginning
    history.insert(0, battle);

    // Keep only the last 10 battles
    if (history.length > _maxHistoryEntries) {
      history = history.take(_maxHistoryEntries).toList();
    }

    // Save back to storage
    final updatedHistoryJson = jsonEncode(history.map((battle) => battle.toJson()).toList());
    await prefs.setString(_storageKey, updatedHistoryJson);
  }

  /// Get battle history
  static Future<List<BattleHistoryEntry>> getBattleHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_storageKey);
    
    if (historyJson == null) {
      return [];
    }

    final List<dynamic> historyList = jsonDecode(historyJson);
    return historyList.map((json) => BattleHistoryEntry.fromJson(json)).toList();
  }

  /// Clear all battle history
  static Future<void> clearBattleHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Get battle by ID
  static Future<BattleHistoryEntry?> getBattleById(String battleId) async {
    final history = await getBattleHistory();
    try {
      return history.firstWhere((battle) => battle.id == battleId);
    } catch (e) {
      return null;
    }
  }
}
