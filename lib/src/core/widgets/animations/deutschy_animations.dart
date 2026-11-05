import 'package:flutter/material.dart';

/// Reusable animated widgets centralised in one library so every
/// loading cue across Deutschy (splash, AI response card, results list)
/// shares the same look-and-feel.
///
/// All three are pure-Dart `StatefulWidget`s plus
/// `SingleTickerProviderStateMixin` — no third-party dependencies.

/// Three-dot semaphore commonly used for inline loaders / "thinking".
class BouncingDots extends StatefulWidget {
  const BouncingDots({
    super.key,
    required this.size,
    this.color,
  });

  /// Diameter of a single dot in logical pixels.
  final double size;

  /// Inherits `colorScheme.primary` if null.
  final Color? color;

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          width: widget.size * 3.6,
          height: widget.size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(3, (i) {
              // Phase each dot at 0, 120ms, 240ms offset to produce
              // a left-to-right traveling wave.
              final t = (_ctrl.value + i / 3.0) % 1.0;
              final scale = 0.7 + 0.3 * (1 - (t - 0.5).abs() * 2).clamp(0, 1);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

/// Pulsing ring used while the splash is fading through the last mile,
/// and as the typical inline loading cue in cards.
class FadingRing extends StatefulWidget {
  const FadingRing({
    super.key,
    this.size = 48,
    this.color,
    this.strokeWidth = 3,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  State<FadingRing> createState() => _FadingRingState();
}

class _FadingRingState extends State<FadingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Static low-opacity track.
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
              ),
              // Sweeping arc (full rotation per cycle).
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: Transform.rotate(
                  angle: _c.value * 2 * 3.14159,
                  child: CustomPaint(
                    painter: _RingArcPainter(
                      progress: _c.value,
                      color: color,
                      strokeWidth: widget.strokeWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingArcPainter extends CustomPainter {
  _RingArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      -3.14159 / 2,
      progress * 2 * 3.14159,
      false,
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _RingArcPainter old) =>
      old.progress != progress || old.color != color;
}

/// Shimmer / striped sweep across text — used for "AI is generating…"
/// headers in the writing-feedback screen so users see motion and know
/// the request is still alive.
class ShimmerText extends StatefulWidget {
  const ShimmerText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.style?.color ?? theme.colorScheme.primary;
    final base = widget.style ??
        theme.textTheme.titleMedium?.copyWith(
          color: baseColor,
        );
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-1.0 + _c.value * 2, -0.3),
            end: Alignment(1.0 + _c.value * 2, 0.3),
            colors: <Color>[
              baseColor,
              baseColor.withValues(alpha: 0.45),
              baseColor,
            ],
          ).createShader(bounds),
          child: Text(widget.text, style: base),
        );
      },
    );
  }
}
