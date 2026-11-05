import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/widgets/animations/premium_animations.dart';
import '../../../data/seed/grammar_lessons.dart';

/// Grammar reference screen — a CEFR-tier catalog of lessons.  Lessons
/// are emitted from `lib/src/data/seed/grammar_lessons.dart`; tapping
/// expands the card to reveal explanation paragraphs plus a worked
/// example.  StaggerCascade fires the entry animation.
class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.grammarTitle))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: StaggerCascade(
          children: [
            for (var i = 0; i < kGrammarLessons.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GrammarCard(lesson: kGrammarLessons[i], index: i),
              ),
          ],
        ),
      ),
    );
  }
}

/// Card with a tap-to-expand disclosure panel.  Every lesson renders
/// its level chip, head, subtitle, the in-depth paragraphs, and a single
/// worked example.
class _GrammarCard extends StatefulWidget {
  const _GrammarCard({required this.lesson, required this.index});
  final GrammarLesson lesson;
  final int index;

  @override
  State<_GrammarCard> createState() => _GrammarCardState();
}

class _GrammarCardState extends State<_GrammarCard>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;
  late final Animation<double> _turn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _turn = Tween<double>(begin: 0, end: 0.18).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lesson = widget.lesson;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: cs.surfaceContainerHigh,
            child: InkWell(
              onTap: _toggle,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: child!,
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _LevelChip(level: lesson.level),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(lesson.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      )),
                ),
                AnimatedBuilder(
                  animation: _turn,
                  builder: (context, _) => Transform.rotate(
                    angle: _turn.value * 6.28,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(lesson.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.66),
                )),
            if (_open) ...[
              const SizedBox(height: 16),
              for (final p in lesson.bodyParagraphs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MarkdownParagraph(text: p),
                ),
              const SizedBox(height: 4),
              _ExampleBlock(
                  de: lesson.exampleDe, en: lesson.exampleEn),
              const SizedBox(height: 12),
              _ComprehensionCheck(lesson: lesson),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level});
  final String level;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;
    switch (level) {
      case 'A2':
        bg = cs.tertiaryContainer;
        fg = cs.onTertiaryContainer;
      case 'B1':
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
      default: // A1 and any future
        bg = cs.primaryContainer;
        fg = cs.onPrimaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(level,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 0.5,
          )),
    );
  }
}

class _MarkdownParagraph extends StatelessWidget {
  const _MarkdownParagraph({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Crude inline **bold** rendering, no need for a Markdown package.
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    var cursor = 0;
    for (final m in regex.allMatches(text)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      spans.add(TextSpan(
        text: m.group(1),
        style: TextStyle(fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface),
      ));
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.86),
          height: 1.45,
        ),
        children: spans,
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  const _ExampleBlock({required this.de, required this.en});
  final String de;
  final String en;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(de,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text(en,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              )),
        ],
      ),
    );
  }
}

class _ComprehensionCheck extends StatefulWidget {
  const _ComprehensionCheck({required this.lesson});
  final GrammarLesson lesson;

  @override
  State<_ComprehensionCheck> createState() => _ComprehensionCheckState();
}

class _ComprehensionCheckState extends State<_ComprehensionCheck> {
  bool? _correct;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                'Verständnis-Check',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Passt das Beispiel "${widget.lesson.exampleDe}" zu dieser Regel?',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ChoiceChip(
                label: const Text('Ja, stimmt!'),
                selected: _correct == true,
                selectedColor: cs.primaryContainer,
                onSelected: (_) {
                  setState(() => _correct = true);
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Nein'),
                selected: _correct == false,
                onSelected: (_) {
                  setState(() => _correct = false);
                },
              ),
            ],
          ),
          if (_correct != null) ...[
            const SizedBox(height: 6),
            Text(
              _correct!
                  ? '🎉 Richtig! Das Beispiel illustriert genau diese Grammatikregel.'
                  : '💡 Nicht ganz. Das Beispiel passt perfekt zur beschriebenen Regel.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _correct! ? cs.primary : cs.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
