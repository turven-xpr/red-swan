import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/gender_colors.dart';
import '../../data/content_repository.dart';
import '../../domain/curriculum_models.dart';
import '../../domain/word_lookup_service.dart';

/// Shows an isolated, accessible modal sheet with word-by-word trilingual translation
/// when a learner taps any word in an example sentence.
Future<void> showWordTranslationModal(
  BuildContext context, {
  required String rawToken,
  required WidgetRef ref,
  required String languageCode,
  required bool isDark,
  CurriculumLearnCard? card,
}) async {
  final clean = WordLookupService.cleanToken(rawToken);
  if (clean.isEmpty) return;

  final repo = ref.read(contentRepositoryProvider);
  final result = WordLookupService.lookup(
    rawToken,
    languageCode: languageCode,
    card: card,
    repo: repo,
  );

  // Pronounce word when tapped
  final speakWord = result?.german ?? clean;
  ref.read(audioPlaybackServiceProvider).speak(speakWord);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => _WordTranslationSheet(
      token: clean,
      result: result,
      languageCode: languageCode,
      isDark: isDark,
      onSpeak: () => ref.read(audioPlaybackServiceProvider).speak(speakWord),
    ),
  );
}

class _WordTranslationSheet extends StatelessWidget {
  const _WordTranslationSheet({
    required this.token,
    required this.result,
    required this.languageCode,
    required this.isDark,
    required this.onSpeak,
  });

  final String token;
  final WordTranslationResult? result;
  final String languageCode;
  final bool isDark;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final germanWord = result?.german ?? token;
    final primaryLang = languageCode.toLowerCase();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Header: Word + Audio + Close
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            germanWord,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: onSpeak,
                        icon: const Icon(Icons.volume_up_rounded, size: 22),
                        tooltip: 'Aussprache / Pronunciation',
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: isDark ? Colors.white60 : Colors.black45,
                        tooltip: 'Schließen / Close',
                      ),
                    ],
                  ),

                  // Metadata Badges (Gender, POS, Lemma)
                  if (_hasMetadata) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (result?.gender != null && result!.gender!.isNotEmpty)
                          _GenderBadge(
                            gender: result!.gender!,
                            isDark: isDark,
                          ),
                        if (result?.pos != null && result!.pos!.isNotEmpty)
                          _PosBadge(
                            pos: result!.pos!,
                            isDark: isDark,
                          ),
                        if (result?.lemma != null &&
                            result!.lemma!.isNotEmpty &&
                            result!.lemma!.toLowerCase() != germanWord.toLowerCase())
                          Text(
                            'Grundform: ${result!.lemma}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Primary translation card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              _languageFlag(primaryLang),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _languageHeader(primaryLang),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Directionality(
                          textDirection: primaryLang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                          child: Text(
                            _primaryTranslation(primaryLang),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reference translations in the other 2 languages
                  const SizedBox(height: 14),
                  Text(
                    _otherLanguagesLabel(primaryLang),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: _buildSecondaryRows(primaryLang),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Close button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _closeButtonText(primaryLang),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasMetadata =>
      (result?.gender != null && result!.gender!.isNotEmpty) ||
      (result?.pos != null && result!.pos!.isNotEmpty) ||
      (result?.lemma != null && result!.lemma!.isNotEmpty);

  String _primaryTranslation(String lang) {
    if (result == null) return token;
    switch (lang) {
      case 'ar':
        return result!.isolatedAr;
      case 'es':
        return result!.es.isNotEmpty ? result!.es : result!.en;
      default:
        return result!.en;
    }
  }

  List<Widget> _buildSecondaryRows(String primary) {
    final list = <Widget>[];
    final langs = ['en', 'ar', 'es']..remove(primary);

    for (int i = 0; i < langs.length; i++) {
      final l = langs[i];
      final flag = _languageFlag(l);
      final name = _languageName(l);
      final text = _translationFor(l);

      if (i > 0) {
        list.add(Divider(
          height: 12,
          thickness: 0.6,
          color: isDark ? Colors.white10 : Colors.black12,
        ));
      }

      list.add(
        Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Directionality(
                textDirection: l == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return list;
  }

  String _translationFor(String lang) {
    if (result == null) return token;
    switch (lang) {
      case 'ar':
        return result!.isolatedAr;
      case 'es':
        return result!.es.isNotEmpty ? result!.es : result!.en;
      default:
        return result!.en;
    }
  }

  String _languageFlag(String lang) {
    switch (lang) {
      case 'ar':
        return '🇸🇦';
      case 'es':
        return '🇪🇸';
      default:
        return '🇬🇧';
    }
  }

  String _languageName(String lang) {
    switch (lang) {
      case 'ar':
        return 'العربية';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  String _languageHeader(String lang) {
    switch (lang) {
      case 'ar':
        return 'الترجمة';
      case 'es':
        return 'TRADUCCIÓN';
      default:
        return 'TRANSLATION';
    }
  }

  String _otherLanguagesLabel(String lang) {
    switch (lang) {
      case 'ar':
        return 'لغات أخرى';
      case 'es':
        return 'OTROS IDIOMAS';
      default:
        return 'OTHER LANGUAGES';
    }
  }

  String _closeButtonText(String lang) {
    switch (lang) {
      case 'ar':
        return 'متابعة التعلم';
      case 'es':
        return 'Continuar';
      default:
        return 'Got it · Continue';
    }
  }
}

class _GenderBadge extends StatelessWidget {
  const _GenderBadge({required this.gender, required this.isDark});

  final String gender;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = GenderColors.foreground(gender, isDark: isDark);
    final bg = GenderColors.background(gender, isDark: isDark);

    String label;
    switch (gender.toLowerCase()) {
      case 'der':
      case 'm':
      case 'masculine':
        label = 'der · Maskulin';
        break;
      case 'die':
      case 'f':
      case 'feminine':
        label = 'die · Feminin';
        break;
      case 'das':
      case 'n':
      case 'neuter':
        label = 'das · Neutrum';
        break;
      case 'plural':
      case 'pl':
        label = 'die · Plural';
        break;
      default:
        label = gender;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _PosBadge extends StatelessWidget {
  const _PosBadge({required this.pos, required this.isDark});

  final String pos;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    String label;
    switch (pos.toLowerCase()) {
      case 'noun':
        label = 'Nomen';
        break;
      case 'verb':
        label = 'Verb';
        break;
      case 'adj':
      case 'adjective':
        label = 'Adjektiv';
        break;
      case 'adv':
      case 'adverb':
        label = 'Adverb';
        break;
      case 'pron':
      case 'pronoun':
        label = 'Pronomen';
        break;
      case 'prep':
      case 'preposition':
        label = 'Präposition';
        break;
      case 'art':
      case 'article':
        label = 'Artikel';
        break;
      case 'num':
      case 'number':
        label = 'Zahl';
        break;
      case 'conj':
      case 'conjunction':
        label = 'Konjunktion';
        break;
      case 'phrase':
        label = 'Redewendung';
        break;
      default:
        label = pos;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFCBD5E1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : const Color(0xFF475569),
        ),
      ),
    );
  }
}
