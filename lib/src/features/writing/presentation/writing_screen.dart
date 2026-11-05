import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/animations/deutschy_animations.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/gemini_client.dart';

import '../../../core/i18n/strings.dart';

import '../../../core/i18n/translations.dart';

/// Writing practice screen.  User writes a paragraph of German text and
/// gets a structured correction panel back from the Gemini proxy.
class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  final _controller = TextEditingController();
  String _level = 'A1';
  bool _busy = false;
  WritingFeedback? _result;
  String? _error;

  /// Maximum input length — keep below Gemini's free-tier well and
  /// above the most useful free-write length.  Past this, the input
  /// hint glows red and the submit button disables.
  static const int _maxChars = 1200;
  static const int _minChars = 12;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Bitte erst etwas schreiben.');
      return;
    }
    if (text.length < _minChars) {
      setState(() => _error =
          'Noch mindestens $_minChars Zeichen, damit die KI genug '
          'zu bewerten hat.');
      return;
    }
    if (text.length > _maxChars) {
      setState(() => _error =
          'Zu lang — bitte kürze auf max $_maxChars Zeichen.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final gemini = ref.read(geminiClientProvider);
      final res = await gemini.correctWriting(
        userText: text,
        level: _level,
      );
      // save submission locally
      await ref.read(appDatabaseProvider).insertWriting(
            WritingSubmissionsCompanion.insert(userText: text),
          );
      if (!mounted) return;
      setState(() => _result = res);
    } catch (e) {
      // Friendly fallback — never expose raw exceptions to the user.
      // They can still Retry or check the proxy from /profile later.
      String message;
      final raw = e.toString();
      if (raw.contains('TimeoutException') ||
          raw.contains('SocketException') ||
          raw.contains('Connection')) {
        message = 'Coach nicht erreichbar — bitte Internet prüfen.';
      } else if (raw.contains('FormatException') ||
          raw.contains('JSON')) {
        message = 'Antwort nicht lesbar — bitte erneut versuchen.';
      } else {
        message = 'Etwas ist schiefgelaufen — bitte erneut versuchen.';
      }
      if (mounted) setState(() => _error = message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.navWriting))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Level chooser
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'A1', label: Text('A1')),
                  ButtonSegment(value: 'A2', label: Text('A2')),
                  ButtonSegment(value: 'B1', label: Text('B1')),
                ],
                selected: {_level},
                onSelectionChanged: (s) => setState(() => _level = s.first),
              ),
              const SizedBox(height: 16),
              // TextField with character counter + maxLength.  The
              // counter is rendered as the suffix so it stays anchored
              // to the input border even when the input grows.
              TextField(
                controller: _controller,
                minLines: 5,
                maxLines: 12,
                maxLength: _maxChars,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '$currentLength / $maxLength',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: currentLength > _maxChars
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                decoration: InputDecoration(
                  hintText: 'Schreibe einen deutschen Absatz…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  helperText: 'Mindestens $_minChars, höchstens $_maxChars Zeichen.',
                  helperStyle: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _busy
                    ? OutlinedButton.icon(
                        icon: const BouncingDots(size: 8),
                        label: const ShimmerText(text: 'Prüfe …'),
                        onPressed: null,
                      )
                    : FilledButton.icon(
                        icon: const Icon(Icons.auto_fix_high),
                        onPressed: _submit,
                        label: const Text('Korrigieren'),
                      ),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: theme.colorScheme.onErrorContainer),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_error!,
                              style: TextStyle(
                                  color:
                                      theme.colorScheme.onErrorContainer)),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Erneut versuchen'),
                          onPressed: _busy ? null : _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_result != null) _FeedbackPanel(feedback: _result!),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({required this.feedback});
  final WritingFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: theme.colorScheme.primary.withValues(alpha: 0.10),
          child: ListTile(
            title: Text('Score: ${feedback.scoreOutOf10}/10'),
            subtitle: Text(feedback.overallFeedback),
          ),
        ),
        const SizedBox(height: 12),
        for (final c in feedback.corrections) _CorrectionCard(c: c),
      ],
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  const _CorrectionCard({required this.c});
  final SentenceCorrection c;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original (struck through)
            Text(c.original,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.error,
                  fontSize: 16,
                )),
            const SizedBox(height: 4),
            // Corrected
            Text(c.corrected,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(c.errorType,
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 6),
            Text(c.explanation),
          ],
        ),
      ),
    );
  }
}
