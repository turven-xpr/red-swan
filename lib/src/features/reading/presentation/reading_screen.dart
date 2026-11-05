import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/tts_service.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/animations/premium_animations.dart';

/// Reading screen — short, level-tagged German texts with a tappable
/// "Read aloud" button that drops into the native TTS service.
class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  static const _passages = <Map<String, Object>>[
    {
      'level': 'A1',
      'title': 'Im Café',
      'body':
          'Anna geht ins Café. Sie bestellt einen Kaffee und ein Croissant. '
          'Der Kaffee kostet drei Euro. Anna trinkt den Kaffee und liest ein Buch. '
          'Das Café ist klein, aber sehr gemütlich.',
    },
    {
      'level': 'A2',
      'title': 'Am Wochenende',
      'body':
          'Am Samstag gehe ich mit meinen Freunden in den Park. Wir picknicken '
          'und spielen Fußball. Am Abend koche ich Spaghetti für meine Familie. '
          'Das Wetter ist schön und wir haben viel Spaß.',
    },
    {
      'level': 'B1',
      'title': 'Bewerbungsgespräch',
      'body':
          'Vor dem Bewerbungsgespräch habe ich mich gründlich vorbereitet. '
          'Ich habe meinen Lebenslauf noch einmal gelesen und typische Fragen geübt. '
          'Im Gespräch konnte ich meine Stärken überzeugend darstellen.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.readingTitle))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StaggerCascade(
            children: [
              for (final p in _passages) _PassageCard(passage: p),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassageCard extends ConsumerStatefulWidget {
  const _PassageCard({required this.passage});
  final Map<String, Object> passage;

  @override
  ConsumerState<_PassageCard> createState() => _PassageCardState();
}

class _PassageCardState extends ConsumerState<_PassageCard> {
  bool _isSpeaking = false;
  StreamSubscription<TtsState>? _ttsSub;

  @override
  void dispose() {
    _ttsSub?.cancel();
    super.dispose();
  }

  void _onSpeak(TtsService tts, String body) async {
    if (_isSpeaking) {
      await tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    } else {
      _ttsSub?.cancel();
      _ttsSub = tts.state.listen((state) {
        if (mounted) {
          setState(() {
            _isSpeaking = state == TtsState.playing;
          });
        }
      });
      await tts.speak(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tts = ref.watch(ttsServiceProvider);
    final passage = widget.passage;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${passage['level']}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: primaryColor),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isSpeaking ? Icons.volume_up_rounded : Icons.volume_up,
                    color: _isSpeaking ? primaryColor : null,
                  ),
                  tooltip: 'Vorlesen',
                  onPressed: () => _onSpeak(tts, passage['body'] as String),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${passage['title']}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${passage['body']}',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
