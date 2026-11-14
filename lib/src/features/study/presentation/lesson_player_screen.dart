import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/i18n/bidi_utils.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../data/content_repository.dart';
import '../domain/curriculum_models.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  const LessonPlayerScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _isCorrect = false;
  String? _selectedOption;
  final TextEditingController _textController = TextEditingController();

  // State for Text lessons
  final Map<int, String> _textAnswers = {};
  bool _showTextTranslations = true;

  // State for Story lessons
  final Map<int, String> _storyAnswers = {};
  int? _activeStorySentenceIndex;
  Timer? _storyTimer;
  bool _isStoryPlaying = false;

  @override
  void dispose() {
    _storyTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _playAudio(String text) {
    ref.read(ttsServiceProvider).speak(text);
  }

  void _checkMultipleChoice(String chosen, String correct) {
    if (_answered) return;
    final isRight = chosen.trim().toLowerCase() == correct.trim().toLowerCase();
    setState(() {
      _answered = true;
      _selectedOption = chosen;
      _isCorrect = isRight;
      if (isRight) _score++;
    });
  }

  void _checkWrittenAnswer(String correct) {
    if (_answered) return;
    final input = _textController.text.trim().toLowerCase();
    final target = correct.trim().toLowerCase();

    // Exact match or transliterated match (ae -> ä, oe -> ö, ue -> ü, ss -> ß)
    bool isRight = input == target;
    if (!isRight) {
      final normalizedInput = input
          .replaceAll('ae', 'ä')
          .replaceAll('oe', 'ö')
          .replaceAll('ue', 'ü')
          .replaceAll('ss', 'ß');
      isRight = normalizedInput == target;
    }

    setState(() {
      _answered = true;
      _isCorrect = isRight;
      if (isRight) _score++;
    });
  }

  void _insertUmlaut(String char) {
    final text = _textController.text;
    final selection = _textController.selection;
    final newText = selection.textBefore(text) + char + selection.textAfter(text);
    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(
      offset: selection.start + char.length,
    );
  }

  void _nextStep(int totalSteps) {
    if (_currentIndex < totalSteps - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _isCorrect = false;
        _selectedOption = null;
        _textController.clear();
      });
    } else {
      // Completed!
      setState(() {
        _currentIndex = totalSteps; // show results screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(contentRepositoryProvider);
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final lesson = repo.getLessonById(widget.lessonId) ?? CurriculumLesson(
      id: widget.lessonId,
      level: 'A1',
      titleDe: 'Lektion',
      titleEn: 'Lesson',
      sortOrder: 1,
      type: LessonType.vocabulary,
    );

    // Specialized curriculum lesson views
    if (lesson.type == LessonType.grammar) {
      return _buildGrammarView(context, lesson, isDark, isArabic);
    }
    if (lesson.type == LessonType.text) {
      return _buildTextView(context, lesson, isDark, isArabic);
    }
    if (lesson.type == LessonType.story) {
      return _buildStoryView(context, lesson, isDark, isArabic);
    }

    final exercises = repo.getExercisesForLesson(widget.lessonId);
    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(lesson.titleDe)),
        body: Center(
          child: Text(
            t(context, Str.noExercisesFound),
          ),
        ),
      );
    }

    // Results screen
    if (_currentIndex >= exercises.length) {
      return _buildResultsScreen(context, exercises.length, isDark, isArabic, locale.languageCode);
    }

    final exercise = exercises[_currentIndex];
    final progress = (_currentIndex + 1) / exercises.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? Colors.white12 : Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 10,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${exercises.length}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skill badge
              _buildSkillBadge(exercise.skill, isDark),
              const SizedBox(height: 16),

              // Main exercise content
              Expanded(
                child: SingleChildScrollView(
                  child: _buildExerciseContent(exercise, isDark, isArabic),
                ),
              ),

              // Bottom check / continue button
              _buildBottomAction(exercise, exercises.length, isDark, isArabic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillBadge(String skill, bool isDark) {
    IconData icon;
    String label;
    Color color;

    switch (skill) {
      case 'listening':
        icon = Icons.headphones_rounded;
        label = 'Listening';
        color = Colors.blue;
        break;
      case 'reading':
        icon = Icons.menu_book_rounded;
        label = 'Reading';
        color = Colors.teal;
        break;
      case 'writing':
        icon = Icons.edit_note_rounded;
        label = 'Writing';
        color = Colors.purple;
        break;
      case 'speaking':
        icon = Icons.record_voice_over_rounded;
        label = 'Speaking';
        color = Colors.orange;
        break;
      default:
        icon = Icons.lightbulb_outline_rounded;
        label = 'Practice';
        color = AppColors.primary;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseContent(CurriculumExercise exercise, bool isDark, bool isArabic) {
    final promptMap = exercise.promptJson;
    final questionText = BidiUtils.safeLocalized(
      arabic: promptMap['question_ar'] as String?,
      fallbackEnglish: promptMap['question_en'] as String? ?? t(context, Str.chooseCorrectAnswer),
      isArabic: isArabic,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question title
        Text(
          questionText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        // Prompt / Target text
        if (exercise.audioText != null)
          Center(
            child: InkWell(
              onTap: () => _playAudio(exercise.audioText!),
              borderRadius: BorderRadius.circular(40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      exercise.skill == 'listening' && exercise.exerciseType == 'listen_choose'
                          ? t(context, Str.tapToListen)
                          : (promptMap['de'] ?? exercise.audioText!),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Multiple choice options
        if (exercise.options != null && exercise.options!.isNotEmpty)
          ...exercise.options!.map((opt) {
            final isSelected = _selectedOption == opt;
            final isCorrectOpt = opt.trim().toLowerCase() == exercise.correctAnswer.trim().toLowerCase();

            Color borderColor = isDark ? Colors.white12 : Colors.black12;
            Color bgColor = Colors.transparent;

            if (_answered) {
              if (isCorrectOpt) {
                borderColor = Colors.green;
                bgColor = Colors.green.withValues(alpha: 0.08);
              } else if (isSelected) {
                borderColor = Colors.red;
                bgColor = Colors.red.withValues(alpha: 0.08);
              }
            } else if (isSelected) {
              borderColor = AppColors.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _answered ? null : () => _checkMultipleChoice(opt, exercise.correctAnswer),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      if (_answered && isCorrectOpt)
                        const Icon(Icons.check_circle_rounded, color: Colors.green),
                      if (_answered && isSelected && !isCorrectOpt)
                        const Icon(Icons.cancel_rounded, color: Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }),

        // Written exercise (Keyboard input with umlaut strip)
        if (exercise.exerciseType == 'type_fill_blank') ...[
          if (promptMap['sentence_de'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                promptMap['sentence_de'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          TextField(
            controller: _textController,
            enabled: !_answered,
            autofocus: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: t(context, Str.typeWordHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onSubmitted: (_) => _checkWrittenAnswer(exercise.correctAnswer),
          ),
          const SizedBox(height: 12),

          // German umlaut virtual accessory strip
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['ä', 'ö', 'ü', 'ß', 'Ä', 'Ö', 'Ü'].map((char) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ActionChip(
                  label: Text(
                    char,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _answered ? null : () => _insertUmlaut(char),
                ),
              );
            }).toList(),
          ),
        ],

        // Speaking repetition exercise
        if (exercise.exerciseType == 'repeat_prompt') ...[
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.mic_rounded, size: 24),
              label: Text(
                t(context, Str.pronouncedCorrectly),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  _answered = true;
                  _isCorrect = true;
                  _score++;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomAction(CurriculumExercise exercise, int totalSteps, bool isDark, bool isArabic) {
    if (!_answered && exercise.exerciseType == 'type_fill_blank') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () => _checkWrittenAnswer(exercise.correctAnswer),
        child: Text(
          t(context, Str.checkAnswer),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (_answered) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isCorrect
              ? Colors.green.withValues(alpha: 0.12)
              : Colors.red.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: _isCorrect ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect
                            ? t(context, Str.correctFeedback)
                            : t(context, Str.incorrectFeedback),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      if (!_isCorrect)
                        Text(
                          '${t(context, Str.correctAnswerLabel)} ${BidiUtils.isolateGerman(exercise.correctAnswer)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCorrect ? Colors.green : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _nextStep(totalSteps),
                child: Text(
                  t(context, Str.continueButton),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGrammarView(BuildContext context, CurriculumLesson lesson, bool isDark, bool isArabic) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      appBar: AppBar(
        title: Text(lesson.titleDe),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lesson.grammarContent ?? '',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => context.pop(),
                child: Text(
                  t(context, Str.finishReading),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Interactive Text Lesson (النصوص: حوارات، رسائل، مقالات)
  /// - Sentence-by-sentence German text + audio speak buttons
  /// - Arabic translation for every sentence
  /// - Vocabulary & grammar callout notes
  /// - Comprehension exercises
  Widget _buildTextView(BuildContext context, CurriculumLesson lesson, bool isDark, bool isArabic) {
    Map<String, dynamic> data = {};
    if (lesson.contentJson != null && lesson.contentJson!.isNotEmpty) {
      try {
        data = jsonDecode(lesson.contentJson!) as Map<String, dynamic>;
      } catch (_) {}
    }

    final sentences = (data['sentences'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final vocabularyNotes = (data['vocabulary_notes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final questions = (data['questions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final title = isArabic ? (data['title_ar'] ?? lesson.titleDe) : (data['title_en'] ?? lesson.titleDe);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: t(context, Str.toggleTranslations),
            icon: Icon(
              _showTextTranslations ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
              color: _showTextTranslations ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => setState(() => _showTextTranslations = !_showTextTranslations),
          ),
          IconButton(
            tooltip: t(context, Str.readFullText),
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
            onPressed: () {
              final fullText = sentences.map((s) => s['de'] as String? ?? '').join(' ');
              if (fullText.isNotEmpty) _playAudio(fullText);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2430) : const Color(0xFFE8EEFD),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title_de'] ?? lesson.titleDe,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t(context, Str.textLessonSubtitle),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : const Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Sentences List
              ...List.generate(sentences.length, (idx) {
                final s = sentences[idx];
                final de = s['de'] as String? ?? '';
                final ar = s['ar'] as String? ?? '';
                final en = s['en'] as String? ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${idx + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              de,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 22),
                            onPressed: () => _playAudio(de),
                            tooltip: 'Aussprache',
                          ),
                        ],
                      ),
                      if (_showTextTranslations) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(
                            isArabic ? ar : en,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              // Vocabulary and Grammar Notes Section
              if (vocabularyNotes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  t(context, Str.vocabGrammarNotes),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vocabularyNotes.map((vocab) {
                    final word = vocab['word'] as String? ?? '';
                    final gender = vocab['gender'] as String? ?? '';
                    final ar = vocab['ar'] as String? ?? '';
                    final en = vocab['en'] as String? ?? '';

                    Color genderColor = Colors.grey;
                    if (gender == 'der') genderColor = Colors.blue;
                    if (gender == 'die') genderColor = Colors.red;
                    if (gender == 'das') genderColor = Colors.green;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: gender.isNotEmpty
                              ? genderColor.withValues(alpha: 0.4)
                              : (isDark ? Colors.white10 : Colors.black12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (gender.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: genderColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                gender,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: genderColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            word,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '· ${isArabic ? ar : en}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _playAudio(word),
                            child: const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Comprehension Quiz Section
              if (questions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  t(context, Str.comprehensionCheck),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(questions.length, (qIdx) {
                  final q = questions[qIdx];
                  final questionText = isArabic
                      ? (q['question_ar'] ?? q['question_de'])
                      : (q['question_en'] ?? q['question_de']);
                  final options = (q['options'] as List?)?.cast<String>() ?? [];
                  final correct = q['correct'] as String? ?? '';
                  final userChoice = _textAnswers[qIdx];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${qIdx + 1}. $questionText',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...options.map((opt) {
                          final isSelected = userChoice == opt;
                          final isRightChoice = opt == correct;

                          Color? btnBg;
                          Color? btnBorder;
                          if (userChoice != null) {
                            if (isSelected) {
                              btnBg = isRightChoice
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : Colors.red.withValues(alpha: 0.15);
                              btnBorder = isRightChoice ? Colors.green : Colors.red;
                            } else if (isRightChoice) {
                              btnBg = Colors.green.withValues(alpha: 0.08);
                              btnBorder = Colors.green.withValues(alpha: 0.5);
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _textAnswers[qIdx] = opt;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                decoration: BoxDecoration(
                                  color: btnBg ?? (isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF3F4F6)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: btnBorder ?? (isSelected ? AppColors.primary : Colors.transparent),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? (isRightChoice ? Icons.check_circle_rounded : Icons.cancel_rounded)
                                          : Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: isSelected
                                          ? (isRightChoice ? Colors.green : Colors.red)
                                          : (isDark ? Colors.white38 : Colors.black38),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        opt,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${t(context, Str.lessonCompletedTitle)} 🎉 +15 XP',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(
                  t(context, Str.completeTextLesson),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Leveled Story Reader (القصص التفاعلية)
  /// - Karaoka-style synchronized read along
  /// - Interactive tap on ANY word to view full definition, gender & audio
  /// - Comprehension exercises
  Widget _buildStoryView(BuildContext context, CurriculumLesson lesson, bool isDark, bool isArabic) {
    Map<String, dynamic> data = {};
    if (lesson.contentJson != null && lesson.contentJson!.isNotEmpty) {
      try {
        data = jsonDecode(lesson.contentJson!) as Map<String, dynamic>;
      } catch (_) {}
    }

    final chapters = (data['chapters'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final questions = (data['questions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final title = isArabic ? (data['title_ar'] ?? lesson.titleDe) : (data['title_en'] ?? lesson.titleDe);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            _storyTimer?.cancel();
            context.pop();
          },
        ),
        actions: [
          IconButton(
            tooltip: t(context, Str.autoReadStory),
            icon: Icon(
              _isStoryPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () => _toggleStoryPlay(chapters),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Story Intro Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2B2117) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title_de'] ?? lesson.titleDe,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF8C3E00),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic
                                ? 'اضغط على أي كلمة في القصة لمعرفة معناها ونطقها فوراً'
                                : 'Tap on any word to look up its definition and audio',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.white70 : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Story Chapters / Sentences
              ...List.generate(chapters.length, (cIdx) {
                final ch = chapters[cIdx];
                final sentenceDe = ch['sentence_de'] as String? ?? '';
                final sentenceAr = ch['sentence_ar'] as String? ?? '';
                final sentenceEn = ch['sentence_en'] as String? ?? '';
                final tokens = (ch['tokens'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                final isCurrentPlaying = _activeStorySentenceIndex == cIdx;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCurrentPlaying
                        ? (isDark ? const Color(0xFF3B271A) : const Color(0xFFFFF7ED))
                        : (isDark ? const Color(0xFF1E1E22) : Colors.white),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCurrentPlaying
                          ? AppColors.primary
                          : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
                      width: isCurrentPlaying ? 2 : 1,
                    ),
                    boxShadow: isCurrentPlaying
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Interactive token words
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: tokens.map((token) {
                          final text = token['text'] as String? ?? '';
                          final gender = token['gender'] as String? ?? '';

                          Color? underColor;
                          if (gender == 'der') underColor = Colors.blue;
                          if (gender == 'die') underColor = Colors.red;
                          if (gender == 'das') underColor = Colors.green;

                          return InkWell(
                            onTap: () => _showTokenModal(context, token, isDark, isArabic),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                                borderRadius: BorderRadius.circular(6),
                                border: underColor != null
                                    ? Border(bottom: BorderSide(color: underColor, width: 2))
                                    : null,
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),

                      // Sentence Audio Speaker & Arabic Meaning
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 20),
                            onPressed: () => _playAudio(sentenceDe),
                          ),
                          Expanded(
                            child: Text(
                              isArabic ? sentenceAr : sentenceEn,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white60 : Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              // Story Comprehension Questions
              if (questions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  t(context, Str.storyComprehension),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(questions.length, (qIdx) {
                  final q = questions[qIdx];
                  final questionText = isArabic
                      ? (q['question_ar'] ?? q['question_de'])
                      : (q['question_en'] ?? q['question_de']);
                  final options = (q['options'] as List?)?.cast<String>() ?? [];
                  final correct = q['correct'] as String? ?? '';
                  final userChoice = _storyAnswers[qIdx];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${qIdx + 1}. $questionText',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...options.map((opt) {
                          final isSelected = userChoice == opt;
                          final isRightChoice = opt == correct;

                          Color? btnBg;
                          Color? btnBorder;
                          if (userChoice != null) {
                            if (isSelected) {
                              btnBg = isRightChoice
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : Colors.red.withValues(alpha: 0.15);
                              btnBorder = isRightChoice ? Colors.green : Colors.red;
                            } else if (isRightChoice) {
                              btnBg = Colors.green.withValues(alpha: 0.08);
                              btnBorder = Colors.green.withValues(alpha: 0.5);
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _storyAnswers[qIdx] = opt;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                decoration: BoxDecoration(
                                  color: btnBg ?? (isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF3F4F6)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: btnBorder ?? (isSelected ? AppColors.primary : Colors.transparent),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? (isRightChoice ? Icons.check_circle_rounded : Icons.cancel_rounded)
                                          : Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: isSelected
                                          ? (isRightChoice ? Colors.green : Colors.red)
                                          : (isDark ? Colors.white38 : Colors.black38),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        opt,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  _storyTimer?.cancel();
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${t(context, Str.lessonCompletedTitle)} 🎉 +20 XP',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(
                  t(context, Str.completeStoryLesson),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleStoryPlay(List<Map<String, dynamic>> chapters) {
    if (_isStoryPlaying) {
      _storyTimer?.cancel();
      ref.read(ttsServiceProvider).stop();
      setState(() {
        _isStoryPlaying = false;
        _activeStorySentenceIndex = null;
      });
    } else {
      setState(() {
        _isStoryPlaying = true;
        _activeStorySentenceIndex = 0;
      });
      _playStoryStep(chapters, 0);
    }
  }

  void _playStoryStep(List<Map<String, dynamic>> chapters, int step) {
    if (step >= chapters.length || !_isStoryPlaying) {
      setState(() {
        _isStoryPlaying = false;
        _activeStorySentenceIndex = null;
      });
      return;
    }

    setState(() => _activeStorySentenceIndex = step);
    final text = chapters[step]['sentence_de'] as String? ?? '';
    _playAudio(text);

    final delay = (text.length / 10).clamp(3, 7).toInt();
    _storyTimer = Timer(Duration(seconds: delay), () {
      if (!mounted || !_isStoryPlaying) return;
      _playStoryStep(chapters, step + 1);
    });
  }

  void _showTokenModal(BuildContext context, Map<String, dynamic> token, bool isDark, bool isArabic) {
    final text = token['text'] as String? ?? '';
    final lemma = token['lemma'] as String? ?? text;
    final gender = token['gender'] as String? ?? '';
    final ar = token['ar'] as String? ?? '';
    final en = token['en'] as String? ?? '';

    Color genderColor = Colors.grey;
    if (gender == 'der') genderColor = Colors.blue;
    if (gender == 'die') genderColor = Colors.red;
    if (gender == 'das') genderColor = Colors.green;

    _playAudio(text);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (gender.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: genderColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gender,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: genderColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 26),
                    onPressed: () => _playAudio(text),
                  ),
                ],
              ),
              if (lemma != text) ...[
                const SizedBox(height: 2),
                Text(
                  'Grundform: $lemma',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const Divider(height: 24),
              Row(
                children: [
                  const Text('🇸🇦  ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      ar.isNotEmpty ? ar : '—',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('🇬🇧  ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      en.isNotEmpty ? en : '—',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsScreen(BuildContext context, int total, bool isDark, bool isArabic, String languageCode) {
    final percentage = (total > 0 ? (_score / total * 100) : 0).round();
    final passed = percentage >= 70;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: passed
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.orange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    passed ? Icons.emoji_events_rounded : Icons.replay_rounded,
                    size: 48,
                    color: passed ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  passed
                      ? t(context, Str.lessonCompletedTitle)
                      : t(context, Str.lessonCompletedSub),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${t(context, Str.yourScore)}: $_score / $total ($percentage%)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⚡ +15 ${t(context, Str.xpPoints, args: [""]).trim()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    const SizedBox(width: 16),
                    Text('🔥 ${BidiUtils.formatStreakDays(1, isArabic, languageCode)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.pop(),
                    child: Text(
                      t(context, Str.continueButton),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
