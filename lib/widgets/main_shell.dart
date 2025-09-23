import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/providers.dart';
import '../features/battle/battle_controller.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadChatCount = ref.watch(unreadChatCountProvider);
    final finishedTimersCount = ref.watch(finishedTimersCountProvider);
    final battleState = ref.watch(battleProvider);
    
    // Check if battle is active (has players/enemies and not ended)
    final isBattleActive = battleState.players.isNotEmpty && 
                          battleState.enemies.isNotEmpty && 
                          !battleState.isBattleEnded;

    return Scaffold(
      body: child,
      bottomNavigationBar: isBattleActive ? null : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.home, unreadChatCount),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.business, 0),
            label: 'Village',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.inventory, 0),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.map, 0),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.person, finishedTimersCount),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/village')) return 1;
    if (location.startsWith('/inventory')) return 2;
    if (location.startsWith('/map')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/village');
        break;
      case 2:
        context.go('/inventory');
        break;
      case 3:
        context.go('/map');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  Widget _buildBadgeIcon(IconData icon, int badgeCount) {
    if (badgeCount == 0) {
      return Icon(icon);
    }

    return Stack(
      children: [
        Icon(icon),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              badgeCount > 99 ? '99+' : badgeCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
