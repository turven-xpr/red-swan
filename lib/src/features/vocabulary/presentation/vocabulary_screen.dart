import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../data/local/app_database.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import 'widgets/srs_stats_card.dart';

/// Vocab overview: every deck by level, total card counts, due counts.
/// "Start review" CTA opens the [ReviewScreen] for the current due set.
class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  String _query = '';
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(cachedFlashcardsProvider);
    final allCards = flashcardsAsync.value ?? const <Flashcard>[];

    final filteredCards = _query.trim().isEmpty
        ? allCards
        : allCards.where((c) {
            final q = _query.toLowerCase();
            return c.german.toLowerCase().contains(q) ||
                c.english.toLowerCase().contains(q);
          }).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _searching
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Vokabeln suchen…',
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() => _query = val),
                )
              : Text(t(context, Str.vocabHeaderTitle)),
          actions: [
            IconButton(
              icon: Icon(_searching ? Icons.close : Icons.search),
              tooltip: _searching ? 'Schließen' : 'Suchen',
              onPressed: () {
                setState(() {
                  if (_searching) {
                    _searching = false;
                    _query = '';
                  } else {
                    _searching = true;
                  }
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'A1'),
              Tab(text: 'A2'),
              Tab(text: 'B1'),
            ],
          ),
        ),
        body: flashcardsAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : allCards.isEmpty
                ? Center(
                    child: Card(
                      margin: const EdgeInsets.all(24),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Keine Vokabeln vorhanden',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  )
                : TabBarView(
                    children: [
                      for (final level in const ['A1', 'A2', 'B1'])
                        _LevelPane(level: level, cards: filteredCards),
                    ],
                  ),
        floatingActionButton: _buildFab(context, allCards),
      ),
    );
  }

  Widget? _buildFab(BuildContext context, List<Flashcard> cards) {
    final due =
        cards.where((c) => c.nextReviewDate.isBefore(DateTime.now())).length;
    if (due == 0) return null;
    return FloatingActionButton.extended(
      onPressed: () => context.go('/vocabulary/review'),
      icon: const Icon(Icons.play_arrow),
      label: Text('Review $due'),
    );
  }
}

class _LevelPane extends StatelessWidget {
  const _LevelPane({required this.level, required this.cards});
  final String level;
  final List<Flashcard> cards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levelCards = cards.where((c) => c.level == level).toList();
    final due = levelCards
        .where((c) => c.nextReviewDate.isBefore(DateTime.now()))
        .length;
    final mastered = levelCards.where((c) => c.repetitions >= 5).length;

    if (levelCards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Level $level startet bald',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Erkunde die A1-Karten und höre mit den Übungen auf. '
                'Dieses Level schaltet automatisch frei, sobald du '
                'fortschreitest.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: null, // disabled until A2 deck ships
                icon: const Icon(Icons.lock_outline),
                label: const Text('Bald verfügbar'),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SrsStatsCard(cards: cards),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Pill(
                  label: 'Due',
                  value: '$due',
                  color: theme.colorScheme.error),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Pill(
                  label: 'Mastered',
                  value: '$mastered',
                  color: theme.colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final c in levelCards)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(c.german,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${c.partOfSpeech} — ${c.english}'),
              leading: CircleAvatar(child: Text(c.repetitions.toString())),
            ),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
