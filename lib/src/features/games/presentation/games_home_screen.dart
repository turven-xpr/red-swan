import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/animations/premium_animations.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';

/// Landing page for Spiele (Games). Two big cards invite the user into
/// Memory Match or Word Chain Race. No bottom-nav — games are immersive.
class GamesHomeScreen extends StatelessWidget {
  const GamesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.navGames))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StaggerCascade(
            children: [
              Text(
                'Lerne spielerisch Deutsch!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Wähle ein Spiel und teste dein Wissen.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              _GameCard(
                icon: Icons.grid_view_rounded,
                title: 'Memory Match',
                subtitle: 'Paare Deutsch ↔ Englisch finden',
                accent: theme.colorScheme.primary,
                onTap: () => context.go('/games/memory-match'),
              ),
              const SizedBox(height: 12),
              _GameCard(
                icon: Icons.timer_outlined,
                title: 'Word Chain Race',
                subtitle: '5 Sekunden pro Wort — wer schafft die meisten?',
                accent: theme.colorScheme.error,
                onTap: () => context.go('/games/word-chain'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
