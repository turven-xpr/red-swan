import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_locale.dart';
import '../../core/config/onboarding_pref.dart';
import '../../core/i18n/bidi_utils.dart';
import '../../core/i18n/strings.dart';
import '../../core/i18n/translations.dart';
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
      labelAr: 'دراسة',
      labelEs: 'Estudio',
      icon: Icons.school_outlined,
      activeIcon: Icons.school_rounded,
    ),
    _TabSpec(
      route: '/listening',
      label: 'Listening',
      labelAr: 'استماع',
      labelEs: 'Escucha',
      icon: Icons.headphones_outlined,
      activeIcon: Icons.headphones_rounded,
    ),
    _TabSpec(
      route: '/tests',
      label: 'Tests',
      labelAr: 'اختبارات',
      labelEs: 'Exámenes',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
    ),
    _TabSpec(
      route: '/ai-tutor',
      label: 'AI Tutor',
      labelAr: 'المعلم الذكي',
      labelEs: 'Tutor IA',
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
    ),
    _TabSpec(
      route: '/profile',
      label: 'Profile',
      labelAr: 'حسابي',
      labelEs: 'Perfil',
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
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale.languageCode == 'ar';
    final onboarding = ref.watch(onboardingPrefsProvider);
    final rawLevel = onboarding.startLevel?.name.toUpperCase() ?? 'INTRO';
    final levelCode = rawLevel == 'A0' ? 'INTRO' : rawLevel;

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
        backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFF7F8FA),
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
                          message: t(context, Str.streakActiveTooltip),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(t(context, Str.streakExtendedToast)),
                                  duration: const Duration(seconds: 2),
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
                                    BidiUtils.formatStreakDays(0, isArabic, locale.languageCode),
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
                                t(context, Str.xpPoints, args: ['0']),
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
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: isDark ? const Color(0xFF282C38) : const Color(0xFFE2E5EB),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    height: 70,
                    backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                    elevation: 0,
                    indicatorColor: isDark
                        ? AppColors.primary.withValues(alpha: 0.22)
                        : AppColors.primary.withValues(alpha: 0.14),
                    iconTheme: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const IconThemeData(color: AppColors.primary);
                      }
                      return IconThemeData(
                        color: isDark ? Colors.white60 : Colors.black54,
                      );
                    }),
                    labelTextStyle: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        );
                      }
                      return TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white60 : Colors.black54,
                      );
                    }),
                  ),
                  child: NavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedIndex: index,
                    onDestinationSelected: (i) {
                      if (i != index) {
                        context.go(_tabs[i].route);
                      }
                    },
                    destinations: [
                      for (final t in _tabs)
                        NavigationDestination(
                          label: t.localizedLabel(locale.languageCode),
                          icon: Icon(t.icon),
                          selectedIcon: Icon(t.activeIcon),
                        ),
                    ],
                  ),
                ),
              ),
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
    required this.labelAr,
    required this.labelEs,
    required this.icon,
    required this.activeIcon,
  });
  final String route;
  final String label;
  final String labelAr;
  final String labelEs;
  final IconData icon;
  final IconData activeIcon;

  String localizedLabel(String languageCode) {
    if (languageCode == 'ar') return labelAr;
    if (languageCode == 'es') return labelEs;
    return label;
  }
}
