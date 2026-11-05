import 'package:flutter/material.dart';

import '../../../../data/local/app_database.dart';

/// Card showing retention statistics, mastery levels, and SRS projection.
class SrsStatsCard extends StatelessWidget {
  const SrsStatsCard({super.key, required this.cards});

  final List<Flashcard> cards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final total = cards.length;
    final mastered = cards.where((c) => c.repetitions >= 4).length;
    final learning = cards.where((c) => c.repetitions > 0 && c.repetitions < 4).length;
    final newCards = cards.where((c) => c.repetitions == 0).length;

    final masteredRatio = total > 0 ? mastered / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_rounded, color: cs.primary, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Vokabel-Fortschritt & SRS',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Overall Mastery Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gemasterte Wörter',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${(masteredRatio * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: masteredRatio,
                minHeight: 8,
                backgroundColor: cs.primary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
            const SizedBox(height: 20),
            // Breakdown Stats Grid
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Neu',
                    count: newCards,
                    color: cs.secondary,
                    icon: Icons.fiber_new_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: 'Lernen',
                    count: learning,
                    color: cs.tertiary,
                    icon: Icons.autorenew_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: 'Gemeistert',
                    count: mastered,
                    color: cs.primary,
                    icon: Icons.verified_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
