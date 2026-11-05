import 'package:flutter/material.dart';
import '../../../core/widgets/animations/premium_animations.dart';

/// Brand splash pulling the Deutschy logo from `assets/splash/`.
///
/// The screen swaps to the GoRouter when the user taps the screen,
/// the asset has finished decoding, or `autoAdvanceAfter` has elapsed —
/// whichever comes first.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.onCompleted,
    this.autoAdvanceAfter = const Duration(milliseconds: 2400),
  });

  /// Callback fired once the splash advances.  Caller is responsible for
  /// mounting the GoRouter (or the next widget).
  final VoidCallback? onCompleted;
  final Duration autoAdvanceAfter;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _fired = false;
  late final Future<void> _autoTimeout;
  final ImageProvider _logo = const AssetImage('assets/splash/splash_logo.png');

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _autoTimeout = Future<void>.delayed(widget.autoAdvanceAfter);

    // Listen for both the animation AND the timeout to advance.
    Future.microtask(() async {
      await Future.any([
        _ctrl.forward().then((_) async {}),
        _autoTimeout,
      ]);
      _fireIfReady();
    });

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) _fireIfReady();
    });
  }

  void _fireIfReady() {
    if (_fired || !mounted) return;
    _fired = true;
    widget.onCompleted?.call();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Announces itself to TalkBack / VoiceOver as a screen that is
  // momentarily loading Deutschy content.  Combine with header
  // semantics so screen-reader users don't hear "Deutschy wird vorbereitet …"
  // without context.
  return Semantics(
    container: true,
    label: 'Deutschy lädt',
    child: Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fade-and-scale-in logo.  Animation sits on top of the
              // asset image; no per-pixel custom paint required.
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  final t = Curves.easeOutCubic
                      .transform(_ctrl.value.clamp(0.0, 1.0));
                  return Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1.0 - t)),
                      child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
                    ),
                  );
                },
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 280,
                    maxHeight: 280,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.18),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  // We give the asset a clipping radius so the splash
                  // looks polished even if the asset is a square with
                  // sharp corners.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image(
                      image: _logo,
                      width: 240,
                      height: 240,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              OrbitRing(
                size: 40,
                color: theme.colorScheme.primary,
                strokeWidth: 2.6,
              ),
              const SizedBox(height: 14),
              Text(
                'Deutschy wird vorbereitet …',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
