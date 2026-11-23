import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/answer_normalizer.dart';

/// An interactive sentence-builder where learners drag/tap German word tiles
/// into the correct order.
///
/// Each tile is wrapped in [Directionality.ltr] so German text renders
/// correctly inside Arabic RTL layouts. BiDi isolates are stripped before
/// answer comparison via [AnswerNormalizer].
class SentenceScrambleWidget extends StatefulWidget {
  const SentenceScrambleWidget({
    super.key,
    required this.correctTokens,
    required this.onCompleted,
    this.languageCode = 'en',
  });

  /// The correct word order, e.g. ['Ich', 'habe', 'einen', 'Bruder'].
  final List<String> correctTokens;

  /// Called when the learner submits their answer. Passes true if correct.
  final ValueChanged<bool> onCompleted;

  /// Current UI language for localized labels.
  final String languageCode;

  @override
  State<SentenceScrambleWidget> createState() => _SentenceScrambleWidgetState();
}

class _SentenceScrambleWidgetState extends State<SentenceScrambleWidget> {
  late List<String> _availableTokens;
  final List<String> _placedTokens = [];
  bool _submitted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _resetTokens();
  }

  @override
  void didUpdateWidget(SentenceScrambleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.correctTokens != widget.correctTokens) {
      _resetTokens();
    }
  }

  void _resetTokens() {
    _availableTokens = List.of(widget.correctTokens)..shuffle();
    _placedTokens.clear();
    _submitted = false;
    _isCorrect = false;
  }

  void _tapAvailable(int index) {
    if (_submitted) return;
    setState(() {
      _placedTokens.add(_availableTokens.removeAt(index));
    });
  }

  void _tapPlaced(int index) {
    if (_submitted) return;
    setState(() {
      _availableTokens.add(_placedTokens.removeAt(index));
    });
  }

  void _submit() {
    if (_submitted || _placedTokens.length != widget.correctTokens.length) return;

    final learnerSentence = _placedTokens.join(' ');
    final correctSentence = widget.correctTokens.join(' ');
    final correct = AnswerNormalizer.isMatch(learnerSentence, correctSentence);

    setState(() {
      _submitted = true;
      _isCorrect = correct;
    });

    widget.onCompleted(correct);
  }

  void _retry() {
    setState(_resetTokens);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instruction label
        Text(
          _localizeInstruction(widget.languageCode),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),

        // Answer zone — placed tokens
        _buildAnswerZone(isDark),
        const SizedBox(height: 16),

        // Available tokens bank
        if (!_submitted || !_isCorrect)
          _buildTokenBank(isDark),

        const SizedBox(height: 16),

        // Submit / Retry button
        _buildActionButton(isDark),
      ],
    );
  }

  Widget _buildAnswerZone(bool isDark) {
    final borderColor = _submitted
        ? (_isCorrect ? Colors.green : Colors.red)
        : AppColors.primary.withValues(alpha: 0.3);

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: _placedTokens.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _localizeHint(widget.languageCode),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white30 : Colors.black26,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : Directionality(
              textDirection: TextDirection.ltr,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_placedTokens.length, (i) {
                  final isWrong = _submitted &&
                      !_isCorrect &&
                      i < widget.correctTokens.length &&
                      AnswerNormalizer.normalize(_placedTokens[i]) !=
                          AnswerNormalizer.normalize(widget.correctTokens[i]);

                  return _WordTile(
                    text: _placedTokens[i],
                    onTap: _submitted ? null : () => _tapPlaced(i),
                    isDark: isDark,
                    isPlaced: true,
                    isError: isWrong,
                    isCorrect: _submitted && _isCorrect,
                  );
                }),
              ),
            ),
    );
  }

  Widget _buildTokenBank(bool isDark) {
    if (_availableTokens.isEmpty) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(_availableTokens.length, (i) {
          return _WordTile(
            text: _availableTokens[i],
            onTap: _submitted ? null : () => _tapAvailable(i),
            isDark: isDark,
            isPlaced: false,
          );
        }),
      ),
    );
  }

  Widget _buildActionButton(bool isDark) {
    if (_submitted && !_isCorrect) {
      return OutlinedButton.icon(
        onPressed: _retry,
        icon: const Icon(Icons.refresh_rounded, size: 20),
        label: Text(_localizeRetry(widget.languageCode)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    }

    if (!_submitted) {
      final canSubmit = _placedTokens.length == widget.correctTokens.length;
      return ElevatedButton(
        onPressed: canSubmit ? _submit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark ? Colors.white12 : Colors.black12,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          _localizeCheck(widget.languageCode),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ── Localization helpers (no hardcoding — driven by languageCode) ──

  static String _localizeInstruction(String lang) {
    switch (lang) {
      case 'ar':
        return 'رتّب الكلمات لتكوين الجملة الصحيحة';
      case 'es':
        return 'Ordena las palabras para formar la oración correcta';
      default:
        return 'Arrange the words to form the correct sentence';
    }
  }

  static String _localizeHint(String lang) {
    switch (lang) {
      case 'ar':
        return 'اضغط على الكلمات لوضعها هنا';
      case 'es':
        return 'Toca las palabras para colocarlas aquí';
      default:
        return 'Tap words to place them here';
    }
  }

  static String _localizeCheck(String lang) {
    switch (lang) {
      case 'ar':
        return 'تحقّق';
      case 'es':
        return 'Comprobar';
      default:
        return 'Check';
    }
  }

  static String _localizeRetry(String lang) {
    switch (lang) {
      case 'ar':
        return 'حاول مرة أخرى';
      case 'es':
        return 'Intentar de nuevo';
      default:
        return 'Try Again';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// WORD TILE
// ─────────────────────────────────────────────────────────────────────

class _WordTile extends StatelessWidget {
  const _WordTile({
    required this.text,
    required this.isDark,
    required this.isPlaced,
    this.onTap,
    this.isError = false,
    this.isCorrect = false,
  });

  final String text;
  final bool isDark;
  final bool isPlaced;
  final VoidCallback? onTap;
  final bool isError;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isCorrect) {
      bgColor = Colors.green.withValues(alpha: 0.12);
      textColor = Colors.green;
      borderColor = Colors.green.withValues(alpha: 0.4);
    } else if (isError) {
      bgColor = Colors.red.withValues(alpha: 0.12);
      textColor = Colors.red;
      borderColor = Colors.red.withValues(alpha: 0.4);
    } else if (isPlaced) {
      bgColor = AppColors.primary.withValues(alpha: 0.1);
      textColor = AppColors.primary;
      borderColor = AppColors.primary.withValues(alpha: 0.3);
    } else {
      bgColor = isDark ? const Color(0xFF2A2A30) : Colors.white;
      textColor = isDark ? Colors.white : Colors.black87;
      borderColor = isDark ? Colors.white12 : Colors.black12;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              if (!isPlaced)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

