import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/theme/app_theme.dart';
import '../data/content_repository.dart';
import '../domain/curriculum_models.dart';

/// Syllabus metadata for the complete A0-B2 Duolingo-style continuous scroll path.
class _SyllabusUnitDef {
  const _SyllabusUnitDef({
    required this.unitNumber,
    required this.level,
    required this.titleDe,
    required this.titleEn,
    required this.titleAr,
    required this.icon,
  });

  final int unitNumber;
  final String level;
  final String titleDe;
  final String titleEn;
  final String titleAr;
  final IconData icon;

  String localizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
}

class _SyllabusLevelDef {
  const _SyllabusLevelDef({
    required this.level,
    required this.sectionNumber,
    required this.titleDe,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.gradient,
    required this.units,
  });

  final String level;
  final int sectionNumber;
  final String titleDe;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final List<Color> gradient;
  final List<_SyllabusUnitDef> units;
}

const List<_SyllabusLevelDef> _syllabusLevels = [
  // SECTION 1: A0
  _SyllabusLevelDef(
    level: 'A0',
    sectionNumber: 1,
    titleDe: 'A0: Absolute Grundlagen',
    titleEn: 'A0: Absolute Foundations',
    titleAr: 'A0: الأساسيات الأولى',
    descriptionEn: 'Alphabet, pronunciation, numbers 0-100, and first greetings.',
    descriptionAr: 'الأبجدية الألمانية، قواعد النطق، الأرقام حتى 100، والتحيات اليومية.',
    gradient: [Color(0xFF2C3E50), Color(0xFF34495E)],
    units: [
      _SyllabusUnitDef(
        unitNumber: 1,
        level: 'A0',
        titleDe: 'Das Alphabet & Aussprache',
        titleEn: 'Alphabet & Pronunciation',
        titleAr: 'الأبجدية وقواعد النطق',
        icon: Icons.abc_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 2,
        level: 'A0',
        titleDe: 'Erste Wörter & Zahlen',
        titleEn: 'First Words & Numbers',
        titleAr: 'الكلمات الأولى والأرقام',
        icon: Icons.pin_outlined,
      ),
    ],
  ),

  // SECTION 2: A1
  _SyllabusLevelDef(
    level: 'A1',
    sectionNumber: 2,
    titleDe: 'A1: Elementare Sprachverwendung',
    titleEn: 'A1: Beginner Elementary',
    titleAr: 'A1: المستوى المبتدئ الأساسي',
    descriptionEn: 'Essential everyday vocabulary, food, family, routine, and Goethe A1 exam prep.',
    descriptionAr: 'مفردات الحياة اليومية، العائلة، الطعام، الروتين، والتجهيز لامتحان Goethe A1.',
    gradient: [Color(0xFFFF5F1F), Color(0xFFE04A0B)], // Deutschy Fiery Orange
    units: [
      _SyllabusUnitDef(
        unitNumber: 3,
        level: 'A1',
        titleDe: 'Familie & Leute',
        titleEn: 'Family & People',
        titleAr: 'العائلة والناس',
        icon: Icons.people_alt_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 4,
        level: 'A1',
        titleDe: 'Essen & Trinken',
        titleEn: 'Food & Drinks',
        titleAr: 'الطعام والشراب',
        icon: Icons.restaurant_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 5,
        level: 'A1',
        titleDe: 'Zuhause & Wohnen',
        titleEn: 'Home & Living',
        titleAr: 'المنزل والسكن',
        icon: Icons.home_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 6,
        level: 'A1',
        titleDe: 'Tagesablauf & Zeit',
        titleEn: 'Daily Routine & Time',
        titleAr: 'الروتين اليومي والوقت',
        icon: Icons.access_time_filled_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 7,
        level: 'A1',
        titleDe: 'Schule & Beruf',
        titleEn: 'School & Work',
        titleAr: 'الدراسة والعمل',
        icon: Icons.work_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 8,
        level: 'A1',
        titleDe: 'Einkaufen & Geld',
        titleEn: 'Shopping & Money',
        titleAr: 'التسوق والمال',
        icon: Icons.shopping_bag_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 9,
        level: 'A1',
        titleDe: 'Körper & Gesundheit',
        titleEn: 'Body & Health',
        titleAr: 'الجسم والصحة',
        icon: Icons.favorite_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 10,
        level: 'A1',
        titleDe: 'Wetter & Jahreszeiten',
        titleEn: 'Weather & Seasons',
        titleAr: 'الطقس وفصول السنة',
        icon: Icons.wb_sunny_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 11,
        level: 'A1',
        titleDe: 'Weg & Verkehr',
        titleEn: 'Directions & Transport',
        titleAr: 'الاتجاهات والمواصلات',
        icon: Icons.directions_transit_rounded,
      ),
    ],
  ),

  // SECTION 3: A2
  _SyllabusLevelDef(
    level: 'A2',
    sectionNumber: 3,
    titleDe: 'A2: Grundlegende Kenntnisse',
    titleEn: 'A2: Pre-Intermediate',
    titleAr: 'A2: المستوى الأساسي المتوسط',
    descriptionEn: 'Travel, past tense (Perfekt), modal verbs, and living in Germany.',
    descriptionAr: 'السفر، زمن الماضي، الأفعال المساعدة، والحياة العملية في ألمانيا.',
    gradient: [Color(0xFF0D9488), Color(0xFF0F766E)], // Teal
    units: [
      _SyllabusUnitDef(
        unitNumber: 12,
        level: 'A2',
        titleDe: 'Reisen & Urlaub',
        titleEn: 'Travel & Holidays',
        titleAr: 'السفر والعطلات',
        icon: Icons.flight_takeoff_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 13,
        level: 'A2',
        titleDe: 'Hobbys & Freizeit',
        titleEn: 'Hobbies & Leisure',
        titleAr: 'الهوايات وأوقات الفراغ',
        icon: Icons.sports_soccer_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 14,
        level: 'A2',
        titleDe: 'Kleidung & Mode',
        titleEn: 'Clothing & Fashion',
        titleAr: 'الملابس والموضة',
        icon: Icons.checkroom_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 15,
        level: 'A2',
        titleDe: 'Stadt & Land',
        titleEn: 'City & Countryside',
        titleAr: 'المدينة والريف',
        icon: Icons.location_city_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 16,
        level: 'A2',
        titleDe: 'Gefühle & Meinungen',
        titleEn: 'Feelings & Opinions',
        titleAr: 'المشاعر وإبداء الرأي',
        icon: Icons.sentiment_satisfied_alt_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 17,
        level: 'A2',
        titleDe: 'Medien & Kommunikation',
        titleEn: 'Media & Tech',
        titleAr: 'الإعلام والتواصل',
        icon: Icons.phone_android_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 18,
        level: 'A2',
        titleDe: 'Natur & Tiere',
        titleEn: 'Nature & Animals',
        titleAr: 'الطبيعة والحيوانات',
        icon: Icons.pets_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 19,
        level: 'A2',
        titleDe: 'Feste & Traditionen',
        titleEn: 'Celebrations & Culture',
        titleAr: 'الأعياد والتقاليد',
        icon: Icons.celebration_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 20,
        level: 'A2',
        titleDe: 'Technik & Internet',
        titleEn: 'Technology & Web',
        titleAr: 'التكنولوجيا والإنترنت',
        icon: Icons.computer_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 21,
        level: 'A2',
        titleDe: 'Kochen & Rezepte',
        titleEn: 'Cooking & Recipes',
        titleAr: 'الطبخ والوصفات',
        icon: Icons.soup_kitchen_rounded,
      ),
    ],
  ),

  // SECTION 4: B1
  _SyllabusLevelDef(
    level: 'B1',
    sectionNumber: 4,
    titleDe: 'B1: Selbstständige Sprachverwendung',
    titleEn: 'B1: Intermediate (Ausbildung Ready)',
    titleAr: 'B1: المستوى المتوسط (جاهزية الأوسبيلدونغ)',
    descriptionEn: 'Fluency in complex conversations, job interviews, and Ausbildung requirements.',
    descriptionAr: 'الطلاقة في الحوارات المعقدة، مقابلات العمل، ومتطلبات الأوسبيلدونغ والجامعات.',
    gradient: [Color(0xFF6366F1), Color(0xFF4F46E5)], // Indigo
    units: [
      _SyllabusUnitDef(
        unitNumber: 22,
        level: 'B1',
        titleDe: 'Arbeitswelt & Bewerbung',
        titleEn: 'Work & Job Applications',
        titleAr: 'عالم العمل والتقديم للوظائف',
        icon: Icons.badge_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 23,
        level: 'B1',
        titleDe: 'Umwelt & Klima',
        titleEn: 'Environment & Climate',
        titleAr: 'البيئة والمناخ',
        icon: Icons.eco_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 24,
        level: 'B1',
        titleDe: 'Gesundheitswesen & Medizin',
        titleEn: 'Healthcare & Medicine',
        titleAr: 'الرعاية الصحية والطب',
        icon: Icons.medical_services_rounded,
      ),
    ],
  ),

  // SECTION 5: B2
  _SyllabusLevelDef(
    level: 'B2',
    sectionNumber: 5,
    titleDe: 'B2: Vertiefte Sprachkompetenz',
    titleEn: 'B2: Upper Intermediate (University & Career)',
    titleAr: 'B2: المستوى المتقدم (الدراسة الجامعية والمهنة)',
    descriptionEn: 'Academic reading, professional discussions, and advanced grammar nuance.',
    descriptionAr: 'القراءة الأكاديمية، النقاشات المهنية الدقيقة، ودقة التعبير المتقدمة.',
    gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Violet
    units: [
      _SyllabusUnitDef(
        unitNumber: 25,
        level: 'B2',
        titleDe: 'Wirtschaft & Finanzen',
        titleEn: 'Economy & Finance',
        titleAr: 'الاقتصاد والمالية',
        icon: Icons.account_balance_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 26,
        level: 'B2',
        titleDe: 'Wissenschaft & Forschung',
        titleEn: 'Science & Research',
        titleAr: 'العلوم والبحث العلمي',
        icon: Icons.biotech_rounded,
      ),
    ],
  ),
];

class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _levelKeys = {
    'A0': GlobalKey(),
    'A1': GlobalKey(),
    'A2': GlobalKey(),
    'B1': GlobalKey(),
    'B2': GlobalKey(),
  };

  final Set<int> _expandedUnits = {3}; // Unit 3 (our prototype) expanded by default

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLevel(String level) {
    final key = _levelKeys[level];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _toggleUnit(int unitNumber) {
    setState(() {
      if (_expandedUnits.contains(unitNumber)) {
        _expandedUnits.remove(unitNumber);
      } else {
        _expandedUnits.add(unitNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale.languageCode == 'ar';
    final contentInit = ref.watch(contentInitProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Quick Jump Level Ribbon
            _buildQuickJumpRibbon(isDark, isArabic),

            // Continuous Duolingo-style learning path
            Expanded(
              child: contentInit.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading curriculum: $err'),
                ),
                data: (_) => _buildContinuousPath(context, isDark, isArabic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact, sticky quick-jump pill ribbon at the top
  Widget _buildQuickJumpRibbon(bool isDark, bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            isArabic ? 'المسار التعليمي:' : 'Learning Path:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['A0', 'A1', 'A2', 'B1', 'B2'].map((lvl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => _scrollToLevel(lvl),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: lvl == 'A1'
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : (isDark ? Colors.white10 : const Color(0xFFF0F2F5)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: lvl == 'A1'
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          lvl,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: lvl == 'A1'
                                ? AppColors.primary
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Single continuous scroll view showing A0 -> A1 -> A2 -> B1 -> B2 in one fluid path
  Widget _buildContinuousPath(BuildContext context, bool isDark, bool isArabic) {
    final repo = ref.watch(contentRepositoryProvider);

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        for (final section in _syllabusLevels) ...[
          // Section Level Banner (A0, A1, A2...)
          Container(
            key: _levelKeys[section.level],
            child: _buildSectionBanner(section, isDark, isArabic),
          ),
          const SizedBox(height: 14),

          // Units in this section
          for (final unitDef in section.units) ...[
            _buildUnitNode(context, unitDef, repo, isDark, isArabic),
            const SizedBox(height: 12),
          ],

          // End-of-Level Gate Test Checkpoint
          _buildLevelGateCheckpoint(context, section, isDark, isArabic),
          const SizedBox(height: 36),
        ],
      ],
    );
  }

  /// Large, immersive Section Banner (like Duolingo Section Headers)
  Widget _buildSectionBanner(_SyllabusLevelDef section, bool isDark, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: section.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: section.gradient.first.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                section.level,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
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
                  isArabic ? section.titleAr : section.titleEn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isArabic ? section.descriptionAr : section.descriptionEn,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Unit Card along the path (Expandable to see the lessons inside)
  Widget _buildUnitNode(
    BuildContext context,
    _SyllabusUnitDef unitDef,
    ContentRepository repo,
    bool isDark,
    bool isArabic,
  ) {
    // Check if this unit is live in the database (e.g. Unit 3)
    final realLessons = repo.getLessonsForUnit(unitDef.unitNumber);
    final hasRealLessons = realLessons.isNotEmpty;
    final isExpanded = _expandedUnits.contains(unitDef.unitNumber);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasRealLessons
              ? AppColors.primary.withValues(alpha: 0.35)
              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
          width: hasRealLessons ? 1.5 : 1,
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
        children: [
          // Unit Header Bar
          InkWell(
            onTap: () => _toggleUnit(unitDef.unitNumber),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: hasRealLessons
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      unitDef.icon,
                      color: hasRealLessons ? AppColors.primary : Colors.grey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Unit ${unitDef.unitNumber}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: hasRealLessons
                                    ? AppColors.primary
                                    : (isDark ? Colors.white38 : Colors.black38),
                              ),
                            ),
                            if (hasRealLessons) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isArabic ? 'جاهز للدراسة' : 'Ready',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unitDef.titleDe,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          unitDef.localizedTitle(isArabic),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Lessons List
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            ),
            if (hasRealLessons)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                itemCount: realLessons.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                ),
                itemBuilder: (context, idx) {
                  final lesson = realLessons[idx];
                  return _buildLessonRow(context, lesson, isDark, isArabic);
                },
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic
                          ? 'دروس هذه الوحدة قيد الإعداد والإضافة'
                          : 'Lessons for this unit will be unlocked soon',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
          ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        lesson.titleDe,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        lesson.localizedTitle(isArabic ? 'ar' : 'en'),
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
      onTap: () {
        context.push('/study/lesson/${lesson.id}');
      },
    );
  }

  /// Gate Checkpoint Banner at the end of each CEFR level
  Widget _buildLevelGateCheckpoint(
    BuildContext context,
    _SyllabusLevelDef section,
    bool isDark,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? 'اختبار اجتياز المستوى ${section.level}'
                          : '${section.level} Gate Test Checkpoint',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isArabic
                          ? 'احصل على 75% لفتح المستوى التالي وتثبيت شهادتك'
                          : 'Score 75% to pass & unlock the next level',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSkillPill(Icons.headphones_rounded, '25% Listen', Colors.blue),
              _buildSkillPill(Icons.menu_book_rounded, '25% Read', Colors.teal),
              _buildSkillPill(Icons.edit_note_rounded, '25% Write', Colors.purple),
              _buildSkillPill(Icons.record_voice_over_rounded, '25% Speak', Colors.orange),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // Opens Gate Test demonstration
              context.push('/study/lesson/10011');
            },
            child: Text(
              isArabic
                  ? 'بدء اختبار اجتياز ${section.level}'
                  : 'Start ${section.level} Gate Test',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
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
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
