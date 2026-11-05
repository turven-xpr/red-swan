// Stroke-painting helpers were retired in favour of an asset-driven
// splash screen.  This file is preserved so any future re-introduction
// of native-painted splash effects can import these symbols without
// re-implementing them.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A painter kept for backwards compatibility.  New code should use the
/// asset-driven splash in `splash_screen.dart`.
class GermanFlagPainter extends CustomPainter {
  GermanFlagPainter({required this.progress, this.color});

  final double progress;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = const Radius.circular(20);
    final rect = RRect.fromRectAndRadius(Offset.zero & size, radius);

    canvas.save();
    canvas.clipRRect(rect);

    final h = size.height / 3;
    final w = size.width * progress;

    void stripe(Color color, double y) {
      final p = Paint()..color = color;
      canvas.drawRect(Rect.fromLTWH(0, y, w, h), p);
    }

    stripe(const Color(0xFF111111), 0);
    stripe(const Color(0xFFCC2027), h);
    stripe(const Color(0xFFE0A023), 2 * h);

    canvas.restore();

    final border = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(rect, border);
  }

  @override
  bool shouldRepaint(covariant GermanFlagPainter old) =>
      old.progress != progress || old.color != color;
}

class DeutschyWordmarkPainter extends CustomPainter {
  DeutschyWordmarkPainter({required this.progress, this.color});

  static const String _word = 'Deutschy';

  final double progress;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = color ?? AppColors.primary;
    final style = TextStyle(
      color: baseColor,
      fontSize: size.height * 0.85,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    );
    final tp = TextPainter(
      text: TextSpan(text: _word, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: size.width);
    final dx = (size.width - tp.width) / 2;
    final dy = (size.height - tp.height) / 2;
    canvas.save();
    canvas.translate(dx, dy);
    final reveal = (progress.clamp(0.0, 1.0)) * tp.width + 6;
    canvas.clipRect(Rect.fromLTRB(-6, -6, reveal, tp.height + 12));
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DeutschyWordmarkPainter old) =>
      old.progress != progress || old.color != color;
}
