import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/i18n/bidi_utils.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
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
    required this.titleEs,
    required this.icon,
  });

  final int unitNumber;
  final String level;
  final String titleDe;
  final String titleEn;
  final String titleAr;
  final String titleEs;
  final IconData icon;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar') return titleAr;
    if (languageCode == 'es') return titleEs;
    return titleEn;
  }
}

class _SyllabusLevelDef {
  const _SyllabusLevelDef({
    required this.level,
    required this.sectionNumber,
    required this.titleDe,
    required this.titleEn,
    required this.titleAr,
    required this.titleEs,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.subtitleEs,
    required this.cardBgColor,
    required this.cardDarkBgColor,
    required this.textColor,
    required this.accentColor,
    this.badgeAsset,
    this.badgeIcon,
    required this.units,
  });

  final String level;
  final int sectionNumber;
  final String titleDe;
  final String titleEn;
  final String titleAr;
  final String titleEs;
  final String subtitleEn;
  final String subtitleAr;
  final String subtitleEs;
  final Color cardBgColor;
  final Color cardDarkBgColor;
  final Color textColor;
  final Color accentColor;
  final String? badgeAsset;
  final IconData? badgeIcon;
  final List<_SyllabusUnitDef> units;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar') return titleAr;
    if (languageCode == 'es') return titleEs;
    return titleDe;
  }

  String localizedSubtitle(String languageCode) {
    if (languageCode == 'ar') return subtitleAr;
    if (languageCode == 'es') return subtitleEs;
    return subtitleEn;
  }

  String get descriptionEn => subtitleEn;
  String get descriptionAr => subtitleAr;
  List<Color> get gradient => [cardBgColor, cardBgColor];
}

const List<_SyllabusLevelDef> _syllabusLevels = [
  // SECTION 1: Intro
  _SyllabusLevelDef(
    level: 'Intro',
    sectionNumber: 1,
    titleDe: 'Einführung',
    titleEn: 'Intro',
    titleAr: 'المقدمة',
    titleEs: 'Introducción',
    subtitleEn: 'Alphabet, pronunciation, first words & greetings',
    subtitleAr: 'الأبجدية وقواعد النطق والكلمات الأولى والتحيات',
    subtitleEs: 'Alfabeto, pronunciación, primeras palabras y saludos',
    cardBgColor: Color(0xFFFDE8E4), // Warm soft rose/peach like template card 1
    cardDarkBgColor: Color(0xFF2C1E1B),
    textColor: Color(0xFFC0392B), // Deep reddish/rust tone
    accentColor: Color(0xFFE74C3C),
    badgeAsset: 'assets/brand/intro.png',
    units: [
      _SyllabusUnitDef(
        unitNumber: 1,
        level: 'Intro',
        titleDe: 'Das Alphabet & Aussprache',
        titleEn: 'Alphabet & Pronunciation',
        titleAr: 'الأبجدية وقواعد النطق',
        titleEs: 'El alfabeto y la pronunciación',
        icon: Icons.abc_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 2,
        level: 'Intro',
        titleDe: 'Erste Wörter & Zahlen',
        titleEn: 'First Words & Numbers',
        titleAr: 'الكلمات الأولى والأرقام',
        titleEs: 'Primeras palabras y números',
        icon: Icons.pin_outlined,
      ),
      _SyllabusUnitDef(
        unitNumber: 3,
        level: 'Intro',
        titleDe: 'Begrüßung & Erste Sätze',
        titleEn: 'Greetings & First Phrases',
        titleAr: 'التحيات والعبارات الأولى',
        titleEs: 'Saludos y primeras frases',
        icon: Icons.waving_hand_rounded,
      ),
    ],
  ),

  // SECTION 2: A1
  _SyllabusLevelDef(
    level: 'A1',
    sectionNumber: 2,
    titleDe: 'A1 · Anfänger',
    titleEn: 'A1 · Beginner',
    titleAr: 'A1 · المستوى المبتدئ',
    titleEs: 'A1 · Principiante',
    subtitleEn: 'Daily life, family, food & routine',
    subtitleAr: 'الحياة اليومية، العائلة، الطعام والروتين',
    subtitleEs: 'Vida diaria, familia, comida y rutina',
    cardBgColor: Color(0xFFE3EDFD), // Soft baby blue like template card 2
    cardDarkBgColor: Color(0xFF1B2333),
    textColor: Color(0xFF2962FF), // Deep vibrant blue
    accentColor: Color(0xFF3D5AFE),
    badgeIcon: Icons.translate_rounded,
    units: [
      _SyllabusUnitDef(
        unitNumber: 4,
        level: 'A1',
        titleDe: 'Familie & Leute',
        titleEn: 'Family & People',
        titleAr: 'العائلة والناس',
        titleEs: 'Familia y personas',
        icon: Icons.people_alt_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 5,
        level: 'A1',
        titleDe: 'Essen & Trinken',
        titleEn: 'Food & Drinks',
        titleAr: 'الطعام والشراب',
        titleEs: 'Comida y bebidas',
        icon: Icons.restaurant_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 6,
        level: 'A1',
        titleDe: 'Zuhause & Wohnen',
        titleEn: 'Home & Living',
        titleAr: 'المنزل والسكن',
        titleEs: 'Hogar y vivienda',
        icon: Icons.home_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 7,
        level: 'A1',
        titleDe: 'Tagesablauf & Zeit',
        titleEn: 'Daily Routine & Time',
        titleAr: 'الروتين اليومي والوقت',
        titleEs: 'Rutina diaria y la hora',
        icon: Icons.access_time_filled_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 8,
        level: 'A1',
        titleDe: 'Schule & Beruf',
        titleEn: 'School & Work',
        titleAr: 'الدراسة والعمل',
        titleEs: 'Estudios y profesión',
        icon: Icons.work_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 9,
        level: 'A1',
        titleDe: 'Einkaufen & Geld',
        titleEn: 'Shopping & Money',
        titleAr: 'التسوق والمال',
        titleEs: 'Compras y dinero',
        icon: Icons.shopping_bag_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 10,
        level: 'A1',
        titleDe: 'Körper & Gesundheit',
        titleEn: 'Body & Health',
        titleAr: 'الجسم والصحة',
        titleEs: 'Cuerpo y salud',
        icon: Icons.favorite_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 11,
        level: 'A1',
        titleDe: 'Wetter & Jahreszeiten',
        titleEn: 'Weather & Seasons',
        titleAr: 'الطقس وفصول السنة',
        titleEs: 'Clima y estaciones del año',
        icon: Icons.wb_sunny_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 12,
        level: 'A1',
        titleDe: 'Weg & Verkehr',
        titleEn: 'Directions & Transport',
        titleAr: 'الاتجاهات والمواصلات',
        titleEs: 'Direcciones y transporte',
        icon: Icons.directions_transit_rounded,
      ),
    ],
  ),

  // SECTION 3: A2
  _SyllabusLevelDef(
    level: 'A2',
    sectionNumber: 3,
    titleDe: 'A2 · Grundstufe',
    titleEn: 'A2 · Elementary',
    titleAr: 'A2 · المستوى الأساسي',
    titleEs: 'A2 · Elemental',
    subtitleEn: 'Travel, past tense & hobbies',
    subtitleAr: 'السفر، زمن الماضي، والهوايات والمشاعر',
    subtitleEs: 'Viajes, tiempo pasado y aficiones',
    cardBgColor: Color(0xFFFDF0D5), // Soft pastel amber/sand like template card 3
    cardDarkBgColor: Color(0xFF2C2415),
    textColor: Color(0xFFB76E00), // Rich amber brown
    accentColor: Color(0xFFD97706),
    badgeIcon: Icons.explore_rounded,
    units: [
      _SyllabusUnitDef(
        unitNumber: 13,
        level: 'A2',
        titleDe: 'Reisen & Urlaub',
        titleEn: 'Travel & Holidays',
        titleAr: 'السفر والعطلات',
        titleEs: 'Viajes y vacaciones',
        icon: Icons.flight_takeoff_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 14,
        level: 'A2',
        titleDe: 'Hobbys & Freizeit',
        titleEn: 'Hobbies & Leisure',
        titleAr: 'الهوايات وأوقات الفراغ',
        titleEs: 'Aficiones y tiempo libre',
        icon: Icons.sports_soccer_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 15,
        level: 'A2',
        titleDe: 'Kleidung & Mode',
        titleEn: 'Clothing & Fashion',
        titleAr: 'الملابس والموضة',
        titleEs: 'Ropa y moda',
        icon: Icons.checkroom_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 16,
        level: 'A2',
        titleDe: 'Stadt & Land',
        titleEn: 'City & Countryside',
        titleAr: 'المدينة والريف',
        titleEs: 'Ciudad y campo',
        icon: Icons.location_city_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 17,
        level: 'A2',
        titleDe: 'Gefühle & Meinungen',
        titleEn: 'Feelings & Opinions',
        titleAr: 'المشاعر وإبداء الرأي',
        titleEs: 'Emociones y opiniones',
        icon: Icons.sentiment_satisfied_alt_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 18,
        level: 'A2',
        titleDe: 'Medien & Kommunikation',
        titleEn: 'Media & Tech',
        titleAr: 'الإعلام والتواصل',
        titleEs: 'Medios y tecnología',
        icon: Icons.phone_android_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 19,
        level: 'A2',
        titleDe: 'Natur & Tiere',
        titleEn: 'Nature & Animals',
        titleAr: 'الطبيعة والحيوانات',
        titleEs: 'Naturaleza y animales',
        icon: Icons.pets_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 20,
        level: 'A2',
        titleDe: 'Feste & Traditionen',
        titleEn: 'Celebrations & Culture',
        titleAr: 'الأعياد والتقاليد',
        titleEs: 'Fiestas y tradiciones',
        icon: Icons.celebration_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 21,
        level: 'A2',
        titleDe: 'Technik & Internet',
        titleEn: 'Technology & Web',
        titleAr: 'التكنولوجيا والإنترنت',
        titleEs: 'Tecnología e internet',
        icon: Icons.computer_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 22,
        level: 'A2',
        titleDe: 'Kochen & Rezepte',
        titleEn: 'Cooking & Recipes',
        titleAr: 'الطبخ والوصفات',
        titleEs: 'Cocina y recetas',
        icon: Icons.soup_kitchen_rounded,
      ),
    ],
  ),

  // SECTION 4: B1
  _SyllabusLevelDef(
    level: 'B1',
    sectionNumber: 4,
    titleDe: 'B1 · Mittelstufe',
    titleEn: 'B1 · Intermediate',
    titleAr: 'B1 · المستوى المتوسط',
    titleEs: 'B1 · Intermedio',
    subtitleEn: 'Ausbildung ready, work & fluent discussions',
    subtitleAr: 'جاهزية الأوسبيلدونغ، العمل والحوارات المتقدمة',
    subtitleEs: 'Listo para formación, trabajo y charlas fluidas',
    cardBgColor: Color(0xFFE8F5E9), // Soft fresh mint green
    cardDarkBgColor: Color(0xFF17291B),
    textColor: Color(0xFF2E7D32), // Deep forest green
    accentColor: Color(0xFF43A047),
    badgeIcon: Icons.psychology_rounded,
    units: [
      _SyllabusUnitDef(
        unitNumber: 23,
        level: 'B1',
        titleDe: 'Arbeitswelt & Bewerbung',
        titleEn: 'Work & Job Applications',
        titleAr: 'عالم العمل والتقديم للوظائف',
        titleEs: 'Mundo laboral y solicitudes',
        icon: Icons.badge_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 24,
        level: 'B1',
        titleDe: 'Umwelt & Klima',
        titleEn: 'Environment & Climate',
        titleAr: 'البيئة والمناخ',
        titleEs: 'Medio ambiente y clima',
        icon: Icons.eco_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 25,
        level: 'B1',
        titleDe: 'Gesundheitswesen & Medizin',
        titleEn: 'Healthcare & Medicine',
        titleAr: 'الرعاية الصحية والطب',
        titleEs: 'Salud y medicina',
        icon: Icons.medical_services_rounded,
      ),
    ],
  ),

  // SECTION 5: B2
  _SyllabusLevelDef(
    level: 'B2',
    sectionNumber: 5,
    titleDe: 'B2 · Fortgeschritten',
    titleEn: 'B2 · Upper Intermediate',
    titleAr: 'B2 · المستوى المتقدم',
    titleEs: 'B2 · Avanzado',
    subtitleEn: 'University, professional & academic fluency',
    subtitleAr: 'الدراسة الجامعية، المصطلحات التخصصية والطلاقة',
    subtitleEs: 'Fluidez universitaria, profesional y académica',
    cardBgColor: Color(0xFFF3E8FF), // Soft lavender purple
    cardDarkBgColor: Color(0xFF261A35),
    textColor: Color(0xFF7E22CE), // Rich royal purple
    accentColor: Color(0xFF9333EA),
    badgeIcon: Icons.school_rounded,
    units: [
      _SyllabusUnitDef(
        unitNumber: 26,
        level: 'B2',
        titleDe: 'Wirtschaft & Finanzen',
        titleEn: 'Economy & Finance',
        titleAr: 'الاقتصاد والمالية',
        titleEs: 'Economía y finanzas',
        icon: Icons.account_balance_rounded,
      ),
      _SyllabusUnitDef(
        unitNumber: 27,
        level: 'B2',
        titleDe: 'Wissenschaft & Forschung',
        titleEn: 'Science & Research',
        titleAr: 'العلوم والبحث العلمي',
        titleEs: 'Ciencia e investigación',
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
    'Intro': GlobalKey(),
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
                data: (_) => _buildContinuousPath(context, isDark, isArabic, locale.languageCode),
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
            t(context, Str.learningPath),
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
                children: ['Intro', 'A1', 'A2', 'B1', 'B2'].map((lvl) {
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

  /// Single continuous scroll view showing Intro -> A1 -> A2 -> B1 -> B2 in one fluid path
  Widget _buildContinuousPath(BuildContext context, bool isDark, bool isArabic, String languageCode) {
    final repo = ref.watch(contentRepositoryProvider);

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        for (final section in _syllabusLevels) ...[
          // Section Level Banner (Intro, A1, A2...)
          Container(
            key: _levelKeys[section.level],
            child: _buildSectionBanner(section, isDark, isArabic, languageCode),
          ),
          const SizedBox(height: 14),

          // Units in this section
          for (final unitDef in section.units) ...[
            _buildUnitNode(context, unitDef, repo, isDark, isArabic, languageCode),
            const SizedBox(height: 12),
          ],

          // End-of-Level Gate Test Checkpoint
          _buildLevelGateCheckpoint(context, section, isDark, isArabic),
          const SizedBox(height: 36),
        ],
      ],
    );
  }

  /// Section Banner styled precisely like the modern Food Delivery card template:
  /// - Soft pastel background matching level theme
  /// - Bold colored title + subtitle
  /// - Meta row: rating, units/time, level badge
  /// - Outer & inner circular "dish" badge on the right (with intro.png for Intro)
  Widget _buildSectionBanner(_SyllabusLevelDef section, bool isDark, bool isArabic, String languageCode) {
    final bgColor = isDark ? section.cardDarkBgColor : section.cardBgColor;
    final primaryTextColor = isDark ? Colors.white : section.textColor;
    final secondaryTextColor = isDark ? Colors.white70 : section.textColor.withValues(alpha: 0.78);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : section.textColor.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black38 : section.textColor.withValues(alpha: 0.08)),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
        children: [
          // Background ambient circular ring accent
          Positioned(
            right: isArabic ? null : -24,
            left: isArabic ? -24 : null,
            top: -24,
            bottom: -24,
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? Colors.white : Colors.white).withValues(alpha: 0.15),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                // Left Column: Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Level Title (Bold & Colored)
                      Text(
                        section.localizedTitle(languageCode),
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Subtitle / Description
                      Text(
                        section.localizedSubtitle(languageCode),
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Meta Info Row (Star rating, Unit count, Level pill)
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: isDark ? Colors.amber : section.textColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '4.9',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.layers_rounded,
                            size: 14,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            t(context, Str.unitsCount, args: [section.units.length.toString()]),
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.white12 : Colors.white.withValues(alpha: 0.7)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              section.level,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Right Column: Circular "Plate" Badge (Template style)
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1F1F24) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: (isDark ? Colors.black26 : section.textColor.withValues(alpha: 0.08)),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? section.cardDarkBgColor
                            : section.cardBgColor.withValues(alpha: 0.55),
                      ),
                      child: Center(
                        child: section.badgeAsset != null
                            ? ClipOval(
                                child: Image.asset(
                                  section.badgeAsset!,
                                  width: 62,
                                  height: 62,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.school_rounded,
                                    size: 34,
                                    color: section.accentColor,
                                  ),
                                ),
                              )
                            : Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: section.accentColor.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  section.badgeIcon ?? Icons.translate_rounded,
                                  size: 28,
                                  color: section.accentColor,
                                ),
                              ),
                      ),
                    ),
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
    String languageCode,
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
                              t(context, Str.unitLabel, args: [unitDef.unitNumber.toString()]),
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
                                  t(context, Str.readyToStudy),
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
                          unitDef.localizedTitle(languageCode),
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
                  return _buildLessonRow(context, lesson, isDark, isArabic, languageCode);
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
                      t(context, Str.lessonsComingSoon),
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
    String languageCode,
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
      case LessonType.text:
        icon = Icons.menu_book_rounded;
        iconColor = Colors.indigo;
        break;
      case LessonType.story:
        icon = Icons.auto_stories_rounded;
        iconColor = Colors.deepOrange;
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
      title: GermanText(
        lesson.titleDe,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        lesson.localizedTitle(languageCode),
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
      trailing: Icon(
        isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 20,
      ),
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
    final isIntro = section.level == 'Intro';

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
                      isIntro
                          ? t(context, Str.checkpointIntro)
                          : t(context, Str.checkpointGate, args: [section.level]),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isIntro
                          ? t(context, Str.checkpointIntroSub)
                          : t(context, Str.checkpointGateSub),
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
              _buildSkillPill(Icons.headphones_rounded, t(context, Str.skillListen, args: ['25%']), Colors.blue),
              _buildSkillPill(Icons.menu_book_rounded, t(context, Str.skillRead, args: ['25%']), Colors.teal),
              _buildSkillPill(Icons.edit_note_rounded, t(context, Str.skillWrite, args: ['25%']), Colors.purple),
              _buildSkillPill(Icons.record_voice_over_rounded, t(context, Str.skillSpeak, args: ['25%']), Colors.orange),
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
              isIntro
                  ? t(context, Str.startIntroCheckpoint)
                  : t(context, Str.startGateTest, args: [section.level]),
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
