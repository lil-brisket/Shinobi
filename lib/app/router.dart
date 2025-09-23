import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/start_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/village_hub/village_hub_screen.dart';
import '../screens/village_hub/training_dojo_screen.dart';
import '../screens/village_hub/item_shop_screen.dart';
import '../screens/village_hub/hospital_screen.dart';
import '../screens/village_hub/clan_hall_screen.dart';
import '../screens/clan/clan_page.dart';
import '../screens/village_hub/bank_screen.dart';
import '../screens/village_hub/battle_grounds_screen.dart';
import '../screens/village_hub/mission_centre_screen.dart';
import '../screens/village_hub/dueling_academy_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/inventory/items_screen.dart';
import '../screens/inventory/jutsus_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/main_shell.dart';
import '../controllers/auth_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      try {
        final authState = ProviderScope.containerOf(context).read(authProvider);
        final isAuthRoute = state.uri.path.startsWith('/login') ||
            state.uri.path.startsWith('/register') ||
            state.uri.path.startsWith('/start');
        
        // If not authenticated and trying to access protected routes
        if (!authState.isAuthenticated && !isAuthRoute && state.uri.path != '/') {
          return '/start';
        }
        
        // If authenticated and on auth routes, redirect to home
        if (authState.isAuthenticated && isAuthRoute) {
          return '/home';
        }
        return null;
      } catch (e) {
        print('DEBUG ROUTER: Error accessing auth state: $e');
        // If there's an error accessing auth state, redirect to start
        return '/start';
      }
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/start',
        name: 'start',
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Protected Game Routes (inside shell)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/village',
            name: 'village',
            builder: (context, state) => const VillageHubScreen(),
            routes: [
              GoRoute(
                path: 'training-dojo',
                name: 'training-dojo',
                builder: (context, state) => const TrainingDojoScreen(),
              ),
              GoRoute(
                path: 'item-shop',
                name: 'item-shop',
                builder: (context, state) => const ItemShopScreen(),
              ),
              GoRoute(
                path: 'hospital',
                name: 'hospital',
                builder: (context, state) => const HospitalScreen(),
              ),
              GoRoute(
                path: 'clan-hall',
                name: 'clan-hall',
                builder: (context, state) => const ClanHallScreen(),
              ),
              GoRoute(
                path: 'clan',
                name: 'clan',
                builder: (context, state) => const ClanPage(),
              ),
              GoRoute(
                path: 'bank',
                name: 'bank',
                builder: (context, state) => const BankScreen(),
              ),
              GoRoute(
                path: 'battle-grounds',
                name: 'battle-grounds',
                builder: (context, state) => const BattleGroundsScreen(),
              ),
              GoRoute(
                path: 'mission-centre',
                name: 'mission-centre',
                builder: (context, state) => const MissionCentreScreen(),
              ),
              GoRoute(
                path: 'dueling-academy',
                name: 'dueling-academy',
                builder: (context, state) => const DuelingAcademyScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            builder: (context, state) => const InventoryScreen(),
            routes: [
              GoRoute(
                path: 'items',
                name: 'inventory-items',
                builder: (context, state) => const ItemsScreen(),
              ),
              GoRoute(
                path: 'jutsus',
                name: 'inventory-jutsus',
                builder: (context, state) => const JutsusScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
