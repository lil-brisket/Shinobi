import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_formulas.dart';
import '../../controllers/providers.dart';
import '../../models/battle_history.dart';
import '../../models/battle_costs.dart';

/// Battle controller managing game state and logic
class BattleController extends StateNotifier<BattleState> {
  BattleController() : super(_initialState);

  static final BattleState _initialState = BattleState(
    rows: 5,
    cols: 12,
    tiles: _createEmptyTiles(5, 12),
    players: [],
    enemies: [],
    turnOrder: [],
    currentTurnIndex: 0,
    activeEntityId: '',
    phase: BattlePhase.selectingAction,
    log: [],
    rngSeed: 42,
    roundNumber: 1,
    turnIndexInRound: 0,
    rounds: [],
  );

  static List<List<Tile>> _createEmptyTiles(int rows, int cols) {
    return List.generate(rows, (row) => 
      List.generate(cols, (col) => Tile(row: row, col: col)));
  }

  // RNG utilities for formulas
  late math.Random _rand;

  int _rngIntInclusive(int min, int max) {
    final r = _rand.nextInt((max - min) + 1); // inclusive
    return min + r;
  }

  bool _rngRollUnder(double p) {
    return _rand.nextDouble() < p;
  }

  /// Start a new round
  void _startNewRound() {
    final now = DateTime.now();
    final newRound = RoundLog(
      round: state.roundNumber,
      startedAt: now,
      entries: [],
      summary: RoundSummary(
        round: state.roundNumber,
        damageDoneByEntity: {},
        healingDoneByEntity: {},
        defeatedEntities: [],
        actionsCount: 0,
      ),
    );

    final newRounds = List<RoundLog>.from(state.rounds)..add(newRound);
    
    state = state.copyWith(
      rounds: newRounds,
      turnIndexInRound: 0,
    );

    // Record start round entry
    _recordEntry(BattleLogEntry(
      ts: now,
      round: state.roundNumber,
      turnIndex: 0,
      actorId: '',
      action: BattleAction.startRound,
      message: '— Round ${state.roundNumber} begins —',
    ));
  }

  /// End the current round
  void _endCurrentRound() {
    if (state.rounds.isEmpty) return;

    final now = DateTime.now();
    final currentRound = state.rounds.last;
    
    // Calculate round summary
    final summary = _calculateRoundSummary(currentRound.entries);
    
    final completedRound = RoundLog(
      round: currentRound.round,
      startedAt: currentRound.startedAt,
      endedAt: now,
      entries: currentRound.entries,
      summary: summary,
    );

    final newRounds = List<RoundLog>.from(state.rounds);
    newRounds[newRounds.length - 1] = completedRound;
    
    state = state.copyWith(rounds: newRounds);

    // Record end round entry
    _recordEntry(BattleLogEntry(
      ts: now,
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: '',
      action: BattleAction.endRound,
      message: '— Round ${state.roundNumber} ends —',
    ));
  }

  /// Calculate round summary from entries
  RoundSummary _calculateRoundSummary(List<BattleLogEntry> entries) {
    final damageDoneByEntity = <String, int>{};
    final healingDoneByEntity = <String, int>{};
    final defeatedEntities = <String>[];

    for (final entry in entries) {
      if (entry.action == BattleAction.punch && entry.damage != null) {
        damageDoneByEntity[entry.actorId] = 
            (damageDoneByEntity[entry.actorId] ?? 0) + entry.damage!;
      }
      
      if (entry.action == BattleAction.heal && entry.heal != null) {
        healingDoneByEntity[entry.actorId] = 
            (healingDoneByEntity[entry.actorId] ?? 0) + entry.heal!;
      }
      
      if (entry.message.contains('was defeated!') && entry.targetId != null) {
        defeatedEntities.add(entry.targetId!);
      }
    }

    final actionsCount = entries.where((e) => 
        e.action != BattleAction.startRound && e.action != BattleAction.endRound).length;

    return RoundSummary(
      round: state.roundNumber,
      damageDoneByEntity: damageDoneByEntity,
      healingDoneByEntity: healingDoneByEntity,
      defeatedEntities: defeatedEntities,
      actionsCount: actionsCount,
    );
  }

  /// Record a battle log entry
  void _recordEntry(BattleLogEntry entry) {
    if (state.rounds.isEmpty) return;

    final currentRound = state.rounds.last;
    final newEntries = List<BattleLogEntry>.from(currentRound.entries)..add(entry);
    
    final updatedRound = RoundLog(
      round: currentRound.round,
      startedAt: currentRound.startedAt,
      endedAt: currentRound.endedAt,
      entries: newEntries,
      summary: currentRound.summary,
    );

    final newRounds = List<RoundLog>.from(state.rounds);
    newRounds[newRounds.length - 1] = updatedRound;

    // Update legacy log (keep last 100 entries)
    final newLog = List<String>.from(state.log)..add(entry.message);
    final trimmedLog = newLog.length > 100 
        ? newLog.sublist(newLog.length - 100)
        : newLog;

    state = state.copyWith(
      rounds: newRounds,
      log: trimmedLog,
    );

    // Increment turn index only for endTurn actions
    if (entry.action == BattleAction.endTurn) {
      state = state.copyWith(turnIndexInRound: state.turnIndexInRound + 1);
    }
  }

  /// Start a new battle with given configuration
  void startBattle(BattleConfig config) {
    // Initialize RNG with the battle seed
    _rand = math.Random(config.rngSeed);
    
    final tiles = _createEmptyTiles(config.rows, config.cols);
    final allEntities = [...config.players, ...config.enemies];
    
    // Place entities on tiles
    for (final entity in allEntities) {
      tiles[entity.pos.row][entity.pos.col] = tiles[entity.pos.row][entity.pos.col]
          .copyWith(entityId: entity.id);
    }

    // Create turn order using effective speed
    final orderedEntities = BattleFormulas.calcTurnOrder(allEntities);
    final turnOrder = orderedEntities.map((e) => e.id).toList();

    final initialState = BattleState(
      rows: config.rows,
      cols: config.cols,
      tiles: tiles,
      players: config.players,
      enemies: config.enemies,
      turnOrder: turnOrder,
      currentTurnIndex: 0,
      activeEntityId: turnOrder.isNotEmpty ? turnOrder.first : '',
      phase: BattlePhase.selectingAction,
      log: ['Battle started!'],
      rngSeed: config.rngSeed,
    );

    state = initialState;
    _addLog('Battle begins!');
    
    // Start the first round
    _startNewRound();
  }

  /// Toggle move mode
  void toggleMoveMode() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    // Clear any existing mode first
    _clearHighlights();
    
    // Toggle move mode
    final newMoveMode = !state.isMoveMode;
    state = state.copyWith(
      isMoveMode: newMoveMode,
      isPunchMode: false,
      isHealMode: false,
      phase: newMoveMode ? BattlePhase.selectingTile : BattlePhase.selectingAction,
    );

    if (newMoveMode) {
      _highlightReachableTiles();
    }
  }

  /// Cancel current mode (move, punch, or heal)
  void cancelCurrentMode() {
    if (!state.isPlayersTurn) return;
    
    state = state.copyWith(
      isMoveMode: false,
      isPunchMode: false,
      isHealMode: false,
      phase: BattlePhase.selectingAction,
    );
    
    _clearHighlights();
  }

  /// Switch to a different action mode (clears current mode first)
  void switchToActionMode() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    // Clear any existing mode
    _clearHighlights();
    
    state = state.copyWith(
      isMoveMode: false,
      isPunchMode: false,
      isHealMode: false,
      phase: BattlePhase.selectingAction,
    );
  }

  /// Toggle punch mode
  void togglePunchMode() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    // Clear any existing mode first
    _clearHighlights();
    
    // Toggle punch mode
    final newPunchMode = !state.isPunchMode;
    state = state.copyWith(
      isPunchMode: newPunchMode,
      isMoveMode: false,
      isHealMode: false,
      phase: newPunchMode ? BattlePhase.selectingTile : BattlePhase.selectingAction,
    );

    if (newPunchMode) {
      _highlightPunchRange();
    }
  }

  /// Toggle heal mode
  void toggleHealMode() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    // Clear any existing mode first
    _clearHighlights();
    
    // Toggle heal mode
    final newHealMode = !state.isHealMode;
    state = state.copyWith(
      isHealMode: newHealMode,
      isMoveMode: false,
      isPunchMode: false,
      phase: newHealMode ? BattlePhase.selectingTile : BattlePhase.selectingAction,
    );

    if (newHealMode) {
      _highlightHealRange();
    }
  }

  /// Select a tile (context-sensitive based on current mode)
  void selectTile(int row, int col) {
    if (state.phase != BattlePhase.selectingTile) return;

    if (state.isMoveMode) {
      _handleMoveSelection(row, col);
    } else if (state.isPunchMode) {
      _handlePunchSelection(row, col);
    } else if (state.isHealMode) {
      _handleHealSelection(row, col);
    }
  }

  /// Execute punch action on target
  void actPunch(String targetId) {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    final target = state.allEntities.firstWhere((e) => e.id == targetId);
    
    if (activeEntity == null || !target.alive) return;

    // Check if target is within punch range (including diagonals)
    if (_euclideanDistance(activeEntity.pos, target.pos) > 2.5) {
      _addLog('Target is out of punch range!');
      return;
    }

    // Check and spend resources
    if (!activeEntity.canAfford(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp)) {
      _addLog('❌ Not enough resources for Punch (need AP:${BattleCosts.punch.ap}, CP:${BattleCosts.punch.cp}, SP:${BattleCosts.punch.sp}).');
      return;
    }
    
    final updatedActiveEntity = activeEntity.spend(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp);
    _updateEntity(updatedActiveEntity);
    _addLog('− Spent AP:${BattleCosts.punch.ap} CP:${BattleCosts.punch.cp} SP:${BattleCosts.punch.sp} for Punch.');

    // Calculate damage using new formula with curves and mitigation
    final damage = BattleFormulas.calcDamage(
      attacker: updatedActiveEntity,
      defender: target,
      rngIntInclusive: _rngIntInclusive,
      rngRollUnder: _rngRollUnder,
    );
    
    final newHp = math.max(0, target.hp - damage);
    final updatedTarget = target.copyWith(hp: newHp);
    
    _updateEntity(updatedTarget);
    
    // Record punch action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: updatedActiveEntity.id,
      action: BattleAction.punch,
      targetId: target.id,
      damage: damage,
      message: '👊 ${updatedActiveEntity.name} used Punch on ${target.name} for $damage damage!',
    ));

    // Check if target died
    if (!updatedTarget.alive) {
      _removeEntityFromTile(updatedTarget);
      
      // Record defeat
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: activeEntity.id,
        action: BattleAction.punch,
        targetId: target.id,
        message: '${target.name} was defeated!',
      ));
    }

    _endTurn();
  }

  /// Execute punch action on empty space (miss)
  void actPunchMiss(Position targetPos) {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check and spend resources
    if (!activeEntity.canAfford(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp)) {
      _addLog('❌ Not enough resources for Punch (need AP:${BattleCosts.punch.ap}, CP:${BattleCosts.punch.cp}, SP:${BattleCosts.punch.sp}).');
      return;
    }
    
    final updatedActiveEntity = activeEntity.spend(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp);
    _updateEntity(updatedActiveEntity);
    _addLog('− Spent AP:${BattleCosts.punch.ap} CP:${BattleCosts.punch.cp} SP:${BattleCosts.punch.sp} for Punch.');
    
    // Record punch miss
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: updatedActiveEntity.id,
      action: BattleAction.punch,
      message: '👊 ${updatedActiveEntity.name} punched at empty space (${targetPos.row},${targetPos.col}) - Miss!',
    ));

    _addLog('👊 ${updatedActiveEntity.name} punched at empty space - Miss!');
    _endTurn();
  }

  /// Execute heal action
  void actHeal() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check and spend resources
    if (!activeEntity.canAfford(BattleCosts.heal.ap, BattleCosts.heal.cp, BattleCosts.heal.sp)) {
      _addLog('❌ Not enough resources for Heal (need AP:${BattleCosts.heal.ap}, CP:${BattleCosts.heal.cp}, SP:${BattleCosts.heal.sp}).');
      return;
    }
    
    final updatedEntity = activeEntity.spend(BattleCosts.heal.ap, BattleCosts.heal.cp, BattleCosts.heal.sp);
    _addLog('− Spent AP:${BattleCosts.heal.ap} CP:${BattleCosts.heal.cp} SP:${BattleCosts.heal.sp} for Heal.');

    // Heal using fixed amount
    final healedEntity = updatedEntity.heal(BattleCosts.healAmount);
    _updateEntity(healedEntity);
    
    // Record heal action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: healedEntity.id,
      action: BattleAction.heal,
      heal: BattleCosts.healAmount,
      message: '✨ ${healedEntity.name} healed +${BattleCosts.healAmount} HP.',
    ));
    
    _endTurn();
  }

  /// Execute flee action
  void actFlee() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check and spend AP (flee only costs AP)
    if (activeEntity.ap < BalanceConfig.costFlee) {
      _addLog('❌ Not enough AP to flee! (Need ${BalanceConfig.costFlee} AP)');
      return;
    }
    
    final updatedEntity = activeEntity.copyWith(ap: activeEntity.ap - BalanceConfig.costFlee);
    _updateEntity(updatedEntity);
    _addLog('− Spent AP:${BalanceConfig.costFlee} for Flee.');

    // Calculate flee chance using new formula
    final fleeChance = BattleFormulas.calcFleeChance(
      fleeEntity: updatedEntity,
      enemies: state.livingEnemies,
    );
    
    final success = _rngRollUnder(fleeChance);

    if (success) {
      // Record successful flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: updatedEntity.id,
        action: BattleAction.flee,
        message: '${updatedEntity.name} successfully fled!',
      ));
      
      state = state.copyWith(phase: BattlePhase.ended);
      _endCurrentRound(); // Close the current round
    } else {
      // Record failed flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: updatedEntity.id,
        action: BattleAction.flee,
        message: '${updatedEntity.name} failed to flee!',
      ));
      
      _endTurn();
    }
  }

  /// End current turn and advance to next
  void endTurn() {
    if (!state.isPlayersTurn) return;
    _endTurn();
  }

  /// Internal method to end turn
  void _endTurn() {
    // Record end turn action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: state.activeEntityId,
      action: BattleAction.endTurn,
      message: '${state.activeEntity?.name ?? 'Unknown'} ended their turn',
    ));

    // Clear modes and highlights
    state = state.copyWith(
      isMoveMode: false,
      isPunchMode: false,
      isHealMode: false,
      phase: BattlePhase.selectingAction,
    );
    _clearHighlights();

    // Check if battle should end
    if (state.shouldEndBattle) {
      _endBattle();
      return;
    }

    _nextTurn();
  }

  /// Advance to next turn
  void nextTurn() {
    _nextTurn();
  }

  /// Internal method to advance turn
  void _nextTurn() {
    final firstLivingEntityIndex = state.turnOrder.indexWhere((id) => _isEntityAlive(id));
    var nextIndex = (state.currentTurnIndex + 1) % state.turnOrder.length;
    var nextEntityId = state.turnOrder[nextIndex];
    
    // Skip dead entities
    while (!_isEntityAlive(nextEntityId) && nextIndex != state.currentTurnIndex) {
      nextIndex = (nextIndex + 1) % state.turnOrder.length;
      nextEntityId = state.turnOrder[nextIndex];
    }

    // Check if we've cycled back to the first living entity (new round)
    final isNewRound = nextIndex == firstLivingEntityIndex && state.turnIndexInRound > 0;

    if (isNewRound) {
      // End current round and start new one
      _endCurrentRound();
      state = state.copyWith(roundNumber: state.roundNumber + 1);
      _startNewRound();
    }

    state = state.copyWith(
      currentTurnIndex: nextIndex,
      activeEntityId: nextEntityId,
    );

    // Refresh AP for the new active entity
    final newActiveEntity = state.activeEntity;
    if (newActiveEntity != null) {
      _refreshAPFor(newActiveEntity);
    }

    _addLog("${state.activeEntity?.name}'s turn");

    // Auto-play enemy turns
    if (!state.isPlayersTurn) {
      _executeEnemyTurn();
    }
  }

  /// Execute enemy AI turn
  void _executeEnemyTurn() {
    final enemy = state.activeEntity;
    if (enemy == null || enemy.isPlayerControlled) return;

    // 5% chance to flee if outnumbered by 2+
    final livingPlayers = state.livingPlayers.length;
    final livingEnemies = state.livingEnemies.length;
    
    if (livingEnemies <= livingPlayers - 2) {
      final random = math.Random(state.rngSeed + state.log.length);
      if (random.nextDouble() < 0.05) {
        _actFleeInternal(enemy);
        return;
      }
    }

    // Check if within punch range of a player - punch the weakest
    final nearbyPlayers = _getNearbyEnemies(enemy.id, 2.5)
        .where((e) => e.isPlayerControlled)
        .toList();
    
    if (nearbyPlayers.isNotEmpty) {
      // Find weakest nearby player
      final weakest = nearbyPlayers.reduce((a, b) => a.hp < b.hp ? a : b);
      _actPunchInternal(enemy, weakest.id);
      return;
    }

    // Move towards closest player
    final closestPlayer = _findClosestPlayer(enemy);
    if (closestPlayer != null) {
      _moveTowardsTarget(enemy, closestPlayer);
    }

    // After moving, check if we can punch
    final updatedEnemy = state.activeEntity;
    if (updatedEnemy != null) {
      final newNearbyPlayers = _getNearbyEnemies(updatedEnemy.id, 2.5)
          .where((e) => e.isPlayerControlled)
          .toList();
      
      if (newNearbyPlayers.isNotEmpty) {
        final weakest = newNearbyPlayers.reduce((a, b) => a.hp < b.hp ? a : b);
        _actPunchInternal(updatedEnemy, weakest.id);
        return;
      }
    }

    _endTurn();
  }

  /// Move enemy towards target player
  void _moveTowardsTarget(Entity enemy, Entity target) {
    final currentPos = enemy.pos;
    final targetPos = target.pos;
    
    // Prefer row movement first, then column
    var newRow = currentPos.row;
    var newCol = currentPos.col;
    
    if (currentPos.row != targetPos.row) {
      newRow = currentPos.row < targetPos.row 
          ? currentPos.row + 1 
          : currentPos.row - 1;
    } else if (currentPos.col != targetPos.col) {
      newCol = currentPos.col < targetPos.col 
          ? currentPos.col + 1 
          : currentPos.col - 1;
    }

    // Check if move is valid (within bounds and not occupied)
    if (_isValidMove(newRow, newCol)) {
      _moveEntity(enemy, Position(row: newRow, col: newCol));
    }
  }

  /// Find closest player to enemy
  Entity? _findClosestPlayer(Entity enemy) {
    if (state.livingPlayers.isEmpty) return null;
    
    return state.livingPlayers.reduce((a, b) {
      final distA = _manhattanDistance(enemy.pos, a.pos);
      final distB = _manhattanDistance(enemy.pos, b.pos);
      return distA < distB ? a : b;
    });
  }

  /// Calculate Manhattan distance between two positions
  int _manhattanDistance(Position a, Position b) {
    return (a.row - b.row).abs() + (a.col - b.col).abs();
  }

  /// Calculate Euclidean distance between two positions
  double _euclideanDistance(Position a, Position b) {
    final rowDiff = a.row - b.row;
    final colDiff = a.col - b.col;
    return math.sqrt(rowDiff * rowDiff + colDiff * colDiff);
  }

  /// Check if move is valid (within bounds and not occupied)
  bool _isValidMove(int row, int col) {
    if (row < 0 || row >= state.rows || col < 0 || col >= state.cols) return false;
    return state.tiles[row][col].isEmpty;
  }

  /// Move entity to new position
  void _moveEntity(Entity entity, Position newPos) {
    // Store the original position before updating
    final originalPos = entity.pos;
    
    // Update entity position first
    final updatedEntity = entity.copyWith(pos: newPos);
    
    // Update entity in the appropriate list
    final newPlayers = List<Entity>.from(state.players);
    final newEnemies = List<Entity>.from(state.enemies);

    if (updatedEntity.isPlayerControlled) {
      final index = newPlayers.indexWhere((e) => e.id == updatedEntity.id);
      if (index != -1) {
        newPlayers[index] = updatedEntity;
      }
    } else {
      final index = newEnemies.indexWhere((e) => e.id == updatedEntity.id);
      if (index != -1) {
        newEnemies[index] = updatedEntity;
      }
    }
    
    // Rebuild tiles from scratch based on all entity positions
    final newTiles = _rebuildTilesFromEntities(newPlayers, newEnemies);
    
    // Single atomic state update
    state = state.copyWith(
      tiles: newTiles,
      players: newPlayers,
      enemies: newEnemies,
    );
    
    // Record move action with correct original position
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: entity.id,
      action: BattleAction.move,
      fromPos: (row: originalPos.row, col: originalPos.col),
      toPos: (row: newPos.row, col: newPos.col),
      message: '${entity.name} moved to (${newPos.row},${newPos.col})',
    ));
  }
  
  /// Rebuild tiles from scratch based on entity positions
  List<List<Tile>> _rebuildTilesFromEntities(List<Entity> players, List<Entity> enemies) {
    // Create empty tiles
    final tiles = List.generate(state.rows, (row) => 
      List.generate(state.cols, (col) => Tile(row: row, col: col)));
    
    // Place all entities on their respective tiles
    final allEntities = [...players, ...enemies];
    for (final entity in allEntities) {
      if (entity.alive) {
        tiles[entity.pos.row][entity.pos.col] = tiles[entity.pos.row][entity.pos.col]
            .copyWith(entityId: entity.id);
      }
    }
    
    return tiles;
  }

  /// Handle move selection
  void _handleMoveSelection(int row, int col) {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check if tile is reachable
    if (!_isReachable(activeEntity.pos, Position(row: row, col: col), state.moveRange)) {
      return;
    }

    // Check if tile is empty
    if (!state.tiles[row][col].isEmpty) {
      return;
    }

    // Check and spend resources
    if (!activeEntity.canAfford(BattleCosts.move.ap, BattleCosts.move.cp, BattleCosts.move.sp)) {
      _addLog('❌ Not enough resources for Move (need AP:${BattleCosts.move.ap}, CP:${BattleCosts.move.cp}, SP:${BattleCosts.move.sp}).');
      return;
    }
    
    final updatedEntity = activeEntity.spend(BattleCosts.move.ap, BattleCosts.move.cp, BattleCosts.move.sp);
    _updateEntity(updatedEntity);
    _addLog('− Spent AP:${BattleCosts.move.ap} CP:${BattleCosts.move.cp} SP:${BattleCosts.move.sp} for Move.');

    _moveEntity(updatedEntity, Position(row: row, col: col));
    _addLog('🟦 ${updatedEntity.name} moved to ($row,$col).');
    _clearHighlights();
    
    state = state.copyWith(
      isMoveMode: false,
      phase: BattlePhase.selectingAction,
    );
  }

  /// Handle punch selection
  void _handlePunchSelection(int row, int col) {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check if the selected tile is within punch range (including diagonals)
    final distance = _euclideanDistance(activeEntity.pos, Position(row: row, col: col));
    if (distance > 2.5) {
      _addLog('Target is out of punch range!');
      return;
    }

    final tile = state.tiles[row][col];
    
    // If there's an entity on the tile, try to punch it
    if (tile.entityId != null) {
      final target = state.allEntities.firstWhere((e) => e.id == tile.entityId);
      // Can only punch enemies (not player controlled) and not yourself
      if (target.isPlayerControlled || target.id == state.activeEntityId) {
        _addLog('Cannot punch allies or yourself!');
        return;
      }
      actPunch(target.id);
    } else {
      // Punch empty space - miss but still spend resources
      actPunchMiss(Position(row: row, col: col));
    }
    
    _clearHighlights();
    
    state = state.copyWith(
      isPunchMode: false,
      phase: BattlePhase.selectingAction,
    );
  }

  /// Handle heal selection
  void _handleHealSelection(int row, int col) {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check if the selected tile is the player's own tile (0 range)
    if (activeEntity.pos.row != row || activeEntity.pos.col != col) {
      _addLog('Heal can only target yourself!');
      return;
    }

    // Check and spend resources
    if (!activeEntity.canAfford(BattleCosts.heal.ap, BattleCosts.heal.cp, BattleCosts.heal.sp)) {
      _addLog('❌ Not enough resources for Heal (need AP:${BattleCosts.heal.ap}, CP:${BattleCosts.heal.cp}, SP:${BattleCosts.heal.sp}).');
      return;
    }
    
    final updatedEntity = activeEntity.spend(BattleCosts.heal.ap, BattleCosts.heal.cp, BattleCosts.heal.sp);
    _updateEntity(updatedEntity);
    _addLog('− Spent AP:${BattleCosts.heal.ap} CP:${BattleCosts.heal.cp} SP:${BattleCosts.heal.sp} for Heal.');

    // Heal using fixed amount
    final healedEntity = updatedEntity.heal(BattleCosts.healAmount);
    _updateEntity(healedEntity);
    
    // Record heal action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: healedEntity.id,
      action: BattleAction.heal,
      heal: BattleCosts.healAmount,
      message: '✨ ${healedEntity.name} healed +${BattleCosts.healAmount} HP.',
    ));
    
    _clearHighlights();
    
    state = state.copyWith(
      isHealMode: false,
      phase: BattlePhase.selectingAction,
    );
    
    _endTurn();
  }

  /// Check if position is reachable within range
  bool _isReachable(Position from, Position to, int range) {
    return _manhattanDistance(from, to) <= range;
  }

  /// Get reachable tiles for entity
  List<Position> reachableTilesFor(String entityId, int range) {
    final entity = state.allEntities.firstWhere((e) => e.id == entityId);
    final reachable = <Position>[];

    for (int row = 0; row < state.rows; row++) {
      for (int col = 0; col < state.cols; col++) {
        if (_isReachable(entity.pos, Position(row: row, col: col), range)) {
          reachable.add(Position(row: row, col: col));
        }
      }
    }

    return reachable;
  }

  /// Get adjacent enemies
  List<Entity> adjacentEnemies(String entityId) {
    return _getAdjacentEnemies(entityId);
  }

  /// Internal method to get adjacent enemies
  List<Entity> _getAdjacentEnemies(String entityId) {
    return _getNearbyEnemies(entityId, 2.5);
  }

  /// Get enemies within a certain radius (Euclidean distance for punch range)
  List<Entity> _getNearbyEnemies(String entityId, double radius) {
    final entity = state.allEntities.firstWhere((e) => e.id == entityId);
    final nearby = <Entity>[];

    // Check all tiles within the radius
    for (int row = 0; row < state.rows; row++) {
      for (int col = 0; col < state.cols; col++) {
        final checkPos = Position(row: row, col: col);
        final distance = _euclideanDistance(entity.pos, checkPos);
        
        if (distance <= radius && distance > 0) { // Within range but not the same position
          final tile = state.tiles[row][col];
          if (tile.entityId != null) {
            final nearbyEntity = state.allEntities.firstWhere((e) => e.id == tile.entityId);
            if (nearbyEntity.alive && nearbyEntity.isPlayerControlled != entity.isPlayerControlled) {
              nearby.add(nearbyEntity);
            }
          }
        }
      }
    }

    return nearby;
  }

  /// Check if two positions are adjacent
  bool _isAdjacent(Position a, Position b) {
    return _manhattanDistance(a, b) == 1;
  }

  /// Check if entity is alive
  bool _isEntityAlive(String entityId) {
    final entity = state.allEntities.where((e) => e.id == entityId).firstOrNull;
    return entity?.alive ?? false;
  }

  /// Highlight reachable tiles for movement
  void _highlightReachableTiles() {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    final reachable = reachableTilesFor(activeEntity.id, state.moveRange);
    final newTiles = List<List<Tile>>.from(state.tiles);

    for (final pos in reachable) {
      if (newTiles[pos.row][pos.col].isEmpty) {
        newTiles[pos.row][pos.col] = newTiles[pos.row][pos.col]
            .copyWith(highlight: TileHighlight.move);
      } else {
        newTiles[pos.row][pos.col] = newTiles[pos.row][pos.col]
            .copyWith(highlight: TileHighlight.blocked);
      }
    }

    state = state.copyWith(tiles: newTiles);
  }

  /// Highlight target tiles for punching
  void _highlightTargetTiles() {
    final nearbyEnemies = _getNearbyEnemies(state.activeEntityId, 1);
    final newTiles = List<List<Tile>>.from(state.tiles);

    for (final enemy in nearbyEnemies) {
      newTiles[enemy.pos.row][enemy.pos.col] = newTiles[enemy.pos.row][enemy.pos.col]
          .copyWith(highlight: TileHighlight.target);
    }

    state = state.copyWith(tiles: newTiles);
  }

  /// Highlight all tiles within punch range
  void _highlightPunchRange() {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    final newTiles = List<List<Tile>>.from(state.tiles);

    // Highlight all tiles within punch range (1 square radius) including diagonals
    for (int row = 0; row < state.rows; row++) {
      for (int col = 0; col < state.cols; col++) {
        final distance = _euclideanDistance(activeEntity.pos, Position(row: row, col: col));
        
        if (distance <= 2.5 && distance > 0) { // Within range but not the same position (2.5 allows 2-square diagonals)
          final tile = state.tiles[row][col];
          
          if (tile.entityId != null) {
            final target = state.allEntities.firstWhere((e) => e.id == tile.entityId);
            // Highlight enemy tiles as valid targets (including diagonal enemies)
            if (!target.isPlayerControlled && target.id != activeEntity.id) {
              newTiles[row][col] = newTiles[row][col]
                  .copyWith(highlight: TileHighlight.target);
            } else {
              // Highlight ally/self tiles as invalid targets (range but can't punch)
              newTiles[row][col] = newTiles[row][col]
                  .copyWith(highlight: TileHighlight.invalid);
            }
          } else {
            // Highlight empty tiles as punchable range (can punch but will miss)
            newTiles[row][col] = newTiles[row][col]
                .copyWith(highlight: TileHighlight.range);
          }
        }
      }
    }

    state = state.copyWith(tiles: newTiles);
  }

  /// Highlight heal range (only the player's own tile)
  void _highlightHealRange() {
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    final newTiles = List<List<Tile>>.from(state.tiles);

    // Highlight only the player's own tile for healing (0 range)
    newTiles[activeEntity.pos.row][activeEntity.pos.col] = 
        newTiles[activeEntity.pos.row][activeEntity.pos.col]
            .copyWith(highlight: TileHighlight.target);

    state = state.copyWith(tiles: newTiles);
  }

  /// Clear all tile highlights
  void _clearHighlights() {
    final newTiles = List.generate(state.rows, (row) => 
      List.generate(state.cols, (col) => 
        state.tiles[row][col].copyWith(highlight: TileHighlight.none)));
    
    state = state.copyWith(tiles: newTiles);
  }

  /// Update entity in state
  void _updateEntity(Entity entity) {
    final newPlayers = List<Entity>.from(state.players);
    final newEnemies = List<Entity>.from(state.enemies);

    if (entity.isPlayerControlled) {
      final index = newPlayers.indexWhere((e) => e.id == entity.id);
      if (index != -1) newPlayers[index] = entity;
    } else {
      final index = newEnemies.indexWhere((e) => e.id == entity.id);
      if (index != -1) newEnemies[index] = entity;
    }

    state = state.copyWith(players: newPlayers, enemies: newEnemies);
  }

  /// Remove entity from tile
  void _removeEntityFromTile(Entity entity) {
    final newTiles = List<List<Tile>>.from(state.tiles);
    newTiles[entity.pos.row][entity.pos.col] = newTiles[entity.pos.row][entity.pos.col]
        .copyWith(entityId: null);
    
    state = state.copyWith(tiles: newTiles);
  }

  /// End battle
  void _endBattle() {
    String result;
    if (state.livingPlayers.isEmpty) {
      result = BattleStrings.defeat;
    } else {
      result = BattleStrings.victory;
    }

    // Close the current round if it's still open
    if (state.rounds.isNotEmpty && !state.rounds.last.isComplete) {
      _endCurrentRound();
    }

    state = state.copyWith(phase: BattlePhase.ended);
    _addLog(result);

    // Save battle to history
    _saveBattleToHistory(result);
  }

  /// Save battle to history
  Future<void> _saveBattleToHistory(String result) async {
    try {
      final battleId = DateTime.now().millisecondsSinceEpoch.toString();
      final battleDate = DateTime.now();
      
      // Convert battle state to JSON-serializable format
      final battleStateData = {
        'players': state.players.map((p) => _entityToJson(p)).toList(),
        'enemies': state.enemies.map((e) => _entityToJson(e)).toList(),
        'rounds': state.rounds.map((r) => _roundToJson(r)).toList(),
        'roundNumber': state.roundNumber,
        'log': state.log,
        'rngSeed': state.rngSeed,
      };

      final battleEntry = BattleHistoryEntry.fromBattleState(
        battleId,
        battleDate,
        result,
        battleStateData,
      );

      await BattleHistoryService.saveBattle(battleEntry);
    } catch (e) {
      // Log error but don't crash the game
      print('Failed to save battle history: $e');
    }
  }

  /// Convert entity to JSON
  Map<String, dynamic> _entityToJson(Entity entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'isPlayerControlled': entity.isPlayerControlled,
      'pos': {'row': entity.pos.row, 'col': entity.pos.col},
      'hp': entity.hp,
      'hpMax': entity.hpMax,
      'cp': entity.cp,
      'cpMax': entity.cpMax,
      'sp': entity.sp,
      'spMax': entity.spMax,
      'str': entity.str,
      'spd': entity.spd,
      'intStat': entity.intStat,
      'wil': entity.wil,
      'ap': entity.ap,
      'apMax': entity.apMax,
    };
  }

  /// Convert round to JSON
  Map<String, dynamic> _roundToJson(RoundLog round) {
    return {
      'round': round.round,
      'startedAt': round.startedAt.toIso8601String(),
      'endedAt': round.endedAt?.toIso8601String(),
      'entries': round.entries.map((e) => _entryToJson(e)).toList(),
      'summary': _summaryToJson(round.summary),
    };
  }

  /// Convert log entry to JSON
  Map<String, dynamic> _entryToJson(BattleLogEntry entry) {
    return {
      'ts': entry.ts.toIso8601String(),
      'round': entry.round,
      'turnIndex': entry.turnIndex,
      'actorId': entry.actorId,
      'action': entry.action.name,
      'message': entry.message,
      'targetId': entry.targetId,
      'damage': entry.damage,
      'heal': entry.heal,
      'fromPos': entry.fromPos != null 
          ? {'row': entry.fromPos!.row, 'col': entry.fromPos!.col}
          : null,
      'toPos': entry.toPos != null 
          ? {'row': entry.toPos!.row, 'col': entry.toPos!.col}
          : null,
    };
  }

  /// Convert summary to JSON
  Map<String, dynamic> _summaryToJson(RoundSummary summary) {
    return {
      'round': summary.round,
      'damageDoneByEntity': summary.damageDoneByEntity,
      'healingDoneByEntity': summary.healingDoneByEntity,
      'defeatedEntities': summary.defeatedEntities,
      'actionsCount': summary.actionsCount,
    };
  }

  /// Add message to battle log
  void _addLog(String message) {
    final newLog = List<String>.from(state.log)..add(message);
    state = state.copyWith(log: newLog);
  }

  /// Refresh AP for an entity at the start of their turn
  void _refreshAPFor(Entity e) {
    final refreshed = e.copyWith(ap: e.apMax);
    _updateEntity(refreshed);
    
    // Log AP refresh
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: e.id,
      action: BattleAction.endTurn, // Using endTurn as a generic action for AP refresh
      message: '${e.name}\'s AP refreshed to ${e.apMax}',
    ));
  }


  /// Internal punch action for AI (no player turn restriction)
  void _actPunchInternal(Entity actor, String targetId) {
    final target = state.allEntities.firstWhere((e) => e.id == targetId);
    
    if (!target.alive) return;

    // Check if target is within punch range (including diagonals)
    if (_euclideanDistance(actor.pos, target.pos) > 2.5) {
      _addLog('Target is out of punch range!');
      return;
    }

    // Check and spend resources
    if (!actor.canAfford(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp)) {
      _addLog('❌ Not enough resources for Punch (need AP:${BattleCosts.punch.ap}, CP:${BattleCosts.punch.cp}, SP:${BattleCosts.punch.sp}).');
      return;
    }
    
    final updatedActor = actor.spend(BattleCosts.punch.ap, BattleCosts.punch.cp, BattleCosts.punch.sp);
    _updateEntity(updatedActor);
    _addLog('− Spent AP:${BattleCosts.punch.ap} CP:${BattleCosts.punch.cp} SP:${BattleCosts.punch.sp} for Punch.');

    // Calculate damage using new formula with curves and mitigation
    final damage = BattleFormulas.calcDamage(
      attacker: updatedActor,
      defender: target,
      rngIntInclusive: _rngIntInclusive,
      rngRollUnder: _rngRollUnder,
    );
    
    final newHp = math.max(0, target.hp - damage);
    final updatedTarget = target.copyWith(hp: newHp);
    
    _updateEntity(updatedTarget);
    
    // Record punch action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: updatedActor.id,
      action: BattleAction.punch,
      targetId: target.id,
      damage: damage,
      message: '👊 ${updatedActor.name} used Punch on ${target.name} for $damage damage!',
    ));

    // Check if target died
    if (!updatedTarget.alive) {
      _removeEntityFromTile(updatedTarget);
      
      // Record defeat
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: updatedActor.id,
        action: BattleAction.punch,
        targetId: target.id,
        message: '${target.name} was defeated!',
      ));
    }

    _endTurn();
  }

  /// Internal flee action for AI (no player turn restriction)
  void _actFleeInternal(Entity actor) {
    // Check and spend AP (flee only costs AP)
    if (actor.ap < BalanceConfig.costFlee) {
      _addLog('❌ Not enough AP to flee! (Need ${BalanceConfig.costFlee} AP)');
      return;
    }
    
    final updatedActor = actor.copyWith(ap: actor.ap - BalanceConfig.costFlee);
    _updateEntity(updatedActor);
    _addLog('− Spent AP:${BalanceConfig.costFlee} for Flee.');

    // Calculate flee chance using new formula
    final fleeChance = BattleFormulas.calcFleeChance(
      fleeEntity: updatedActor,
      enemies: state.livingEnemies,
    );
    
    final success = _rngRollUnder(fleeChance);

    if (success) {
      // Record successful flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: updatedActor.id,
        action: BattleAction.flee,
        message: '${updatedActor.name} successfully fled!',
      ));
      
      state = state.copyWith(phase: BattlePhase.ended);
      _endCurrentRound(); // Close the current round
    } else {
      // Record failed flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: updatedActor.id,
        action: BattleAction.flee,
        message: '${updatedActor.name} failed to flee!',
      ));
      
      _endTurn();
    }
  }

  /// Focus on a specific enemy (for UI purposes)
  void focusEnemy(String id) {
    // For now, this is a no-op as the UI handles enemy selection
    // In the future, you could store a focusedEnemyId in state if needed
    // state = state.copyWith(focusedEnemyId: id);
  }
}

/// Provider for battle controller
final battleProvider = StateNotifierProvider<BattleController, BattleState>((ref) {
  return BattleController();
});

/// Provider for battle configuration
final battleConfigProvider = Provider<BattleConfig>((ref) {
  // Get actual player data from the player provider
  final playerData = ref.watch(playerProvider);
  
  // Calculate level-based default values
  final level = playerData.stats.level;
  final defaultHP = 500 + (level * 100); // Base 500 + 100 per level
  final defaultCP = 500 + (level * 100); // Base 500 + 100 per level  
  final defaultSP = 500 + (level * 100); // Base 500 + 100 per level
  
  final player = Entity(
    id: 'P1',
    name: playerData.name,
    isPlayerControlled: true,
    pos: const Position(row: 2, col: 2),
    hp: playerData.stats.currentHP ?? defaultHP,
    hpMax: playerData.stats.currentHP ?? defaultHP, // Assuming current values are max for now
    cp: playerData.stats.currentCP ?? defaultCP,
    cpMax: playerData.stats.currentCP ?? defaultCP, // Assuming current values are max for now
    sp: playerData.stats.currentSP ?? defaultSP,
    spMax: playerData.stats.currentSP ?? defaultSP, // Assuming current values are max for now
    str: playerData.stats.str,
    spd: playerData.stats.spd,
    intStat: playerData.stats.intl,
    wil: playerData.stats.wil,
    ap: BalanceConfig.defaultAPMax,
    apMax: BalanceConfig.defaultAPMax,
  );

  final enemies = [
    Entity(
      id: 'E1',
      name: 'Enemy 1',
      isPlayerControlled: false,
      pos: const Position(row: 2, col: 8),
      hp: 90,
      hpMax: 90,
      cp: 50,
      cpMax: 50,
      sp: 30,
      spMax: 30,
      str: 5,
      spd: 5,
      intStat: 0,
      wil: 3,
      ap: BalanceConfig.defaultAPMax,
      apMax: BalanceConfig.defaultAPMax,
    ),
    Entity(
      id: 'E2',
      name: 'Enemy 2',
      isPlayerControlled: false,
      pos: const Position(row: 1, col: 9),
      hp: 80,
      hpMax: 80,
      cp: 40,
      cpMax: 40,
      sp: 25,
      spMax: 25,
      str: 4,
      spd: 4,
      intStat: 0,
      wil: 2,
      ap: BalanceConfig.defaultAPMax,
      apMax: BalanceConfig.defaultAPMax,
    ),
  ];

  return BattleConfig(
    players: [player],
    enemies: enemies,
    rows: 5,
    cols: 12,
    rngSeed: 42,
  );
});
