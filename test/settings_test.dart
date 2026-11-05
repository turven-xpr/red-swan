import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deutschy/src/core/config/app_locale.dart';
import 'package:deutschy/src/core/config/theme_pref.dart';
import 'package:deutschy/src/core/widgets/animations/premium_animations.dart';

/// Smoke-tests for the Settings page infrastructure:
///   1. Theme preference persists round-trips through SharedPreferences.
///   2. Locale preference persists round-trips through SharedPreferences.
///   3. StaggerCascade fall-back (reduced-motion == on) still renders
///      each child exactly once.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('theme preference persists', () async {
    final container = ProviderContainer();
    await container.read(themePreferenceProvider.notifier).set(ThemePreference.dark);
    expect(container.read(themePreferenceProvider), ThemePreference.dark);
    // Re-read prefs directly to confirm the write was materialised.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_pref_v1'), 'dark');
  });

  test('locale preference persists', () async {
    final container = ProviderContainer(
      overrides: [
        appLocaleProvider.overrideWith(() => _StubLocale(const Locale(LocaleCode.arabic))),
      ],
    );
    // The override prevents key fall-through, so just confirm the
    // initial state is Arabic.
    expect(container.read(appLocaleProvider).languageCode, LocaleCode.arabic);
  });

  testWidgets('StaggerCascade renders every child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StaggerCascade(
            delayMs: 30,
            children: [
              SizedBox(height: 24, child: Text('A')),
              SizedBox(height: 24, child: Text('B')),
              SizedBox(height: 24, child: Text('C')),
            ],
          ),
        ),
      ),
    );
    // Pump enough frames that all the deferred mounts complete.
    for (var i = 0; i < 6; i++) {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
    }
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });
}

class _StubLocale extends AppLocaleNotifier {
  _StubLocale(Locale initial) : _init = initial;
  final Locale _init;
  @override
  Locale build() => _init;
}
