import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/bidi_utils.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/gender_colors.dart';
import '../../data/content_repository.dart';
import '../../domain/curriculum_models.dart';

/// Universal presentation card widget for the PPP teaching engine.
///
/// Renders one of four card types:
///   - [LearnCardType.phonetic]    — letter, mouth tip, contrast pairs, samples
///   - [LearnCardType.concept]     — color swatch / number group, chunk audio
///   - [LearnCardType.nounArticle] — gender badge, article, example sentence
///   - [LearnCardType.phraseChunk] — highlighted token, grammar note, audio
///
/// All German text is wrapped in [Directionality] LTR for Arabic RTL safety.
/// Gender colors use [GenderColors] with text badges for color-blind access.
class LearnCardWidget extends ConsumerWidget {
  const LearnCardWidget({
    super.key,
    required this.card,
    required this.languageCode,
  });

  final CurriculumLearnCard card;
  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (card.type) {
      case LearnCardType.phonetic:
        return _PhoneticCard(card: card, languageCode: languageCode, isDark: isDark);
      case LearnCardType.concept:
        return _ConceptCard(card: card, languageCode: languageCode, isDark: isDark);
      case LearnCardType.nounArticle:
        return _NounArticleCard(card: card, languageCode: languageCode, isDark: isDark, ref: ref);
      case LearnCardType.phraseChunk:
        return _PhraseChunkCard(card: card, languageCode: languageCode, isDark: isDark);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// PHONETIC CARD
// ─────────────────────────────────────────────────────────────────────

class _PhoneticCard extends ConsumerWidget {
  const _PhoneticCard({
    required this.card,
    required this.languageCode,
    required this.isDark,
  });

  final CurriculumLearnCard card;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryText = card.customPromptDe ?? '';
    final mouthTip = _localizedMouthTip;
    final contrastPairs = card.contrastPairs;
    final sampleWords = card.sampleWords;

    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Large letter display
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                primaryText,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Audio button for the letter/sound
          _AudioChip(text: primaryText, ref: ref, isDark: isDark),
          const SizedBox(height: 16),

          // Anchor word with translation (e.g., A wie Apfel -> der Apfel / apple)
          if (card.anchorWordDe != null && card.anchorWordDe!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          card.anchorWordDe!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _AudioIconButton(
                        text: card.anchorWordDe!,
                        ref: ref,
                      ),
                    ],
                  ),
                  if (_localizedAnchorTranslation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _localizedAnchorTranslation!,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Example sentence (e.g. Der Apfel ist rot.)
          if (card.exampleSentenceDe != null && card.exampleSentenceDe!.isNotEmpty) ...[
            _ExampleSentence(
              german: card.exampleSentenceDe!,
              translation: card.localizedExampleSentence(languageCode),
              highlightWord: _extractCoreWord(card.anchorWordDe),
              ref: ref,
              isDark: isDark,
            ),
            const SizedBox(height: 14),
          ],

          // Mouth / tongue tip
          if (mouthTip != null && mouthTip.isNotEmpty)
            _TipBox(text: mouthTip, isDark: isDark, icon: Icons.tips_and_updates_rounded),

          // Contrast pairs (ich vs ach)
          if (contrastPairs.isNotEmpty) ...[
            const SizedBox(height: 14),
            _SectionLabel(
              text: _localizeLabel('contrastPairs'),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: contrastPairs.map((pair) {
                final wordA = pair['word_a']?.toString() ?? '';
                final wordB = pair['word_b']?.toString() ?? '';
                return _ContrastPairChip(
                  wordA: wordA,
                  wordB: wordB,
                  ref: ref,
                  isDark: isDark,
                );
              }).toList(),
            ),
          ],

          // Sample words
          if (sampleWords.isNotEmpty) ...[
            const SizedBox(height: 14),
            _SectionLabel(
              text: _localizeLabel('sampleWords'),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: sampleWords.map((word) {
                return _AudioWordChip(text: word, ref: ref, isDark: isDark);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String? get _localizedMouthTip {
    switch (languageCode) {
      case 'ar':
        return card.mouthTipAr ?? card.mouthTipEn;
      case 'es':
        return card.mouthTipEs ?? card.mouthTipEn;
      default:
        return card.mouthTipEn;
    }
  }

  String? get _localizedAnchorTranslation {
    switch (languageCode) {
      case 'ar':
        return card.anchorWordAr ?? card.anchorWordEn;
      case 'es':
        return card.anchorWordEs ?? card.anchorWordEn;
      default:
        return card.anchorWordEn;
    }
  }

  String _localizeLabel(String key) {
    switch (key) {
      case 'contrastPairs':
        switch (languageCode) {
          case 'ar':
            return 'أزواج متقابلة';
          case 'es':
            return 'Pares de contraste';
          default:
            return 'Contrast Pairs';
        }
      case 'sampleWords':
        switch (languageCode) {
          case 'ar':
            return 'كلمات نموذجية';
          case 'es':
            return 'Palabras de ejemplo';
          default:
            return 'Example Words';
        }
      default:
        return key;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// CONCEPT CARD
// ─────────────────────────────────────────────────────────────────────

class _ConceptCard extends ConsumerWidget {
  const _ConceptCard({
    required this.card,
    required this.languageCode,
    required this.isDark,
  });

  final CurriculumLearnCard card;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryText = card.customPromptDe ?? card.chunkDe ?? '';
    final swatchHex = card.swatchHex;
    final translation = _localizedTranslation;

    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Color swatch (for colors) or icon (for numbers/dates)
              if (swatchHex != null && swatchHex.isNotEmpty)
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: _parseHex(swatchHex),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                ),

              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    primaryText,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Audio
          _AudioChip(text: primaryText, ref: ref, isDark: isDark),

          // Translation
          if (translation != null && translation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              translation,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],

          // Example sentence
          if (card.exampleSentenceDe != null) ...[
            const SizedBox(height: 14),
            _ExampleSentence(
              german: card.exampleSentenceDe!,
              translation: _localizedSentence,
              highlightWord: _extractCoreWord(card.chunkDe ?? card.customPromptDe),
              ref: ref,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  String? get _localizedTranslation {
    return card.localizedTranslation(languageCode) ?? card.sentenceEn;
  }

  String? get _localizedSentence {
    return card.localizedExampleSentence(languageCode);
  }

  static Color _parseHex(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }
    if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return Colors.grey;
  }
}

// ─────────────────────────────────────────────────────────────────────
// NOUN + ARTICLE CARD
// ─────────────────────────────────────────────────────────────────────

class _NounArticleCard extends ConsumerWidget {
  const _NounArticleCard({
    required this.card,
    required this.languageCode,
    required this.isDark,
    required this.ref,
  });

  final CurriculumLearnCard card;
  final String languageCode;
  final bool isDark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    // Resolve the linked word to get gender, lemma, translations
    final repo = widgetRef.watch(contentRepositoryProvider);
    final linkedWord = card.wordId != null ? repo.getWordById(card.wordId!) : null;

    final gender = linkedWord?.gender;
    final lemma = linkedWord?.lemma ?? card.customPromptDe ?? '';
    final articleStr = GenderColors.article(gender);
    final genderLabel = GenderColors.accessibilityLabel(gender, languageCode);
    final genderFg = GenderColors.foreground(gender, isDark: isDark);
    final genderBg = GenderColors.background(gender, isDark: isDark);

    final translation = _resolveTranslation(linkedWord);
    final exampleDe = card.exampleSentenceDe;
    final exampleTranslation = _resolveExampleTranslation;

    return _CardShell(
      isDark: isDark,
      borderColor: genderFg.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gender badge + article + noun
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gender badge (color + text for accessibility)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: genderBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: genderFg.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$articleStr · $genderLabel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: genderFg,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              // Audio button
              _AudioIconButton(
                text: '$articleStr $lemma',
                ref: widgetRef,
                color: genderFg,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Large noun display
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$articleStr ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: genderFg,
                      ),
                    ),
                    TextSpan(
                      text: lemma,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Translation
          if (translation.isNotEmpty)
            Center(
              child: Text(
                translation,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ),

          // Plural form
          if (linkedWord?.plural != null && linkedWord!.plural!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  'Pl: die ${linkedWord.plural}',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: GenderColors.foreground('plural', isDark: isDark),
                  ),
                ),
              ),
            ),
          ],

          // Example sentence
          if (exampleDe != null && exampleDe.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ExampleSentence(
              german: exampleDe,
              translation: exampleTranslation,
              highlightWord: linkedWord?.lemma ?? _extractCoreWord(card.customPromptDe),
              ref: widgetRef,
              isDark: isDark,
              highlightColor: genderFg,
            ),
          ],
        ],
      ),
    );
  }

  String _resolveTranslation(CurriculumWord? word) {
    if (word == null) return '';
    switch (languageCode) {
      case 'ar':
        return word.translationAr;
      case 'es':
        return word.translationEs ?? word.translationEn;
      default:
        return word.translationEn;
    }
  }

  String? get _resolveExampleTranslation => card.localizedExampleSentence(languageCode);
}

// ─────────────────────────────────────────────────────────────────────
// PHRASE CHUNK CARD
// ─────────────────────────────────────────────────────────────────────

class _PhraseChunkCard extends ConsumerWidget {
  const _PhraseChunkCard({
    required this.card,
    required this.languageCode,
    required this.isDark,
  });

  final CurriculumLearnCard card;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chunkDe = card.chunkDe ?? card.customPromptDe ?? '';
    final highlightToken = card.highlightToken;
    final grammarNote = _localizedGrammarNote;
    final translation = _localizedTranslation;

    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phrase with optional highlighted token
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: _buildHighlightedPhrase(chunkDe, highlightToken),
            ),
          ),
          const SizedBox(height: 8),

          // Audio
          _AudioChip(text: chunkDe, ref: ref, isDark: isDark),

          // Translation
          if (translation != null && translation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                translation,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          // Grammar note
          if (grammarNote != null && grammarNote.isNotEmpty) ...[
            const SizedBox(height: 14),
            _TipBox(
              text: grammarNote,
              isDark: isDark,
              icon: Icons.lightbulb_outline_rounded,
            ),
          ],

          // Example sentence (if provided)
          if (card.exampleSentenceDe != null && card.exampleSentenceDe!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _ExampleSentence(
              german: card.exampleSentenceDe!,
              translation: card.localizedExampleSentence(languageCode),
              highlightWord: card.highlightToken ?? _extractCoreWord(chunkDe),
              ref: ref,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightedPhrase(String phrase, String? highlight) {
    if (highlight == null || highlight.isEmpty || !phrase.contains(highlight)) {
      return Text(
        phrase,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : Colors.black87,
        ),
        textAlign: TextAlign.center,
      );
    }

    final parts = phrase.split(highlight);
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ));
      }
      if (i < parts.length - 1) {
        spans.add(TextSpan(
          text: highlight,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary.withValues(alpha: 0.5),
            decorationThickness: 2,
          ),
        ));
      }
    }

    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(children: spans),
    );
  }

  String? get _localizedGrammarNote {
    switch (languageCode) {
      case 'ar':
        return card.grammaticalNoteAr ?? card.grammaticalNoteEn;
      case 'es':
        // No Spanish grammar note field yet; fall back to English
        return card.grammaticalNoteEn;
      default:
        return card.grammaticalNoteEn;
    }
  }

  String? get _localizedTranslation {
    switch (languageCode) {
      case 'ar':
        return card.sentenceAr ?? card.sentenceEn;
      case 'es':
        return card.sentenceEs ?? card.sentenceEn;
      default:
        return card.sentenceEn;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// SHARED BUILDING BLOCKS
// ─────────────────────────────────────────────────────────────────────

/// Outer card shell with consistent padding, border radius, and elevation.
class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.isDark,
    required this.child,
    this.borderColor,
  });

  final bool isDark;
  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.08)),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A centered audio play chip for primary text.
class _AudioChip extends StatelessWidget {
  const _AudioChip({
    required this.text,
    required this.ref,
    required this.isDark,
  });

  final String text;
  final WidgetRef ref;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => _playAudio(ref, text),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  BidiUtils.isolateGerman(text),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small icon-only audio button.
class _AudioIconButton extends StatelessWidget {
  const _AudioIconButton({
    required this.text,
    required this.ref,
    this.color,
  });

  final String text;
  final WidgetRef ref;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.volume_up_rounded, size: 24),
      color: color ?? AppColors.primary,
      onPressed: () => _playAudio(ref, text),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

/// Contrast pair chip showing two words side-by-side with audio.
class _ContrastPairChip extends StatelessWidget {
  const _ContrastPairChip({
    required this.wordA,
    required this.wordB,
    required this.ref,
    required this.isDark,
  });

  final String wordA;
  final String wordB;
  final WidgetRef ref;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _playAudio(ref, wordA),
              child: Text(
                wordA,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'vs',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
            InkWell(
              onTap: () => _playAudio(ref, wordB),
              child: Text(
                wordB,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A word chip that plays its audio on tap.
class _AudioWordChip extends StatelessWidget {
  const _AudioWordChip({
    required this.text,
    required this.ref,
    required this.isDark,
  });

  final String text;
  final WidgetRef ref;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _playAudio(ref, text),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volume_up_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extracts the core noun or lemma by stripping leading German articles.
String? _extractCoreWord(String? text) {
  if (text == null || text.trim().isEmpty) return null;
  final trimmed = text.trim();
  final lower = trimmed.toLowerCase();
  for (final article in [
    'der ', 'die ', 'das ', 'den ', 'dem ', 'des ',
    'ein ', 'eine ', 'einen ', 'einem ', 'einer ',
  ]) {
    if (lower.startsWith(article)) {
      return trimmed.substring(article.length).trim();
    }
  }
  return trimmed;
}

/// Example sentence display with German + translation, with the target word highlighted.
class _ExampleSentence extends StatelessWidget {
  const _ExampleSentence({
    required this.german,
    this.translation,
    required this.ref,
    required this.isDark,
    this.highlightWord,
    this.highlightColor,
  });

  final String german;
  final String? translation;
  final WidgetRef ref;
  final bool isDark;
  final String? highlightWord;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final effectiveHighlightColor = highlightColor ?? AppColors.primary;
    final normalStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      color: isDark ? Colors.white : Colors.black87,
    );
    final highlightStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      color: effectiveHighlightColor,
      backgroundColor: effectiveHighlightColor.withValues(alpha: isDark ? 0.20 : 0.10),
      decoration: TextDecoration.underline,
      decorationColor: effectiveHighlightColor.withValues(alpha: 0.6),
      decorationThickness: 2,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: effectiveHighlightColor.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text.rich(
                    TextSpan(
                      children: _buildSpans(german, highlightWord, normalStyle, highlightStyle),
                    ),
                  ),
                ),
              ),
              _AudioIconButton(
                text: german,
                ref: ref,
                color: effectiveHighlightColor,
              ),
            ],
          ),
          if (translation != null && translation!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              translation!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static List<InlineSpan> _buildSpans(
    String text,
    String? target,
    TextStyle normalStyle,
    TextStyle highlightStyle,
  ) {
    if (target == null || target.trim().isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final cleanTarget = target.trim();
    final lowerText = text.toLowerCase();
    final lowerTarget = cleanTarget.toLowerCase();

    if (!lowerText.contains(lowerTarget)) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final spans = <InlineSpan>[];
    int cursor = 0;
    while (cursor < text.length) {
      final idx = lowerText.indexOf(lowerTarget, cursor);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(cursor), style: normalStyle));
        break;
      }
      if (idx > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, idx), style: normalStyle));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + lowerTarget.length),
        style: highlightStyle,
      ));
      cursor = idx + lowerTarget.length;
    }
    return spans;
  }
}

/// A tip / note box with an icon.
class _TipBox extends StatelessWidget {
  const _TipBox({
    required this.text,
    required this.isDark,
    required this.icon,
  });

  final String text;
  final bool isDark;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A section label (e.g. "Contrast Pairs", "Example Words").
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    required this.isDark,
  });

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// HELPER
// ─────────────────────────────────────────────────────────────────────

void _playAudio(WidgetRef ref, String text) {
  ref.read(audioPlaybackServiceProvider).speak(text);
}

