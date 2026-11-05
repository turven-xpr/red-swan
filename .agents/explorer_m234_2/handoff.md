# Handoff Report: UI Enhancements & M3 Color Migration

## 1. Observation

During my read-only investigation, I analyzed the relevant files in the `german_learning_app` repository. Below are my direct observations:

### Game Completion Flow & Overlays
* **Memory Match Screen Dialog:** In `lib/src/features/games/presentation/memory_match_screen.dart` (lines 121–165), game completion is handled by the `_showWin(int secs)` method, which triggers a standard `AlertDialog` using `showDialog`:
  ```dart
  void _showWin(int secs) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Sehr gut! 🎉'),
        content: Text(
          'Du hast alle Paare in ${_formatSecs(secs)} gefunden.\n'
          'Züge: $_moves',
        ),
        actions: [ ... ]
      ),
    );
  }
  ```
* **Word Chain Screen Dialog:** In `lib/src/features/games/presentation/word_chain_screen.dart` (lines 137–177), game-over and completion are handled by `_finishGame()`, which also invokes a standard `AlertDialog`:
  ```dart
  void _finishGame() {
    _timer?.cancel();
    final score = _score;
    ...
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Spiel vorbei!'),
        content: Text(
          'Dein Punktestand: $score\n'
          'Highscore: ${score > (_highScore ?? 0) ? score : (_highScore ?? score)}',
        ),
        actions: [ ... ]
      ),
    );
  }
  ```
* **Existing Review Completion UI:** In `lib/src/features/vocabulary/presentation/review_screen.dart` (lines 391–434), vocabulary review completion is represented by the inline state `_CompletionScreen` widget. This screen renders a gold trophy icon, translation-derived text headers (using `Str.gamesComplete`), a custom particle-driven confetti paint widget `_ConfettiBurst()`, a streak flame badge `_StreakBadge()`, and navigation buttons.
* **Confetti & Streak Badge Code:** In `lib/src/features/vocabulary/presentation/review_screen.dart` (lines 437–574), the `_ConfettiBurst`, `_ConfettiPainter`, `_HashRng`, and `_StreakBadge` classes are implemented as private local classes, preventing reusability by default.

### Card Animations
* **Memory Cards Transition:** In `lib/src/features/games/presentation/memory_match_screen.dart` (lines 276–333), the `MemoryCardTile` is a `StatelessWidget` wrapping an `AnimatedSwitcher` with a simple 2D `FadeTransition`:
  ```dart
  transitionBuilder: (child, anim) =>
      FadeTransition(opacity: anim, child: child),
  ```
* **3D Flip Reference:** In `lib/src/features/vocabulary/presentation/review_screen.dart` (lines 221–247), `FlashcardView` implements a 3D perspective flip card transition utilizing `AnimationController` and `Transform` with `rotateY` and a perspective entry `setEntry(3, 2, 0.001)`:
  ```dart
  final angle = t * 3.14159265;
  ...
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001)
    ..rotateY(angle),
  ```

### Timer Ring
* **Word Chain Timer Ticks:** In `lib/src/features/games/presentation/word_chain_screen.dart` (lines 333–366), `_CountdownRing` displays a `CircularProgressIndicator` whose `value` is directly tied to the integer `seconds` state updated on a 1-second `Timer.periodic`. This causes the progress indicator to snap blockily once every second (1.0 → 0.8 → 0.6 → 0.4 → 0.2 → 0.0).

### Colors & Theming
* **App Themes:** In `lib/src/core/theme/app_theme.dart` (lines 7–18), the brand colors are cobalt `AppColors.primary` (`0xFF2547A0`), warm coral `AppColors.secondary` (`0xFFFF7A59`), and mint `AppColors.tertiary` (`0xFF1BB388`).
* **Hardcoded Colors:** In `lib/src/features/games/presentation/word_chain_screen.dart`:
  * Correct Option Button: Uses hardcoded green `const Color(0xFF1E8A6E)` (line 303).
  * Wrong Option Button: Uses hardcoded red `const Color(0xFFC0392B)` (line 307).
  * Timer Ring & Lives Icon: Uses hardcoded `Colors.redAccent` (lines 198, 354) and `Colors.amber` (line 274).

---

## 2. Logic Chain

Based on my observations, here is the rationale supporting the recommended UI enhancements and implementation steps:

1. **Overlay vs. Dialogs:**
   * Standard `AlertDialog` popups interrupt the game experience, lack animations, and do not fit a premium gaming theme.
   * By replacing them with overlay widgets inside a `Stack` at the screen level, we can achieve high-fidelity full-screen overlays with blurred backgrounds and staggered animations.
   * To prevent duplicate implementations, we can extract `ConfettiBurst` and `StreakBadge` from `review_screen.dart` into public widgets in `lib/src/core/widgets/animations/premium_animations.dart`.
2. **3D Flip Cards:**
   * To replace the basic fade transition in `MemoryCardTile`, we must transform the card rotation about the Y-axis.
   * Making `MemoryCardTile` a `StatefulWidget` with an `AnimationController` driven by parent changes to the `faceUp` flag allows us to animate rotation smoothly. We will use the exact perspective values from `FlashcardView` to maintain design consistency across the application.
3. **Smooth Countdown Timer Ring:**
   * Instead of a 1-second periodic timer triggering blocky value updates, the countdown can be driven by a frame-rate independent `AnimationController` on the screen state.
   * Running `_timerCtrl.reverse(from: 1.0)` over 5 seconds allows the countdown ring to sweep continuously at 60fps/120fps. We can use an `AnimatedBuilder` inside `_CountdownRing` to read `_timerCtrl.value` directly.
   * The remaining seconds can be calculated dynamically as `(animation.value * totalSeconds).ceil()`, ensuring that timeout triggers instantly when the controller finishes.
4. **Tactile Press-Scale Micro-interactions:**
   * A reusable `PressScaleEffect` widget using `GestureDetector` and `ScaleTransition` driven by tap-down/up/cancel actions can wrap option buttons and game cards.
   * Applying a small scale reduction (e.g., to `0.95`) with a fast duration (e.g., `100ms`) produces a physical bounce effect.
5. **Material 3 Token Clean-up:**
   * Replacing the hardcoded option colors with semantic tokens ensures proper adaptivity to light/dark themes.
   * `theme.colorScheme.tertiary` (mint) acts as the success indicator.
   * `theme.colorScheme.error` acts as the error indicator (wrong option button, timer danger state, and lives icon).
   * Both colors map directly to text tokens (`onTertiary` and `onError`) for readable contrast and compliance with accessibility guidelines.

---

## 3. Caveats

* **Animation Disabling / Reduced Motion:** In accordance with accessibility guidelines, both `PressScaleEffect` and staggered overlays must check `MediaQuery.maybeOf(context)?.disableAnimations ?? false` to disable scale-down effects and spring animations if the user prefers reduced motion.
* **Shared Preferences State:** The game screens update best-times and high scores. The overlays must pull these states correctly when rendering the completion UI.
* **Text-to-Speech Interruption:** When Word Chain resets, the TTS engine speaks the first question. If the user hits "Play Again", the transition should not cause double-speech.

---

## 4. Conclusion

Below is the structured, step-by-step implementation strategy for the code enhancement.

### Step 1: Extract Shared Animation Components
Refactor `_ConfettiBurst` and `_StreakBadge` from `lib/src/features/vocabulary/presentation/review_screen.dart` into `lib/src/core/widgets/animations/premium_animations.dart` and export them. Introduce the reusable `PressScaleEffect` widget.

**Proposed additions to `lib/src/core/widgets/animations/premium_animations.dart`:**

```dart
/// Reusable tactile press-scale animation.
class PressScaleEffect extends StatefulWidget {
  const PressScaleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<PressScaleEffect> createState() => _PressScaleEffectState();
}

class _PressScaleEffectState extends State<PressScaleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.enabled && widget.onTap != null) _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.enabled && widget.onTap != null) _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.enabled && widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion || !widget.enabled || widget.onTap == null) {
      return GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Dynamic particle confetti burst.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return SizedBox(
          width: 220,
          height: 80,
          child: CustomPaint(
            painter: _ConfettiPainter(progress: _ctrl.value),
          ),
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = _HashRng(hashCode);
    final colors = const [
      Color(0xFFF97316),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
      Color(0xFFEC4899),
      Color(0xFFFACC15),
      Color(0xFF8B5CF6),
    ];
    final paint = Paint()..style = PaintingStyle.fill;
    var alpha = (1 - progress).clamp(0.0, 1.0);
    if (alpha < 0.05) return;
    for (var i = 0; i < 16; i++) {
      final x = _lerp(rng, 0.08, 0.92, 2 * i);
      final y = _lerp(rng, 0.1, 1.2 - progress * 0.4, 2 * i + 1);
      final w = _lerp(rng, 4, 10, i * 3);
      final h = _lerp(rng, 4, 14, i * 3 + 1);
      paint.color = colors[i % colors.length].withValues(alpha: alpha * 0.9);
      final rect = Rect.fromLTWH(x * size.width, y * size.height, w, h);
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(_lerp(rng, -0.35, 0.35, i * 7));
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;

  double _lerp(_HashRng rng, double a, double b, int i) =>
      a + (b - a) * rng.next(i);
}

class _HashRng {
  _HashRng(this.seed);
  final int seed;
  double next(int i) {
    final h = (seed * 0x5DEECE66D + i * 0xB).toUnsigned(32).toDouble();
    return (h % 1024) / 1024.0;
  }
}

/// Adaptive streak flame / milestone badge.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.days});
  final int days;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final icon = days >= 7 ? Icons.local_fire_department : Icons.auto_awesome;
    final label = days >= 7 ? '$days-Tage-Streak!' : '$days ${days == 1 ? 'Tag' : 'Tage'}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: cs.onPrimaryContainer, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: cs.onPrimaryContainer,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
```

Ensure `lib/src/features/vocabulary/presentation/review_screen.dart` is updated to delete its local classes and import these public ones instead.

---

### Step 2: Implement Memory Match 3D Cards

Modify `MemoryCardTile` inside `lib/src/features/games/presentation/memory_match_screen.dart` to perform a 3D rotation flip on selection:

```dart
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
  void didUpdateWidget(covariant MemoryCardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.faceUp != oldWidget.faceUp) {
      if (widget.faceUp) {
        _flipCtrl.forward();
      } else {
        _flipCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = widget.card;

    return PressScaleEffect(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipCtrl,
        builder: (context, _) {
          final t = _flipCtrl.value;
          final angle = t * 3.14159265;
          final showingFront = t >= 0.5; // Card is flipped face up

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 3D Perspective
              ..rotateY(angle),
            child: showingFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159265),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color ?? theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        card.text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.question_mark_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
```

---

### Step 3: Implement Word Chain Smooth Countdown Timer Ring

1. **Refactor timer control in `_WordChainScreenState`:**
   Add `SingleTickerProviderStateMixin` and initialize an `AnimationController` to represent the timer instead of utilizing a `Timer.periodic`.

```dart
class _WordChainScreenState extends ConsumerState<WordChainScreen>
    with SingleTickerProviderStateMixin {
  ...
  late final AnimationController _timerCtrl;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _nextQuestion());
  }

  @override
  void dispose() {
    _timerCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() async {
    if (_lives <= 0 || _questionIdx >= _totalQuestions) {
      _finishGame();
      return;
    }
    // (Fetch flashcards pool logic...)
    setState(() {
      _current = q;
      _answered = false;
      _pickedIndex = null;
      _questionIdx++;
    });
    final tts = ref.read(ttsServiceProvider);
    unawaited(tts.speak(q.german));
    
    // Start countdown smoothly from 1.0 to 0.0
    _timerCtrl.reverse(from: 1.0);
  }

  void _onPick(int index) {
    if (_answered) return;
    _answered = true;
    _timerCtrl.stop(); // Halt the timer animation
    final correct = _engine.check(_current!, index);
    setState(() {
      _pickedIndex = index;
      if (correct) {
        // Calculate remaining seconds exactly using the fractional value
        final remainingSec = (_timerCtrl.value * _engine.secondsPerQuestion).round();
        _score += 5 + remainingSec.clamp(0, 5);
      } else {
        _lives--;
      }
    });
    _scheduleAdvance();
  }

  void _onTimeout() {
    if (_answered) return;
    _answered = true;
    setState(() {
      _lives--;
    });
    _scheduleAdvance();
  }
}
```

2. **Update the `_CountdownRing` to use `AnimatedBuilder` and the controller:**

```dart
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

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = animation.value;
        final seconds = (progress * totalSeconds).ceil();
        final danger = seconds <= 2;

        return Center(
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
                    color: danger ? theme.colorScheme.error : theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                Text(
                  '${seconds.clamp(0, totalSeconds)}s',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

---

### Step 4: Apply Material 3 Theme Tokens & Press-Scale Micro-interactions

Modify option buttons and decorative icons in `WordChainScreen` to implement themed attributes:

```dart
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
    Color bg;
    Color fg;

    switch (state) {
      case _OptionState.correct:
        bg = theme.colorScheme.tertiary; // Mint Accent
        fg = theme.colorScheme.onTertiary;
        break;
      case _OptionState.wrong:
        bg = theme.colorScheme.error; // Semantic Error Red
        fg = theme.colorScheme.onError;
        break;
      case _OptionState.idle:
        bg = theme.cardTheme.color ?? theme.colorScheme.surface;
        fg = theme.colorScheme.onSurface;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressScaleEffect(
        onTap: state == _OptionState.idle ? onTap : null,
        enabled: state == _OptionState.idle,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

Also, update the lives display and score text in `WordChainScreen` to utilize `theme.colorScheme.error` and `theme.colorScheme.secondary` instead of `Colors.redAccent` and `Colors.amber`.

---

### Step 5: Implement Game-Completion Stack Overlays

Design two premium completion overlay screens (`MemoryMatchCompletionOverlay` and `WordChainCompletionOverlay`) wrapped in dynamic slide/fade animations.

**1. Memory Match Completion Overlay (`MemoryMatchCompletionOverlay`):**

```dart
class MemoryMatchCompletionOverlay extends StatelessWidget {
  const MemoryMatchCompletionOverlay({
    super.key,
    required this.elapsedSec,
    required this.moves,
    required this.bestSec,
    required this.onPlayAgain,
  });

  final int elapsedSec;
  final int moves;
  final int? bestSec;
  final VoidCallback onPlayAgain;

  String _formatSecs(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      color: cs.surface.withValues(alpha: 0.95),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: StaggerCascade(
              children: [
                const ConfettiBurst(),
                const SizedBox(height: 16),
                Icon(Icons.emoji_events_rounded, size: 80, color: Colors.amber[600]),
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
                // Stats Card Grid
                Card(
                  color: cs.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Nächstes Spiel'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Zurück'),
                ),
              ],
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
```

**2. Word Chain Completion Overlay (`WordChainCompletionOverlay`):**

```dart
class WordChainCompletionOverlay extends ConsumerWidget {
  const WordChainCompletionOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.lives,
    required this.onPlayAgain,
  });

  final int score;
  final int? highScore;
  final int lives;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWin = lives > 0;
    final currentStreak = ref.watch(streakProvider).consecutiveDays;

    return Container(
      color: cs.surface.withValues(alpha: 0.95),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: StaggerCascade(
              children: [
                if (isWin) ...[
                  const ConfettiBurst(),
                  const SizedBox(height: 16),
                  Icon(Icons.emoji_events_rounded, size: 80, color: Colors.amber[600]),
                ] else ...[
                  const SizedBox(height: 16),
                  Icon(Icons.heart_broken_rounded, size: 80, color: cs.error),
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
                  isWin ? 'Hervorragende Übersetzungsleistung!' : 'Keine Leben mehr übrig.',
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
                FilledButton.icon(
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Nochmal spielen'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Zurück'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

To display these, add a state variable `bool _isCompleted = false` in both `_MemoryMatchScreenState` and `_WordChainScreenState`. Wrap the body of both build methods in a `Stack` showing the gameplay screen and, if `_isCompleted` is true, the corresponding completion overlay.

---

## 5. Verification Method

To verify this implementation independently:

1. **Verify Formatting & Static Analysis:**
   Run the static analysis check to ensure no new errors were introduced:
   ```bash
   flutter analyze
   ```
2. **Execute Engine Unit Tests:**
   Ensure current gameplay logic remains functional:
   ```bash
   flutter test test/memory_match_engine_test.dart
   flutter test test/word_chain_engine_test.dart
   ```
3. **Write New UI and Animation Tests:**
   * Write tests asserting that the game card (`MemoryCardTile`) changes rotation from `0.0` to `3.14159265` when `faceUp` transitions to `true`.
   * Assert that `_CountdownRing` uses the updated animation controller and that the progress bar decreases smoothly instead of skipping dynamically.
   * Verify that when the win/loss criteria are satisfied in both games, `AlertDialog` is not present, and the full-screen overlay components (`ConfettiBurst`, `StreakBadge`, statistics rows, play buttons) are mounted.
   * Run the newly created test suite:
     ```bash
     flutter test test/games_ui_enhancements_test.dart
     ```
