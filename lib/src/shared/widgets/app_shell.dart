import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/strings.dart';
import '../../core/i18n/translations.dart';
import '../../features/monetization/ad_widgets.dart';

/// Persistent shell with bottom navigation.  Includes all primary
/// feature routes so the user can always navigate back to a known
/// screen when inside a sub-route (e.g. /reading or /profile).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  List<_TabSpec> _tabsFor(BuildContext context) => [
        _TabSpec(
          route: '/home',
          label: t(context, Str.navHome),
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        _TabSpec(
          route: '/vocabulary',
          label: t(context, Str.navVocab),
          icon: Icons.style_outlined,
          activeIcon: Icons.style,
        ),
        _TabSpec(
          route: '/speaking',
          label: t(context, Str.navSpeaking),
          icon: Icons.record_voice_over_outlined,
          activeIcon: Icons.record_voice_over,
        ),
        _TabSpec(
          route: '/writing',
          label: t(context, Str.navWriting),
          icon: Icons.edit_note_outlined,
          activeIcon: Icons.edit_note,
        ),
        _TabSpec(
          route: '/more',
          label: t(context, Str.navMore),
          icon: Icons.more_horiz_outlined,
          activeIcon: Icons.more_horiz,
        ),
      ];

  int get _currentIndex {
    final tabs = _tabsFor(context);
    final loc = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    if (loc.startsWith('/grammar') ||
        loc.startsWith('/reading') ||
        loc.startsWith('/profile')) {
      return 4; // More tab
    }
    final i = tabs.indexWhere((t) => loc.startsWith(t.route));
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
    final tabs = _tabsFor(context);
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return true;
        }
        if (loc.startsWith('/speaking/chat/')) {
          context.go('/speaking');
          return true;
        } else if (loc.startsWith('/vocabulary/review')) {
          context.go('/vocabulary');
          return true;
        } else if (index != 0 || loc != '/home') {
          context.go('/home');
          return true;
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(child: widget.child),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AdsStrip(),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.4),
            ),
            NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) {
                if (i != index) {
                  if (tabs[i].route == '/more') {
                    _showMoreMenu(context);
                  } else {
                    context.go(tabs[i].route);
                  }
                }
              },
              destinations: [
                for (final t in tabs)
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

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(t(context, Str.navGrammar)),
              onTap: () {
                Navigator.pop(context);
                context.go('/grammar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(t(context, Str.navReading)),
              onTap: () {
                Navigator.pop(context);
                context.go('/reading');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(t(context, Str.navProfile)),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
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
