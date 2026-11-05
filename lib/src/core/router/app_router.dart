import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import '../config/onboarding_pref.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/vocabulary/presentation/review_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_screen.dart';
import '../../features/speaking/presentation/scenarios_screen.dart';
import '../../features/speaking/presentation/scenario_chat_screen.dart';
import '../../features/writing/presentation/writing_screen.dart';
import '../../features/grammar/presentation/grammar_screen.dart';
import '../../features/reading/presentation/reading_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/games/presentation/games_home_screen.dart';
import '../../features/games/presentation/memory_match_screen.dart';
import '../../features/games/presentation/word_chain_screen.dart';
import '../../shared/widgets/app_shell.dart';

/// Go-Router configuration with auth guard.
///
/// We rebuild the router whenever the AuthService user changes so login /
/// logout transitions don't require re-launching the app.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authAsync = ref.read(currentUserProvider);
      if (authAsync.isLoading) return null;
      final user = authAsync.value;

      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      if (user == null) {
        return isAuthRoute ? null : '/auth/login';
      }

      if (isAuthRoute) return '/';

      final onboarding = ref.read(onboardingPrefsProvider);
      final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
      if (!onboarding.shown) {
        return isOnboardingRoute ? null : '/onboarding';
      }
      if (isOnboardingRoute) return '/';

      return null;
    },
    refreshListenable: _AuthListenable(ref),
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/home'),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, _) => const LoginScreen(),
      ),
      // Top-level Games routes (full-screen, no bottom-nav).
      GoRoute(
        path: '/games',
        builder: (_, _) => const GamesHomeScreen(),
      ),
      GoRoute(
        path: '/games/memory-match',
        builder: (_, _) => const MemoryMatchScreen(),
      ),
      GoRoute(
        path: '/games/word-chain',
        builder: (_, _) => const WordChainScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vocabulary',
            builder: (_, _) => const VocabularyScreen(),
          ),
          GoRoute(
            path: '/vocabulary/review',
            builder: (_, _) => const ReviewScreen(),
          ),
          GoRoute(
            path: '/speaking',
            builder: (_, _) => const ScenariosScreen(),
          ),
          GoRoute(
            path: '/speaking/chat/:id',
            builder: (_, state) => ScenarioChatScreen(
              scenarioId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/writing',
            builder: (_, _) => const WritingScreen(),
          ),
          GoRoute(
            path: '/grammar',
            builder: (_, _) => const GrammarScreen(),
          ),
          GoRoute(
            path: '/reading',
            builder: (_, _) => const ReadingScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Unknown route: ${state.uri}')),
    ),
  );
});

/// Bridges Riverpod's auth state into GoRouter's change-notifier API.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this.ref) {
    final subAuth = ref.listen<AsyncValue<dynamic>>(currentUserProvider, (_, _) {
      notifyListeners();
    });
    final subOnboard = ref.listen<OnboardingPrefs>(onboardingPrefsProvider, (_, _) {
      notifyListeners();
    });
    ref.onDispose(() {
      subAuth.close();
      subOnboard.close();
    });
  }
  final Ref ref;
}
