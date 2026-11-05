import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/animations/premium_animations.dart';
import '../application/memory_match_engine.dart';

/// 4×4 Memory Match game screen.
/// Tapping a card reveals German OR English; matching two of the same
/// `pairId` keeps both face-up. Best-time persists in SharedPreferences.
class MemoryMatchScreen extends ConsumerStatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  ConsumerState<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends ConsumerState<MemoryMatchScreen> {
  late MemoryMatchEngine _engine;
  late List<MemoryCard> _deck;
  final Set<int> _matched = <int>{};
  final Set<int> _revealed = <int>{};
  MemoryCard? _first;
  MemoryCard? _second;
  int _moves = 0;
  int _matches = 0;
  bool _busy = false;
  Timer? _ticker;
  int _elapsedSec = 0;
  int? _bestSec;
  bool _isCompleted = false;
  Timer? _mismatchTimer;

  static const String _bestKey = 'best_memory_match_seconds';

  @override
  void initState() {
    super.initState();
    _engine = MemoryMatchEngine();
    _deck = _engine.buildDeck();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSec++);
    });
    _loadBest();
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _bestSec = prefs.getInt(_bestKey));
  }

  Future<void> _saveBest(int secs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestKey, secs);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _mismatchTimer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    if (!mounted) return;
    setState(() {
      _deck = _engine.buildDeck();
      _matched.clear();
      _revealed.clear();
      _moves = 0;
      _matches = 0;
      _first = null;
      _second = null;
      _busy = false;
      _elapsedSec = 0;
      _isCompleted = false;
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsedSec++);
      });
    });
  }

  Future<void> _onTap(MemoryCard card) async {
    if (_busy) return;
    if (_matched.contains(card.id)) return;
    if (_revealed.contains(card.id)) return;
    final tts = ref.read(ttsServiceProvider);
    if (_first?.id == card.id) return;

    HapticFeedback.selectionClick();

    setState(() => _revealed.add(card.id));

    // Speak the German card the moment it's revealed.
    if (card.face == CardFace.german) {
      unawaited(tts.speak(card.text));
    }

    if (_first == null) {
      _first = card;
      return;
    }
    _second = card;
    _moves++;
    _busy = true;

    final status = _engine.check(_first!, _second!);
    if (status == MatchStatus.matched) {
      _matched.add(_first!.id);
      _matched.add(_second!.id);
      _matches++;
      _first = null;
      _second = null;
      _busy = false;
      if (_matches == _deck.length ~/ 2) {
        _ticker?.cancel();
        final secs = _elapsedSec;
        if (_bestSec == null || secs < _bestSec!) {
          await _saveBest(secs);
          if (mounted) {
            setState(() {
              _bestSec = secs;
            });
          }
        }
        if (!mounted) return;
        setState(() {
          _isCompleted = true;
        });
      }
      setState(() {});
      return;
    }

    // Mismatch: hold for 600ms, flip back.
    _mismatchTimer?.cancel();
    _mismatchTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _revealed.remove(_first!.id);
        _revealed.remove(_second!.id);
        _first = null;
        _second = null;
        _busy = false;
      });
    });
  }

  String _formatSecs(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(_formatSecs(_elapsedSec),
                  style: theme.textTheme.titleMedium),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _StatsRow(
                  moves: _moves,
                  matches: _matches,
                  best: _bestSec == null ? null : _formatSecs(_bestSec!),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Column(
                    children: [
                      for (var r = 0; r < 4; r++) ...[
                        if (r > 0) const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              for (var c = 0; c < 4; c++) ...[
                                if (c > 0) const SizedBox(width: 8),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      final i = r * 4 + c;
                                      final card = _deck[i];
                                      final isFaceUp =
                                          _matched.contains(card.id) || _revealed.contains(card.id);
                                      return MemoryCardTile(
                                        key: ValueKey('card-${card.id}'),
                                        card: card,
                                        faceUp: isFaceUp,
                                        onTap: () => _onTap(card),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isCompleted)
            Positioned.fill(
              child: MemoryMatchCompletionOverlay(
                elapsedSec: _elapsedSec,
                moves: _moves,
                bestSec: _bestSec,
                onPlayAgain: _resetGame,
                onBack: () => context.go('/games'),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.moves,
    required this.matches,
    required this.best,
  });

  final int moves;
  final int matches;
  final String? best;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Pill(label: 'Züge', value: '$moves'),
        _Pill(label: 'Paare', value: '$matches'),
        _Pill(label: 'Bestzeit', value: best ?? '—'),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: theme.textTheme.titleMedium),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class MemoryCardTile extends StatefulWidget {
  const MemoryCardTile({
    super.key,
    required this.card,
    required this.faceUp,
    required this.onTap,
  });

  final MemoryCard card;
  final bool faceUp;
  final VoidCallback onTap;

  @override
  State<MemoryCardTile> createState() => _MemoryCardTileState();
}

class _MemoryCardTileState extends State<MemoryCardTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipCtrl;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.faceUp ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MemoryCardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.faceUp != oldWidget.faceUp) {
      final reducedMotion = (MediaQuery.maybeOf(context)?.disableAnimations ?? false) ||
          WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (reducedMotion) {
        _flipCtrl.value = widget.faceUp ? 1.0 : 0.0;
      } else {
        if (widget.faceUp) {
          _flipCtrl.forward();
        } else {
          _flipCtrl.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressScaleEffect(
      enabled: !widget.faceUp, // Disable tap-scale once card is flipped face-up
      onTap: widget.onTap,
      child: Semantics(
        label: widget.faceUp
            ? 'Karte aufgedeckt: ${widget.card.text}'
            : 'Karte verdeckt, tippen zum Aufdecken',
        button: true,
        child: AnimatedBuilder(
          animation: _flipCtrl,
          builder: (context, child) {
            final t = _flipCtrl.value;
            final angle = t * 3.14159265; // 0 to pi
            final showingBack = t < 0.5;

            // Subtle scale shrink at the midpoint (t = 0.5) using sine wave
            final scale = 1.0 - (sin(t * 3.14159265) * 0.08);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective depth
                ..rotateY(angle),
              child: Transform.scale(
                scale: scale,
                child: showingBack
                    ? _buildCardBack(theme)
                    : Transform(
                        alignment: Alignment.center,
                        // Reverse rotation so that the front face reads left-to-right
                        transform: Matrix4.identity()..rotateY(3.14159265),
                        child: _buildCardFront(theme),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        widget.card.text,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCardBack(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.question_mark_rounded,
        color: theme.colorScheme.primary,
        size: 28,
      ),
    );
  }
}

class MemoryMatchCompletionOverlay extends StatelessWidget {
  const MemoryMatchCompletionOverlay({
    super.key,
    required this.elapsedSec,
    required this.moves,
    required this.bestSec,
    required this.onPlayAgain,
    required this.onBack,
  });

  final int elapsedSec;
  final int moves;
  final int? bestSec;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;

  String _formatSecs(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final label = 'Sehr gut! 🎉 Du hast alle Paare gefunden! Zeit: ${_formatSecs(elapsedSec)}. Züge: $moves. Bestzeit: ${bestSec == null ? 'keine' : _formatSecs(bestSec!)}.';

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
                    const Center(child: ConfettiBurst()),
                    const SizedBox(height: 16),
                    Center(
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 80,
                        color: cs.primary, // migrated from Colors.amber[600]
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sehr gut! 🎉',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Du hast alle Paare gefunden!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      color: cs.surfaceContainerHigh,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(label: 'Zeit', value: _formatSecs(elapsedSec)),
                            _StatItem(label: 'Züge', value: '$moves'),
                            _StatItem(
                              label: 'Bestzeit',
                              value: bestSec == null ? '—' : _formatSecs(bestSec!),
                            ),
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
                            label: const Text('Nächstes Spiel'),
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
