import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_models.dart';
import 'battle_formulas.dart';
import '../../controllers/providers.dart';

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
  late Random _rand;

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
    _rand = Random(config.rngSeed);
    
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
    
    state = state.copyWith(
      isMoveMode: !state.isMoveMode,
      isPunchMode: false,
      phase: state.isMoveMode ? BattlePhase.selectingAction : BattlePhase.selectingTile,
    );

    if (!state.isMoveMode) {
      _clearHighlights();
    } else {
      _highlightReachableTiles();
    }
  }

  /// Cancel current mode (move or punch)
  void cancelCurrentMode() {
    if (!state.isPlayersTurn) return;
    
    state = state.copyWith(
      isMoveMode: false,
      isPunchMode: false,
      phase: BattlePhase.selectingAction,
    );
    
    _clearHighlights();
  }

  /// Toggle punch mode
  void togglePunchMode() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final adjacentEnemies = _getAdjacentEnemies(state.activeEntityId);
    if (adjacentEnemies.isEmpty) {
      _addLog(BattleStrings.noAdjacentTargets);
      return;
    }

    state = state.copyWith(
      isPunchMode: !state.isPunchMode,
      isMoveMode: false,
      phase: state.isPunchMode ? BattlePhase.selectingAction : BattlePhase.selectingTile,
    );

    if (!state.isPunchMode) {
      _clearHighlights();
    } else {
      _highlightTargetTiles();
    }
  }

  /// Select a tile (context-sensitive based on current mode)
  void selectTile(int row, int col) {
    if (state.phase != BattlePhase.selectingTile) return;

    if (state.isMoveMode) {
      _handleMoveSelection(row, col);
    } else if (state.isPunchMode) {
      _handlePunchSelection(row, col);
    }
  }

  /// Execute punch action on target
  void actPunch(String targetId) {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    final target = state.allEntities.firstWhere((e) => e.id == targetId);
    
    if (activeEntity == null || !target.alive) return;

    // Check if target is adjacent
    if (!_isAdjacent(activeEntity.pos, target.pos)) {
      _addLog(BattleStrings.noAdjacentTargets);
      return;
    }

    // Check and spend AP
    if (!_spendAP(activeEntity, BalanceConfig.costPunch)) {
      _addLog('Not enough AP to punch! (Need ${BalanceConfig.costPunch} AP)');
      return;
    }

    // Calculate damage using new formula with curves and mitigation
    final damage = BattleFormulas.calcDamage(
      attacker: activeEntity,
      defender: target,
      rngIntInclusive: _rngIntInclusive,
      rngRollUnder: _rngRollUnder,
    );
    
    final newHp = max(0, target.hp - damage);
    final updatedTarget = target.copyWith(hp: newHp);
    
    _updateEntity(updatedTarget);
    
    // Record punch action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: activeEntity.id,
      action: BattleAction.punch,
      targetId: target.id,
      damage: damage,
      message: '${activeEntity.name} punched ${target.name} for $damage damage!',
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

  /// Execute heal action
  void actHeal() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check CP cost
    if (activeEntity.cp < BalanceConfig.healCpCost) {
      _addLog(BattleStrings.notEnoughCp);
      return;
    }

    // Check and spend AP
    if (!_spendAP(activeEntity, BalanceConfig.costHeal)) {
      _addLog('Not enough AP to heal! (Need ${BalanceConfig.costHeal} AP)');
      return;
    }

    // Calculate heal amount using new formula
    final healAmount = BattleFormulas.calcHeal(
      caster: activeEntity,
      rngIntInclusive: _rngIntInclusive,
    );
    
    final newHp = min(activeEntity.hpMax, activeEntity.hp + healAmount);
    final newCp = max(0, activeEntity.cp - BalanceConfig.healCpCost);
    
    final updatedEntity = activeEntity.copyWith(hp: newHp, cp: newCp);
    _updateEntity(updatedEntity);
    
    // Record heal action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: activeEntity.id,
      action: BattleAction.heal,
      heal: healAmount,
      message: '${activeEntity.name} healed for $healAmount HP!',
    ));
    
    _endTurn();
  }

  /// Execute flee action
  void actFlee() {
    if (!state.isPlayersTurn || state.phase != BattlePhase.selectingAction) return;
    
    final activeEntity = state.activeEntity;
    if (activeEntity == null) return;

    // Check and spend AP
    if (!_spendAP(activeEntity, BalanceConfig.costFlee)) {
      _addLog('Not enough AP to flee! (Need ${BalanceConfig.costFlee} AP)');
      return;
    }

    // Calculate flee chance using new formula
    final fleeChance = BattleFormulas.calcFleeChance(
      fleeEntity: activeEntity,
      enemies: state.livingEnemies,
    );
    
    final success = _rngRollUnder(fleeChance);

    if (success) {
      // Record successful flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: activeEntity.id,
        action: BattleAction.flee,
        message: '${activeEntity.name} successfully fled!',
      ));
      
      state = state.copyWith(phase: BattlePhase.ended);
      _endCurrentRound(); // Close the current round
    } else {
      // Record failed flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: activeEntity.id,
        action: BattleAction.flee,
        message: '${activeEntity.name} failed to flee!',
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
      final random = Random(state.rngSeed + state.log.length);
      if (random.nextDouble() < 0.05) {
        _actFleeInternal(enemy);
        return;
      }
    }

    // Check if adjacent to a player - punch the weakest
    final adjacentPlayers = _getAdjacentEnemies(enemy.id)
        .where((e) => e.isPlayerControlled)
        .toList();
    
    if (adjacentPlayers.isNotEmpty) {
      // Find weakest adjacent player
      final weakest = adjacentPlayers.reduce((a, b) => a.hp < b.hp ? a : b);
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
      final newAdjacentPlayers = _getAdjacentEnemies(updatedEnemy.id)
          .where((e) => e.isPlayerControlled)
          .toList();
      
      if (newAdjacentPlayers.isNotEmpty) {
        final weakest = newAdjacentPlayers.reduce((a, b) => a.hp < b.hp ? a : b);
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

    // Check and spend AP
    if (!_spendAP(activeEntity, BalanceConfig.costMove)) {
      _addLog('Not enough AP to move! (Need ${BalanceConfig.costMove} AP)');
      return;
    }

    // Get the updated entity after spending AP
    final updatedEntity = state.activeEntity;
    if (updatedEntity == null) return;

    _moveEntity(updatedEntity, Position(row: row, col: col));
    _clearHighlights();
    
    state = state.copyWith(
      isMoveMode: false,
      phase: BattlePhase.selectingAction,
    );
  }

  /// Handle punch selection
  void _handlePunchSelection(int row, int col) {
    final tile = state.tiles[row][col];
    if (tile.entityId == null) return;

    final target = state.allEntities.firstWhere((e) => e.id == tile.entityId);
    // Can only punch enemies (not player controlled) and not yourself
    if (target.isPlayerControlled || target.id == state.activeEntityId) return;

    actPunch(target.id);
    _clearHighlights();
    
    state = state.copyWith(
      isPunchMode: false,
      phase: BattlePhase.selectingAction,
    );
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
    final entity = state.allEntities.firstWhere((e) => e.id == entityId);
    final adjacent = <Entity>[];

    // Check all 4 directions
    final directions = [
      Position(row: -1, col: 0), // Up
      Position(row: 1, col: 0),  // Down
      Position(row: 0, col: -1), // Left
      Position(row: 0, col: 1),  // Right
    ];

    for (final dir in directions) {
      final checkPos = Position(row: entity.pos.row + dir.row, col: entity.pos.col + dir.col);
      
      if (checkPos.row >= 0 && checkPos.row < state.rows &&
          checkPos.col >= 0 && checkPos.col < state.cols) {
        
        final tile = state.tiles[checkPos.row][checkPos.col];
        if (tile.entityId != null) {
          final adjacentEntity = state.allEntities.firstWhere((e) => e.id == tile.entityId);
          if (adjacentEntity.alive && adjacentEntity.isPlayerControlled != entity.isPlayerControlled) {
            adjacent.add(adjacentEntity);
          }
        }
      }
    }

    return adjacent;
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
    final adjacentEnemies = _getAdjacentEnemies(state.activeEntityId);
    final newTiles = List<List<Tile>>.from(state.tiles);

    for (final enemy in adjacentEnemies) {
      newTiles[enemy.pos.row][enemy.pos.col] = newTiles[enemy.pos.row][enemy.pos.col]
          .copyWith(highlight: TileHighlight.target);
    }

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

  /// Spend AP for an action, returns false if insufficient AP
  bool _spendAP(Entity e, int cost) {
    if (e.ap < cost) return false;
    final updated = e.copyWith(ap: e.ap - cost);
    _updateEntity(updated);
    
    // Log AP spending
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: e.id,
      action: BattleAction.endTurn, // Using endTurn as a generic action for AP spending
      message: '${e.name} spent $cost AP (AP left: ${updated.ap}/${updated.apMax})',
    ));
    
    return true;
  }

  /// Internal punch action for AI (no player turn restriction)
  void _actPunchInternal(Entity actor, String targetId) {
    final target = state.allEntities.firstWhere((e) => e.id == targetId);
    
    if (!target.alive) return;

    // Check if target is adjacent
    if (!_isAdjacent(actor.pos, target.pos)) {
      _addLog(BattleStrings.noAdjacentTargets);
      return;
    }

    // Check and spend AP
    if (!_spendAP(actor, BalanceConfig.costPunch)) {
      _addLog('Not enough AP to punch! (Need ${BalanceConfig.costPunch} AP)');
      return;
    }

    // Calculate damage using new formula with curves and mitigation
    final damage = BattleFormulas.calcDamage(
      attacker: actor,
      defender: target,
      rngIntInclusive: _rngIntInclusive,
      rngRollUnder: _rngRollUnder,
    );
    
    final newHp = max(0, target.hp - damage);
    final updatedTarget = target.copyWith(hp: newHp);
    
    _updateEntity(updatedTarget);
    
    // Record punch action
    _recordEntry(BattleLogEntry(
      ts: DateTime.now(),
      round: state.roundNumber,
      turnIndex: state.turnIndexInRound,
      actorId: actor.id,
      action: BattleAction.punch,
      targetId: target.id,
      damage: damage,
      message: '${actor.name} punched ${target.name} for $damage damage!',
    ));

    // Check if target died
    if (!updatedTarget.alive) {
      _removeEntityFromTile(updatedTarget);
      
      // Record defeat
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: actor.id,
        action: BattleAction.punch,
        targetId: target.id,
        message: '${target.name} was defeated!',
      ));
    }

    _endTurn();
  }

  /// Internal flee action for AI (no player turn restriction)
  void _actFleeInternal(Entity actor) {
    // Check and spend AP
    if (!_spendAP(actor, BalanceConfig.costFlee)) {
      _addLog('Not enough AP to flee! (Need ${BalanceConfig.costFlee} AP)');
      return;
    }

    // Calculate flee chance using new formula
    final fleeChance = BattleFormulas.calcFleeChance(
      fleeEntity: actor,
      enemies: state.livingEnemies,
    );
    
    final success = _rngRollUnder(fleeChance);

    if (success) {
      // Record successful flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: actor.id,
        action: BattleAction.flee,
        message: '${actor.name} successfully fled!',
      ));
      
      state = state.copyWith(phase: BattlePhase.ended);
      _endCurrentRound(); // Close the current round
    } else {
      // Record failed flee
      _recordEntry(BattleLogEntry(
        ts: DateTime.now(),
        round: state.roundNumber,
        turnIndex: state.turnIndexInRound,
        actorId: actor.id,
        action: BattleAction.flee,
        message: '${actor.name} failed to flee!',
      ));
      
      _endTurn();
    }
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
      cp: 0,
      cpMax: 0,
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
      cp: 0,
      cpMax: 0,
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
