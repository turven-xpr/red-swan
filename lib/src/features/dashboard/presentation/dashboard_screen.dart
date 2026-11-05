import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/animations/premium_animations.dart';
import '../../vocabulary/presentation/review_screen.dart' show pendingReviewQueueProvider;
import '../../vocabulary/presentation/streak_provider.dart';

/// Home dashboard — the canvas that ties every learning module together.
/// Today: shows greeting, streak, due-card count, and four feature tiles.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final dueCount = ref.watch(cachedDueCountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const Image(
              image: AssetImage('assets/brand/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        titleSpacing: 12,
        title: const Text('Deutschy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profil',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
        child: StaggerCascade(
          delayMs: 80,
          children: [
            // Greeting
            userAsync.when(
              data: (user) => _GreetingText(name: user?.displayName),
              loading: () => const SizedBox(height: 28),
              error: (_, _) => const Text('Willkommen'),
            ),
            const SizedBox(height: 28),

            // Today's headline KPI: cards due for review + streak
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DueTodayCard(count: dueCount),
                ),
                const SizedBox(width: 12),
                const _StreakChip(),
              ],
            ),
            const SizedBox(height: 6),
            const _PendingSyncBanner(),
            const SizedBox(height: 24),

            // Feature grid — column count adapts to window width
            // (`flutter-adaptive-design` skill).  Phone: 2 cols.  Tablet
            // (`>=600 dp`): 3 cols.  Desktop (`>=900 dp`): 4 cols.
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                // Pick a column count and aspect-ratio that work well
                // for the available horizontal real-estate.
                final int crossAxisCount;
                final double childAspect;
                if (width >= 900) {
                  crossAxisCount = 4;
                  childAspect = 1.05;
                } else if (width >= 600) {
                  crossAxisCount = 3;
                  childAspect = 1.05;
                } else {
                  crossAxisCount = 2;
                  childAspect = 1.05;
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: childAspect,
                  children: [
                _FeatureTile(
                  icon: Icons.style,
                  label: 'Vocabulary',
                  subtitle: 'SRS flashcards',
                  onTap: () => context.go('/vocabulary'),
                ),
                _FeatureTile(
                  icon: Icons.record_voice_over,
                  label: 'Speaking',
                  subtitle: 'AI scenarios',
                  onTap: () => context.go('/speaking'),
                ),
                _FeatureTile(
                  icon: Icons.edit_note,
                  label: 'Writing',
                  subtitle: 'AI correction',
                  onTap: () => context.go('/writing'),
                ),
                _FeatureTile(
                  icon: Icons.menu_book,
                  label: 'Grammar',
                  subtitle: 'Bite-sized lessons',
                  onTap: () => context.go('/grammar'),
                ),
                _FeatureTile(
                  icon: Icons.sports_esports,
                  label: 'Games',
                  subtitle: 'Memory & race',
                  onTap: () => context.go('/games'),
                ),
                _FeatureTile(
                  icon: Icons.article_outlined,
                  label: 'Reading',
                  subtitle: 'Leveled texts',
                  onTap: () => context.go('/reading'),
                ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText({required this.name});
  final String? name;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final slot = hour < 12
        ? 'Guten Morgen'
        : (hour < 18 ? 'Guten Tag' : 'Guten Abend');
    final text = name == null ? slot : '$slot, $name';
    return Text(
      text,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Reactive count of flashcards due for review.  Thin alias kept on
/// the original name for legacy code reads, backed by the cached
/// provider (which serves stub data before Drift loads).
final dueCardsCountProvider = Provider<int>(
  (ref) => ref.watch(cachedDueCountProvider),
);

class _DueTodayCard extends StatelessWidget {
  const _DueTodayCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.alarm, size: 44, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count == 0 ? 'Alles erledigt!' : '$count Karten',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  count == 0
                      ? 'Du bist heute fertig — gut gemacht.'
                      : 'warten heute auf Wiederholung.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: count == 0
                ? null
                : () => context.go('/vocabulary/review'),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatefulWidget {
  const _FeatureTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0,
      upperBound: 0.06,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        // hover scales the icon up subtly.
        final scale = 1 + _ctrl.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Material(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (pressed) {
            if (pressed) {
              _ctrl.forward();
            } else {
              _ctrl.reverse();
            }
          },
          borderRadius: BorderRadius.circular(22),
          splashColor: cs.primary.withValues(alpha: 0.10),
          highlightColor: cs.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon,
                      size: 26, color: cs.onSecondaryContainer),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        )),
                    Text(widget.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small streak indicator showing consecutive daily review count.
class _StreakChip extends ConsumerWidget {
  const _StreakChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final cs = Theme.of(context).colorScheme;
    final days = streak.consecutiveDays;
    if (days <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: cs.onTertiaryContainer, size: 22),
          const SizedBox(width: 6),
          Text('$days',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: cs.onTertiaryContainer,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

/// Inline banner shown when there are unsaved review updates waiting
/// on the DB.  If the queue stays empty (the common case), the
/// widget renders nothing.
class _PendingSyncBanner extends ConsumerWidget {
  const _PendingSyncBanner();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingReviewQueueProvider).length;
    if (pendingCount == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_sync, size: 18,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$pendingCount Karten werden gespeichert, sobald der Speicher verfügbar ist.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
