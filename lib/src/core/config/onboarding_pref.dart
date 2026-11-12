import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// CEFR-style starting levels.
enum StartLevel { a0, a1, a2, b1, b2 }

/// User motivation / reason for studying German.
enum LearningReason { ausbildung, study, job, travel, fun }

class OnboardingPrefs {
  const OnboardingPrefs({
    required this.shown,
    required this.startLevel,
    this.nativeLanguage = 'en',
    this.reason = LearningReason.study,
    this.dailyGoalMinutes = 15,
  });

  final bool shown;
  final StartLevel? startLevel;
  final String nativeLanguage;
  final LearningReason reason;
  final int dailyGoalMinutes;

  static const empty = OnboardingPrefs(
    shown: false,
    startLevel: null,
    nativeLanguage: 'en',
    reason: LearningReason.study,
    dailyGoalMinutes: 15,
  );

  OnboardingPrefs copyWith({
    bool? shown,
    StartLevel? startLevel,
    String? nativeLanguage,
    LearningReason? reason,
    int? dailyGoalMinutes,
  }) =>
      OnboardingPrefs(
        shown: shown ?? this.shown,
        startLevel: startLevel ?? this.startLevel,
        nativeLanguage: nativeLanguage ?? this.nativeLanguage,
        reason: reason ?? this.reason,
        dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      );
}

class OnboardingPrefsNotifier extends Notifier<OnboardingPrefs> {
  static const _kKey = 'deutschy_onboarding_v2';
  static const _kLegacyKey = 'deutschy_onboarding_v1';

  @override
  OnboardingPrefs build() {
    _load();
    return OnboardingPrefs.empty;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var raw = prefs.getString(_kKey);
      if (raw == null) {
        // Fall back to legacy key
        final legacy = prefs.getString(_kLegacyKey);
        if (legacy != null && legacy.startsWith('shown:')) {
          final levelStr = legacy.substring(6);
          final level = StartLevel.values.firstWhere(
            (e) => e.name == levelStr,
            orElse: () => StartLevel.a1,
          );
          state = OnboardingPrefs(shown: true, startLevel: level);
          return;
        }
        return;
      }

      // Format: shown:level:lang:reason:goal
      final parts = raw.split(':');
      if (parts.length >= 2 && parts[0] == 'shown') {
        final level = StartLevel.values.firstWhere(
          (e) => e.name == parts[1],
          orElse: () => StartLevel.a1,
        );
        final lang = parts.length > 2 ? parts[2] : 'en';
        final reason = parts.length > 3
            ? LearningReason.values.firstWhere(
                (r) => r.name == parts[3],
                orElse: () => LearningReason.study,
              )
            : LearningReason.study;
        final goal = parts.length > 4 ? int.tryParse(parts[4]) ?? 15 : 15;

        state = OnboardingPrefs(
          shown: true,
          startLevel: level,
          nativeLanguage: lang,
          reason: reason,
          dailyGoalMinutes: goal,
        );
      }
    } catch (_) {
      // tolerate (tests etc.)
    }
  }

  Future<void> setComplete({
    required StartLevel level,
    required String nativeLanguage,
    required LearningReason reason,
    required int dailyGoalMinutes,
  }) async {
    state = OnboardingPrefs(
      shown: true,
      startLevel: level,
      nativeLanguage: nativeLanguage,
      reason: reason,
      dailyGoalMinutes: dailyGoalMinutes,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kKey,
        'shown:${level.name}:$nativeLanguage:${reason.name}:$dailyGoalMinutes',
      );
    } catch (_) {/* tolerate */}
  }

  /// Legacy helper for unit tests and simple calls
  Future<void> setShown(StartLevel level) async {
    state = state.copyWith(shown: true, startLevel: level);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, 'shown:${level.name}:${state.nativeLanguage}:${state.reason.name}:${state.dailyGoalMinutes}');
    } catch (_) {/* tolerate */}
  }

  Future<void> dismiss() async {
    final level = state.startLevel ?? StartLevel.a1;
    state = state.copyWith(shown: true, startLevel: level);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kKey,
        'shown:${level.name}:${state.nativeLanguage}:${state.reason.name}:${state.dailyGoalMinutes}',
      );
    } catch (_) {/* tolerate */}
  }
}

final onboardingPrefsProvider =
    NotifierProvider<OnboardingPrefsNotifier, OnboardingPrefs>(
        OnboardingPrefsNotifier.new);

/// Pretty name for the level chip.
String startLevelLabel(StartLevel level) {
  switch (level) {
    case StartLevel.a0:
      return 'Intro · Absolute Beginner';
    case StartLevel.a1:
      return 'A1 · Beginner+';
    case StartLevel.a2:
      return 'A2 · Elementary';
    case StartLevel.b1:
      return 'B1 · Intermediate';
    case StartLevel.b2:
      return 'B2 · Upper Intermediate';
  }
}

/// Short description for each level.
String startLevelDescription(StartLevel level) {
  switch (level) {
    case StartLevel.a0:
      return 'No prior knowledge, starting from zero';
    case StartLevel.a1:
      return 'Basic greetings and simple everyday phrases';
    case StartLevel.a2:
      return 'Simple routines, shopping, and directions';
    case StartLevel.b1:
      return 'Express opinions and hold steady conversations';
    case StartLevel.b2:
      return 'Complex texts, work, and fluent discussions';
  }
}

/// Short helper for the dashboard greeting card.
String startLevelCEFR(StartLevel level) {
  switch (level) {
    case StartLevel.a0:
      return 'Intro';
    case StartLevel.a1:
      return 'A1';
    case StartLevel.a2:
      return 'A2';
    case StartLevel.b1:
      return 'B1';
    case StartLevel.b2:
      return 'B2';
  }
}

/// Label for learning reason.
String learningReasonLabel(LearningReason reason) {
  switch (reason) {
    case LearningReason.ausbildung:
      return 'For Ausbildung';
    case LearningReason.study:
      return 'For Study';
    case LearningReason.job:
      return 'For Job / Career';
    case LearningReason.travel:
      return 'For Travel';
    case LearningReason.fun:
      return 'For Fun & Hobby';
  }
}

String learningReasonSubtitle(LearningReason reason) {
  switch (reason) {
    case LearningReason.ausbildung:
      return 'Vocational training & German apprenticeships';
    case LearningReason.study:
      return 'University degrees & academic exchange';
    case LearningReason.job:
      return 'Professional growth & German workplace';
    case LearningReason.travel:
      return 'Vacations, culture & navigating Germany';
    case LearningReason.fun:
      return 'Personal interest, passion & brain training';
  }
}
