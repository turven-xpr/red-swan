import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/onboarding_pref.dart';
import '../../core/theme/app_theme.dart';
import '../../features/monetization/ad_widgets.dart';

/// Persistent shell with top bar (Streak + Level + XP) and bottom navigation (Study, Tests, AI Tutor, Profile).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const List<_TabSpec> _tabs = [
    _TabSpec(
      route: '/study',
      label: 'Study',
      icon: Icons.school_outlined,
      activeIcon: Icons.school_rounded,
    ),
    _TabSpec(
      route: '/tests',
      label: 'Tests',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
    ),
    _TabSpec(
      route: '/ai-tutor',
      label: 'AI Tutor',
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
    ),
    _TabSpec(
      route: '/profile',
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  int get _currentIndex {
    final loc = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    final i = _tabs.indexWhere((t) => loc.startsWith(t.route));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    final index = _currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onboarding = ref.watch(onboardingPrefsProvider);
    final levelCode = onboarding.startLevel?.name.toUpperCase() ?? 'A0';

    // Show top streak navbar on main tabs
    final isMainTab = _tabs.any((t) => loc == t.route || loc == '${t.route}/');

    return BackButtonListener(
      onBackButtonPressed: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return true;
        }
        if (loc != '/study') {
          context.go('/study');
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: isMainTab
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? const Color(0xFF222228) : const Color(0xFFEFEFF4),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left: App Brand & Current Level Badge
                        Text(
                          'Deutschy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.secondary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'DE',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            levelCode,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Right: Streak Counter System Pill
                        Tooltip(
                          message: 'Daily Streak: Practice every day to build your streak!',
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔥 Streak active! Keep learning daily to extend it.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '0 d',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Right: XP Counter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⚡', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 4),
                              Text(
                                '0 XP',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
        body: widget.child,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AdsStrip(),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? const Color(0xFF222228) : const Color(0xFFEAEAEA),
            ),
            NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) {
                if (i != index) {
                  context.go(_tabs[i].route);
                }
              },
              destinations: [
                for (final t in _tabs)
                  NavigationDestination(
                    label: t.label,
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.activeIcon),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({
    required this.route,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String route;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
