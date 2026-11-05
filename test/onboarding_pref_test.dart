// Verifies the onboarding prefs notifier's persistence behaviour.
// We swap SharedPreferences with an in-memory instance.

import 'package:flutter_test/flutter_test.dart';
import 'package:deutschy/src/core/config/onboarding_pref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('default state is shown=false, level=null', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    final initial = container.read(onboardingPrefsProvider);
    expect(initial.shown, isFalse);
    expect(initial.startLevel, isNull);
  });

  test('setShown(A2) flips shown=true and level=A2', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    await container.read(onboardingPrefsProvider.notifier).setShown(StartLevel.a2);
    final after = container.read(onboardingPrefsProvider);
    expect(after.shown, isTrue);
    expect(after.startLevel, StartLevel.a2);
  });
}