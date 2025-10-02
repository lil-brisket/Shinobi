import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../utils/snackbar_utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const int gridSize = 20;
  static const int viewportSize = 8; // 8x8 viewport around player
  
  // Player position (starting at center)
  int playerX = 10;
  int playerY = 10;
  
  // Focus node for keyboard input
  late FocusNode _focusNode;
  
  // Continuous movement
  Timer? _movementTimer;
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  static const Duration _movementDelay = Duration(milliseconds: 100); // Faster response
  static const Duration _initialDelay = Duration(milliseconds: 200); // Initial delay before continuous movement

  // Hard-code your five village positions
  static const Map<String, Offset> villages = {
    "Willowshade": Offset(2, 3),
    "Ashpeak": Offset(15, 4),
    "Stormvale": Offset(7, 10),
    "Snowhollow": Offset(4, 16),
    "Shadowfen": Offset(12, 14),
  };

  // Check if a position is within movement range (3x3 around player)
  bool _isWithinMovementRange(int x, int y) {
    final dx = (x - playerX).abs();
    final dy = (y - playerY).abs();
    return dx <= 1 && dy <= 1 && !(dx == 0 && dy == 0);
  }

  // Move player to new position
  void _movePlayer(int x, int y) {
    if (_isWithinMovementRange(x, y)) {
      // Use setState with a callback to ensure state is updated before checking village
      setState(() {
        playerX = x;
        playerY = y;
      });
      
      // Check if player is on a village tile and auto-enter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVillageEntry();
      });
    }
  }

  // Check if player is on a village and auto-enter
  void _checkVillageEntry() {
    final villageEntry = villages.entries
        .firstWhere((e) => e.value == Offset(playerX.toDouble(), playerY.toDouble()),
            orElse: () => const MapEntry("", Offset(-1, -1)));

    if (villageEntry.key.isNotEmpty) {
      // Auto-enter village
      SnackbarUtils.showInfo(
        context,
        "Entering ${villageEntry.key}...",
      );
      // TODO: Navigate to VillageHubScreen(villageId: villageEntry.key)
    }
  }

  // Get viewport bounds (10x10 area around player)
  ({int startX, int endX, int startY, int endY}) _getViewportBounds() {
    final halfViewport = viewportSize ~/ 2;
    
    int startX = (playerX - halfViewport).clamp(0, gridSize - viewportSize);
    int endX = startX + viewportSize;
    int startY = (playerY - halfViewport).clamp(0, gridSize - viewportSize);
    int endY = startY + viewportSize;
    
    return (startX: startX, endX: endX, startY: startY, endY: endY);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _movementTimer?.cancel();
    super.dispose();
  }

  // Handle keyboard input
  KeyEventResult _handleKeyPress(FocusNode focusNode, KeyEvent event) {
    if (event is KeyDownEvent) {
      // Check if this is a movement key
      if (_isMovementKey(event.logicalKey)) {
        _pressedKeys.add(event.logicalKey);
        
        // Immediate movement on first key press
        _processMovement();
        
        // Start continuous movement after initial delay
        _startContinuousMovement();
      }
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
      if (_pressedKeys.isEmpty) {
        _stopContinuousMovement();
      }
    }

    return KeyEventResult.handled;
  }

  // Check if key is a movement key
  bool _isMovementKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.arrowUp ||
           key == LogicalKeyboardKey.arrowDown ||
           key == LogicalKeyboardKey.arrowLeft ||
           key == LogicalKeyboardKey.arrowRight ||
           key == LogicalKeyboardKey.keyW ||
           key == LogicalKeyboardKey.keyS ||
           key == LogicalKeyboardKey.keyA ||
           key == LogicalKeyboardKey.keyD;
  }

  // Start continuous movement timer
  void _startContinuousMovement() {
    _movementTimer?.cancel();
    // Use initial delay for first continuous movement, then faster repeats
    _movementTimer = Timer(_initialDelay, () {
      if (_pressedKeys.isNotEmpty) {
        _movementTimer = Timer.periodic(_movementDelay, (timer) {
          if (_pressedKeys.isNotEmpty) {
            _processMovement();
          } else {
            _stopContinuousMovement();
          }
        });
      }
    });
  }

  // Stop continuous movement timer
  void _stopContinuousMovement() {
    _movementTimer?.cancel();
    _movementTimer = null;
  }

  // Process movement based on currently pressed keys
  void _processMovement() {
    int newX = playerX;
    int newY = playerY;
    bool hasMovement = false;

    // Check for movement keys and handle combinations
    bool moveUp = _pressedKeys.contains(LogicalKeyboardKey.arrowUp) || 
                  _pressedKeys.contains(LogicalKeyboardKey.keyW);
    bool moveDown = _pressedKeys.contains(LogicalKeyboardKey.arrowDown) || 
                    _pressedKeys.contains(LogicalKeyboardKey.keyS);
    bool moveLeft = _pressedKeys.contains(LogicalKeyboardKey.arrowLeft) || 
                    _pressedKeys.contains(LogicalKeyboardKey.keyA);
    bool moveRight = _pressedKeys.contains(LogicalKeyboardKey.arrowRight) || 
                     _pressedKeys.contains(LogicalKeyboardKey.keyD);

    // Handle vertical movement
    if (moveUp && !moveDown) {
      newY = (playerY - 1).clamp(0, gridSize - 1);
      hasMovement = true;
    } else if (moveDown && !moveUp) {
      newY = (playerY + 1).clamp(0, gridSize - 1);
      hasMovement = true;
    }

    // Handle horizontal movement
    if (moveLeft && !moveRight) {
      newX = (playerX - 1).clamp(0, gridSize - 1);
      hasMovement = true;
    } else if (moveRight && !moveLeft) {
      newX = (playerX + 1).clamp(0, gridSize - 1);
      hasMovement = true;
    }

    // Check if movement is valid and within range
    if (hasMovement && _isWithinMovementRange(newX, newY)) {
      _movePlayer(newX, newY);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("World Map"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Position: $playerX, $playerY',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyPress,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bounds = _getViewportBounds();
              final tileSize = (constraints.maxWidth - 32) / viewportSize; // Account for padding
              
              return SizedBox(
                width: tileSize * viewportSize,
                height: tileSize * viewportSize,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewportSize,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: viewportSize * viewportSize,
                  itemBuilder: (context, i) {
                    final localX = i % viewportSize;
                    final localY = i ~/ viewportSize;
                    final x = bounds.startX + localX;
                    final y = bounds.startY + localY;

                    // Check if a village is here
                    final villageEntry = villages.entries
                        .firstWhere((e) => e.value == Offset(x.toDouble(), y.toDouble()),
                            orElse: () => const MapEntry("", Offset(-1, -1)));

                    final isVillage = villageEntry.key.isNotEmpty;
                    final isPlayerPosition = playerX == x && playerY == y;
                    final isWithinRange = _isWithinMovementRange(x, y);

                    return GestureDetector(
                      onTap: isWithinRange && !isPlayerPosition
                          ? () => _movePlayer(x, y)
                          : null, // No manual village entry - auto-enter only
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isPlayerPosition
                              ? Colors.blue[600] // Player position - bright blue
                              : isVillage
                                  ? Colors.amber[700] // Village - amber
                                  : isWithinRange
                                      ? Colors.green[800] // Movement range - dark green
                                      : Colors.grey[900], // Default - dark grey
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isPlayerPosition
                                ? Colors.blue[300]!
                                : isVillage
                                    ? Colors.amber[300]!
                                    : Colors.black54,
                            width: isPlayerPosition ? 2 : 0.5,
                          ),
                          boxShadow: isPlayerPosition
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Main content
                            Center(
                              child: isPlayerPosition
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : isVillage
                                      ? Text(
                                          villageEntry.key.characters.first,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        )
                                      : isWithinRange
                                          ? const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white60,
                                              size: 8,
                                            )
                                          : null,
                            ),
                            // Village indicator
                            if (isVillage)
                              Positioned(
                                top: 1,
                                right: 1,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            // Movement range indicator
                            if (isWithinRange && !isPlayerPosition)
                              Positioned(
                                bottom: 1,
                                left: 1,
                                child: Container(
                                  width: 3,
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[900],
        child: const Text(
          'Use arrow keys or WASD to move. Tap highlighted tiles to move. Walk onto villages to enter them.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
