import 'dart:collection';

/// Battle phase enum
enum BattlePhase {
  selectingAction,
  selectingTile,
  resolving,
  ended,
}

/// Tile highlight types
enum TileHighlight {
  none,
  move,
  target,
  blocked,
}

/// Battle action types for logging
enum BattleAction {
  move,
  punch,
  heal,
  flee,
  endTurn,
  startRound,
  endRound,
}

/// Dev/QA flags
const bool kShowTileCoords = true;
const bool kShowTurnDebug = false;

/// Position class for grid coordinates
class Position {
  final int row;
  final int col;

  const Position({required this.row, required this.col});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => '($row, $col)';
}

/// Battle log entry with detailed information
class BattleLogEntry {
  final DateTime ts;
  final int round;
  final int turnIndex;
  final String actorId;
  final BattleAction action;
  final String message;
  final String? targetId;
  final int? damage;
  final int? heal;
  final ({int row, int col})? fromPos;
  final ({int row, int col})? toPos;

  const BattleLogEntry({
    required this.ts,
    required this.round,
    required this.turnIndex,
    required this.actorId,
    required this.action,
    required this.message,
    this.targetId,
    this.damage,
    this.heal,
    this.fromPos,
    this.toPos,
  });

  @override
  String toString() => 'BattleLogEntry(round: $round, turn: $turnIndex, $actorId: $message)';
}

/// Summary of a round's actions and results
class RoundSummary {
  final int round;
  final Map<String, int> damageDoneByEntity;
  final Map<String, int> healingDoneByEntity;
  final List<String> defeatedEntities;
  final int actionsCount;

  const RoundSummary({
    required this.round,
    required this.damageDoneByEntity,
    required this.healingDoneByEntity,
    required this.defeatedEntities,
    required this.actionsCount,
  });

  /// Get total damage dealt in this round
  int get totalDamage => damageDoneByEntity.values.fold(0, (sum, dmg) => sum + dmg);

  /// Get total healing done in this round
  int get totalHealing => healingDoneByEntity.values.fold(0, (sum, heal) => sum + heal);

  @override
  String toString() => 'RoundSummary(round: $round, actions: $actionsCount, dmg: $totalDamage, heal: $totalHealing, KOs: ${defeatedEntities.length})';
}

/// Complete log for a single round
class RoundLog {
  final int round;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<BattleLogEntry> entries;
  final RoundSummary summary;

  const RoundLog({
    required this.round,
    required this.startedAt,
    this.endedAt,
    required this.entries,
    required this.summary,
  });

  /// Check if round is complete
  bool get isComplete => endedAt != null;

  /// Get round duration
  Duration? get duration => endedAt?.difference(startedAt);

  @override
  String toString() => 'RoundLog(round: $round, entries: ${entries.length}, complete: $isComplete)';
}

/// Entity class representing players and enemies
class Entity {
  final String id;
  final String name;
  final bool isPlayerControlled;
  final Position pos;
  final int hp;
  final int hpMax;
  final int cp;
  final int cpMax;
  final int sp;
  final int spMax;
  final int str;
  final int spd;
  final int intStat;
  final int wil; // Willpower for damage mitigation

  const Entity({
    required this.id,
    required this.name,
    required this.isPlayerControlled,
    required this.pos,
    required this.hp,
    required this.hpMax,
    required this.cp,
    required this.cpMax,
    required this.sp,
    required this.spMax,
    required this.str,
    required this.spd,
    required this.intStat,
    required this.wil,
  });

  /// Derived getter for alive status
  bool get alive => hp > 0;

  /// Copy with method for immutable updates
  Entity copyWith({
    String? id,
    String? name,
    bool? isPlayerControlled,
    Position? pos,
    int? hp,
    int? hpMax,
    int? cp,
    int? cpMax,
    int? sp,
    int? spMax,
    int? str,
    int? spd,
    int? intStat,
    int? wil,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      isPlayerControlled: isPlayerControlled ?? this.isPlayerControlled,
      pos: pos ?? this.pos,
      hp: hp ?? this.hp,
      hpMax: hpMax ?? this.hpMax,
      cp: cp ?? this.cp,
      cpMax: cpMax ?? this.cpMax,
      sp: sp ?? this.sp,
      spMax: spMax ?? this.spMax,
      str: str ?? this.str,
      spd: spd ?? this.spd,
      intStat: intStat ?? this.intStat,
      wil: wil ?? this.wil,
    );
  }

  @override
  String toString() => 'Entity($id: $name, HP: $hp/$hpMax, CP: $cp/$cpMax, Pos: $pos)';
}

/// Tile class representing a single grid cell
class Tile {
  final int row;
  final int col;
  final String? entityId;
  final TileHighlight highlight;

  const Tile({
    required this.row,
    required this.col,
    this.entityId,
    this.highlight = TileHighlight.none,
  });

  /// Copy with method for immutable updates
  Tile copyWith({
    int? row,
    int? col,
    String? entityId,
    TileHighlight? highlight,
  }) {
    return Tile(
      row: row ?? this.row,
      col: col ?? this.col,
      entityId: entityId ?? this.entityId,
      highlight: highlight ?? this.highlight,
    );
  }

  /// Check if tile is empty
  bool get isEmpty => entityId == null;

  @override
  String toString() => 'Tile($row, $col, entity: $entityId, highlight: $highlight)';
}

/// Main battle state class
class BattleState {
  final int rows;
  final int cols;
  final List<List<Tile>> tiles;
  final List<Entity> players;
  final List<Entity> enemies;
  final List<String> turnOrder;
  final int currentTurnIndex;
  final String activeEntityId;
  final BattlePhase phase;
  final List<String> log;
  final int rngSeed;
  final bool isMoveMode;
  final bool isPunchMode;
  final int moveRange;
  
  // Round-based logging
  final int roundNumber;
  final int turnIndexInRound;
  final List<RoundLog> rounds;

  const BattleState({
    required this.rows,
    required this.cols,
    required this.tiles,
    required this.players,
    required this.enemies,
    required this.turnOrder,
    required this.currentTurnIndex,
    required this.activeEntityId,
    required this.phase,
    required this.log,
    required this.rngSeed,
    this.isMoveMode = false,
    this.isPunchMode = false,
    this.moveRange = 3,
    this.roundNumber = 1,
    this.turnIndexInRound = 0,
    this.rounds = const [],
  });

  /// Get all entities (players + enemies)
  List<Entity> get allEntities => [...players, ...enemies];

  /// Get current active entity
  Entity? get activeEntity => allEntities.where((e) => e.id == activeEntityId).firstOrNull;

  /// Check if it's a player's turn
  bool get isPlayersTurn => activeEntity?.isPlayerControlled ?? false;

  /// Check if battle is over
  bool get isBattleEnded => phase == BattlePhase.ended;

  /// Get all living entities
  List<Entity> get livingEntities => allEntities.where((e) => e.alive).toList();

  /// Get all living players
  List<Entity> get livingPlayers => players.where((e) => e.alive).toList();

  /// Get all living enemies
  List<Entity> get livingEnemies => enemies.where((e) => e.alive).toList();

  /// Check if battle should end (no living players or enemies)
  bool get shouldEndBattle => livingPlayers.isEmpty || livingEnemies.isEmpty;

  /// Copy with method for immutable updates
  BattleState copyWith({
    int? rows,
    int? cols,
    List<List<Tile>>? tiles,
    List<Entity>? players,
    List<Entity>? enemies,
    List<String>? turnOrder,
    int? currentTurnIndex,
    String? activeEntityId,
    BattlePhase? phase,
    List<String>? log,
    int? rngSeed,
    bool? isMoveMode,
    bool? isPunchMode,
    int? moveRange,
    int? roundNumber,
    int? turnIndexInRound,
    List<RoundLog>? rounds,
  }) {
    return BattleState(
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      tiles: tiles ?? this.tiles,
      players: players ?? this.players,
      enemies: enemies ?? this.enemies,
      turnOrder: turnOrder ?? this.turnOrder,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      activeEntityId: activeEntityId ?? this.activeEntityId,
      phase: phase ?? this.phase,
      log: log ?? this.log,
      rngSeed: rngSeed ?? this.rngSeed,
      isMoveMode: isMoveMode ?? this.isMoveMode,
      isPunchMode: isPunchMode ?? this.isPunchMode,
      moveRange: moveRange ?? this.moveRange,
      roundNumber: roundNumber ?? this.roundNumber,
      turnIndexInRound: turnIndexInRound ?? this.turnIndexInRound,
      rounds: rounds ?? this.rounds,
    );
  }

  @override
  String toString() => 'BattleState(phase: $phase, active: $activeEntityId, turn: ${currentTurnIndex + 1}/${turnOrder.length})';
}

/// Battle configuration for seeding
class BattleConfig {
  final List<Entity> players;
  final List<Entity> enemies;
  final int rows;
  final int cols;
  final int rngSeed;

  const BattleConfig({
    required this.players,
    required this.enemies,
    this.rows = 5,
    this.cols = 12,
    this.rngSeed = 42,
  });
}

/// Battle strings for localization
class BattleStrings {
  static const String battleTitle = 'Battle';
  static const String yourTurn = 'Your Turn';
  static const String enemyTurn = 'Enemy Turn';
  static const String move = 'Move';
  static const String punch = 'Punch';
  static const String heal = 'Heal';
  static const String flee = 'Flee';
  static const String endTurn = 'End Turn';
  static const String victory = 'Victory!';
  static const String defeat = 'Defeat!';
  static const String fled = 'Fled!';
  static const String notEnoughCp = 'Not enough CP to heal!';
  static const String noAdjacentTargets = 'No adjacent enemies to punch!';
  static const String fleeFailed = 'Flee attempt failed!';
  static const String punchDamage = 'deals damage to';
  static const String healAmount = 'heals for';
  static const String defeated = 'defeated';
  static const String movedTo = 'moved to';
  static const String hp = 'HP';
  static const String cp = 'CP';
  static const String debugMode = 'Debug Mode';
  static const String cancel = 'Cancel';
}
