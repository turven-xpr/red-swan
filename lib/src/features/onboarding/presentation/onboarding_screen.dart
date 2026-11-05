import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/config/onboarding_pref.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animations/premium_animations.dart';

/// Multi-step personalized onboarding flow:
///   Step 1: Native Language (English, Arabic, French)
///   Step 2: Reason for learning German (Ausbildung, Study, Job, Travel, Fun)
///   Step 3: German Level (A0, A1, A2, B1, B2)
///   Step 4: Daily Goal (3 min, 5 min, 15 min, 30 min, 1h, 2h)
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // Selected values
  String _selectedLanguage = 'en';
  LearningReason? _selectedReason = LearningReason.study;
  StartLevel? _selectedLevel = StartLevel.a0;
  int _selectedGoalMinutes = 15;

  bool _committing = false;

  void _onNext() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _finish();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _finish() async {
    if (_committing) return;
    setState(() => _committing = true);

    await ref.read(onboardingPrefsProvider.notifier).setComplete(
          level: _selectedLevel ?? StartLevel.a0,
          nativeLanguage: _selectedLanguage,
          reason: _selectedReason ?? LearningReason.study,
          dailyGoalMinutes: _selectedGoalMinutes,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Palette: White, Black, Crimson Red (#830000)
    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.secondary;
    final textSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : AppColors.secondary.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar with Back Button & Progress
            _buildTopBar(context, textPrimary),

            // Scrollable Content area (Responsive, never overflows)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: _buildCurrentStepView(
                        key: ValueKey<int>(_currentStep),
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation & Continue CTA
            _buildBottomBar(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Color textPrimary) {
    final progress = (_currentStep + 1) / _totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: textPrimary,
                  tooltip: 'Back',
                  onPressed: _onBack,
                )
              else
                const SizedBox(width: 48, height: 48),
              Expanded(
                child: Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepView({
    required Key key,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Language(
          key: key,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isDark: isDark,
        );
      case 1:
        return _buildStep2Reason(
          key: key,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isDark: isDark,
        );
      case 2:
        return _buildStep3Level(
          key: key,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isDark: isDark,
        );
      case 3:
      default:
        return _buildStep4DailyGoal(
          key: key,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isDark: isDark,
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 1: LANGUAGE
  // ─────────────────────────────────────────────────────────────
  Widget _buildStep1Language({
    required Key key,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final languages = [
      (
        code: 'en',
        name: 'English',
        nativeName: 'English',
        flag: '🇬🇧',
        desc: 'Learn German with English translations and grammar notes',
      ),
      (
        code: 'ar',
        name: 'Arabic',
        nativeName: 'العربية',
        flag: '🇸🇦',
        desc: 'تعلم اللغة الألمانية مع شروحات باللغة العربية وترجمة كاملة',
      ),
      (
        code: 'fr',
        name: 'French',
        nativeName: 'Français',
        flag: '🇫🇷',
        desc: 'Apprenez l\'allemand avec des explications et exemples en français',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          icon: Icons.language_rounded,
          title: 'What language do you speak?',
          subtitle:
              'Choose the language you will use to learn German.',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 28),
        for (final item in languages)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedLanguage == item.code,
              onTap: () {
                setState(() => _selectedLanguage = item.code);
                // Dynamically apply app language
                ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(Locale(item.code));
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedLanguage == item.code
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.flag,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: item.nativeName,
              subtitle: item.desc,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 2: REASON
  // ─────────────────────────────────────────────────────────────
  Widget _buildStep2Reason({
    required Key key,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final reasons = [
      (
        reason: LearningReason.ausbildung,
        title: 'For Ausbildung',
        subtitle: 'Vocational training & German apprenticeships',
        icon: Icons.handyman_rounded,
        emoji: '🛠️',
      ),
      (
        reason: LearningReason.study,
        title: 'For Study',
        subtitle: 'University admission, exams (TestDaF/DSH) & degrees',
        icon: Icons.school_rounded,
        emoji: '🎓',
      ),
      (
        reason: LearningReason.job,
        title: 'For Job / Career',
        subtitle: 'Work in Germany, medical/tech career & interviews',
        icon: Icons.business_center_rounded,
        emoji: '💼',
      ),
      (
        reason: LearningReason.travel,
        title: 'For Travel',
        subtitle: 'Tourism, navigating cities, culture & everyday life',
        icon: Icons.flight_takeoff_rounded,
        emoji: '✈️',
      ),
      (
        reason: LearningReason.fun,
        title: 'For Fun & Hobby',
        subtitle: 'Personal growth, brain training & love for languages',
        icon: Icons.emoji_emotions_rounded,
        emoji: '🌟',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          icon: Icons.track_changes_rounded,
          title: 'Why are you learning German?',
          subtitle:
              'We will tailor your vocabulary, exercises and dialogues to match your goals.',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 28),
        for (final item in reasons)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedReason == item.reason,
              onTap: () => setState(() => _selectedReason = item.reason),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedReason == item.reason
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              title: item.title,
              subtitle: item.subtitle,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 3: LEVEL
  // ─────────────────────────────────────────────────────────────
  Widget _buildStep3Level({
    required Key key,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final levels = [
      (
        level: StartLevel.a0,
        code: 'A0',
        title: 'A0 · Absolute Beginner',
        desc: 'I know zero German or just a few basic words',
      ),
      (
        level: StartLevel.a1,
        code: 'A1',
        title: 'A1 · Beginner',
        desc: 'I can introduce myself and understand simple daily phrases',
      ),
      (
        level: StartLevel.a2,
        code: 'A2',
        title: 'A2 · Elementary',
        desc: 'I can communicate in simple everyday situations & routines',
      ),
      (
        level: StartLevel.b1,
        code: 'B1',
        title: 'B1 · Intermediate',
        desc: 'I can express opinions, understand main ideas & speak steadily',
      ),
      (
        level: StartLevel.b2,
        code: 'B2',
        title: 'B2 · Upper Intermediate',
        desc: 'I can handle technical/work conversations & complex texts',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          icon: Icons.military_tech_rounded,
          title: 'What is your German level?',
          subtitle:
              'Choose your current proficiency to start at the right difficulty.',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 28),
        for (final item in levels)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedLevel == item.level,
              onTap: () => setState(() => _selectedLevel = item.level),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedLevel == item.level
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.code,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: _selectedLevel == item.level
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.secondary),
                  ),
                ),
              ),
              title: item.title,
              subtitle: item.desc,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 4: DAILY GOAL
  // ─────────────────────────────────────────────────────────────
  Widget _buildStep4DailyGoal({
    required Key key,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final goals = [
      (
        minutes: 3,
        title: '3 min / day · Casual',
        subtitle: 'Quick micro-habit to keep your brain active',
        emoji: '⚡',
      ),
      (
        minutes: 5,
        title: '5 min / day · Regular',
        subtitle: 'Steady daily practice to build your streak',
        emoji: '⏱️',
      ),
      (
        minutes: 15,
        title: '15 min / day · Committed (Recommended)',
        subtitle: 'Optimal daily pace for solid retention and vocabulary growth',
        emoji: '🎯',
      ),
      (
        minutes: 30,
        title: '30 min / day · Serious',
        subtitle: 'Fast-track your German fluency for work or study',
        emoji: '🔥',
      ),
      (
        minutes: 60,
        title: '1 Hour / day · Intensive',
        subtitle: 'Comprehensive study covering grammar, speaking & tests',
        emoji: '🚀',
      ),
      (
        minutes: 120,
        title: '2 Hours / day · Super Intensive',
        subtitle: 'Fastest route to passing Goethe / telc exams',
        emoji: '🏆',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          icon: Icons.timer_outlined,
          title: 'What is your daily goal?',
          subtitle:
              'Set a realistic goal. Consistency builds fluency faster than cramming.',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 28),
        for (final item in goals)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedGoalMinutes == item.minutes,
              onTap: () => setState(() => _selectedGoalMinutes = item.minutes),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedGoalMinutes == item.minutes
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF222228) : const Color(0xFFF2F2F5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              title: item.title,
              subtitle: item.subtitle,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  // Common Header Helper
  Widget _buildHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.4,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  // Bottom Continue / Commit Button
  Widget _buildBottomBar(BuildContext context, bool isDark) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final ctaLabel = isLastStep ? 'Start Learning' : 'Continue';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _committing ? null : _onNext,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary, // Crimson Red #830000
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _committing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ctaLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLastStep
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable selectable card tile with checkmark and feedback animations
class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.isSelected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Colors according to user's White, Black, Crimson Red palette
    final bgColor = isSelected
        ? (isDark
            ? AppColors.primary.withValues(alpha: 0.22)
            : const Color(0xFFFFF0F0))
        : (isDark ? const Color(0xFF141418) : const Color(0xFFF9F9FB));

    final borderColor = isSelected
        ? AppColors.primary
        : (isDark ? const Color(0xFF26262E) : const Color(0xFFE5E5EB));

    final titleColor = isDark ? Colors.white : AppColors.secondary;
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : AppColors.secondary.withValues(alpha: 0.55);

    return PressScaleEffect(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: subtitleColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white24 : Colors.black26),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
