import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/config/app_locale.dart';
import 'src/core/config/supabase_config.dart';
import 'src/core/config/theme_pref.dart';
import 'src/core/providers.dart';
import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/monetization/ad_service.dart';
import 'src/features/splash/presentation/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase backend if configured with credentials
  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.publishableKey,
      );
    } catch (e) {
      debugPrint('[Supabase] Initialization error: $e');
    }
  }

  final container = ProviderContainer();
  // Kick auth init lazily off the critical path
  // ignore: unawaited_futures
  container.read(authServiceProvider).init();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DeutschyApp(),
    ),
  );
}

/// Brand constant — referenced from error dialogs and notifications.
const String appName = 'Deutschy';

/// Root widget.
///
/// Behaviour:
///  1. Mount the `SplashScreen` instantly on first frame.
///  2. When the splash finishes, swap to the GoRouter so we can route
///     to either '/auth/login' or '/home' depending on auth state.
///  3. Defer Drift open off the critical path — Drift is hydrated in
///     the background once the splash has finished.
class DeutschyApp extends ConsumerStatefulWidget {
  const DeutschyApp({super.key});

  @override
  ConsumerState<DeutschyApp> createState() => _DeutschyAppState();
}

class _DeutschyAppState extends ConsumerState<DeutschyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Kick the lazy Drift open AFTER the first frame.  Drift hydrate
    // happens in the background while the user is still enjoying the
    // splash, so the router's first paint is never blocked.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unawaited_futures
      ref.read(driftInitProvider.future).then(
        (_) {
          // ignore: unawaited_futures
          ref.read(seedBootstrapProvider.future);
        },
      );
      // Defer AdMob init until after the splash is done, so we don't
      // compete with Firebase + Drift for the main thread.
      Future.delayed(const Duration(seconds: 2), () {
        // ignore: unawaited_futures
        ref.read(adServiceProvider).init();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final routerConfig = ref.watch(goRouterProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = themeModeOf(ref.watch(themePreferenceProvider));
    return MaterialApp.router(
      routerConfig: routerConfig,
      title: 'Deutschy — Learn German',
      locale: locale,
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      scrollBehavior: const AppScrollBehavior(),
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (child, animation) {
            final slide = animation.drive(
              Tween<Offset>(
                begin: const Offset(0.0, -0.05),
                end: Offset.zero,
              ),
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
          child: _showSplash
              ? SplashScreen(
                  key: const ValueKey('splash'),
                  onCompleted: _onSplashDone,
                )
              : KeyedSubtree(
                  key: const ValueKey('content'),
                  child: child!,
                ),
        );
      },
    );
  }

  void _onSplashDone() {
    if (!mounted) return;
    setState(() => _showSplash = false);
  }
}

/// Enables mouse and trackpad drag scrolling on Web and Desktop platforms.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
