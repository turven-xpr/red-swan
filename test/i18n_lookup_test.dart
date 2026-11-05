import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschy/src/core/config/app_locale.dart';
import 'package:deutschy/src/core/i18n/strings.dart';
import 'package:deutschy/src/core/i18n/translations.dart';

/// i18n smoke tests — any string key must render to a non-empty
/// string in every supported locale.  Catches regressions when a
/// translator forgets to fill in a particular column.
void main() {
  const keysToCheck = <String>[
    Str.appName,
    Str.loginWithGoogle,
    Str.loginWithApple,
    Str.writingGrade,
    Str.errorGeneric,
    Str.errorNetwork,
    Str.errorMalformed,
    Str.errorRetry,
    Str.writingHelperChars,
    Str.reviewActionForgot,
    Str.reviewActionHard,
    Str.reviewActionGood,
    Str.reviewActionEasy,
    Str.reviewActionSkip,
    Str.settingsTheme,
    Str.settingsLanguage,
    Str.settingsNotifications,
    Str.settingsAccount,
    Str.settingsAbout,
    Str.photoGallery,
    Str.photoCamera,
    Str.photoRemove,
    Str.settingsSignOut,
    Str.settingsProfilePhoto,
    Str.settingsChangePhoto,
    Str.settingsVersion,
    Str.splashTagline,
    Str.dashboardToday,
    Str.dashboardEmptyState,
    Str.navHome,
    Str.navVocab,
    Str.navSpeaking,
    Str.navWriting,
    Str.navGames,
    Str.navProfile,
  ];

  Future<void> pumpFor(WidgetTester tester, Locale locale,
      void Function(BuildContext) onReady) async {
    late BuildContext captured;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLocaleProvider.overrideWith(() => _StubLocale(locale)),
        ],
        child: MaterialApp(
          locale: locale,
          home: Builder(builder: (ctx) {
            captured = ctx;
            return const SizedBox();
          }),
        ),
      ),
    );
    await tester.pump();
    onReady(captured);
  }

  for (final locale in const [
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ]) {
    testWidgets('$locale: every shipped string is non-empty', (tester) async {
      late BuildContext ctx;
      await pumpFor(tester, locale, (c) => ctx = c);
      for (final k in keysToCheck) {
        final result = t(ctx, k);
        expect(result, isNotEmpty, reason: 'lookup($k) empty for $locale');
      }
    });
  }

  testWidgets('language picker labels render in their own script',
      (tester) async {
    expect(AppLocale.label(const Locale('de')), 'Deutsch');
    expect(AppLocale.label(const Locale('en')), 'English');
    expect(AppLocale.label(const Locale('fr')), 'Français');
    expect(AppLocale.label(const Locale('ar')), 'العربية');
  });
}

/// Stubbed [AppLocaleNotifier] whose initial state is the chosen
/// locale, no SharedPreferences reads.
class _StubLocale extends AppLocaleNotifier {
  _StubLocale(Locale loc) {
    // Initial state must be set so the build() returns the right
    // value before `setLocale` is called.
    state = loc;
  }
}
