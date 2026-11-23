import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/stt_service.dart';
import '../../../../core/i18n/bidi_utils.dart';
import '../../../../core/i18n/strings.dart';
import '../../../../core/i18n/translations.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/answer_normalizer.dart';

/// Interactive pronunciation coach widget for speaking repetition exercises.
///
/// Follows the forgiving coaching philosophy:
///   1. Listen to native studio audio
///   2. Record speech with forgiving on-device STT
///   3. Compare normalized text via Levenshtein similarity
///   4. If match >= 70%: celebrate and pass
///   5. If match < 70%: show feedback, offer retry OR "Mark as Practiced"
///   6. If STT unavailable: fallback to self-assessment (learner is NEVER blocked)
class PronunciationCoachWidget extends ConsumerStatefulWidget {
  const PronunciationCoachWidget({
    super.key,
    required this.targetText,
    this.audioText,
    required this.onCompleted,
    this.languageCode = 'en',
  });

  final String targetText;
  final String? audioText;
  final ValueChanged<bool> onCompleted;
  final String languageCode;

  @override
  ConsumerState<PronunciationCoachWidget> createState() =>
      _PronunciationCoachWidgetState();
}

class _PronunciationCoachWidgetState
    extends ConsumerState<PronunciationCoachWidget> {
  bool _isListening = false;
  String? _recognizedText;
  double? _similarityScore;
  bool _isEvaluated = false;
  bool _sttUnavailable = false;

  void _playNativeAudio() {
    final textToPlay = widget.audioText ?? widget.targetText;
    ref.read(audioPlaybackServiceProvider).speak(textToPlay);
  }

  Future<void> _startListening() async {
    final stt = ref.read(sttServiceProvider);

    setState(() {
      _isListening = true;
      _recognizedText = null;
      _similarityScore = null;
      _isEvaluated = false;
      _sttUnavailable = false;
    });

    try {
      final text = await stt.listenOnce(
        onPartial: (partial) {
          if (mounted) {
            setState(() => _recognizedText = partial);
          }
        },
        listenFor: const Duration(seconds: 8),
      );

      if (!mounted) return;

      final normalizedClean = AnswerNormalizer.cleanBiDi(text);
      final score = AnswerNormalizer.similarity(normalizedClean, widget.targetText);
      final isExact = AnswerNormalizer.isMatch(normalizedClean, widget.targetText);

      setState(() {
        _isListening = false;
        _recognizedText = normalizedClean;
        _similarityScore = isExact ? 1.0 : score;
        _isEvaluated = true;
      });

      // If high confidence match (>= 70%), auto-complete after short pause
      if (_similarityScore! >= 0.70) {
        widget.onCompleted(true);
      }
    } on SttUnavailableException catch (_) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _sttUnavailable = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _sttUnavailable = true;
        });
      }
    }
  }

  void _markAsPracticed() {
    setState(() {
      _isEvaluated = true;
      _similarityScore = 1.0;
    });
    widget.onCompleted(true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Target Phrase Card ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E22) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  widget.targetText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // Listen to native audio button
              OutlinedButton.icon(
                onPressed: _playNativeAudio,
                icon: const Icon(Icons.volume_up_rounded, size: 20),
                label: Text(t(context, Str.listenNative)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Mic / Recording Action ──
        if (!_isEvaluated || _similarityScore! < 0.70)
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _isListening ? null : _startListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? Colors.red
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : AppColors.primary)
                              .withValues(alpha: 0.35),
                          blurRadius: _isListening ? 20 : 10,
                          spreadRadius: _isListening ? 4 : 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isListening
                      ? t(context, Str.listeningState)
                      : t(context, Str.tapToSpeak),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

        // ── STT Unavailable Fallback Banner ──
        if (_sttUnavailable) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t(context, Str.speechNotAvailable),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.amber[200] : Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _markAsPracticed,
            icon: const Icon(Icons.check_circle_rounded, size: 18),
            label: Text(t(context, Str.markAsPracticed)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],

        // ── Evaluation / Feedback Box ──
        if (_isEvaluated && _similarityScore != null && !_sttUnavailable) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _similarityScore! >= 0.70
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _similarityScore! >= 0.70
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.orange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      _similarityScore! >= 0.70
                          ? Icons.check_circle_rounded
                          : Icons.record_voice_over_rounded,
                      color: _similarityScore! >= 0.70 ? Colors.green : Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _similarityScore! >= 0.70
                          ? t(context, Str.greatPronunciation)
                          : t(context, Str.goodTry),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _similarityScore! >= 0.70 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                if (_recognizedText != null && _recognizedText!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    t(context, Str.youSaid,
                        args: [BidiUtils.isolateGerman(_recognizedText!)]),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
                if (_similarityScore! < 0.70) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _startListening,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(t(context, Str.tryAgainCoach)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _markAsPracticed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(t(context, Str.markAsPracticed)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
