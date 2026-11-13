import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_locale.dart';
import '../../../core/config/onboarding_pref.dart';
import '../../../core/i18n/strings.dart';
import '../../../core/i18n/translations.dart';
import '../../../core/providers.dart';
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

    final level = _selectedLevel ?? StartLevel.a0;
    final reason = _selectedReason ?? LearningReason.study;

    // 1. Save to local preferences
    await ref.read(onboardingPrefsProvider.notifier).setComplete(
          level: level,
          nativeLanguage: _selectedLanguage,
          reason: reason,
          dailyGoalMinutes: _selectedGoalMinutes,
        );

    // 2. Sync to Supabase cloud profile
    try {
      await ref.read(authServiceProvider).syncProfile(
            nativeLanguage: _selectedLanguage,
            reason: reason.name,
            targetLevel: level.name.toUpperCase(),
            dailyGoalMinutes: _selectedGoalMinutes,
          );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Palette: White, Black, Fiery Orange (#FF5F1F)
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
        code: 'es',
        name: 'Spanish',
        nativeName: 'Español',
        flag: '🇪🇸',
        desc: 'Aprende alemán con explicaciones y traducciones en español',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          title: t(context, Str.onboardingStep1Title),
          subtitle: t(context, Str.onboardingStep1Sub),
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 24),
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
              leading: Text(
                item.flag,
                style: const TextStyle(fontSize: 24),
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
        title: t(context, Str.onboardingReasonAusbildung),
        subtitle: t(context, Str.onboardingReasonAusbildungDesc),
        icon: Icons.handyman_rounded,
        emoji: '🛠️',
      ),
      (
        reason: LearningReason.study,
        title: t(context, Str.onboardingReasonStudy),
        subtitle: t(context, Str.onboardingReasonStudyDesc),
        icon: Icons.school_rounded,
        emoji: '🎓',
      ),
      (
        reason: LearningReason.job,
        title: t(context, Str.onboardingReasonJob),
        subtitle: t(context, Str.onboardingReasonJobDesc),
        icon: Icons.business_center_rounded,
        emoji: '💼',
      ),
      (
        reason: LearningReason.travel,
        title: t(context, Str.onboardingReasonTravel),
        subtitle: t(context, Str.onboardingReasonTravelDesc),
        icon: Icons.flight_takeoff_rounded,
        emoji: '✈️',
      ),
      (
        reason: LearningReason.fun,
        title: t(context, Str.onboardingReasonFun),
        subtitle: t(context, Str.onboardingReasonFunDesc),
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
          title: t(context, Str.onboardingStep2Title),
          subtitle: t(context, Str.onboardingStep2Sub),
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 24),
        for (final item in reasons)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedReason == item.reason,
              onTap: () => setState(() => _selectedReason = item.reason),
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
        code: 'Intro',
        title: t(context, Str.onboardingLevelIntroTitle),
        desc: t(context, Str.onboardingLevelIntroDesc),
      ),
      (
        level: StartLevel.a1,
        code: 'A1',
        title: t(context, Str.onboardingLevelA1Title),
        desc: t(context, Str.onboardingLevelA1Desc),
      ),
      (
        level: StartLevel.a2,
        code: 'A2',
        title: t(context, Str.onboardingLevelA2Title),
        desc: t(context, Str.onboardingLevelA2Desc),
      ),
      (
        level: StartLevel.b1,
        code: 'B1',
        title: t(context, Str.onboardingLevelB1Title),
        desc: t(context, Str.onboardingLevelB1Desc),
      ),
      (
        level: StartLevel.b2,
        code: 'B2',
        title: t(context, Str.onboardingLevelB2Title),
        desc: t(context, Str.onboardingLevelB2Desc),
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          title: t(context, Str.onboardingStep3Title),
          subtitle: t(context, Str.onboardingStep3Sub),
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 24),
        for (final item in levels)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedLevel == item.level,
              onTap: () => setState(() => _selectedLevel = item.level),
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
        title: t(context, Str.onboardingGoal3MinTitle),
        subtitle: t(context, Str.onboardingGoal3MinDesc),
        emoji: '⚡',
      ),
      (
        minutes: 5,
        title: t(context, Str.onboardingGoal5MinTitle),
        subtitle: t(context, Str.onboardingGoal5MinDesc),
        emoji: '⏱️',
      ),
      (
        minutes: 15,
        title: t(context, Str.onboardingGoal15MinTitle),
        subtitle: t(context, Str.onboardingGoal15MinDesc),
        emoji: '🎯',
      ),
      (
        minutes: 30,
        title: t(context, Str.onboardingGoal30MinTitle),
        subtitle: t(context, Str.onboardingGoal30MinDesc),
        emoji: '🔥',
      ),
      (
        minutes: 60,
        title: t(context, Str.onboardingGoal60MinTitle),
        subtitle: t(context, Str.onboardingGoal60MinDesc),
        emoji: '🚀',
      ),
      (
        minutes: 120,
        title: t(context, Str.onboardingGoal120MinTitle),
        subtitle: t(context, Str.onboardingGoal120MinDesc),
        emoji: '🏆',
      ),
    ];

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildHeader(
          title: t(context, Str.onboardingStep4Title),
          subtitle: t(context, Str.onboardingStep4Sub),
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 24),
        for (final item in goals)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              isSelected: _selectedGoalMinutes == item.minutes,
              onTap: () => setState(() => _selectedGoalMinutes = item.minutes),
              title: item.title,
              subtitle: item.subtitle,
              isDark: isDark,
            ),
          ),
      ],
    );
  }

  // Common Header Helper (clean typography, no generic badges)
  Widget _buildHeader({
    required String title,
    required String subtitle,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        const SizedBox(height: 8),
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
    final ctaLabel = isLastStep ? t(context, Str.onboardingBtnStart) : t(context, Str.onboardingBtnContinue);

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
                backgroundColor: AppColors.primary, // Fiery Orange #FF5F1F
                foregroundColor: Colors.white, // Crisp white text on orange CTA
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
    this.leading,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget? leading;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Keep background clean & neutral for both selected and unselected states.
    // Absolutely NO color tint / fill on selection — selection is indicated strictly via border.
    final bgColor = isDark ? const Color(0xFF141418) : Colors.white;

    // Selection shown strictly by the card border
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
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
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
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white24 : Colors.black26),
                    width: isSelected ? 2 : 1.5,
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
