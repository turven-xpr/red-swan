import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// CEFR-style starting levels.
enum StartLevel { a0, a1, a2, b1 }

class OnboardingPrefs {
  const OnboardingPrefs({required this.shown, required this.startLevel});
  final bool shown;
  final StartLevel? startLevel;

  static const empty = OnboardingPrefs(shown: false, startLevel: null);

  OnboardingPrefs copyWith({bool? shown, StartLevel? startLevel}) =>
      OnboardingPrefs(
        shown: shown ?? this.shown,
        startLevel: startLevel ?? this.startLevel,
      );
}

class OnboardingPrefsNotifier extends Notifier<OnboardingPrefs> {
  static const _kKey = 'deutschy_onboarding_v1';

  @override
  OnboardingPrefs build() {
    _load();
    return OnboardingPrefs.empty;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null || !raw.startsWith('shown:')) return;
      final levelStr = raw.substring(6);
      final level = StartLevel.values.firstWhere(
        (e) => e.name == levelStr,
        orElse: () => StartLevel.a1,
      );
      state = OnboardingPrefs(shown: true, startLevel: level);
    } catch (_) {
      // tolerate (tests etc.)
    }
  }

  Future<void> setShown(StartLevel level) async {
    state = OnboardingPrefs(shown: true, startLevel: level);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, 'shown:${level.name}');
    } catch (_) {/* tolerate */}
  }

  Future<void> dismiss() async {
    state = OnboardingPrefs(shown: true, startLevel: state.startLevel ?? StartLevel.a1);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, 'shown:${state.startLevel!.name}');
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
      return 'A0 · Beginner';
    case StartLevel.a1:
      return 'A1 · Beginner+';
    case StartLevel.a2:
      return 'A2 · Elementary';
    case StartLevel.b1:
      return 'B1 · Intermediate';
  }
}

/// Short helper for the dashboard greeting card.
String startLevelCEFR(StartLevel level) {
  switch (level) {
    case StartLevel.a0:
      return 'A0';
    case StartLevel.a1:
      return 'A1';
    case StartLevel.a2:
      return 'A2';
    case StartLevel.b1:
      return 'B1';
  }
}
