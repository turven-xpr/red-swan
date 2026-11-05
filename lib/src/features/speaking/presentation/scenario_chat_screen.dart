import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/audio/stt_service.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../data/local/app_database.dart';
import '../../../core/widgets/animations/premium_animations.dart';

class ChatMessage {
  ChatMessage({required this.text, required this.fromUser});
  final String text;
  final bool fromUser;
}

/// Multi-turn dialogue screen.
///   User taps → mic (STT) → sends transcript to Gemini proxy → AI replies
///   in German → reply is auto-played via native TTS.  No audio file I/O,
///   no remote STT (we use the device STT engine for $0 cost).
class ScenarioChatScreen extends ConsumerStatefulWidget {
  const ScenarioChatScreen({super.key, required this.scenarioId});
  final int scenarioId;

  @override
  ConsumerState<ScenarioChatScreen> createState() =>
      _ScenarioChatScreenState();
}

class _ScenarioChatScreenState extends ConsumerState<ScenarioChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollCtrl = ScrollController();
  bool _busy = false;
  bool _userIsListening = false;
  String _partialText = '';
  SpeakingScenario? _scenario;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final tts = ref.read(ttsServiceProvider);
    final seed = await ref.read(appDatabaseProvider)
        .watchAllScenarios()
        .first;
    final scenario = seed.firstWhere((s) => s.id == widget.scenarioId,
        orElse: () => seed.first);
    setState(() {
      _scenario = scenario;
      _messages.add(ChatMessage(text: scenario.openingMessage, fromUser: false));
    });
    _scrollToBottom();
    await tts.speak(scenario.openingMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _onMic() async {
    final stt = ref.read(sttServiceProvider);
    final tts = ref.read(ttsServiceProvider);
    if (_userIsListening) return;
    _userIsListening = true;
    setState(() => _partialText = '');
    try {
      final transcript = await stt.listenOnce(
        onPartial: (p) => setState(() => _partialText = p),
      );
      if (transcript.trim().isEmpty) {
        setState(() => _userIsListening = false);
        return;
      }
      setState(() {
        _userIsListening = false;
        _messages.add(ChatMessage(text: transcript, fromUser: true));
        _busy = true;
      });
      _scrollToBottom();
      // Forward to AI
      try {
        final history = _messages.map((m) => m.text).toList();
        final reply = await ref.read(geminiClientProvider)
            .continueSpeakingScenario(
          scenarioId: widget.scenarioId,
          history: history,
          userMessage: transcript,
          systemPrompt: _scenario?.systemPrompt,
        );
        if (reply.isNotEmpty) {
          _messages.add(ChatMessage(text: reply, fromUser: false));
          _scrollToBottom();
          await tts.speak(reply);
        }
      } catch (e) {
        // Soft-fail: tell the user that the AI is unreachable but the app
        // continues to work offline (vocab + writing + grammar).
        _messages.add(ChatMessage(
          text: '⚠️ AI ist momentan nicht erreichbar (offline).',
          fromUser: false,
        ));
        _scrollToBottom();
      }
    } on SttUnavailableException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _userIsListening = false;
          _partialText = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(context, Str.navSpeaking))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              reverse: false,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return _ChatBubble(message: m);
              },
            ),
          ),
          if (_busy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: OrbitRing(
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          if (_partialText.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('…$_partialText',
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                decoration: _userIsListening
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      )
                    : null,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _onMic,
                  icon: Icon(_userIsListening ? Icons.mic : Icons.mic_none),
                  label: Text(_busy
                      ? 'Spreche …'
                      : (_userIsListening ? 'Ich höre dir zu …' : 'Antworten')),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align =
        message.fromUser ? Alignment.centerRight : Alignment.centerLeft;
    final bg = message.fromUser
        ? theme.colorScheme.primary
        : theme.cardTheme.color ?? theme.colorScheme.surface;
    final fg = message.fromUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    return Semantics(
      label: '${message.fromUser ? "Du" : "KI"}: ${message.text}',
      child: Align(
        alignment: align,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(message.text, style: TextStyle(color: fg)),
        ),
      ),
    );
  }
}
