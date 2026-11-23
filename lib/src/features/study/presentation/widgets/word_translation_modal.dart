import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/gender_colors.dart';
import '../../data/content_repository.dart';
import '../../domain/curriculum_models.dart';
import '../../domain/word_lookup_service.dart';

/// Shows an isolated, accessible modal sheet with word-by-word translation
/// in the user's selected language (English, Arabic, or Spanish) when a learner taps any word.
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
                        tooltip: 'Aussprache / Audio',
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: isDark ? Colors.white60 : Colors.black45,
                        tooltip: 'Schließen',
                      ),
                    ],
                  ),

                  // Metadata Badges (Gender, POS, Lemma) localized to user language
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
                            languageCode: primaryLang,
                            isDark: isDark,
                          ),
                        if (result?.pos != null && result!.pos!.isNotEmpty)
                          _PosBadge(
                            pos: result!.pos!,
                            languageCode: primaryLang,
                            isDark: isDark,
                          ),
                        if (result?.lemma != null &&
                            result!.lemma!.isNotEmpty &&
                            result!.lemma!.toLowerCase() != germanWord.toLowerCase())
                          _BaseFormBadge(
                            lemma: result!.lemma!,
                            languageCode: primaryLang,
                            isDark: isDark,
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Translation card in user's language only
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: primaryLang == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          _languageHeader(primaryLang),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Directionality(
                          textDirection: primaryLang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                          child: Text(
                            _primaryTranslation(primaryLang),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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

class _BaseFormBadge extends StatelessWidget {
  const _BaseFormBadge({
    required this.lemma,
    required this.languageCode,
    required this.isDark,
  });

  final String lemma;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    String prefix;
    switch (languageCode.toLowerCase()) {
      case 'ar':
        prefix = 'الأصل';
        break;
      case 'es':
        prefix = 'Forma base';
        break;
      default:
        prefix = 'Base form';
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
        '$prefix: $lemma',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : const Color(0xFF475569),
        ),
      ),
    );
  }
}

class _GenderBadge extends StatelessWidget {
  const _GenderBadge({
    required this.gender,
    required this.languageCode,
    required this.isDark,
  });

  final String gender;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = GenderColors.foreground(gender, isDark: isDark);
    final bg = GenderColors.background(gender, isDark: isDark);

    String label;
    final lang = languageCode.toLowerCase();
    switch (gender.toLowerCase()) {
      case 'der':
      case 'm':
      case 'masculine':
        label = lang == 'ar' ? 'مذكر (der)' : (lang == 'es' ? 'der · Masculino' : 'der · Masculine');
        break;
      case 'die':
      case 'f':
      case 'feminine':
        label = lang == 'ar' ? 'مؤنث (die)' : (lang == 'es' ? 'die · Femenino' : 'die · Feminine');
        break;
      case 'das':
      case 'n':
      case 'neuter':
        label = lang == 'ar' ? 'محايد (das)' : (lang == 'es' ? 'das · Neutro' : 'das · Neuter');
        break;
      case 'plural':
      case 'pl':
        label = lang == 'ar' ? 'جمع (die)' : (lang == 'es' ? 'die · Plural' : 'die · Plural');
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
  const _PosBadge({
    required this.pos,
    required this.languageCode,
    required this.isDark,
  });

  final String pos;
  final String languageCode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    String label;
    final lang = languageCode.toLowerCase();
    switch (pos.toLowerCase()) {
      case 'noun':
        label = lang == 'ar' ? 'اسم' : (lang == 'es' ? 'Sustantivo' : 'Noun');
        break;
      case 'verb':
        label = lang == 'ar' ? 'فعل' : (lang == 'es' ? 'Verbo' : 'Verb');
        break;
      case 'adj':
      case 'adjective':
        label = lang == 'ar' ? 'صفة' : (lang == 'es' ? 'Adjetivo' : 'Adjective');
        break;
      case 'adv':
      case 'adverb':
        label = lang == 'ar' ? 'ظرف' : (lang == 'es' ? 'Adverbio' : 'Adverb');
        break;
      case 'pron':
      case 'pronoun':
        label = lang == 'ar' ? 'ضمير' : (lang == 'es' ? 'Pronombre' : 'Pronoun');
        break;
      case 'prep':
      case 'preposition':
        label = lang == 'ar' ? 'حرف جر' : (lang == 'es' ? 'Preposición' : 'Preposition');
        break;
      case 'art':
      case 'article':
        label = lang == 'ar' ? 'أداة' : (lang == 'es' ? 'Artículo' : 'Article');
        break;
      case 'num':
      case 'number':
        label = lang == 'ar' ? 'رقم' : (lang == 'es' ? 'Número' : 'Number');
        break;
      case 'conj':
      case 'conjunction':
        label = lang == 'ar' ? 'حرف عطف' : (lang == 'es' ? 'Conjunción' : 'Conjunction');
        break;
      case 'phrase':
        label = lang == 'ar' ? 'تعبير' : (lang == 'es' ? 'Frase' : 'Phrase');
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
