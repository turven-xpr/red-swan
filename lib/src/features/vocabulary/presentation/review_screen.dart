import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/local/app_database.dart';
import '../../monetization/ad_service.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/widgets/animations/premium_animations.dart';

import 'streak_provider.dart';

/// Streams flashcards that are due for review RIGHT NOW. Powers off of
/// the cached flashcards provider so reviews start without waiting for
/// the Drift database to open.
final dueCardsProvider = Provider<List<Flashcard>>((ref) {
  final cards = ref.watch(cachedFlashcardsProvider).value ?? const <Flashcard>[];
  return cards
      .where((c) => c.nextReviewDate.isBefore(DateTime.now()))
      .toList();
});

/// Offline-first safety net — flashcard updates that failed to persist
/// (disk full, DB locked, transient I/O).  Stored in memory and shown
/// in the dashboard as a small "pending sync" badge.  Drained by a
/// post-frame callback when the DB becomes reachable again.
typedef PendingReviewEntry = ({int cardId, Flashcard card, int grade});

final pendingReviewQueueProvider =
    NotifierProvider<PendingReviewQueueNotifier, List<PendingReviewEntry>>(
  PendingReviewQueueNotifier.new,
);

class PendingReviewQueueNotifier extends Notifier<List<PendingReviewEntry>> {
  @override
  List<PendingReviewEntry> build() => [];

  void add(int cardId, Flashcard card, int grade) {
    state = [...state, (cardId: cardId, card: card, grade: grade)];
  }

  void clear() => state = [];
}

/// SRS review screen:
///   - Streams the due-card set from Drift (unaffected by network).
///   - Tap to flip card (front = German, back = English + example).
///   - 4 grading buttons feed the SuperMemo-2 scheduler; the updated
///     card is written back to the local DB row.
///   - TTS button on the front face so the user can hear the word.
///   - Completing the deck triggers a single interstitial ad.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _index = 0;
  bool _showBack = false;
  bool _adShown = false;

  Future<void> _onGrade(Flashcard card, int grade) async {
      final scheduler = ref.read(srsSchedulerProvider);
      final db = ref.read(appDatabaseProvider);
      final updated = scheduler.nextState(card, grade);
      try {
        await db.updateFlashcard(updated);
      } catch (e) {
        // Offline-first safety net — DB write failed (disk full, locked,
        // transient I/O).  Queue the update in memory and continue; the
        // user doesn't lose their review progress.
        ref.read(pendingReviewQueueProvider.notifier).add(card.id, updated, grade);
      }
      if (!mounted) return;
      setState(() {
        _index += 1;
        _showBack = false;
      });
    }

  /// Skip = advance without grading.  Doesn't mutate SRS state, so the
  /// user keeps the same `due` set.  Inaccessible while the front of
  /// the card is showing because readers may want to consider a card
  /// over multiple sittings.
  void _onSkip() {
    setState(() {
      _index += 1;
      _showBack = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final due = ref.watch(dueCardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, Str.vocabHeaderTitle)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Schließen',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: _buildBody(context, due),
    );
  }

  Widget _buildBody(BuildContext context, List<Flashcard> due) {
    if (due.isEmpty) {
      final theme = Theme.of(context);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keine Karten fällig!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gute Arbeit! Alle Vokabeln sind auf dem neuesten Stand.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.tonal(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Zurück zum Überblick'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (_index >= due.length) {
          // Review complete — show interstitial ad at most once.
          if (!_adShown) {
            _adShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(adServiceProvider).showInterstitial();
              ref.read(streakProvider.notifier).markReviewed();
            });
          }
          return const _CompletionScreen();
    }
    final card = due[_index];
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / due.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: FlashcardView(
                  key: ValueKey(card.id),
                  card: card,
                  showBack: _showBack,
                  onFlip: () => setState(() => _showBack = !_showBack),
                ),
              ),
            ),
          ),
        ),
        if (_showBack) _GradePanel(card: card, onGrade: _onGrade, onSkip: _onSkip),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Visual representation of the card itself. Tap-to-flip animates the
/// face swap between German cue (front) and English translation + sample
/// sentence (back).
class FlashcardView extends ConsumerStatefulWidget {
  const FlashcardView({
    super.key,
    required this.card,
    required this.showBack,
    required this.onFlip,
  });

  final Flashcard card;
  final bool showBack;
  final VoidCallback onFlip;

  @override
  ConsumerState<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends ConsumerState<FlashcardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipCtrl;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: widget.showBack ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != oldWidget.showBack) {
      final reducedMotion = (MediaQuery.maybeOf(context)?.disableAnimations ?? false) ||
          WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (reducedMotion) {
        _flipCtrl.value = widget.showBack ? 1.0 : 0.0;
      } else {
        if (widget.showBack) {
          _flipCtrl.forward();
        } else {
          _flipCtrl.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tts = ref.watch(ttsServiceProvider);
    final c = widget.card;
    final theme = Theme.of(context);
    final showingFront = !widget.showBack;

    return Semantics(
      label: 'Vokabelkarte: ${showingFront ? c.german : c.english}. Tippen zum Umdrehen.',
      button: true,
      child: PressScaleEffect(
        onTap: widget.onFlip,
        child: AnimatedBuilder(
          animation: _flipCtrl,
          builder: (context, _) {
            final t = _flipCtrl.value;
            // 3D perspective transform — rotateY.
            final angle = t * 3.14159265; // 0 → π (front to back).
            final showingFront = t < 0.5;
            final scale = 1 - (t * 0.05).abs(); // subtle shrink at mid-flip.
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(angle),
              child: Transform.scale(
                scale: scale,
                child: showingFront
                    ? _buildFront(c, theme, tts)
                    : Transform(
                        alignment: Alignment.center,
                        // Mirror the back so text isn't reversed at π > π/2.
                        transform: Matrix4.identity()..rotateY(3.14159265),
                        child: _buildBack(c, theme),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(Flashcard c, ThemeData theme, dynamic tts) {
    return Card(
      key: const ValueKey('front'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              c.partOfSpeech.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              c.german,
              style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            IconButton.filledTonal(
              onPressed: () => tts.speak(c.german),
              icon: const Icon(Icons.volume_up),
              tooltip: 'Anhören',
            ),
            const SizedBox(height: 12),
            const Text('Tippe um die Antwort zu sehen',
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(Flashcard c, ThemeData theme) {
    return Card(
      key: const ValueKey('back'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(c.english,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (c.exampleGerman != null)
              Text('"${c.exampleGerman}"',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic)),
            if (c.exampleEnglish != null)
              Text('"${c.exampleEnglish}"',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Buttons are mapped to the SM-2 0..5 scale (Anki standard).
class _GradePanel extends ConsumerWidget {
  const _GradePanel({
    required this.card,
    required this.onGrade,
    required this.onSkip,
  });
  final Flashcard card;
  final Future<void> Function(Flashcard, int) onGrade;
  final VoidCallback onSkip;

  static const _moods = [
    (label: 'Vergessen', icon: Icons.sentiment_dissatisfied, value: 1),
    (label: 'Schwer', icon: Icons.sentiment_neutral, value: 3),
    (label: 'Gut', icon: Icons.sentiment_satisfied_alt, value: 4),
    (label: 'Einfach', icon: Icons.sentiment_very_satisfied, value: 5),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final m in _moods)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: PressScaleEffect(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onGrade(card, m.value);
                      },
                      child: IgnorePointer(
                        child: FilledButton.tonal(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(m.icon, size: 24),
                              const SizedBox(height: 6),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  m.label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Skip button — discreet, secondary affordance.  Lets a
          // power-user dismiss without affecting SRS state.
          PressScaleEffect(
            onTap: onSkip,
            child: IgnorePointer(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.skip_next_outlined),
                label: const Text('Überspringen'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionScreen extends ConsumerWidget {
  const _CompletionScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final theme = Theme.of(context);
    return Center(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ConfettiBurst(),
            const SizedBox(height: 12),
            Icon(Icons.emoji_events_rounded, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(t(context, Str.gamesComplete),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 6),
            Text('Du bist für heute fertig.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                )),
            const SizedBox(height: 18),
            // Streak flame badge
            StreakBadge(days: streak.consecutiveDays),
            const SizedBox(height: 32),
            PressScaleEffect(
              onTap: () => Navigator.of(context).pop(),
              child: IgnorePointer(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Zurück zum Dashboard'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

