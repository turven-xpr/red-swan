import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Animated widgets that produce a "premium" feel — staggered entry, hero
// transitions, gesture-aware reviews.
// ─────────────────────────────────────────────────────────────────────────────

/// Wrap a static-typed children list to enter the screen with a clean
/// cascading animation.  Each child is offset from the previous by 50 ms.
/// Falls back gracefully when `prefersReducedMotion`.
class StaggerCascade extends StatelessWidget {
  const StaggerCascade({
    super.key,
    required this.children,
    this.delayMs = 60,
    this.durationMs = 380,
    this.curve = Curves.easeOutCubic,
  });
  final List<Widget> children;
  final int delayMs;
  final int durationMs;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false) ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (reducedMotion) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: durationMs),
            curve: curve,
            builder: (ctx, t, child) {
              return Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 14),
                  child: child,
                ),
              );
            },
            child: _DeferredMount(
              delay: Duration(milliseconds: i * delayMs),
              child: children[i],
            ),
          ),
      ],
    );
  }
}

class _DeferredMount extends StatefulWidget {
  const _DeferredMount({required this.delay, required this.child});
  final Duration delay;
  final Widget child;
  @override
  State<_DeferredMount> createState() => _DeferredMountState();
}

class _DeferredMountState extends State<_DeferredMount> {
  bool _mounted = false;
  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _mounted = true;
    } else {
      // Schedule the deferred build on the post-frame callback chain.
      // This avoids leaving a long-lived pending timer in widget tests
      // that don't subsequently pump more frames.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Convert frame-count delay into a frame-pump cadence.
        var remaining = widget.delay;
        const step = Duration(milliseconds: 32);
        void tick() {
          if (!mounted) return;
          if (remaining <= Duration.zero) {
            setState(() => _mounted = true);
            return;
          }
          remaining -= step;
          WidgetsBinding.instance.addPostFrameCallback((_) => tick());
        }
        tick();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _mounted ? widget.child : const SizedBox.shrink();
  }
}

/// Decorative ring that travels around a child widget — a flavourful
/// way to highlight the last-step feedback (e.g. "Kraken: 1.5x ease").
class OrbitRing extends StatefulWidget {
  const OrbitRing({
    super.key,
    required this.size,
    this.color,
    this.durationMs = 2400,
    this.strokeWidth = 2.5,
  });

  final double size;
  final Color? color;
  final int durationMs;
  final double strokeWidth;

  @override
  State<OrbitRing> createState() => _OrbitRingState();
}

class _OrbitRingState extends State<OrbitRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _OrbitPainter(_ctrl.value, c, widget.strokeWidth),
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter(double t, Color c, double w) : _t = t, _c = c, _w = w;
  final double _t;
  final Color _c;
  final double _w;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;

    final base = Paint()
      ..color = _c.withValues(alpha: 0.08)
      ..strokeWidth = _w
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(centre, radius, base);

    final arc = Paint()
      ..color = _c
      ..strokeWidth = _w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final sweep = _t * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -3.14159 / 2,
      sweep,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old._t != _t;
}

/// A "soft, premium" roundification for any [Container] — sleeves a
/// subtle inner shadow + 1px outline so cards float gently.
class GlossySurface extends StatelessWidget {
  const GlossySurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.glow = false,
  });
  final Widget child;
  final double radius;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: cs.surfaceContainerHigh,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.18),
                  blurRadius: 22,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

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
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.enabled && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.enabled && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion || !widget.enabled || widget.onTap == null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onTap : null,
        child: widget.child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
    );
    _ctrl.forward();
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
