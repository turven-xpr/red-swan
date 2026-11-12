import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_locale.dart';
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

  @override
  void dispose() {
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

    final lessons = repo.getLessonsForLevel('A1');
    final lesson = lessons.firstWhere(
      (l) => l.id == widget.lessonId,
      orElse: () => CurriculumLesson(
        id: widget.lessonId,
        level: 'A1',
        titleDe: 'Lektion',
        titleEn: 'Lesson',
        sortOrder: 1,
        type: LessonType.vocabulary,
      ),
    );

    // Grammar lesson view
    if (lesson.type == LessonType.grammar) {
      return _buildGrammarView(context, lesson, isDark, isArabic);
    }

    final exercises = repo.getExercisesForLesson(widget.lessonId);
    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(lesson.titleDe)),
        body: Center(
          child: Text(
            isArabic ? 'لا توجد تمارين متاحة حالياً.' : 'No exercises found for this lesson.',
          ),
        ),
      );
    }

    // Results screen
    if (_currentIndex >= exercises.length) {
      return _buildResultsScreen(context, exercises.length, isDark, isArabic);
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
    final questionText = isArabic
        ? (promptMap['question_ar'] as String? ?? 'اختر الإجابة الصحيحة')
        : (promptMap['question_en'] as String? ?? 'Choose the correct answer');

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
                          ? (isArabic ? 'اضغط للاستماع' : 'Tap to listen')
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
              hintText: isArabic ? 'اكتب الكلمة هنا...' : 'Type word here...',
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
                isArabic ? 'نطقتها بصوت صحيح' : 'I pronounced it correctly',
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
          isArabic ? 'تحقق من الإجابة' : 'Check Answer',
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
                            ? (isArabic ? 'إجابة صحيحة! أحسنت 👏' : 'Correct! Great job 👏')
                            : (isArabic ? 'إجابة غير صحيحة' : 'Incorrect'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      if (!_isCorrect)
                        Text(
                          '${isArabic ? "الإجابة الصحيحة" : "Correct answer"}: ${exercise.correctAnswer}',
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
                  isArabic ? 'المتابعة' : 'Continue',
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
                  isArabic ? 'أنهيت قراءة الدرس' : 'Finished Reading',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen(BuildContext context, int total, bool isDark, bool isArabic) {
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
                      ? (isArabic ? 'أحسنت! أتممت الدرس بنجاح' : 'Awesome! Lesson Completed')
                      : (isArabic ? 'تحتاج إلى مراجعة بسيطة' : 'Keep Practicing'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${isArabic ? "درجتك" : "Your Score"}: $_score / $total ($percentage%)',
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
                    const Text('⚡ +15 XP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    const SizedBox(width: 16),
                    const Text('🔥 Streak +1', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
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
                      isArabic ? 'العودة إلى شاشة الدراسة' : 'Return to Study',
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
