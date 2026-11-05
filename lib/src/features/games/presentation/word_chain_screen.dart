import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/animations/premium_animations.dart';
import '../../../data/local/app_database.dart';
import '../../vocabulary/presentation/streak_provider.dart';
import '../application/word_chain_engine.dart';

/// Rapid-fire 5-second-per-word translation quiz. Score tracks correctly
/// answered AND fast; high score persists across launches.
class WordChainScreen extends ConsumerStatefulWidget {
  const WordChainScreen({super.key});

  static void resetStaticState() {
    _WordChainScreenState._staticIsCompleted = false;
    _WordChainScreenState._staticScore = 0;
    _WordChainScreenState._staticLives = 3;
  }

  @override
  ConsumerState<WordChainScreen> createState() => _WordChainScreenState();
}

class _WordChainScreenState extends ConsumerState<WordChainScreen>
    with SingleTickerProviderStateMixin {
  static const int _totalQuestions = 10;
  static const int _maxLives = 3;
  static const String _highScoreKey = 'high_score_word_chain';

  late final WordChainEngine _engine;
  late List<Flashcard> _pool;
  WordChainQuestion? _current;
  int _questionIdx = 0;
  int _score = 0;
  int _lives = _maxLives;
  int? _pickedIndex;
  bool _answered = false;
  int? _highScore;
  late final AnimationController _timerCtrl;
  bool _isCompleted = false;
  Timer? _advanceTimer;

  static bool _staticIsCompleted = false;
  static int _staticScore = 0;
  static int _staticLives = 3;

  @override
  void initState() {
    super.initState();
    _engine = WordChainEngine();
    _loadHighScore();
    _timerCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: _engine.secondsPerQuestion),
    );
    _timerCtrl.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (!_answered) _onTimeout();
      }
    });
    if (_staticIsCompleted) {
      _isCompleted = true;
      _score = _staticScore;
      _lives = _staticLives;
    } else {
      Future.microtask(() => _nextQuestion());
    }
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _highScore = prefs.getInt(_highScoreKey));
  }

  Future<void> _saveHighScore(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, v);
  }

  void _nextQuestion() async {
    if (_lives <= 0 || _questionIdx >= _totalQuestions) {
      _finishGame();
      return;
    }
    if (_questionIdx == 0) {
      final db = ref.read(appDatabaseProvider);
      final cards = await db.select(db.flashcards).get();
      _pool = cards.where((c) => c.english.trim().isNotEmpty).toList();
    }
    if (_pool.length < 4) {
      // Not enough content; bail.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Mindestens 4 Karten nötig — bitte Vokabeln üben.')),
      );
      context.go('/games');
      return;
    }
    final target = (_pool..shuffle()).first;
    final q = _engine.nextQuestion(target, _pool);
    if (!mounted) return;
    setState(() {
      _current = q;
      _answered = false;
      _pickedIndex = null;
      _questionIdx++;
    });
    final tts = ref.read(ttsServiceProvider);
    unawaited(tts.speak(q.german));
    _timerCtrl.reverse(from: 1.0);
  }

  void _onTimeout() {
    if (_answered) return;
    _answered = true;
    setState(() {
      _lives--;
    });
    _scheduleAdvance();
  }

  void _onPick(int index) {
    if (_answered) return;
    HapticFeedback.selectionClick();
    _answered = true;
    _timerCtrl.stop();
    final correct = _engine.check(_current!, index);
    setState(() {
      _pickedIndex = index;
      if (correct) {
        // Time-bonus: faster answers earn more points.
        final remainingSec = (_timerCtrl.value * _engine.secondsPerQuestion).round();
        _score += 5 + (remainingSec.clamp(0, 5));
      } else {
        _lives--;
      }
    });
    _scheduleAdvance();
  }

  void _scheduleAdvance() {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _finishGame() {
    _timerCtrl.stop();
    final score = _score;
    if (_highScore == null || score > _highScore!) {
      _saveHighScore(score);
      _highScore = score;
    }
    setState(() {
      _isCompleted = true;
      _staticIsCompleted = true;
      _staticScore = _score;
      _staticLives = _lives;
    });
  }

  void _resetGame() async {
    await _loadHighScore();
    if (!mounted) return;
    setState(() {
      _score = 0;
      _lives = _maxLives;
      _questionIdx = 0;
      _pickedIndex = null;
      _answered = false;
      _isCompleted = false;
      _staticIsCompleted = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _nextQuestion());
  }

  @override
  void dispose() {
    _timerCtrl.dispose();
    _advanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _current;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Chain Race'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(Icons.favorite, color: theme.colorScheme.error, size: 18),
                  const SizedBox(width: 4),
                  Text('$_lives', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          q == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(
                          questionIdx: _questionIdx,
                          total: _totalQuestions,
                          score: _score,
                          highScore: _highScore,
                        ),
                        const SizedBox(height: 8),
                        _CountdownRing(
                          animation: _timerCtrl,
                          totalSeconds: _engine.secondsPerQuestion,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            q.german,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        for (var i = 0; i < q.options.length; i++)
                          _OptionButton(
                            text: q.options[i],
                            state: _answered
                                ? (i == q.correctIndex
                                    ? _OptionState.correct
                                    : (i == _pickedIndex
                                        ? _OptionState.wrong
                                        : _OptionState.idle))
                                : _OptionState.idle,
                            onTap: () => _onPick(i),
                          ),
                      ],
                    ),
                  ),
                ),
          if (_isCompleted)
            Positioned.fill(
              child: WordChainCompletionOverlay(
                score: _score,
                highScore: _highScore,
                lives: _lives,
                onPlayAgain: _resetGame,
                onBack: () => context.go('/games'),
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.questionIdx,
    required this.total,
    required this.score,
    required this.highScore,
  });
  final int questionIdx;
  final int total;
  final int score;
  final int? highScore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Frage $questionIdx / $total',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            Icon(Icons.stars, color: theme.colorScheme.secondary),
            const SizedBox(width: 4),
            Text('$score  (Best: ${highScore ?? 0})'),
          ],
        ),
      ],
    );
  }
}

enum _OptionState { idle, correct, wrong }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.text,
    required this.state,
    required this.onTap,
  });
  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    Color bg;
    Color fg;
    String semanticLabel = '';
    switch (state) {
      case _OptionState.correct:
        bg = cs.tertiary;
        fg = cs.onTertiary;
        semanticLabel = 'Richtig: $text';
        break;
      case _OptionState.wrong:
        bg = cs.error;
        fg = cs.onError;
        semanticLabel = 'Falsch: $text';
        break;
      case _OptionState.idle:
        bg = theme.cardTheme.color ?? cs.surface;
        fg = cs.onSurface;
        semanticLabel = 'Option: $text';
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label: semanticLabel,
        button: state == _OptionState.idle,
        child: PressScaleEffect(
          onTap: state == _OptionState.idle ? onTap : null,
          enabled: state == _OptionState.idle,
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Center(
                  child: Text(text,
                      style: theme.textTheme.titleMedium?.copyWith(color: fg, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    required this.animation,
    required this.totalSeconds,
  });

  final Animation<double> animation;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final rawProgress = animation.value;
        final seconds = (rawProgress * totalSeconds).ceil();
        final danger = seconds <= 2;
        final reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
        
        final progress = reducedMotion ? (seconds / totalSeconds) : rawProgress;

        final color = Color.lerp(
          cs.error,
          cs.primary,
          (progress - 0.4).clamp(0.0, 0.6) / 0.6,
        )!;

        return Semantics(
          label: 'Verbleibende Zeit: $seconds Sekunden',
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 86,
              height: 86,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      color: danger ? Colors.redAccent : color, // migrated from Colors.redAccent
                      backgroundColor: cs.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  Text(
                    '${seconds.clamp(0, totalSeconds)}s',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: danger ? cs.error : cs.onSurface, // migrated from Colors.redAccent
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class WordChainCompletionOverlay extends ConsumerWidget {
  const WordChainCompletionOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.lives,
    required this.onPlayAgain,
    required this.onBack,
  });

  final int score;
  final int? highScore;
  final int lives;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWin = lives > 0;
    final streak = ref.watch(streakProvider);
    final currentStreak = streak.consecutiveDays;

    final label = isWin
        ? 'Spiel beendet! 🏆 Hervorragende Übersetzungsleistung. Punkte: $score. Highscore: ${highScore ?? score}. Leben übrig: $lives.'
        : 'Spiel vorbei! 💔 Keine Leben mehr übrig. Punkte: $score. Highscore: ${highScore ?? score}. Leben übrig: $lives.';

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Semantics(
        label: label,
        container: true,
        child: Material(
          color: cs.surface.withValues(alpha: 0.95),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: StaggerCascade(
                  children: [
                    if (isWin) ...[
                      const Center(child: ConfettiBurst()),
                      const SizedBox(height: 16),
                      Center(
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 80,
                          color: cs.primary, // migrated from Colors.amber[600]
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Icon(
                          Icons.heart_broken_rounded,
                          size: 80,
                          color: cs.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      isWin ? 'Spiel beendet! 🏆' : 'Spiel vorbei! 💔',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isWin ? cs.primary : cs.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isWin
                          ? 'Hervorragende Übersetzungsleistung!'
                          : 'Keine Leben mehr übrig.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isWin && currentStreak > 0) ...[
                      Center(child: StreakBadge(days: currentStreak)),
                      const SizedBox(height: 16),
                    ],
                    Card(
                      color: cs.surfaceContainerHigh,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(label: 'Punkte', value: '$score'),
                            _StatItem(
                              label: 'Highscore',
                              value: '${score > (highScore ?? 0) ? score : (highScore ?? score)}',
                            ),
                            _StatItem(label: 'Leben übrig', value: '$lives'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: PressScaleEffect(
                        onTap: onPlayAgain,
                        child: IgnorePointer(
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Nochmal spielen'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PressScaleEffect(
                        onTap: onBack,
                        child: IgnorePointer(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Zurück'),
                          ),
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
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
