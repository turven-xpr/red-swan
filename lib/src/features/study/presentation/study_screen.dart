import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/theme/app_theme.dart';
import '../data/content_repository.dart';
import '../domain/curriculum_models.dart';

class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  String _selectedLevel = 'A1';

  final List<String> _levels = const ['A0', 'A1', 'A2', 'B1', 'B2'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale.languageCode == 'ar';

    final contentInit = ref.watch(contentInitProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Level Selector Header
            _buildLevelHeader(isDark, isArabic),

            // Content Area
            Expanded(
              child: contentInit.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading curriculum: $err'),
                ),
                data: (_) => _buildCurriculumBody(context, isDark, isArabic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelHeader(bool isDark, bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isArabic ? 'المستوى التعليمي' : 'CEFR Level',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getLevelSubtitle(_selectedLevel, isArabic),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: _levels.map((lvl) {
              final isSelected = lvl == _selectedLevel;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLevel = lvl;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.white12 : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? Colors.white12 : Colors.black12),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          lvl,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? Colors.white60 : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getLevelSubtitle(String level, bool isArabic) {
    switch (level) {
      case 'A0':
        return isArabic ? 'الأساسيات الأولى' : 'Absolute Beginner';
      case 'A1':
        return isArabic ? 'مستوى مبتدئ' : 'Elementary';
      case 'A2':
        return isArabic ? 'مستوى أساسي' : 'Pre-Intermediate';
      case 'B1':
        return isArabic ? 'مستوى متوسط' : 'Intermediate';
      case 'B2':
        return isArabic ? 'فوق المتوسط' : 'Upper Intermediate';
      default:
        return '';
    }
  }

  Widget _buildCurriculumBody(BuildContext context, bool isDark, bool isArabic) {
    final repo = ref.watch(contentRepositoryProvider);
    final units = repo.getUnitsForLevel(_selectedLevel);

    if (units.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_clock_rounded,
                size: 52,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'وحدات المستوى $_selectedLevel قيد التجهيز'
                    : 'Level $_selectedLevel content is coming soon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'جرب المستوى A1 للاطلاع على الوحدة التجريبية المكتملة'
                    : 'Switch to Level A1 to explore the completed prototype unit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final unit in units) ...[
          _buildUnitCard(context, unit, repo, isDark, isArabic),
          const SizedBox(height: 20),
        ],

        // End-of-level Gate Test Card
        _buildGateTestCard(context, isDark, isArabic),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUnitCard(
    BuildContext context,
    CurriculumUnit unit,
    ContentRepository repo,
    bool isDark,
    bool isArabic,
  ) {
    final lessons = repo.getLessonsForUnit(unit.id);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Unit Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'U${unit.unitNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.titleDe,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.localizedTitle(isArabic ? 'ar' : 'en'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${lessons.length} ${isArabic ? "دروس" : "lessons"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lessons List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: lessons.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            ),
            itemBuilder: (context, idx) {
              final lesson = lessons[idx];
              return _buildLessonRow(context, lesson, isDark, isArabic);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLessonRow(
    BuildContext context,
    CurriculumLesson lesson,
    bool isDark,
    bool isArabic,
  ) {
    IconData icon;
    Color iconColor;

    switch (lesson.type) {
      case LessonType.grammar:
        icon = Icons.auto_stories_rounded;
        iconColor = Colors.purple;
        break;
      case LessonType.review:
        icon = Icons.replay_rounded;
        iconColor = Colors.orange;
        break;
      case LessonType.unitTest:
        icon = Icons.military_tech_rounded;
        iconColor = Colors.amber.shade800;
        break;
      case LessonType.levelTest:
        icon = Icons.workspace_premium_rounded;
        iconColor = AppColors.primary;
        break;
      case LessonType.vocabulary:
        icon = Icons.translate_rounded;
        iconColor = Colors.teal;
        break;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        lesson.titleDe,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        lesson.localizedTitle(isArabic ? 'ar' : 'en'),
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: () {
        context.push('/study/lesson/${lesson.id}');
      },
    );
  }

  Widget _buildGateTestCard(BuildContext context, bool isDark, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C1E14), const Color(0xFF1E1E1E)]
              : [const Color(0xFFFFF3ED), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'اختبار اجتياز المستوى A1' : 'Level A1 Gate Test',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isArabic
                          ? 'يتطلب 75% للنجاح والحصول على شهادة المستوى'
                          : 'Requires 75% to pass & unlock A2 level',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSkillPill(Icons.headphones_rounded, '25% Listen', Colors.blue),
              _buildSkillPill(Icons.menu_book_rounded, '25% Read', Colors.teal),
              _buildSkillPill(Icons.edit_note_rounded, '25% Write', Colors.purple),
              _buildSkillPill(Icons.record_voice_over_rounded, '25% Speak', Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // In prototype: launches unit test as demonstration
                context.push('/study/lesson/10011');
              },
              child: Text(
                isArabic ? 'بدء اختبار المستوى التجريبي' : 'Start Prototype Gate Test',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillPill(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
